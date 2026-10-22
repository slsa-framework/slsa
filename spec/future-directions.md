---
title: Future directions
description: This page collects some early thoughts on how SLSA might evolve in future versions to add additional aspects of automatable supply chain security.
---

This page collects some early thoughts on how SLSA **might** evolve in future
versions to add additional aspects of automatable supply chain security.

<section id="platform-operations-track">

## Platform Operations track

A Platform Operations track could provide assurances around the hardening of
platforms (e.g. build or source platforms) as they are operated.

The initial [draft version (v0.1)] of SLSA included a section on
[common requirements](../v0.1/requirements.md#common-requirements) that formed
the foundation of the guidance for
[assessing build platforms](assessing-build-platforms.md), which **may or may not** form
the basis for a future Build Platform Operations track:

-   Controls for approval, logging, and auditing of all physical and remote
    access to platform infrastructure, cryptographic secrets, and privileged
    debugging interfaces.
-   Conformance to security best practices to minimize the risk of compromise.
-   Protection of cryptographic secrets used by the build platform.

</section>

[draft version (v0.1)]: ../v0.1/requirements.md
