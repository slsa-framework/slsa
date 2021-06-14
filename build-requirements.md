# SLSA Build and Provenance Requirements

TODO: Add an introduction, diagram, threat model, and high-level description of
each level.

_Reminder: The definitions below are not yet finalized and subject to change,
particularly SLSA 3-4._

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD",
"SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be
interpreted as described in
[RFC 2119](https://www.rfc-editor.org/rfc/rfc2119).

## Definitions

**Provenance**: Metadata about how an artifact was produced.

<a id="immutable-reference"></a>**Immutable reference:** An identifier that is
guaranteed to always point to the same, immutable artifact. This MUST allow the
consumer to locate the artifact and SHOULD include a cryptographic hash of the
artifact's contents to ensure integrity. Examples: git URL + branch/tag/ref \+
commit ID; cloud storage bucket ID + SHA-256 hash; Subversion URL (no hash).

[immutable reference]: #immutable-reference
[immutable references]: #immutable-reference

## Requirements

### Build Requirements

Requirements on build process:

<table>
 <tr><th>Requirement<th>Description<th>L1<th>L2<th>L3<th>L4</tr>
 <tr id="scripted-build">
  <td>Scripted Build
  <td>

  All build steps were fully defined in some sort of "build script". The
  only manual command, if any, was to invoke the build script.

  Examples:

  * Build script is Makefile, invoked via `make all`.
  * Build script is .github/workflows/build.yaml, invoked by GitHub Actions.

  <td>✓<td>✓<td>✓<td>✓
 </tr>
 <tr id="build-service">
  <td>Build Service
  <td>

  All build steps ran using some build service, not on a developer's
  workstation.

  Examples: GitHub Actions, Google Cloud Build, Travis CI.

  <td> <td>✓<td>✓<td>✓
 </tr>
 <tr id="ephemeral-environment">
  <td>Ephemeral Environment
  <td>

  The build service ensured that the build steps ran in an ephemeral
  environment, such as a container or VM, provisioned solely for this build, and
  not reused from a prior build.

  <td> <td> <td>✓<td>✓
 </tr>
 <tr id="isolated">
  <td>Isolated
  <td>

  The build service ensured that the build steps ran in an isolated
  environment free of influence from other build instances, whether prior or
  concurrent.

  * It MUST NOT be possible for a build to access any secrets of the build
    service, such as the provenance signing key.
  * It MUST NOT be possible for two builds that overlap in time to
    influence one another.
  * It MUST NOT be possible for one build to persist or influence the
    build environment of a subsequent build.
  * Build caches, if used, MUST be purely content-addressable to prevent
    tampering.

  <td> <td> <td>✓<td>✓
 </tr>
 <tr id="parameterless">
  <td>Parameterless
  <td>

  The build output cannot be affected by user parameters other than the build
  entry point and the top-level source location. In other words, the build is
  fully defined through the build script and nothing else.

  Examples:

  * GitHub Actions
    [workflow_dispatch](https://docs.github.com/en/actions/reference/events-that-trigger-workflows#workflow_dispatch) `inputs` MUST be empty.
  * Google Cloud Build
    [user-defined substitutions](https://cloud.google.com/build/docs/configuring-builds/substitute-variable-values)
    MUST be empty. (Default substitutions, whose values are defined by the
    server, are acceptable.)

  <td> <td> <td> <td>✓
 </tr>
 <tr id="hermetic">
  <td>Hermetic
  <td>

  All transitive build steps, sources, and dependencies were fully declared up
  front with [immutable references], and the build steps ran with no network
  access.

  The user-defined build script:

  * MUST declare all dependencies, including sources and other build steps,
    using [immutable references] in a format that the build service understands.

  The build service:

  * MUST fetch all artifacts in a trusted control plane.
  * MUST disallow mutable references.
  * MUST verify the integrity of each artifact.
    * If the [immutable reference] includes a cryptographic hash, the service
      MUST verify the hash and reject the fetch if the verification fails.
    * Otherwise, the service MUST fetch the artifact over a channel that ensures
      transport integrity, such as TLS or code signing.
  * MUST prevent network access while running the build steps.
    * This requirement is "best effort." It SHOULD deter a reasonable team from
      having a non-hermetic build, but it need not stop a determined adversary.
      For example, using a container to prevent network access is sufficient.

  <td> <td> <td> <td>✓
 </tr>
 <tr id="reproducible">
  <td>Reproducible
  <td>

  Re-running the build steps with identical input artifacts results in
  bit-for-bit identical output. Builds that cannot meet this MUST provide a
  justification why the build cannot be made reproducible.

  "○" means that this requirement is "best effort". The user-provided build
  script SHOULD declare whether the build is intended to be reproducible or a
  justification why not. The build service MAY blindly propagate this intent
  without verifying reproducibility. A consumer MAY reject the build if it does
  not reproduce.

  <td> <td> <td> <td>○
 </tr>
</table>

### Provenance Requirements

Requirements on the process by which provenance is generated and consumed:

<table>
 <tr><th>Requirement<th>Description<th>L1<th>L2<th>L3<th>L4</tr>
 <tr id="available">
  <td>Available
  <td>

  The provenance is available to the consumer in a format that the consumer
  accepts. The format SHOULD be
  [in-toto provenance](https://github.com/in-toto/attestation/blob/main/spec/predicates/provenance.md),
  but another format MAY be used if both producer and consumer
  agree and it meets all the other requirements.

  <td>✓<td>✓<td>✓<td>✓
 </tr>
 <tr id="authenticated">
  <td>Authenticated
  <td>

  The provenance's authenticity and integrity can be verified by the
  consumer. This SHOULD be through a digital signature from a private key
  accessible only to the build service.

  <td> <td>✓<td>✓<td>✓
 </tr>
 <tr id="service-generated">
  <td>Service Generated
  <td>

  The provenance was populated by the build service, not by user-provided
  tooling running on top of the service.

  <td> <td>✓<td>✓<td>✓
 </tr>
 <tr id="non-falsifiable">
  <td>Non-Falsifiable
  <td>

  Provenance cannot be falsified by the build service's users.

  * The provenance signing key MUST be stored in a secure key management system
    accessible only to the build service account.
  * The provenance signing key MUST NOT be accessible to the environment running
    the user-defined build steps.
  * Every field in the provenance MUST be generated or verified by the build
    service in a trusted control plane. The user-controlled build steps MUST
    NOT be able to inject or alter the contents, except as noted below.

  The following provenance fields MAY be generated by the user-controlled build
  steps without the build service verifying their correctness:

  * The output artifact hash from [Identifies Artifact](#identifies-artifact).
    * Reasoning: This only allows a "bad" build to falsely claim that it
      produced a "good" artifact. This is not a security problem because the
      consumer MUST accept only "good" builds and reject "bad" builds.
  * The "reproducible" boolean and justification from
    [Reproducible](#reproducible).


  <td> <td> <td>✓<td>✓
 </tr>
 <tr id="dependencies-complete">
  <td>Dependencies Complete
  <td>

  Provenance records all build dependencies that were available while running
  the build steps. This includes the initial state of the machine, VM, or
  container of the build worker.

  * MUST include all user-specified build steps, sources, dependencies.
  * SHOULD include all service-provided artifacts.

  <td> <td> <td> <td>✓
 </tr>
</table>

Requirements on the contents of the provenance:

<table>
 <tr><th>Requirement<th>Description<th>L1<th>L2<th>L3<th>L4</tr>
 <tr id="identifies-artifact">
  <td>Identifies Artifact
  <td>

  The provenance identifies the output artifact via a cryptographic hash. The
  RECOMMENDED algorithm is SHA-256 for cross-system compatibility. If another
  algorithm is used, it SHOULD be resistant to collisions and second preimages.

  <td>✓<td>✓<td>✓<td>✓
 </tr>
 <tr id="identifies-builder">
  <td>Identifies Builder
  <td>

  The provenance identifies the entity that performed the build and generated
  the provenance. This represents the entity that the consumer must trust.
  Examples: "GitHub Actions with a GitHub-hosted worker", "jdoe@example.com's
  machine".

  <td>✓<td>✓<td>✓<td>✓
 </tr>
 <tr id="identifies-source">
  <td>Identifies Source
  <td>

  The provenance identifies the source containing the top-level build script,
  via an [immutable reference]. Example: git URL + branch/tag/ref + commit ID.

  <td>✓<td>✓<td>✓<td>✓
 </tr>
 <tr id="identifies-entry-point">
  <td>Identifies Entry Point
  <td>

  The provenance identifies the "entry point" or command that was used to
  invoke the build script. Example: `make all`.

  <td>✓<td>✓<td>✓<td>✓
 </tr>
 <tr id="includes-all-params">
  <td>Includes All Build Parameters
  <td>

  The provenance includes all build parameters under a user's control.
  See [Parameterless](#parameterless) for details. (At L3, the parameters must
  be listed; at L4, they must be empty.)

  <td> <td> <td>✓<td>✓
 </tr>
 <tr id="includes-all-deps">
  <td>Includes All Transitive Dependencies
  <td>

  The provenance includes all transitive dependencies listed in
  [Dependencies Complete](#dependencies-complete).

  <td> <td> <td> <td>✓
 </tr>
 <tr id="includes-reproducible-info">
  <td>Includes Reproducible Info
  <td>

  The provenance includes a boolean indicating whether build is intended to be
  reproducible and, if so, all information necessary to reproduce the build.
  See [Reproducible](#reproducible) for more details.

  <td> <td> <td> <td>✓
 </tr>
 <tr id="includes-metadata">
  <td>Includes Metadata
  <td>

  The provenance includes metadata to aid debugging and investigations. This
  SHOULD at least include start and end timestamps and a permalink to debug
  logs.

  "○" = RECOMMENDED.

  <td>○<td>○<td>○<td>○
 </tr>
</table>
