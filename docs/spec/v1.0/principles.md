---
prev_page:
  title: What's new in SLSA v1.0
  url: whats-new
next_page:
  title: Supply-chain threats
  url: threats-overview
---

# About SLSA

This page is an introduction to SLSA and its guiding principles. If you're new
to SLSA, start here!

## What is SLSA?

SLSA is a set of incrementally adoptable security guidelines, established by
industry consensus. The standards set by SLSA are guiding principles for both
software producers and consumers: producers can follow the guidelines to make
their software more secure, and consumers can make decisions based on a software
package's security posture. SLSA's levels are designed to be incremental
and actionable, and to protect against specific classes of supply chain attacks.
The highest level in each track represents an ideal end state, and the lower
levels represent intermediate milestones with commensurate security guarantees.

Importantly, SLSA is intended to be a primitive in a broader determination of a
software's risk. SLSA measures specific aspects of supply chain security,
particularly those that can be fully automated; other aspects, such as developer
trust and code quality, are out of scope. Furthermore, each link in the software
supply chain has its own, independent SLSA level---in other words, it is not
transitive ([FAQ](faq.md#q-why-is-slsa-not-transitive)). The benefit of this
approach is to break up the large supply chain security problem into tractable
subproblems that can be prioritized based on risk and tackled in parallel. But
this does mean that SLSA alone is not sufficient to determine if an artifact is
"safe".

Finally, SLSA is in the eye of the beholder: software consumers ultimately make
their own SLSA determinations, though in practice they may delegate to some
authority. For example, a build system may claim to conform to SLSA Build L3,
but it is up to a consumer whether to trust that claim.

## Who is SLSA for?

SLSA is intended to serve multiple populations:

-   **Project maintainers,** who are often small teams that know their build
    process and trust their teammates. Their primary goal is protection against
    compromise with as low overhead as possible. They may also benefit from
    easier maintenance and increased consumer confidence.

-   **Consumers,** who use a variety of software and do not know the maintainers
    or their build processes. Their primary goal is confidence that the software
    has not been tampered with. They are concerned about rogue maintainers,
    compromised credentials, and compromised infrastructure.

-   **Organizations,** who are both producers and consumers of software. In
    addition to the goals above, organizations also want to broadly understand
    and reduce risk across the organization.

-   **Infrastructure providers,** such as build services and package
    ecosystems, who are critical to achieving SLSA. While not the primary
    beneficiary of SLSA, they may benefit from increased security and user
    trust.

## Guiding principles

The following section describes the guiding principles behind SLSA's design
decisions.

### Trust systems, verify artifacts

Establish trust in a small number of systems---such as change management, build,
and packaging systems---and then automatically verify the many artifacts
produced by those systems.

**Reasoning**: Trusted computing bases are unavoidable---there's no choice but
to trust some systems. Hardening and verifying systems is difficult and
expensive manual work, and each trusted system expands the attack surface of the
supply chain. Verifying that an artifact is produced by a trusted system,
though, is easy to automate.

To simultaniously scale and reduce attack surfaces, it is most efficient to trust a limited
numbers of systems and then automate verification of the artifacts produced by those systems.
The attack surface and work to establish trust does not scale with the number of artifacts produced,
as happens when artifacts each use a different trusted system.

**Benefits**: Allows SLSA to scale to entire ecosystems or organizations with a near-constant
amount of central work.

#### Example

A security engineer analyzes the architecture and implementation of a build
system to ensure that it meets the SLSA Build Track requirements. Following the
analysis, the public keys used by the build system to sign provenance are
"trusted" up to the given SLSA level. Downstream systems verify the provenance
signed by the public key to automatically determine that an artifact meets the
SLSA level.  

#### Corollary: Minimize the number of trusted systems

A corollary to this principle is to minimize the size of the trusted computing
base. Every system we trust adds attack surface and increases the need for
manual security analysis. Where possible:

-   Concentrate trust in shared infrastructure. For example, instead of each
    team within an organization maintaining their own build system, use a
    shared build system. Hardening work can be shared across all teams.
-   Remove the need to trust components. For example, use end-to-end signing
    to avoid the need to trust intermediate distribution systems.

### Trust code, not individuals

Securely trace all software back to source code rather than trust individual maintainers who have write access to package registries.

**Reasoning**: Code is static and analyzable. People, on the other hand, are prone to mistakes,
credential compromise, and sometimes malicious action.

**Benefits**: Removes the possibility for an individual maintainer---or an
attacker abusing a compromised maintainer's credentials---to tamper with source code
after it has been committed.

### Prefer attestations over inferences

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

Access control is still important, but SLSA goes further to provide defense in depth: it **requires proof in
the form of attestations that the package was built correctly**.

**Benefits**: The attestation removes intermediate systems from the trust base and ensures that
individuals who are accidentally granted access do not have sufficient permission to tamper with the package.
