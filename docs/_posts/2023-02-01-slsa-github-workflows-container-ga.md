---
title: "General availability of SLSA 3 Container Generator for GitHub Actions"
author: "Asra Ali, Ian Lewis, Laurent Simon"
is_guest_post: false
---

Today, we are announcing the general availability of the [SLSA 3 Container Generator for GitHub Actions](https://github.com/slsa-framework/slsa-github-generator/tree/main/internal/builders/container) starting with v1.4.0. This free tool allows any GitHub project to produce SLSA level 3 compliant provenance statements so users can verify the origin of container images they use. While previous tools allowed users to generate provenance for file artifacts, the Container Generator is able to support container ecosystems. It does this by allowing provenance statements to be distributed alongside your images in a container registry and integrating directly with [Sigstore](https://www.sigstore.dev/)-compatible tooling for inspection and verification.

In only a few short years since container management platforms like Docker and Kubernetes were released, container images have become one of the most popular ways to deploy software. Containers allow their users to deploy software in a more flexible way without depending on language specific packaging or deployment mechanisms. Many public repositories of container images, like [Docker Hub](https://hub.docker.com/), allow you to upload pre-packaged images that can be used out of the box or customized by users as base images.

However, it can be a huge challenge for users to verify the provenance of your images. Various reports from [Aqua Security's Team Nautilus](https://blog.aquasec.com/supply-chain-threats-using-container-images) and the [Sysdig Threat Research Team](https://sysdig.com/blog/analysis-of-supply-chain-attacks-through-public-docker-images/) show that container images which include malicious payloads are common. How can users of your image be confident of how the images you use were built? How can they be sure they haven't been modified to include malicious payloads?

One solution is including [SLSA provenance](/provenance/) with your container image. SLSA provenance is metadata about your build that includes information that strongly links your artifacts to the build system and source code that was used. SLSA provenance can build trust in your images by helping your users verify that the images come from you and your source repositories.

The Container Generator's reusable workflow can help you to achieve [SLSA level 3](/spec/v0.1/levels) for your project by automatically generating provenance from your existing GitHub Actions workflows to generate images. This can be done by simply adding a new job step to call the generator's reusable workflow, which generates and signs the provenance in an isolated job separate from your image's build step for added security. Popular projects like [Kyverno](https://kyverno.io/docs/) are already using this workflow to generate provenance for their container image releases.

## Generating Provenance

Under the hood, the Container Generator's reusable workflow uses [Sigstore](https://sigstore.dev/)'s [cosign](https://github.com/sigstore/cosign) to sign the provenance. This provenance is combined with the cryptographic signature into something called an attestation. This attestation is then uploaded to the container registry. Using cosign to sign the provenance allows the generated attestation to integrate well with Sigstore's ecosystem of tools for discovery and verification.

However, unlike simply signing your container directly with cosign, using the Container Generator as a [GitHub Actions reusable workflow](https://docs.github.com/en/actions/using-workflows/reusing-workflows) generates the signed provenance in an isolated build job. This protects the provenance from being modified by malicious code in the build itself and enables you to meet the [Non-Falsifiable requirements](/spec/v0.1/requirements#non-falsifiable) for [SLSA level 3](/spec/v0.1/levels). You can find out more about the specifics in our [Technical Design](https://github.com/slsa-framework/slsa-github-generator/blob/main/SPECIFICATIONS.md).

The following is an example of how to generate provenance using the Container Generator. You can read more details in the [documentation](https://github.com/slsa-framework/slsa-github-generator/tree/main/internal/builders/container).

### Step 1: Build and push your container image

You can first build and push your image as you would normally using Docker's `build-push-action`. You can find a full example in the [documentation](https://github.com/slsa-framework/slsa-github-generator/blob/main/internal/builders/container/README.md#getting-started).

```yaml
build:
  # ...
  steps:
    # ...
    - name: Build and push Docker image
      uses: docker/build-push-action@e551b19e49efd4e98792db7592c17c09b89db8d8 # v3.0.0
      id: build
      with:
        push: true
        tags: {% raw %}${{ steps.meta.outputs.tags }}{% endraw %}
        labels: {% raw %}${{ steps.meta.outputs.labels }{% endraw %}}
    # ...
```

### Step 2: Call the Container Generator to generate and upload SLSA provenance

With the outputs from image generation you can call the Container Generator reusable workflow. This step calls the container workflow to generate provenance, sign it, and push the resulting attestation to the container registry. An example looks like this:

```yaml
provenance:
  needs: [build]
  permissions:
    actions: read # for detecting the Github Actions environment.
    id-token: write # for creating OIDC tokens for signing.
    packages: write # for uploading attestations.
  uses: slsa-framework/slsa-github-generator/.github/workflows/generator_container_slsa3.yml@v1.4.0
  with:
    image: {% raw %}${{ needs.build.outputs.image }}{% endraw %}
    # The image digest is used to prevent TOCTOU issues.
    # This is an output of the docker/build-push-action
    # See: https://github.com/slsa-framework/slsa-verifier#toctou-attacks
    digest: {% raw %}${{ needs.build.outputs.digest }}{% endraw %}
    registry-username: {% raw %}${{ github.actor }}{% endraw %}
  secrets:
    registry-password: {% raw %}${{ secrets.GITHUB_TOKEN }}{% endraw %}
```

### Step 3: Inspection

You can validate that the attestation has been uploaded to the repository using cosign. Here we use the `cosign tree` command to display the SLSA provenance attestation associated with our image.

```shell
$ cosign tree ghcr.io/ianlewis/actions-test:v0.0.86@sha256:70205a915e3288e71b48e794e4789bf28ae4c0660c4ce340f2c48ed356b68d35
📦 Supply Chain Security Related artifacts for an image: ghcr.io/ianlewis/actions-test:v0.0.86@sha256:70205a915e3288e71b48e794e4789bf28ae4c0660c4ce340f2c48ed356b68d35
└── 💾 Attestations for an image tag: ghcr.io/ianlewis/actions-test:sha256-70205a915e3288e71b48e794e4789bf28ae4c0660c4ce340f2c48ed356b68d35.att
   └── 🍒 sha256:1f7571f8ca4e22229ae6fb53fdc1282cd3c251cd121e61fb035cce55bc227070
```

You can also inspect the uploaded provenance payload using the `cosign download attestation` command. The attestation is stored in a [DSSE envelope](https://github.com/secure-systems-lab/dsse/blob/master/protocol.md), which includes the cryptographic signature and encoded provenance payload in base64. Use the following command to retrieve the payload in human readable format:

```shell
$ cosign download attestation ghcr.io/ianlewis/actions-test:v0.0.86@sha256:70205a915e3288e71b48e794e4789bf28ae4c0660c4ce340f2c48ed356b68d35 | jq -r '.payload' | base64 -d | jq
{
  "_type": "https://in-toto.io/Statement/v0.1",
  "predicateType": "https://slsa.dev/provenance/v0.2",
  "subject": [
    {
      "name": "ghcr.io/ianlewis/actions-test",
      "digest": {
        "sha256": "70205a915e3288e71b48e794e4789bf28ae4c0660c4ce340f2c48ed356b68d35"
      }
    }
...
```

See the [Container Generator's documentation](https://github.com/slsa-framework/slsa-github-generator/tree/main/internal/builders/container#provenance-format) and the [SLSA documentation](/provenance) for more information about the provenance's JSON format.

### Step 4: Verification

To verify your image's provenance, use the [slsa-verifier](https://github.com/slsa-framework/slsa-verifier#containers) tool on the command line. This tool will verify the provenance's signature and check the expected source repository and builder ID.

```shell
$ slsa-verifier verify-image ghcr.io/ianlewis/actions-test:v0.0.86@sha256:70205a915e3288e71b48e794e4789bf28ae4c0660c4ce340f2c48ed356b68d35 \
    --source-uri github.com/ianlewis/actions-test \
    --source-tag v0.0.86 \
    --builder-id https://github.com/slsa-framework/slsa-github-generator/.github/workflows/generator_container_slsa3.yml@refs/tags/v1.4.0
Verified build using builder https://github.com/slsa-framework/slsa-github-generator/.github/workflows/generator_container_slsa3.yml@refs/tags/v1.4.0 at commit d9be953dd17e7f20c7a234ada668f9c8c4aaafc3
PASSED: Verified SLSA provenance
```

You can also use [Kyverno](https://kyverno.io/docs/writing-policies/verify-images/) or sigstore's [policy-controller](https://docs.sigstore.dev/policy-controller/overview/) for verification in Kubernetes environments. See the [documentation](https://github.com/slsa-framework/slsa-github-generator/tree/main/internal/builders/container#verification) for more examples of verifying SLSA provenance.

## No more weak links

Tackling supply chain security can be a daunting task for large organizations and open source ecosystems. The Container Generator allows any project on GitHub that generates container images to generate provenance using GitHub Actions.

Our work on SLSA tooling is just getting started. You can follow along with our project roadmap on our [milestones page](https://github.com/slsa-framework/slsa-github-generator/milestones).

SLSA generation and verification is also only a small part of what we need to do to improve supply chain security. Connect with us via the [SLSA community](/community) on [Slack](https://openssf.slack.com/archives/C029E4N3DPF), discuss ideas with us in the [#slsa-tooling](https://openssf.slack.com/archives/C03PDLFET5W) channel, and join our [SLSA Tooling working group meetings](https://docs.google.com/document/d/15Xp8-0Ff_BPg_LMKr1RIKtwAavXGdrgb1BoX4Cl2bE4/edit) to help us prioritize future work. We welcome any contributions you can make. See you there!
