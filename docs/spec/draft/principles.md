---
title: Guiding principles
description: An introduction to the guiding principles behind SLSA's design decisions.
---

This page is an introduction to the guiding principles behind SLSA's design
decisions.

## Simple levels with clear outcomes

Use [levels](levels) to communicate security state and to encourage a large
population to improve its security stance over time. When necessary, split
levels into separate tracks to recognize progress in unrelated security areas.

**Reasoning:** Levels simplify how to think about security by boiling a complex
topic into an easy-to-understand number. It is clear that level N is better than
level N-1, even to someone with passing familiarity. This provides a convenient
way to describe current security state as well as a natural path to improvement.

Guidelines:

-   **Define levels in terms of concrete security outcomes.** Each level should
    have clear and meaningful security value, such as stopping a particular
    class of threats. Levels should represent security milestones, not just
    incremental progress. Give each level an easy-to-remember mnemonic, such as
    "Provenance exists".

-   **Balance level granularity.** Too many levels makes SLSA hard to understand
    and remember; too few makes each level hard to achieve. Collapse levels
    until each step requires a non-trivial but manageable amount of work to
    implement. Separate levels if they require significant work from multiple
    distinct parties, such as infrastructure work plus user behavior changes, so
    long as the intermediate level still has some security value (prior bullet).

-   **Use tracks sparingly.** Additional tracks add extra complexity to SLSA, so
    a new track should be seen as a last resort. Each track should have a clear,
    distinct purpose with a crisply defined objective, such as trustworthy
    provenance for the [Build track](levels#build-track). As a rule of thumb, a
    new track may be warranted if it addresses threats unrelated to another
    track. Try to avoid tracks that sound confusingly similar in either name or
    objective.

## Trust platforms, verify artifacts

Establish trust in a small number of platforms and systems---such as change management, build,
and packaging platforms---and then automatically verify the many artifacts
produced by those platforms.

**Reasoning**: Trusted computing bases are unavoidable---there's no choice but
to trust some platforms. Hardening and verifying platforms is difficult and
expensive manual work, and each trusted platform expands the attack surface of the
supply chain. Verifying that an artifact is produced by a trusted platform,
though, is easy to automate.

To simultaneously scale and reduce attack surfaces, it is most efficient to trust a limited
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

## Support anonymous and pseudonymous contributions

SLSA supports anonymous and pseudonymous 'identities' within the software supply chain.
While organizations that implement SLSA may choose otherwise, SLSA itself does not require,
or encourage, participants to be mapped to their legal identities.

**Nothing in this specification should be taken to mean that SLSA requires participants to
to reveal their legal identity.**

**Reasoning**: SLSA uses identities for multiple purposes: as a trust anchor for attestations
(i.e. who or what is making this claim and do I trust it to do so) or for attributing actions
to an actor. Choice of identification technology is left to the organization and technical
stacks implementing the SLSA standards.

When identities are strongly authenticated and used consistently they can often be leveraged
for both of these purposes without requiring them to be mapped to legal identities.
This reflects how identities are often used in open source where legal name means much less
to projects than the history and behavior of a given handle over time does. Meanwhile some
organizations may choose to levy additional requirements on identities. They are free to do
so, but SLSA itself does not require it.

**Benefits**: By _not_ requiring legal identities SLSA lowers the barriers to its adoption,
enabling all of its other benefits and maintaining support for anonymous and pseudonymous
contribution as has been practiced in the software industry for decades.
