# SLSA definitions

_Reminder: The definitions below are not yet finalized and subject to change. In
particular, (1) we expect to renumber the levels to be integers; and (2) levels
2-3 are likely to undergo further changes._

An artifact's **SLSA level** describes the integrity strength of its direct
supply chain, meaning its direct sources and build steps. To verify that the
artifact meets this level, **provenance** is required. This serves as evidence
that the level's requirements have been met.

## Terminology

An **artifact** is an immutable blob of data. Example artifacts: a file, a git
commit, a directory of files (serialized in some way), a container image, a
firmware image. The primary use case is for _software_ artifacts, but SLSA can
be used for any type of artifact.

A **software supply chain** is a sequence of steps resulting in the creation of
an artifact. We represent a supply chain as a
[directed acyclic graph](https://en.wikipedia.org/wiki/Directed_acyclic_graph)
of sources, builds, dependencies, and packages. Furthermore, each source, build,
and package may be hosted on a platform, such as Source Code Management (SCM) or
Continuous Integration / Continuous Deployment (CI/CD). Note that one artifact's
supply chain is a combination of its dependencies' supply chains plus its own
sources and builds.

The following diagram shows the relationship between concepts.

![Software Supply Chain Model](images/supply-chain-model.svg)

<table>
 <thead>
  <tr>
   <th>Term
   <th>Description
   <th>Example
  </tr>
 </thead>
 <tbody>
  <tr>
   <th>Source
   <td>Artifact that was directly authored or directly by persons, without modification. It is the beginning of the supply chain; we do not trace the provenance back any further.
   <td>Git commit (source) hosted on GitHub (platform).
  </tr>
   <th>Build
   <td>Process that transforms a set of input artifacts into a set of output artifacts. The inputs may be sources, dependencies, or ephemeral build outputs.
   <td>.travis.yml (process) run by Travis CI (platform).
  </tr>
  <tr>
   <th>Package
   <td>Artifact that is "published" for use by others. In the model, it is
   always the output of a build process, though that build process can be a
   no-op.
   <td>Docker image (package) distributed on DockerHub (platform).
  </tr>
  <tr>
   <th>Dependency
   <td>Artifact that is an input to a build process but that is not a source. In
   the model, it is always a package.
   <td>Alpine package (package) distributed on Alpine Linux (platform).
  </tr>
 </tbody>
</table>

Special cases:

*   A ZIP file is containing source code is a package, not a source, because it
    is built from some other source, such as a git commit.

## Level descriptions

_This section is non-normative._

There are four SLSA levels. SLSA 3 is the current highest level and represents
the ideal end state. SLSA 1–2 offer lower security guarantees but are easier to
meet. In our experience, achieving SLSA 3 can take many years and significant
effort, so intermediate milestones are important.

<table>
 <thead>
  <tr>
   <th>Level
   <th>Meaning
  </tr>
 </thead>
 <tbody>
  <tr>
   <td>SLSA 3
   <td>"Auditable and Non-Unilateral." High confidence that (1) one can correctly and easily trace back to the original source code, its change history, and all dependencies and (2) no single person has the power to make a meaningful change to the software without review.
  </tr>
  <tr>
   <td>SLSA 2
   <td>"Auditable." Moderate confidence that one can trace back to the original source code and change history. However, trusted persons still have the ability to make unilateral changes, and the list of dependencies is likely incomplete.
  </tr>
  <tr>
   <td>SLSA 1.5
   <td>Stepping stone to higher levels. Moderate confidence that one can determine either who authorized the artifact or what systems produced the artifact. Protects against tampering after the build.
  </tr>
  <tr>
   <td>SLSA 1
   <td>Entry point into SLSA. Provenance indicates the artifact's origins without any integrity guarantees.
  </tr>
 </tbody>
</table>

## Level requirements

<!-- When editing this table, also edit ../README.md. -->

<table>
 <thead>
  <tr><th colspan="2">           <th colspan="4">Required at</tr>
  <tr><th colspan="2">Requirement<th>SLSA 1<th>SLSA 1.5<th>SLSA 2<th>SLSA 3</tr>
 </thead>
 <tbody>
  <tr><td rowspan="4">Source
      <td>Version Controlled        <td> <td>✓<td>✓     <td>✓</tr>
  <tr><td>Verified History          <td> <td> <td>✓     <td>✓</tr>
  <tr><td>Retained Indefinitely     <td> <td> <td>18 mo.<td>✓</tr>
  <tr><td>Two-Person Reviewed       <td> <td> <td>      <td>✓</tr>
  <tr><td rowspan="6">Build
      <td>Scripted                  <td>✓<td>✓<td>✓     <td>✓</tr>
  <tr><td>Build Service             <td> <td>✓<td>✓     <td>✓</tr>
  <tr><td>Ephemeral Environment     <td> <td> <td>✓     <td>✓</tr>
  <tr><td>Isolated                  <td> <td> <td>✓     <td>✓</tr>
  <tr><td>Hermetic                  <td> <td> <td>      <td>✓</tr>
  <tr><td>Reproducible              <td> <td> <td>      <td>○</tr>
  <tr><td rowspan="5">Provenance
      <td>Available                 <td>✓<td>✓<td>✓     <td>✓</tr>
  <tr><td>Authenticated             <td> <td>✓<td>✓     <td>✓</tr>
  <tr><td>Service Generated         <td> <td>✓<td>✓     <td>✓</tr>
  <tr><td>Non-Falsifiable           <td> <td> <td>✓     <td>✓</tr>
  <tr><td>Dependencies Complete     <td> <td> <td>      <td>✓</tr>
  <tr><td rowspan="3">Common
      <td>Security                  <td> <td> <td>      <td>✓</tr>
  <tr><td>Access                    <td> <td> <td>      <td>✓</tr>
  <tr><td>Superusers                <td> <td> <td>      <td>✓</tr>
 </tbody>
</table>

_○ = required unless there is a justification_

Note: The actual requirements will necessarily be much more detailed and
nuanced. We only provide a brief summary here for clarity.

**[Source]** Requirements for the artifact's top-level source (i.e. the one
containing the build script):

