---
title: "Introducing Enterprise Contract Validate Github Action with SLSA 3 Container Generator v1.9"
author: "Sean Conroy (Enterprise Contract)"
is_guest_post: true
---

As a software producer, you may have come across [Enterprise Contract (EC)](https://enterprisecontract.dev), which securely verifies supply chain artifacts such as SBOM content, signatures, and attestations. EC use policies to enforce regarding their construction and testing in a manageable, scalable, and declarative manner. As a member of Enterprise Contract, today I am going to demonstrate how you can leverage both SLSA 3 Container Generator v1.9.0 and EC Validate GitHub Actions.

## What is EC Validate Github Action?
EC Validate is a GitHub Action provided by Enterprise Contract, designed to verify container images. It supports making policy-based decisions based on attestations using the SLSA provenance format 0.1 and 1.0. EC assesses the provenance data against a set of security policies that can be either [predefined](https://github.com/enterprise-contract/config#enterprise-contract-configuration-files) or [customized](https://enterprisecontract.dev/docs/ec-cli/main/configuration.html#_including_and_excluding_rules) according to your organization's requirements. EC Validate ensures that the provenance data complies with specific rules and standards. It also performs integrity checks to verify that the provenance has not been altered, thus maintaining the integrity within a GitHub workflow.

Interested in learning more? Visit the [EC Validate action](https://github.com/marketplace/actions/ec-validate) in GitHub’s Market Place for a user guide.

## What is the SLSA 3 Generator v1.9.0?
 The SLSA 3 Generator Action allow your workflow to produce SLSA level 3 compliant provenance statements so users can verify the origin of container images they use. More information can be found [here](https://slsa.dev/blog/2023/02/slsa-github-workflows-container-ga)

## Building a more secure Pipeline

Enterprise Contract has incorporated the SLSA 3 Container Generator v1.9.0 into their [Golden Container Release workflow](https://github.com/enterprise-contract/golden-container/blob/main/.github/workflows/release.yaml) to enhance security. The pipeline process involves building, digitally signing, generating an SBOM, generating SLSA level 3 provenance, and validating with EC Validate before releasing to `ghcr.io`.

First, I'll guide you through the prerequisite steps that Enterprise Contract implemented to construct a release pipeline. After that, we'll delve into how to integrate the SLSA 3 Container Generator v1.9.0 and EC Validate to fortify your pipeline.  
### Building the Container Image
```yaml
build:
    - name: Buildah Action
      id: build-image
      uses: redhat-actions/buildah-build@v2
      with:
        image: $env.IMAGE_REPO
        tags: $env.IMAGE_TAGS
        dockerfiles: ./Containerfile
```
### Sign the Container Image and generate SBOM
In this step, the container image is signed using Cosign and a GitHub OIDC token. This adds a layer of security and trust to the image, making it easier to verify its integrity and origin.

```yaml
- name: Sign image with GitHub OIDC Token
  run: cosign sign --yes ${IMAGE_REGISTRY}/${IMAGE_REPO}@${DIGEST}
  env:
    DIGEST: ${ steps.push-image.outputs.digest }
```
We use Syft to generate a SBOM. It’s then attested using Cosign.
```yaml
- name: Generate and store SBOM
  run: |
      syft "${IMAGE_REGISTRY}/${IMAGE_REPO}@${DIGEST}" -o spdx-json=sbom-spdx.json
      cosign attest --yes --predicate sbom-spdx.json --type spdx "${IMAGE_REGISTRY}/${IMAGE_REPO}@${DIGEST}"
  env:
    DIGEST: ${ steps.push-image.outputs.digest }
```

### Generating SLSA Provenance
Using the SLSA 3 Container Generator v1.9.0, we create a solid foundation for trust in our container images. This tool is integrated into GitHub workflow, automating the generation of SLSA level 3 provenance. Here’s how it enhances the Security of the pipeline:

- **Isolation and Security**: The provenance is generated in an isolated job, separate from the image build step, minimizing the risk of tampering.
- **Compliance with Standards**: It ensures compliance with SLSA level 3, which is a stringent set of standards that stipulate controlled, reviewed, and repeatable build processes.

```yaml
- name: slsa-github-generator
  uses: slsa-framework/slsa-github-generator/.github/workflows/generator_container_slsa3.yml@v1.9.0 
  with:
    image: $needs.build.outputs.image
    digest: $needs.build.outputs.digest
    registry-username: $github.actor
  secrets:
    registry-password: $secrets.GITHUB_TOKEN
```
The SLSA 3 Container Generator v1.9 signs the provenance using a trusted key, which is then uploaded to the container registry, providing an additional layer of verification for the final image. 


### Validating with EC Validate
After generating the provenance, the EC Validate GitHub Action verifies the integrity and compliance of the attestation:

- **Checks**: It doesn't just check for the presence of provenance; it ensures it meets specific cryptographic signatures and adheres to the set policy.
- **Policy Compliance**: `EC Validate integrates with your organization's security policies to make sure that the artifact's provenance is not just accurate but also follows custom or predefined policies.

```yaml
- name: Validate image (keyless)
  uses: enterprise-contract/action-validate-image@v1.0.31 
  with:
    image: $needs.build.outputs.image @$needs.build.outputs.digest
    identity: https:\/\/github\.com\/(slsa-framework\/slsa-github-generator|$github.repository_owner\/$ github.event.repository.name)\/
    issuer: https://token.actions.GitHubusercontent.com
    policy: github.com/enterprise-contract/config//github-default
```

### Advantages of Pairing EC Validate with SLSA 3

Combining EC Validate with SLSA 3 Container Generator v1.9 offers significant benefits:

- **Automated and Enhanced Security**: It takes the heavy lifting out of the validation process, automating what would typically be a complex and meticulous task.
- **Custom Policy Enforcement**: Organizations can enforce specific security policies during the validation process, ensuring that every artifact meets set requirements.
- **Increased Trust**: By ensuring the artifacts comply with SLSA level 3 standards and passing the EC Validate checks, users can have increased confidence in the Security of their software supply chain.

### An Example of an Implementation

Enterprise Contract has implemented this approach to secure a critical application deployment:

- **Compliant**: By employing the SLSA 3 Container Generator v1.9 alongside EC Validate, we've created a pipeline that is not just functional but also fully auditable and compliant with security standards. 
- **Policy Enforcement**: The EC Validate GitHub Action ensures that the provenance adheres to the organization's policy, which is `github-default` in this case. 
```yaml
name: GitHub Default
description: >-
  Rules for container images built via GitHub Workflows.

sources:
  - name: Default
    policy:
      - github.com/enterprise-contract/ec-policies//policy/lib
      - github.com/enterprise-contract/ec-policies//policy/release
    data: []
    config:
      include:
        - '@github'
      exclude:

```
- **Integrity Checks**: The combination of these tools provides a tamper-evident record of the build process, making it possible to trace every step of the build.

To see this in action, Enterprise Contract’s [Golden Release Pipeline](https://github.com/enterprise-contract/golden-container/blob/main/.github/workflows/release.yaml) serves as a live example of how integrating these actions.

## Conclusion

By integrating the SLSA 3 Container Generator v1.9 with EC Validate, developers and organizations can significantly bolster their Security. This combination doesn't just add layers of Security; it embeds Security into the very fabric of the pipeline, ensuring that each release is not just faster and more efficient but also safer.

Explore EC Validate in the [GitHub Marketplace](https://github.com/marketplace/actions/ec-validate) and consult the user guide for more details. Be sure to read [Introducing EC Validate Image](https://enterprisecontract.dev/posts/introducing-action-validate-image/). Big thanks to SLSA team for their support and collaboration!