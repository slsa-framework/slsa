# SLSA: Supply-chain Levels for Software Artifacts

Supply-chain Levels for Software Artifacts (SLSA, pronounced
_[salsa](https://www.google.com/search?q=how+to+pronounce+salsa)_) is an
end-to-end framework for ensuring the integrity of software artifacts throughout
the software supply chain. The requirements are inspired by Google’s internal
"[Binary Authorization for Borg]" that has been in use for the past 8+ years and
that is mandatory for all of Google's production workloads.

**IMPORTANT:** SLSA is an evolving specification and we are looking for
wide-ranging feedback via GitHub issues, [email][mailing list], or
[feedback form]. SLSA is being developed as part of the
[OpenSSF Digital Identity WG](https://github.com/ossf/wg-digital-identity-attestation).

## Overview

SLSA consists of:

1.  **Standards:** (this doc) Industry consensus on the definition of a "secure"
    software supply chain. There may be multiple standards to represent multiple
    aspects of security.
2.  **Accreditation:** Process for organizations to certify compliance with
    these standards.
3.  **[Technical controls](controls/README.md):** To record provenance and
    detect or prevent non-compliance.

Ultimately, the software consumer decides whom to trust and what standards to
enforce. In this light, accreditation is a means to transfer trust across
organizational boundaries. For example, a company may internally "accredit" its
in-house source and build systems while relying on OpenSSF to accredit
third-party ones. Other organizations may trust other accreditation bodies.

This document *only discusses the first part*, Standards. We expect to develop
an accreditation process and technical controls over time. In the interim, these
levels can provide value as guidelines for how to secure a software supply
chain.

## Principles

SLSA focuses on the following two main principles:

*   **Non-unilateral:** No person can modify the software artifact anywhere in
    the software supply chain without explicit review and approval by at least
    one other "trusted person."[^1] The purpose is prevention, deterrence,
    and/or early detection of risky/bad changes.

*   **Auditable:** The software artifact can be securely and transparently
    traced back to the original, human readable sources and dependencies. The
    primary purpose is for automated analyses of sources and dependencies, as
    well as ad-hoc investigations.

Though not perfect, these two principles provide substantial mitigation for a
wide range of tampering, confusion, and other supply chain attacks.

To measure how well protected a supply chain is according to the two principles
above, we propose the SLSA levels. A higher level means it is better protected.
SLSA 4 is the end goal but may take many years and significant investment for
large organizations. SLSA 1 through SLSA 3 are stepping stones to recognize
meaningful progress.

What sets SLSA 4 apart from simple best practices is its resilience against
determined adversaries. That is, SLSA is a **guarantee** that these practices
have been followed, though still not a guarantee that the software is "safe."

## Background

### Why do we need SLSA?

SLSA addresses three issues:

*   Software producers want to secure their supply chains but don't know exactly
    how.
*   Software consumers want to understand and limit their exposure to supply
    chain attacks but have no means of doing so.
*   Artifact signatures alone only prevent a subset of the attacks we care
    about.

At a minimum, SLSA can be used as a set of guiding principles for software
producers and consumers. More importantly, SLSA allows us to talk about supply
chain risks and mitigations in a common language. This allows us to communicate
and act on those risks across organizational boundaries.

Numeric levels, in particular, are useful because they are simple. A decision
maker easily understands that SLSA 4 is better than SLSA 3 without understanding
any of the details. That said, we are not committed to numeric levels and are
open to other options.

Once SLSA is complete it will provide a mapping from requirements that the
supply chain can implement to the attacks they can prevent. Software producers
and consumers will be able to look at the SLSA level of a software artifact and
know what attacks have been defended against in its production.

### What about reproducible builds?

When talking about [reproducible builds](https://reproducible-builds.org), 
there are two related but distinct concepts: "reproducible" and
"verified reproducible."

"Reproducible" means that repeating the build with the same inputs results in
bit-for-bit identical output. This property
[provides](https://reproducible-builds.org/docs/buy-in/)
[many](https://wiki.debian.org/ReproducibleBuilds/About)
[benefits](https://static.googleusercontent.com/media/sre.google/en//static/pdf/building_secure_and_reliable_systems.pdf#page=357),
including easier debugging, more confident cherry-pick releases, better build
caching and storage efficiency, and accurate dependency tracking.

For these reasons, SLSA 4 [requires](#level-requirements) reproducible builds
unless there is a justification why the build cannot be made reproducible.
[Example](https://lists.reproducible-builds.org/pipermail/rb-general/2021-January/002177.html)
justifications include profile-guided optimizations or code signing that
invalidates hashes. Note that there is no actual reproduction, just a claim that
reproduction is possible.

"Verified reproducible" means using two or more independent build systems to
corroborate the provenance of a build. In this way, one can create an overall
system that is more trustworthy than any of the individual components. This is
often
[suggested](https://www.linuxfoundation.org/en/blog/preventing-supply-chain-attacks-like-solarwinds/)
as a solution to supply chain integrity. Indeed, this is one option to secure
build steps of a supply chain. When designed correctly, such a system can
satisfy all of the SLSA build requirements.

That said, verified reproducible builds are not a complete solution to supply
chain integrity, nor are they practical in all cases:

*   Reproducible builds do not address source, dependency, or distribution
    threats.
*   Reproducers must truly be independent, lest they all be susceptible to the
    same attack. For example, if all rebuilders run the same pipeline software,
    and that software has a vulnerability that can be triggered by sending a
    build request, then an attacker can compromise all rebuilders, violating the
    assumption above.
*   Some builds cannot easily be made reproducible, as noted above.
*   Closed-source reproducible builds require the code owner to either grant
    source access to multiple independent rebuilders, which is unacceptable in
    many cases, or develop multiple, independent in-house rebuilders, which is
    likely prohibitively expensive.

Therefore, SLSA does not require verified reproducible builds directly. Instead,
verified reproducible builds are one option for implementing the requirements.

For more on reproducibility, see
[Hermetic, Reproducible, or Verifiable?](https://sre.google/static/pdf/building_secure_and_reliable_systems.pdf#page=357)

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
   <td>Artifact that was directly authored or reviewed by persons, without modification. It is the beginning of the supply chain; we do not trace the provenance back any further.
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

## SLSA definitions

_Reminder: The definitions below are not yet finalized and subject to change,
particularly SLSA 3-4._

An artifact's **SLSA level** describes the integrity strength of its direct
supply chain, meaning its direct sources and build steps. To verify that the
artifact meets this level, **provenance** is required. This serves as evidence
that the level's requirements have been met.

### Level descriptions

_This section is non-normative._

There are four SLSA levels. SLSA 4 is the current highest level and represents
the ideal end state. SLSA 1–3 offer lower security guarantees but are easier to
meet. In our experience, achieving SLSA 4 can take many years and significant
effort, so intermediate milestones are important. We also use the term SLSA 0 to
mean the lack of a SLSA level.

<table>
 <thead>
  <tr>
   <th>Level
   <th>Meaning
  </tr>
 </thead>
 <tbody>
  <tr>
   <td>SLSA 4
   <td>"Auditable and Non-Unilateral." High confidence that (1) one can correctly and easily trace back to the original source code, its change history, and all dependencies and (2) no single person has the power to make a meaningful change to the software without review.
  </tr>
  <tr>
   <td>SLSA 3
   <td>"Auditable." Moderate confidence that one can trace back to the original source code and change history. However, trusted persons still have the ability to make unilateral changes, and the list of dependencies is likely incomplete.
  </tr>
  <tr>
   <td>SLSA 2
   <td>Stepping stone to higher levels. Moderate confidence that one can determine either who authorized the artifact or what systems produced the artifact. Protects against tampering after the build.
  </tr>
  <tr>
   <td>SLSA 1
   <td>Entry point into SLSA. Provenance indicates the artifact's origins without any integrity guarantees.
  </tr>
 </tbody>
</table>

### Level requirements

<table>
 <thead>
  <tr><th colspan="2">           <th colspan="4">Required at</tr>
  <tr><th colspan="2">Requirement<th>SLSA 1<th>SLSA 2<th>SLSA 3<th>SLSA 4</tr>
 </thead>
 <tbody>
  <tr><td rowspan="4">Source
      <td>Version Controlled        <td> <td>✓<td>✓     <td>✓</tr>
  <tr><td>Verified History          <td> <td> <td>✓     <td>✓</tr>
  <tr><td>Retained Indefinitely     <td> <td> <td>18 mo.<td>✓</tr>
  <tr><td>Two-Person Reviewed       <td> <td> <td>      <td>✓</tr>
  <tr><td rowspan="7">Build
      <td>Scripted                  <td>✓<td>✓<td>✓     <td>✓</tr>
  <tr><td>Build Service             <td> <td>✓<td>✓     <td>✓</tr>
  <tr><td>Ephemeral Environment     <td> <td> <td>✓     <td>✓</tr>
  <tr><td>Isolated                  <td> <td> <td>✓     <td>✓</tr>
  <tr><td>Parameterless             <td> <td> <td>      <td>✓</tr>
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

The following is a summary. For details, see corresponding
[Source][source-reqs], [Build/Provenance][build-reqs], and [Common][common-reqs]
documents.

**[\[Source\]][source-reqs]** Requirements for the artifact's top-level source,
meaning the one containing the build script:

*   **[Version Controlled]** Every change to the source is tracked in a version
    control system that identifies who made the change, what the change was, and
    when that change occurred.
*   **[Verified History]** Every change in the history has at least one strongly
    authenticated actor identity (author, uploader, reviewer, etc.) and
    timestamp.
*   **[Retained Indefinitely]** The artifact and its change history are retained
    indefinitely and cannot be deleted.
*   **[Two-Person Review]** At least two trusted persons agreed to every change
    in the history.

**[\[Build\]][build-reqs]** Requirements for the artifact's build process:

*   **[Scripted]** All build steps were fully defined in some sort of "build
    script". The only manual command, if any, was to invoke the build script.
*   **[Build Service]** All build steps ran using some build service, such as a
    Continuous Integration (CI) platform, not on a developer's workstation.
*   **[Ephemeral Environment]** The build steps ran in an ephemeral environment,
    such as a container or VM, provisioned solely for this build, and not reused
    from a prior build.
*   **[Isolated]** The build steps ran in an isolated environment free of
    influence from other build instances, whether prior or concurrent. Build
    caches, if used, are purely content-addressable to prevent tampering.
*   **[Parameterless]** The build output cannot be affected by user parameters
    other than the build entry point and the top-level source location.
*   **[Hermetic]** All build steps, sources, and dependencies were fully
    declared up front with immutable references, and the build steps ran with no
    network access. All dependencies were fetched by the build service control
    plane and checked for integrity.
*   **[Reproducible]** Re-running the build steps with identical input artifacts
    results in bit-for-bit identical output. (Builds that cannot meet this must
    provide a justification.)

**[\[Provenance\]][build-reqs]** Requirements for the artifact's provenance:

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

**[\[Common\]][common-reqs]** Common requirements for every trusted system
involved in the supply chain (source, build, distribution, etc.):

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
SLSA 4 artifact to be built from SLSA 0 dependencies.

The reason for non-transitivity is to make the problem tractable. If SLSA 4
required dependencies to be SLSA 4, then reaching SLSA 4 would require starting
at the very beginning of the supply chain and working forward. This is
backwards, forcing us to work on the least risky component first and blocking
any progress further downstream. By making each artifact's SLSA rating
independent from one another, it allows parallel progress and prioritization
based on risk. (This is a lesson we learned when deploying other security
controls at scale throughout Google.)

We expect SLSA ratings to be composed to describe a supply chain's overall
security stance, as described in the [vision](walkthrough.md#vision-case-study) below.

## Detailed example

For a motivating example and vision, see [detailed example](walkthrough.md).

## Related work

In parallel to the SLSA specification, there is work to develop core formats and
data models. Currently this is joint work between
[Binary Authorization](https://cloud.google.com/binary-authorization) and
[in-toto](https://in-toto.io/) but we invite wider participation.

*   [Standard attestation format](https://github.com/in-toto/attestation#in-toto-attestations)
    to express provenance and other attributes. This will allow sources and
    builders to express properties in a standard way that can be consumed by
    anyone. Also includes reference implementations for generating these
    attestations.
*   Policy data model and reference implementation.

For a broader view of the software supply chain problem:

*   [Know, Prevent, Fix: A framework for shifting the discussion around
    vulnerabilities in open
    source](https://security.googleblog.com/2021/02/know-prevent-fix-framework-for-shifting.html)
*   [Threats, Risks, and Mitigations in the Open Source Ecosystem]

Prior iterations of the ideas presented here:

*   [Building Secure and Reliable Systems, Chapter 14: Deploying Code](https://sre.google/static/pdf/building_secure_and_reliable_systems.pdf#page=339)
*   [Binary Authorization for Borg] - This is how Google implements the SLSA
    idea internally.

Other related work:

*   [CII Best Practices Badge](https://bestpractices.coreinfrastructure.org/en)
*   [Security Scorecards](https://github.com/ossf/scorecard) - Perhaps SLSA
    could be implemented as an aggregation of scorecard entries, for at least
    the checks that can be automated.
*   [Trustmarks](https://trustmark.gtri.gatech.edu/)

Other takes on provenance and CI/CD:

*   [The Path to Code Provenance](https://medium.com/uber-security-privacy/code-provenance-application-security-77ebfa4b6bc5)
*   [How to Build a Compromise-Resilient CI/CD](https://www.youtube.com/watch?v=9hCiHr1f0zM)

## Footnotes

[^1]: "Trusted person" is defined by the organization or developers that
    own/produce the software. A consumer must ultimately trust them to do the
    right thing. The non-unilateral principle protects against individuals
    within the organization subverting the organization's goals.

<!-- Links -->

[Binary Authorization for Borg]: https://cloud.google.com/security/binary-authorization-for-borg
[Threats, Risks, and Mitigations in the Open Source Ecosystem]: https://github.com/Open-Source-Security-Coalition/Open-Source-Security-Coalition/blob/master/publications/threats-risks-mitigations/v1.1/Threats%2C%20Risks%2C%20and%20Mitigations%20in%20the%20Open%20Source%20Ecosystem%20-%20v1.1.pdf
[build-reqs]: build-requirements.md
[common-reqs]: common-requirements.md
[curl-dev]: https://pkgs.alpinelinux.org/package/edge/main/x86/curl-dev
[curlimages/curl]: https://hub.docker.com/r/curlimages/curl
[feedback form]: https://forms.gle/93QRfUqF7YY2mJDi9
[mailing list]: https://groups.google.com/g/slsa-discussion
[source-reqs]: source-requirements.md
