---
title: "Safeguarding builds on Google Cloud Build with SLSA"
author: "Asra Ali, Ian Lewis, Laurent Simon, Stephen Anastos"
is_guest_post: true
---


Earlier this year, [Google Cloud Build](https://cloud.google.com/build/docs/overview) (GCB) announced support for Level 3 assurance of [Supply-chain Levels for Software Artifacts](https://slsa.dev/) (SLSA) for container images. Users can now automatically generate verifiable provenance documents (build records) of builds that take place in Cloud Build. Provenance can be used to provide assurance that a trusted builder (in this case, GCB) produced the resulting image through some declared process with trusted source material. To make verification effortless, we are announcing support for verifying the provenance document in the open-source [slsa-verifier](https://github.com/slsa-framework/slsa-verifier) CLI tool, which previously only had support for [GitHub Actions](https://slsa.dev/blog/2022/06/slsa-github-workflows). With the slsa-verifier, everyone — not just the container authors — can verify the SLSA provenance document.

SLSA’s series of [levels](https://slsa.dev/spec/v0.1/levels) provide progressively stronger guarantees about the integrity of a software artifact.  Requirements in each level are grouped by components, so projects receive separate sub-ratings for _build_ level and _provenance_ level. GCB users may already be familiar with SLSA build levels: [Software Delivery Shield’s security insights](https://cloud.google.com/software-supply-chain-security/docs/sds/overview) in-console panel displays the SLSA build levels of artifacts. GCB already reaches Level 3 build requirements by performing builds in isolated and ephemeral environments. Now, GCB also meets the Level 3 provenance requirements by recording the “entry point” (or command) that was used to define the build and all user-controlled parameters. These details are in addition to the verifiable information the provenance already contained, such as the digests of the built images, the input sources, the build arguments, and the build recipe. To learn more about GCB provenance, see [Safeguard builds](https://cloud.google.com/software-supply-chain-security/docs/safeguard-builds#provenance).

As we’ll see below, this new provenance information can be used to validate that builds were generated from a specific version-controlled build pipeline, and to maintain a record of the parameters used to generate the container image for policy evaluation or reproducibility.

### GCB Provenance at SLSA Level 3

At SLSA Level 3, users have assurance that the metadata content is authentic, tamper-proof, and not altered by the project maintainers. The build definition and configuration is verifiably derived from definitions stored in versioned source control systems (known as “[build-as-code](https://slsa.dev/spec/v0.1/requirements#build-as-code)”). So in order to describe the full top-level build instructions, GCB now identifies the build configuration stored in git, the `entrypoint`, often named [cloudbuild.yaml](https://cloud.google.com/build/docs/configuring-builds/create-basic-configuration).  A record of all user-controlled parameters ([substitutions](https://cloud.google.com/build/docs/configuring-builds/substitute-variable-values)) to the build is also provided in the provenance’s `recipe`.

```json
{
  "_type": "https://in-toto.io/Statement/v0.1",
  "predicateType": "https://slsa.dev/provenance/v0.1",
  "predicate": {
    "builder": {
      "id": "https://cloudbuild.googleapis.com/GoogleHostedWorker@v0.3"
    },
    "materials": [
      {
        "digest": {
          "sha1": "01ce393d04eb6df2a7b2b3e95d4126e687afb7ae"
        },
        "uri": "https://github.com/ORG/REPO"
      }
    ],
    "metadata": {...},
    "recipe": {
      "arguments": {
        "sourceProvenance": {...},
        "steps": [...],
        "substitutions": {
          "_IMAGE_NAME": "PROJECT_ID/REPOSITORY/IMAGE_NAME:TAG"
        }
      },
      "definedInMaterial": "1",
      "entryPoint": "cloudbuild.yaml",
      "type": "https://cloudbuild.googleapis.com/CloudBuildSteps@v0.1"
    }
  },
  "subject": [
    {
      "digest": {
        "sha256": "29e5d68bdb6b95cbcb456953ae5981f9dca6a50c3621c01beb9a75869bc79bec"
      },
      "name": "https://us-LOCATION-docker.pkg.dev/PROJECT_ID/REPOSITORY/IMAGE_NAME:TAG"
    },
  ]
}
```

A user can view a container's provenance by following the [viewing instructions](https://cloud.google.com/build/docs/securing-builds/view-build-provenance#validate_the_provenance_metadata). Next, we’ll discuss how you can use our SLSA tools to easily verify its authenticity, integrity and properties.

### Verification

Validating SLSA Level 3 provenance can help to both verify that a build was produced by an expected source and build system and also identify whether any code was injected via an untrusted source location or build system. At SLSA Level 3, the provenance is service-generated (by GCB), verifiable for authenticity and integrity, and non-forgeable—meaning that a user cannot tamper with the provenance metadata.

Our SLSA verification CLI tool now supports [GCB provenance verification](https://cloud.google.com/build/docs/securing-builds/view-build-provenance#validate_provenance_using_the_slsa_verifier) for container images. Not only does `slsa-verifier` verify the signature over the provenance and the human-readable provenance summary, but it also automatically handles verification key management and allows end-users to validate that the container image was generated from the trusted Cloud Build builder and trusted source location.

To start verifying provenance, you must provide a container image name that is _immutable_ by providing its digest (rather than, say, a mutable image tag). This avoids “Time-of-check-to-time-of-use” (TOCTTOU) attacks, described in [this overview](https://github.com/slsa-framework/slsa-verifier#toctou-attacks). A user can retrieve the digest of the container using the [crane](https://github.com/google/go-containerregistry/blob/main/cmd/crane/doc/crane.md) command:

```bash
UNVERIFIED_IMAGE="us-LOCATION-docker.pkg.dev/PROJECT_ID/REPOSITORY/IMAGE_NAME:TAG"
IMMUTABLE_IMAGE="${UNVERIFIED_IMAGE%:*}@$(crane digest ${UNVERIFIED_IMAGE})"
```

Then, retrieve the provenance using the [gcloud](https://cloud.google.com/sdk/gcloud) CLI utility. (Note: You _must_ be authenticated to GCP to retrieve information about the image and [configure docker authentication](https://cloud.google.com/sdk/gcloud/reference/auth/configure-docker).)

```shell
gcloud artifacts docker images describe "${IMMUTABLE_IMAGE}" \
  --format json --show-provenance \
  > unverified-provenance.json
```

Verify the image using the slsa-verifier CLI tool ([installation instructions](https://github.com/slsa-framework/slsa-verifier#installation)) against the downloaded provenance via the `--provenance-path` flag. The `--source-uri` flag specifies the version-controlled source repository that was expected to be used to build the image. The `--builder-id` flag specifies the expected builder identity; in this case, we specify GCB’s builders: `https://cloudbuild.googleapis.com/GoogleHostedWorker`.

```shell
slsa-verifier verify-image "${IMMUTABLE_IMAGE}" \
  --provenance-path unverified-provenance.json \
  --source-uri github.com/laurentsimon/gcb-tests \
  --builder-id=https://cloudbuild.googleapis.com/GoogleHostedWorker \
  --print-provenance > verified-provenance.json # PASSED: Verified SLSA provenance
```

Using the `--print-provenance` flag will print the validated provenance JSON to allow piping into a policy engine. If verification succeeds, `$IMMUTABLE_IMAGE` is verified.

To run the verified container image, use the `$IMMUTABLE_IMAGE` (not `$UNVERIFIED_IMAGE`):

```shell
docker run "${IMMUTABLE_IMAGE}"
```

### Use-Cases

In previous posts ([1](https://slsa.dev/blog/2022/06/slsa-github-workflows), [2](https://slsa.dev/blog/2022/08/slsa-github-workflows-generic-ga)), we described how consumers can use information found in non-forgeable SLSA Level 3 build provenance to evaluate policies that may prevent certain classes of supply chain attacks.

In particular, with the new information provided in GCB’s provenance, users may validate that a predefined set of workflows created the artifacts. For example, an organization may use a certain build configuration to generate a base image for building a final artifact. Before executing the image to create their releases, they can verify the SLSA provenance like above and then validate that the base image was generated from the authorized configuration. The GCB provenance exposes the metadata in the build recipe:

```shell
jq -r '.predicate.recipe.entryPoint' verified-provenance.json # cloudbuild.yaml
```

### Conclusion

Reaching SLSA Level 3 with GCB is a major step in making provenance available to even more consumers. This is important to provide build transparency and security in your own or your end-users’ supply-chain. We encourage you to enable build provenance in your container image builds on GCB and to use our verification tools to start validating provenance for policy evaluation. We welcome all types of feedback and contributions to our [verifier](https://github.com/slsa-framework/slsa-verifier).

In the future, we’re looking to move towards more seamless SLSA provenance verification and also enable policy evaluation on images. We’re also hoping to add build provenance verification for other artifact types to slsa-verifier as support for provenance generation expands.

If you are interested in working with us to grow the ecosystem of SLSA tooling, we invite you to the [SLSA Working Group](https://slsa.dev/community) and the [SLSA Tooling special interest group](https://slsa.dev/notes/tooling).
