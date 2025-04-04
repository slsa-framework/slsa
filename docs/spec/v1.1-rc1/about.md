---
title: About SLSA
description: With supply chain attacks on the rise, a shared vocabulary and universal framework is needed to provide incremental guidance to harden supply chains for more secure software production. This page introduces the main concepts behind SLSA and explains how it can help anyone involved in producing, consuming, or providing infrastructure for software. 
---

This page is an introduction to SLSA and its concepts. If you're new
to SLSA, start here!

## What is SLSA?

Supply-chain Levels for Software Artifacts, or SLSA ("salsa"), is a set of incrementally adoptable guidelines for supply chain security,
established by industry consensus. The specification set by SLSA is useful for
both software producers and consumers: producers can follow SLSA's guidelines to
make their software supply chain more secure, and consumers can use SLSA to make
decisions about whether to trust a software package.

SLSA offers:

-   A common vocabulary to talk about software supply chain security
-   A way to secure your incoming supply chain by evaluating the trustworthiness of the artifacts you consume
-   An actionable checklist to improve your own software's security
-   A way to measure your efforts toward compliance with forthcoming
    Executive Order standards in the [Secure Software Development Framework (SSDF)](https://csrc.nist.gov/Projects/ssdf)

## Why SLSA is needed

High profile attacks like those against [SolarWinds](https://www.crowdstrike.com/blog/sunspot-malware-technical-analysis/) or [Codecov](https://about.codecov.io/apr-2021-post-mortem/) have exposed the kind of supply
chain integrity weaknesses that may go unnoticed, yet quickly become very
public, disruptive, and costly in today's environment when exploited. They've
also shown that there are inherent risks not just in code itself, but at
multiple points in the complex process of getting that code into software
systems—that is, in the **software supply chain**. Since these attacks are on
the rise and show no sign of decreasing, a universal framework for hardening the
software supply chain is needed, as affirmed by the
[U.S. Executive Order on Improving the Nation's Cybersecurity](https://www.whitehouse.gov/briefing-room/presidential-actions/2021/05/12/executive-order-on-improving-the-nations-cybersecurity/).

Security techniques for vulnerability detection and analysis of source code are
essential, but are not enough on their own. Even after fuzzing or vulnerability
scanning is completed, changes to code can happen, whether unintentionally or
from insider threats or compromised accounts. Risk for code modification exists at
each link in a typical software supply chain, from source to build through
packaging and distribution. Any weaknesses in the supply chain undermine
confidence in whether the code that you run is actually the code that you
scanned.

SLSA is designed to support automation that tracks code handling from source
to binary, protecting against tampering regardless of the complexity
of the software supply chain. As a result, SLSA increases trust that the
analysis and review performed on source code can be assumed to still apply to
the binary consumed after the build and distribution process.

## SLSA in layperson's terms

There has been a [lot of discussion](https://ntia.gov/page/software-bill-materials) about the need for "ingredient labels" for
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

-   Code modification (by adding a tamper-evident "seal" to code after
    source control)
-   Uploaded artifacts that were not built by the expected CI/CD platform (by marking
    artifacts with a factory "stamp" that shows which build platform created it)
-   Threats against the build platform (by providing "manufacturing facility"
    best practices for build platform services)

For more exploration of this analogy, see the blog post
[SLSA + SBOM: Accelerating SBOM success with the help of SLSA](/blog/2022/05/slsa-sbom).

## Who is SLSA for?

In short: everyone involved in producing and consuming software, or providing
infrastructure for software.

**Software producers**, such as an open source project, a software vendor, or a
team writing first-party code for use within the same company. SLSA gives you
protection against tampering along the supply chain to your consumers, both
reducing insider risk and increasing confidence that the software you produce
reaches your consumers as you intended.

**Software consumers**, such as a development team using open source packages, a
government agency using vendored software, or a CISO judging organizational
risk. SLSA gives you a way to judge the security practices of the software you
rely on and be sure that what you receive is what you expected.

**Infrastructure providers**, who provide infrastructure such as an ecosystem
package manager, build platform, or CI/CD platform. As the bridge between the
producers and consumers, your adoption of SLSA enables a secure software supply
chain between them.

## How SLSA works

We talk about SLSA in terms of [tracks and levels](levels.md).
A SLSA track focuses on a particular aspect of a supply chain, such as the Build
Track. SLSA v1.0 consists of only a single track ([Build](levels.md#build-track)), but future versions of
SLSA will add tracks that cover other parts of the software supply chain, such
as how source code is managed.

Within each track, ascending levels indicate increasingly hardened security
practices. Higher levels provide better guarantees against supply chain threats,
but come at higher implementation costs. Lower SLSA levels are designed to be
easier to adopt, but with only modest security guarantees. SLSA 0 is sometimes
used to refer to software that doesn't yet meet any SLSA level. Currently, the
SLSA Build Track encompasses Levels 1 through 3, but we envision higher levels
to be possible in [future revisions](future-directions.md).

The combination of tracks and levels offers an easy way to discuss whether
software meets a specific set of requirements. By referring to an artifact as
meeting SLSA Build Level 3, for example, you're indicating in one phrase that
the software artifact was built following a set of security practices that
industry leaders agree protect against particular supply chain compromises.

## What SLSA doesn't cover

SLSA is only one part of a thorough approach to supply chain security. There
are several areas outside SLSA's current framework that are nevertheless
important to consider together with SLSA such as:

-   Code quality: SLSA does not tell you whether the developers writing the
    source code followed secure coding practices.
-   Producer trust: SLSA does not address organizations that intentionally
    produce malicious software, but it can reduce insider risks within an
    organization you trust. SLSA's Build Track protects against tampering during
    or after the build, and [future SLSA tracks](future-directions.md) intend to
    protect against unauthorized modifications of source code and dependencies.
-   Transitive trust for dependencies: the SLSA level of an artifact is
    independent of the level of its dependencies. You can use SLSA recursively to
    also judge an artifact's dependencies on their own, but there is
    currently no single SLSA level that applies to both an artifact and its
    transitive dependencies together. For a more detailed explanation of why,
    see the [FAQ](faq#q-why-is-slsa-not-transitive).
