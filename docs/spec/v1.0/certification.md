# Certification

## **TODO**

- [ ] Create a self-certification questionnaire.
- [ ] Add a link to the SLSA Self-Certification Questionnaire.

## Overview

> User's looking for certifications for a particular build system can find them
> on the [Certification Registry](certification-registry.md).

The SLSA Framework defines a series of levels that describe increasing security
guarantees. The certification process is intended to verify that a build system
meets the requirements of a particular SLSA level and is provided to help users
determine the level of trust they can place in a build system and the artifacts
it produces.

## Certification Tiers

These tiers are intended to provide users with a way to determine the level of
trust they can place in a build system. The following tiers are defined:

### Tier 0 - No evidence of conformance

> **Note:** If a build system is not listed in the
> [Certification Registry](certification-registry.md), you should assume that it
> is in Tier 0.

The Tier 0 trust tier is the lowest level of trust. Build systems in this tier
have not produced any supporting evidence for their claimed level of SLSA
conformance and no third-party verification has been performed. It is
recommended that users exercise caution or take additional steps to verify the
build system before using it.

### Tier 1 - Self-certified conformance

> Build systems in this trust tier are listed in the
> [Certification Registry](certification-registry.md).

Tier 1 signifies that a build system owner has self-certified their build system
to a particular SLSA level. This certification is intended to be a reasonable
level of trust. Users should still exercise reasonable caution when using a
build system in this trust tier and should consider reviewing the full
responses to the self-certification questionnaire.

#### Process

The self-certification process includes the following steps:

1. The build system owner fills out the SLSA Self-Certification Questionnaire to
   document their build system's conformance to a particular SLSA level.
   **[TODO] provide link to questionnaire**
2. The build system owner attests to the accuracy of the questionnaire responses
   and publishes it on their website.
3. The build system owner publishes their public key to a public key server.
4. The build system owner submits a pull request to add their build system to
   the [Certification Registry](certification-registry.md). **[TODO] provide PR
   template link**

### Tier 2 - Third-party verified conformance [TODO]

**Note:** This tier is not yet implemented.
