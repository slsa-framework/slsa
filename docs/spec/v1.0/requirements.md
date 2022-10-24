---
title: Requirements
---
<div class="subtitle">

This page covers the detailed technical requirements for each SLSA level. The
intended audience is system implementers and security engineers.

</div>

For an informative description of the levels intended for all audiences, see
[Levels](levels.md). For background, see [Terminology](terminology.md). To
better understand the reasoning behind the requirements, see [Threats and
mitigations](threats.md).

## TODO

**TODO:** Update the requirements to provide guidelines for how to implement,
showing what the options are:

-   How to define expectations: explicit vs implicit
-   What provenance format to use: recommend [SLSA Provenance](../../provenance)
-   Whether provenance is generated during the initial build and/or
    after-the-fact using reproducible builds
-   How provenance is distributed
-   When verification happens: during upload, during download, and/or continuous
    monitoring
-   What happens on failure: blocking, warning, and/or asynchronous notification

## Summary table

| Requirement ([Build track])      | Build L1 | Build L2 | Build L3 |
| -------------------------------- | -------- | -------- | -------- |
| Build - [Scripted build]         | ✓        | ✓        | ✓        |
| Build - [Build service]          |          | ✓        | ✓        |
| Build - [Build as code]          |          |          | ✓        |
| Build - [Ephemeral environment]  |          |          | ✓        |
| Build - [Isolated]               |          |          | ✓        |
| Provenance - [Available]         | ✓        | ✓        | ✓        |
| Provenance - [Authenticated]     |          | ✓        | ✓        |
| Provenance - [Service generated] |          | ✓        | ✓        |
| Provenance - [Non-falsifiable]   |          |          | ✓        |

[authenticated]: #authenticated
[available]: #available
[build as code]: #build-as-code
[build service]: #build-service
[ephemeral environment]: #ephemeral-environment
[isolated]: #isolated
[non-falsifiable]: #non-falsifiable
[scripted build]: #scripted-build
[service generated]: #service-generated

## Build track

[build track]: #build-track

### Build process requirements

<table>
<tr><th>Requirement<th>Description<th>L1<th>L2<th>L3
<tr id="scripted-build">
<td>Scripted build
<td>

All build steps were fully defined in some sort of "build script". The
only manual command, if any, was to invoke the build script.

Examples:

-   Build script is Makefile, invoked via `make all`.
-   Build script is .github/workflows/build.yaml, invoked by GitHub Actions.

<td>✓<td>✓<td>✓
<tr id="build-service">
<td>Build service
<td>

All build steps ran using some build service, not on a developer's
workstation.

Examples: GitHub Actions, Google Cloud Build, Travis CI.

<td> <td>✓<td>✓
<tr id="build-as-code">
<td>Build as code
<td>

The build definition and configuration executed by the build service is
verifiably derived from text file definitions stored in a version control
system.

Verifiably derived can mean either fetched directly through a trusted channel,
or that the derived definition has some trustworthy provenance chain linking
back to version control.

Examples:

-   .github/workflows/build.yaml stored in git
-   Tekton bundles generated from text files by a SLSA compliant build process
    and stored in an OCI registry with SLSA provenance metadata available.

<td> <td> <td>✓
<tr id="ephemeral-environment">
<td>Ephemeral environment
<td>

The build service ensured that the build steps ran in an ephemeral environment,
such as a container or VM, provisioned solely for this build, and not reused
from a prior build.

<td> <td> <td>✓
<tr id="isolated">
<td>Isolated
<td>

The build service ensured that the build steps ran in an isolated environment
free of influence from other build instances, whether prior or concurrent.

-   It MUST NOT be possible for a build to access any secrets of the build service, such as the provenance signing key.
-   It MUST NOT be possible for two builds that overlap in time to influence one another.
-   It MUST NOT be possible for one build to persist or influence the build environment of a subsequent build.
-   Build caches, if used, MUST be purely content-addressable to prevent tampering.

<td> <td> <td>✓
</table>

### Provenance generation requirements

<table>
<tr><th>Requirement<th>Description<th>L1<th>L2<th>L3
<tr id="available">
<td>Available
<td>