*   **[Version Controlled]** Every change to the source is tracked in a version
    control system that identifies who made the change, what the change was, and
    when that change occurred.
*   **[Verified History]** The version control history indicates which actor
    identities (author, uploader, reviewer, etc.) and timestamps were strongly
    authenticated. For example, GitHub-generated merge commits for pull requests
    meet this requirement.
*   **[Retained Indefinitely]** The artifact and its change history are retained
    indefinitely and cannot be deleted.
*   **[Two-Person Review]** At least two trusted persons agreed to every change
    in the history.

**[Build]** Requirements for the artifact's build process:

*   **[Scripted]** All build steps were fully defined in some sort of "build
    script". The only manual command, if any, was to invoke the build script.
*   **[Build Service]** All build steps ran using some build service, such as a
    Continuous Integration (CI) platform, not on a developer's workstation.
*   **[Ephemeral Environment]** The build steps ran in an ephemeral environment,
    such as a container or VM, provisioned solely for this build, and not reused
    by other builds.
*   **[Isolated]** The build steps ran in an isolated environment free of
    influence from other build instances, whether prior or concurrent. Build
    caches, if used, are purely content-addressable to prevent tampering.
*   **[Hermetic]** All build steps, sources, and dependencies were fully
    declared up front with immutable references, and the build steps ran with no
    network access. All dependencies were fetched by the build service control
    plane and checked for integrity.
*   **[Reproducible]** Re-running the build steps with identical input artifacts
    results in bit-for-bit identical output. (Builds that cannot meet this must
    provide a justification.)

**[Provenance]** Requirements for the artifact's provenance:

*   **[Available]** Provenance is available to the consumer of the artifact, or
    to whomever is verifying the policy, and it identifies at least the
    artifact, the system that performed the build, and the top-level source. All
    artifact references are immutable, such as via a cryptographic hash.
*   **[Authenticated]** Provenance's authenticity and integrity can be verified,
    such as through a digital signature.
*   **[Service Generated]** Provenance is generated by the build service itself,
    as opposed to user-provided tooling running on top of the service.
*   **[Non-Falsifiable]** Provenance cannot be falsified by the build service's
    users.
*   **[Dependencies Complete]** Provenance records all build dependencies,
    meaning every artifact that was available to the build script. This includes
    the initial state of the machine, VM, or container of the build worker.

**[Common]** Common requirements for every trusted system involved in the supply
chain (source, build, distribution, etc.):

*   **[Security]** The system meets some TBD baseline security standard to
    prevent compromise. (Patching, vulnerability scanning, user isolation,
    transport security, secure boot, machine identity, etc. Perhaps
    [NIST 800-53](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-53r5.pdf)
    or a subset thereof.)
*   **[Access]** All physical and remote access must be rare, logged, and gated
    behind multi-party approval.
*   **[Superusers]** Only a small number of platform admins may override the
    guarantees listed here. Doing so MUST require approval of a second platform
    admin.

## Scope of SLSA

SLSA is not transitive. It describes the integrity protections of an artifact's
build process and top-level source, but nothing about the artifact's
dependencies. Dependencies have their own SLSA ratings, and it is possible for a
SLSA 3 artifact to be built from SLSA 0 dependencies.

The reason for non-transitivity is to make the problem tractable. If SLSA 3
required dependencies to be SLSA 3, then reaching SLSA 3 would require starting
at the very beginning of the supply chain and working forward. This is
backwards, forcing us to work on the least risky component first and blocking
any progress further downstream. By making each artifact's SLSA rating
independent from one another, it allows parallel progress and prioritization
based on risk. (This is a lesson we learned when deploying other security
controls at scale throughout Google.)

We expect SLSA ratings to be composed to describe a supply chain's overall
security stance, as described in the
[vision](../background.md#vision-case-study).
