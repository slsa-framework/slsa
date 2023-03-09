---
prev_page:
  title: Security levels
  url: levels
next_page:
  title: Terminology
  url: terminology
---

# Guiding principles

<div class="subtitle">

This page provides a background on the guiding principles behind SLSA. It is
intended to help the reader better understand SLSA's design decisions.

</div>

## Trust systems, verify artifacts

One of the main ideas behind SLSA is to establish trust in a small number of
*systems* and then automatically verify the many *artifacts* produced by those
systems. In this way, SLSA is able to scale to support hundreds of thousands of
software projects with a near-constant amount of central work.

We have no option but to manually analyze and reason about the behavior of some
number of trusted *systems*, such as change management, build, and packaging
systems. There will always be some trusted computing base on which we rely for
security. We need to analyze and reason about this computing base to convince
ourselves that it meets our security needs. Such analysis is difficult and
expensive. We cannot possibly harden and audit thousands of bespoke build
systems. We can, however, do this for a small number of general purpose systems.

Once we have a set of trusted systems, we can verify the supply chain of
arbitrarily many *artifacts* by ensuring that artifacts were produced by trusted
systems. This allows SLSA to scale to entire ecosystems and organizations
regardless of size.

For example, a security engineer may analyze the architecture and implementation
of a build system to ensure that it meets the SLSA build requirements. Once the
analysis is complete, the public keys used by the build system to sign
provenance can then be "trusted" up to a given SLSA level. Downstream systems
can then automatically determine that an artifact meets a given level by
verifying that it has provenance signed by that public key.

### Corollary: Minimize the number of trusted systems

A corollary to the previous principle is to minimize the size of the trusted
computing base. Every system we trust adds attack surface and increases the need
for manual security analysis. Where possible:

-   Concentrate trust in shared infrastructure. For example, instead of each
    team maintaining their own build system, use a shared build system. This way
    hardening work can be shared across all teams.
-   Remove the need to trust components whenever possible. For example, use
    end-to-end signing to avoid the need to trust intermediate distribution
    systems.

## Anchor trust in code, not individuals

Another idea behind SLSA is to anchor our trust in source code rather than
individual maintainers who have write access to package registries. Code is
static and analyzable. People, on the other hand, are prone to mistakes,
credential compromise, and sometimes malicious action. Therefore, SLSA aims to
securely trace all software back to source code, without the possibility for an
individual maintainer to tamper with it after it has been committed.

## Prefer attestations over inferences

SLSA places a strong emphasis on explicit attestations about security
properties, particularly an artifact's provenance, rather than inferring
security properties from how a system is configured.

Theoretically one could configure access control such that the only path from
source to release is through the official channels: the CI/CD system only pulls
from the proper source, package registry only allows access to the CI/CD system,
and so on. In practice, that is almost impossible to get right and keep right.
There are often over-provisioning, confused deputy problems, or mistakes. Even
if it is configured properly at one moment, there is no guarantee that it will
continue to stay so. And humans almost always end up getting in the access
control lists.

Instead, SLSA prefers explicit attestations about an artifact's provenance.
Access control is still important, but SLSA provides a defense in depth: it is
not sufficient to be granted access to publish a package; one must also have
proof in the form of attestations that a package was built correctly. This way,
the intermediate systems are taken out of the trust base and any individuals
that are accidentally granted access do not have sufficient permission to tamper
with the package.
