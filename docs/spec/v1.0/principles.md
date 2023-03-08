# Guiding principles

<div class="subtitle">

This page describes the guiding principles behind SLSA's design
decisions.

</div>

## Trust systems, verify artifacts

Establish trust in a small number of systems---such as change management, build,
and packaging systems---and then automatically verify the many artifacts
produced by those systems.

**Reasoning**: Trusted computing bases are unavoidable, but analysis to establish that trust is
difficult and expensive. It's infeasible to harden and audit thousands of
bespoke build systems.  

We can, however, do this for a small number of general purpose systems. **Once
those systems are trusted, we can verify the supply chain of _artifacts_ by
ensuring that they were produced by trusted systems**.

**Benefits**: Allows SLSA to scale to entire ecosystems or organizations with a near-constant
amount of central work.

### Example

A security engineer analyzes the architecture and implementation of a build
system to ensure that it meets the SLSA Build Track requirements. Following the
analysis, the public keys used by the build system to sign provenance are
"trusted" up to the given SLSA level. Downstream systems verify the provenance
signed by the public key to automatically determine that an artifact meets the
SLSA level.  

### Corollary: Minimize the number of trusted systems

A corollary to this principle is to minimize the size of the trusted computing
base. Every system we trust adds attack surface and increases the need for
manual security analysis. Where possible:

-   Concentrate trust in shared infrastructure. For example, instead of each
    team within an organization maintaining their own build system, use a
    shared build system. Hardening work can be shared across all teams.
-   Remove the need to trust components. For example, use end-to-end signing
    to avoid the need to trust intermediate distribution systems.

##Trust code, not individuals

Securely trace all software back to source code.  

**Reasoning**: Code is static and analyzable. People, on the other hand, are prone to mistakes,
credential compromise, and sometimes malicious action.

**Benefits**: Removes the possibility for an individual maintainer to tamper with source code
after it has been committed.

##Prefer attestations over inferences

Require explicit attestations about an artifact's provenance; do not infer
security properties from a system's configurations.

**Reasoning**: Theoretically, access control can be configured so that the only path from
source to release is through the official channels: the CI/CD system pulls only
from the proper source, package registry allows access only to the CI/CD system,
and so on. We might infer that we can trust artifacts produced by these systems
based on the system's configuration.

In practice, though, these configurations are almost impossible to get right and
keep right. There are often over-provisioning, confused deputy problems, or
mistakes. Even if a system is configured properly at one moment, it might not
stay that way, and humans almost always end up getting in the access control
lists.  

Access control is still important, but SLSA goes further and **requires proof in
the form of attestations that the package was built correctly**.

**Benefits**: The attestation removes intermediate systems from the trust base and ensures
individuals do not have sufficient permission to tamper with the package.
