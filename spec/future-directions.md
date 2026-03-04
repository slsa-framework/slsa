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

A build L4 could include further hardening of the build service and enabling
corraboration of the provenance, for example by providing complete knowledge of
the build inputs.

The initial [draft version (v0.1)] of SLSA defined a "SLSA 4" that included the
following requirements, which **may or may not** be part of a future Build L4:

-   Pinned dependencies, which guarantee that each build runs on exactly the
    same set of inputs.
-   Hermetic builds, which guarantee that no extraneous dependencies are used.
-   All dependencies listed in the provenance, which enables downstream systems
    to recursively apply SLSA to dependencies.
-   Reproducible builds, which enable other systems to corroborate the
    provenance.

</section>

<section id="source-track">

## Source track

A Source track could provide protection against tampering of the source code
prior to the build.

The initial [draft version (v0.1)](../v0.1/requirements.md#source-requirements)
of SLSA included the following source requirements, which **may or may not**
form the basis for a future Source track:

-   Strong authentication of author and reviewer identities, such as 2-factor
    authentication using a hardware security key, to resist account and
    credential compromise.
-   Retention of the source code to allow for after-the-fact inspection and
    future rebuilds.
-   Mandatory two-person review of all changes to the source to prevent a single
    compromised actor or account from introducing malicious changes.

</section>

[draft version (v0.1)]: ../v0.1/requirements.md
