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

This page is an introduction to SLSA and its concepts. If you're new
to SLSA, start here!

## What is SLSA?

SLSA is a set of incrementally adoptable guidelines for supply-chain security,
established by industry consensus. The specification set by SLSA is useful for
both software producers and consumers: producers can follow SLSA's guidelines to
make their software supply chain more secure, and consumers can use SLSA to make
decisions about whether to trust a software package. 

SLSA offers:

-   A common vocabulary to talk about software supply-chain security
-   A way to judge the software you consume and secure your incoming supply chain
-   An actionable checklist to improve your own software's security
-   A way to measure your efforts toward compliance with forthcoming
    Executive Order standards in the [Secure Software Development Framework (SSDF)](https://csrc.nist.gov/Projects/ssdf).

## Why SLSA is needed

High profile attacks like those against [SolarWinds](https://www.crowdstrike.com/blog/sunspot-malware-technical-analysis/) or [Codecov](https://about.codecov.io/apr-2021-post-mortem/) have exposed the kind of supply
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
-   Uploaded artifacts that were not built by a CI/CD system (by marking
    artifacts with a factory "stamp" that verifies which build service created it)
-   Threats against the build system (by providing "manufacturing facility"
    best practices for build system services)

For more exploration of this analogy, see the blog post
[SLSA + SBOM: Accelerating SBOM success with the help of SLSA](https://slsa.dev/blog/2022/05/slsa-sbom).

## Who is SLSA for?

In short: everyone involved in producing, consuming software, or providing 
infrastructure for software.

**Software producers**, such as a development team at a software company or open
source maintainers. SLSA gives you protection against insider risk and tampering
along the supply chain to your consumers, increasing confidence that the
software you produce reaches your consumers as you intended it.

**Software consumers**, such as a development team using open source packages, a
government agency using vendored software, or a CISO judging organizational
risk. SLSA gives you a way to judge the security practices of the software you
rely on and be sure that what you receive is what you expected.

**Infrastructure providers**, who provide infrastructure such as an ecosystem
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

-   Code quality: SLSA does not tell you whether the developers writing the
    source code followed secure coding practices [TODO: ARE EXAMPLES NEEDED?]
-   Developer trust: SLSA cannot tell you whether a developer is
    intentionally writing malicious code. If you trust a developer to write
    code you want to consume, though, SLSA can guarantee that the code will
    reach you without another party maliciously tampering with it.
-   Transitive trust for dependencies: the SLSA level of an artifact is
    independent of the level of its dependencies. You can use SLSA recursively to 
    also judge an artifact's dependencies on their own, but there is 
    currently no single SLSA level that applies to both an artifact and its 
    transitive dependencies together. For a more detailed explanation of why, 
    see the [FAQ](faq).
