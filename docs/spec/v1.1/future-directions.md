---
title: Future directions
description: The initial draft version (v0.1) of SLSA had a larger scope including protections against tampering with source code and a higher level of build integrity (Build L4). This page collects some early thoughts on how SLSA **might** evolve in future versions to re-introduce these notions and add other additional aspects of automatable supply chain security.
---

The initial [draft version (v0.1)] of SLSA had a larger scope including
protections against tampering with source code and a higher level of build
integrity (Build L4). This page collects some early thoughts on how SLSA
**might** evolve in future versions to re-introduce those notions and add other
additional aspects of automatable supply chain security.

<section id="build-l4">

## Build track

### Build L4

A build L4 could include further hardening of the build platform and enabling
corroboration of the provenance, for example by providing complete knowledge of
the build inputs.

The initial [draft version (v0.1)] of SLSA defined a "SLSA 4" that included the
following requirements, which **may or may not** be part of a future Build L4:

-   Pinned dependencies, which guarantee that each build runs on exactly the
    same set of inputs.
-   Hermetic builds, which guarantee that no extraneous dependencies are used.
-   All dependencies listed in the provenance, which enables downstream verifiers
    to recursively apply SLSA to dependencies.
-   Reproducible builds, which enable other build platforms to corroborate the
    provenance.

</section>

<section id="platform-operations-track">

## Platform Operations track

A Platform Operations track could provide assurances around the hardening of
platforms (e.g. build or source platforms) as they are operated.

The initial [draft version (v0.1)] of SLSA included a section on
[common requirements](../v0.1/requirements.md#common-requirements) that formed
the foundation of the guidance for
[verifying build systems](verifying-systems.md), which **may or may not** form
the basis for a future Build Platform Operations track:

-   Controls for approval, logging, and auditing of all physical and remote
    access to platform infrastructure, cryptographic secrets, and privileged
    debugging interfaces.
-   Conformance to security best practices to minimize the risk of compromise.
-   Protection of cryptographic secrets used by the build platform.

</section>

[draft version (v0.1)]: ../v0.1/requirements.md

## Source Track

The SLSA Source track will describe increasing levels of trustworthiness and completeness in a repository revision's provenance (e.g. how it was generated, who the contributors were, etc).

The Source track will be scoped to revisions of a single repository.
The intent of each revision is determined by the [software producer](terminology.md#roles) who is also responsible for declaring which Source level should apply and administering technical controls to enforce that level.

The primary purpose of the Source track will be to enable verification that the creation of a revision followed the producer's intended process.
Consumers will be able to examine source provenance attestations to determine if a revision meets their requirements.
