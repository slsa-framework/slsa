---
title: Guiding principles
description: An introduction to the guiding principles behind SLSA's design decisions.
---

This page is an introduction to the guiding principles behind SLSA's design
decisions.

## Trust platforms, verify artifacts

Establish trust in a small number of platforms and systems---such as change management, build,
and packaging platforms---and then automatically verify the many artifacts
produced by those platforms.

**Reasoning**: Trusted computing bases are unavoidable---there's no choice but
to trust some platforms. Hardening and verifying platforms is difficult and
expensive manual work, and each trusted platform expands the attack surface of the
supply chain. Verifying that an artifact is produced by a trusted platform,
though, is easy to automate.

To simultaniously scale and reduce attack surfaces, it is most efficient to trust a limited
numbers of platforms and then automate verification of the artifacts produced by those platforms.
The attack surface and work to establish trust does not scale with the number of artifacts produced,
as happens when artifacts each use a different trusted platform.

**Benefits**: Allows SLSA to scale to entire ecosystems or organizations with a near-constant
amount of central work.

### Example

A security engineer analyzes the architecture and implementation of a build
platform to ensure that it meets the SLSA Build Track requirements. Following the
analysis, the public keys used by the build platform to sign provenance are
"trusted" up to the given SLSA level. Downstream platforms verify the provenance
signed by the public key to automatically determine that an artifact meets the
SLSA level.  

### Corollary: Minimize the number of trusted platforms

A corollary to this principle is to minimize the size of the trusted computing
base. Every platform we trust adds attack surface and increases the need for
manual security analysis. Where possible:

-   Concentrate trust in shared infrastructure. For example, instead of each
    team within an organization maintaining their own build platform, use a
    shared build platform. Hardening work can be shared across all teams.
-   Remove the need to trust components. For example, use end-to-end signing
    to avoid the need to trust intermediate distribution platforms.

## Trust code, not individuals

Securely trace all software back to source code rather than trust individuals who have write access to package registries.

**Reasoning**: Code is static and analyzable. People, on the other hand, are prone to mistakes,
credential compromise, and sometimes malicious action.

**Benefits**: Removes the possibility for a trusted individual---or an
attacker abusing compromised credentials---to tamper with source code
after it has been committed.

## Prefer attestations over inferences

Require explicit attestations about an artifact's provenance; do not infer
security properties from a platform's configurations.

**Reasoning**: Theoretically, access control can be configured so that the only path from
source to release is through the official channels: the CI/CD platform pulls only
from the proper source, package registry allows access only to the CI/CD platform,
and so on. We might infer that we can trust artifacts produced by these platforms
based on the platform's configuration.

In practice, though, these configurations are almost impossible to get right and
keep right. There are often over-provisioning, confused deputy problems, or
mistakes. Even if a platform is configured properly at one moment, it might not
stay that way, and humans almost always end up getting in the access control
lists.  

Access control is still important, but SLSA goes further to provide defense in depth: it **requires proof in
the form of attestations that the package was built correctly**.

**Benefits**: The attestation removes intermediate platforms from the trust base and ensures that
individuals who are accidentally granted access do not have sufficient permission to tamper with the package.
