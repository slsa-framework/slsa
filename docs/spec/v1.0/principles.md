---
description: An introduction to SLSA
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

SLSA is a set of incrementally adoptable guidelines for supply-chain security,
established by industry consensus. The specification set by SLSA is useful for
both software producers and consumers: producers can follow SLSA's guidelines to
make their software supply chain more secure, and consumers can use SLSA to make
decisions about whether to trust a software package. 

SLSA offers:

-  A common vocabulary to talk about software supply-chain security
-  A way to judge the software you consume and secure your incoming supply chain
-  An actionable checklist to improve your own software's security
-  A way to measure your efforts toward compliance with forthcoming
    Executive Order standards in the Secure Software Development Framework (SSDF)

## Why SLSA is needed

High profile attacks like SolarWinds or Codecov have exposed the kind of supply
chain integrity weaknesses that may go unnoticed, yet quickly become very
public, disruptive, and costly in today's environment when exploited. They've
also shown that there are inherent risks not just in code itself, but at
multiple points in the complex process of getting that code into software
systems—that is, in the **software supply chain**. Since these attacks are on
the rise and show no sign of decreasing, a universal framework for hardening the
software supply chain is needed, as evidenced by the
[U.S. Executive Order on Improving the Nation's Cybersecurity](https://www.whitehouse.gov/briefing-room/presidential-actions/2021/05/12/executive-order-on-improving-the-nations-cybersecurity/).

Security techniques for vulnerability detection and analysis of source code are
essential, but are not enough on their own. Even after fuzzing or vulnerability
scanning is completed, changes to code can happen, whether unintentionally or
from a compromised or malicious insider. Risk for code modification exists at
each link in a typical software supply chain, from source to build through
packaging and distribution. Any weaknesses in the supply chain undermine
confidence in whether the code that you run is actually the code that you
scanned. 

This need to track code handling from source to binary puts an extra burden on
anyone involved in complex critical systems. SLSA is meant to support automation
so even the largest and most complex systems can protect against tampering. As a
result, SLSA increases trust that the analysis and review performed on source
code can be assumed to still apply to the binary consumed at the end of a
complex software supply chain. 

## SLSA in layman's terms

There has been a lot of discussion about the need for "ingredient labels" for
software—a "software bill of materials" (SBOM) that tells users what is in their
software. Building off this analogy, SLSA can be thought of as all the food
safety handling guidelines that make an ingredient list credible. From standards
for clean factory environments so contaminants aren't introduced in packaging
plants, to the requirement for tamper-proof seals on lids that ensure nobody
changes the contents of items sitting on grocery store shelves, the entire food
safety framework ensures that consumers can trust that the ingredient list
matches what's actually in the package they buy.

Likewise, the SLSA framework provides this trust with guidelines and
tamper-resistant evidence for securing each step of the software production
process. That means you know not only that nothing unexpected was added to the
software product, but also that the ingredient label itself wasn't tampered with
and accurately reflects the software contents. In this way, SLSA helps protect
against the risk of:

-  Code modification (by adding a tamper-evident "seal" to code after
    source control)
-  Uploaded artifacts that were not built by a CI/CD system (by marking
    artifacts with a factory "stamp" that verifies which build service created it)
-  Threats against the build system (by providing "manufacturing facility"
    best practices for build system services)

For more exploration of this analogy, see the blog post
[SLSA + SBOM: Accelerating SBOM success with the help of SLSA](https://slsa.dev/blog/2022/05/slsa-sbom).

## Who is SLSA for?

In short: everyone involved in producing, distributing, or consuming software.

**Software producers**, such as a development team at a software company or open
source maintainers. SLSA gives you protection against insider risk and tampering
along the supply chain to your consumers, increasing confidence that the
software you produce reaches your consumers as you intended it.

**Software consumers**, such as a development team using open source packages, a
government agency using vendored software, or a CISO judging organizational
risk. SLSA gives you a way to judge the security practices of the software you
rely on and be sure that what you receive is what you expected.

**Software implementers**, who provide infrastructure such as an ecosystem
package manager, build platform, or CI/CD system. As the bridge between the
producers and consumers, your adoption of SLSA makes a secure software supply
chain more frictionless for both of them. 

## How SLSA works

We talk about SLSA in terms of [tracks and levels](levels.md).
A SLSA track focuses on a particular aspect of a supply chain, such as the Build
Track. SLSA v1.0 consists of only a single track (Build), but future versions of
SLSA will add tracks that cover other parts of the software supply chain.  
Within each track, ascending levels indicate increasingly hardened security
practices. Higher levels provide better guarantees against supply-chain threats,
but come at higher implementation costs. Lower SLSA levels are designed to be
easier to adopt, but with only modest security guarantees. SLSA 0 is sometimes
used to refer to software that doesn't yet meet any SLSA level. Currently, the
SLSA Build Track encompasses Levels 1 through 3, but we envision higher levels
to be possible in future revisions.   

The combination of tracks and levels offers an easy way to discuss whether
software meets a specific set of requirements. By referring to an artifact as
meeting SLSA Build Level 3, for example, you're indicating in one phrase that
the software artifact was built following a defined set of multiple security
practices that qualify it for that level. 

## What SLSA doesn't cover

There are several areas outside SLSA's current framework:

-  Code quality: SLSA does not tell you whether the developers writing the
    source code followed secure coding practices [TODO: ARE EXAMPLES NEEDED?]
-  Developer trust: SLSA cannot tell you whether a developer is
    intentionally writing malicious code. If you trust a developer to write
    code you want to consume, though, SLSA can guarantee that the code will
    reach you without another party maliciously tampering with it.
-  Transitive trust for dependencies: each artifact's SLSA level is
    independent of its dependencies' levels. For a more detailed explanation of
    why, see the [FAQ](faq).

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