The provenance is available to the consumer in a format that the consumer
accepts. The format SHOULD be in-toto [SLSA Provenance],
but another format MAY be used if both producer and consumer agree and it meets
all the other requirements.

[SLSA Provenance]: ../../provenance

<td>✓<td>✓<td>✓
<tr id="authenticated">
<td>Authenticated
<td>

The provenance's authenticity and integrity can be verified by the consumer.
This SHOULD be through a digital signature from a private key accessible only to
the service generating the provenance.

<td> <td>✓<td>✓
<tr id="service-generated">
<td>Service generated
<td>

The data in the provenance MUST be obtained from the build service (either because
the generator _is_ the build service or because the provenance generator reads the
data directly from the build service).

Regular users of the service MUST NOT be
able to inject or alter the contents, except as noted below.

The following provenance fields MAY be generated by the user-controlled build
steps:

-   The output artifact hash from [Identifies Artifact](#identifies-artifact).
    -   Reasoning: This only allows a "bad" build to falsely claim that it
        produced a "good" artifact. This is not a security problem because the
        consumer MUST accept only "good" builds and reject "bad" builds.

<td> <td>✓<td>✓
<tr id="non-falsifiable">
<td>Non-falsifiable
<td>

Provenance cannot be falsified by the build service's users.

NOTE: This requirement is a stricter version of [Service Generated](#service-generated).

-   Any secret material used to demonstrate the non-falsifiable nature of
    the provenance, for example the signing key used to generate a digital
    signature, MUST be stored in a secure management system appropriate for
    such material and accessible only to the build service account.
-   Such secret material MUST NOT be accessible to the environment running
    the user-defined build steps.
-   Every field in the provenance MUST be generated or verified by the build
    service in a trusted control plane. The user-controlled build steps MUST
    NOT be able to inject or alter the contents, except as noted below.

The following provenance fields MAY be generated by the user-controlled build
steps without the build service verifying their correctness:

-   The output artifact hash from [Identifies Artifact](#identifies-artifact).
    -   Reasoning: This only allows a "bad" build to falsely claim that it
        produced a "good" artifact. This is not a security problem because the
        consumer MUST accept only "good" builds and reject "bad" builds.

<td> <td> <td>✓
</table>

### Provenance contents requirements

<table>
<tr><th>Requirement<th>Description<th>L1<th>L2<th>L3
<tr id="identifies-artifact">
<td>Identifies artifact
<td>

The provenance MUST identify the output artifact via at least one
cryptographic hash. The provenance MAY provide multiple identifying
cryptographic hashes using different algorithms. When only one hash is
provided, the RECOMMENDED algorithm is SHA-256 for cross-system
compatibility. If another algorithm is used, it SHOULD be resistant to
collisions and second preimages.

<td>✓<td>✓<td>✓
<tr id="identifies-builder">
<td>Identifies builder
<td>

The provenance identifies the entity that performed the build and generated the
provenance. This represents the entity that the consumer must trust. Examples:
"GitHub Actions with a GitHub-hosted worker", "jdoe@example.com's machine".

<td>✓<td>✓<td>✓
<tr id="identifies-build-instructions">
<td>Identifies build instructions
<td>

The provenance identifies the top-level instructions used to execute the build.

The identified instructions SHOULD be at the highest level available to the build
(e.g. if the build is told to run build.sh it should list build.sh and NOT the
individual instructions in build.sh).

If <a href="#build-as-code">build-as-code</a> is used, this SHOULD be the
source repo and entry point of the build config (as in
[the GitHub Actions example](/provenance/v0.2#github-actions)).

If the build isn't defined in code it MAY list the details of what it was
asked to do (as in
[the Google Cloud Build RPC example](/provenance/v0.2#cloud-build-rpc)
or
[the Explicitly Run Commands example](/provenance/v0.2#explicitly-run-commands)).

<td>✓<td>✓<td>✓
<tr id="identifies-source-code">
<td>Identifies source code
<td>

The provenance identifies the repository origin(s) for the source code used in
the build.

The identified repositories SHOULD only include source used directly in the build.
The source of dependencies SHOULD NOT be included.

At level 2 this information MAY come from users and DOES NOT need to be
authenticated by the builder.

At level 3+ this information MUST be authenticated by the builder (i.e. the
builder either needs to have fetched the source itself or _observed_ the fetch).

<td><td>✓<td>✓✓
<tr id="identifies-entry-point">
<td>Identifies entry point
<td>

The provenance identifies the "entry point" of the build definition
(see <a href="#build-as-code">build-as-code</a>) used to drive the build
including what source repo the configuration was read from.

Example:

-   source repo: git URL + branch/tag/ref + commit ID
-   entrypoint: path to config file(s) (e.g. ./.zuul.yaml) + job name within config (e.g. envoy-build-arm64)

<td><td><td>✓
<tr id="includes-all-params">
<td>Includes all build parameters
<td>

The provenance includes all build parameters under a user's control.

<td> <td> <td>✓
<tr id="includes-metadata">
<td>Includes metadata
<td>

The provenance includes metadata to aid debugging and investigations. This
SHOULD at least include start and end timestamps and a unique identifier to
allow finding detailed debug logs.

"○" = RECOMMENDED.

<td>○<td>○<td>○
</table>

### Possible future requirements

The [prior version](../v0.1/requirements.md) of SLSA defined a "SLSA 4" that
included the following requirements. A future Build L4 may incorporate some or
all of the following, in whole or in part.

> NOTE: The draft requirements here are unversioned and subject to change.

<details id="parameterless">
<summary>Parameterless (draft)</summary>

The build output cannot be affected by user parameters other than the build
entry point and the top-level source location. In other words, the build is
fully defined through the build script and nothing else.

Examples:

-   GitHub Actions
    [workflow_dispatch](https://docs.github.com/en/actions/reference/events-that-trigger-workflows#workflow_dispatch)
    `inputs` MUST be empty.
-   Google Cloud Build
    [user-defined substitutions](https://cloud.google.com/build/docs/configuring-builds/substitute-variable-values)
    MUST be empty. (Default substitutions, whose values are defined by the
    server, are acceptable.)

</details>
<details id="hermetic">
<summary>Hermetic (draft)</summary>

All transitive build steps, sources, and dependencies were fully declared up
front with _immutable references_, and the build steps ran with no network
access.

An **immutable reference** is an identifier that is
guaranteed to always point to the same, immutable artifact. This MUST allow the
consumer to locate the artifact and SHOULD include a cryptographic hash of the
artifact's contents to ensure integrity. Examples: git URL + branch/tag/ref \+
commit ID; cloud storage bucket ID + SHA-256 hash; Subversion URL (no hash).

The user-defined build script:

-   MUST declare all dependencies, including sources and other build steps,
    using _immutable references_ in a format that the build service understands.

The build service:

-   MUST fetch all artifacts in a trusted control plane.
-   MUST NOT allow mutable references.
-   MUST verify the integrity of each artifact.
    -   If the _immutable reference_ includes a cryptographic hash, the service
        MUST verify the hash and reject the fetch if the verification fails.
    -   Otherwise, the service MUST fetch the artifact over a channel that
        ensures transport integrity, such as TLS or code signing.
-   MUST prevent network access while running the build steps.
    -   This requirement is "best effort." It SHOULD deter a reasonable team
        from having a non-hermetic build, but it need not stop a determined
        adversary. For example, using a container to prevent network access is
        sufficient.

</details>
<details id="reproducible">
<summary>Reproducible (draft)</summary>

Re-running the build steps with identical input artifacts results in bit-for-bit
identical output. Builds that cannot meet this MUST provide a justification why
the build cannot be made reproducible.

"○" means that this requirement is "best effort". The user-provided build script
SHOULD declare whether the build is intended to be reproducible or a
justification why not. The build service MAY blindly propagate this intent
without verifying reproducibility. A consumer MAY reject the build if it does
not reproduce.

</details>
<details id="dependencies-complete">
<summary>Dependencies complete (draft)</summary>

Provenance records all build dependencies that were available while running the
build steps. This includes the initial state of the machine, VM, or container of
the build worker.

-   MUST include all user-specified build steps, sources, dependencies.
-   SHOULD include all service-provided artifacts.

</details>

## Source track

The Source track is not yet defined. For an idea of what the levels might look
like in a future version, see
[v0.1 Source requirements](../v0.1/requirements.md#source-requirements).
