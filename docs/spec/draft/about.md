---
title: About SLSA 
description: With supply chain attacks on the rise, a shared vocabulary and universal framework are needed to provide incremental guidance to harden supply chains for more secure software production. This page introduces the main concepts behind SLSA and explains how it can help anyone involved in producing, consuming, or providing infrastructure for software. 
---

# About SLSA

This page is an introduction to SLSA and its concepts. If you're new
to SLSA, start here!

## What is SLSA?

The term SLSA ("salsa") is an acronym that stands for Supply-chain Levels for Software Artifacts. It is a set of incrementally adoptable guidelines for supply chain security that has been established by industry consensus. The specification set by SLSA is useful for
both software producers and consumers. Producers can follow SLSA's guidelines to make their software supply chain more secure, and consumers can use SLSA to make decisions about whether to trust a software package.

SLSA provides:

-   **A common vocabulary** to help people talk about software supply chain security across domains.
-   **Security for your incoming supply chain** by evaluating the trustworthiness of the artifacts you consume.
-   **Actionable checklists** to improve your software's security.
-   **Compliance measurement** of your efforts to achieve compliance with the [Secure Software Development Framework (SSDF)](https://csrc.nist.gov/Projects/ssdf).

## Why SLSA is needed

High-profile attacks like those against [SolarWinds](https://www.crowdstrike.com/blog/sunspot-malware-technical-analysis/) or [Codecov](https://about.codecov.io/apr-2021-post-mortem/) have exposed the kind of supply
chain integrity weaknesses that may go unnoticed, yet quickly become very
public, disruptive, and costly in today's environment when exploited. These attacks have also shown that there are inherent risks not just in code itself, but at
multiple points in the complex process of getting that code into software
systems; that is, into the *software supply chain*. Since these attacks are on
the rise and show no sign of decreasing, a universal framework for hardening the
software supply chain is needed, as affirmed by the U.S. Executive Order on
Improving the Nation's Cybersecurity of May 12th, 2021.

Security techniques for vulnerability detection and analysis of source code are
essential, but are not enough on their own. Even after fuzzing or vulnerability
scanning is completed, unfortunately changes to code can take place, either unintentionally or
from insider threats or compromised accounts. Risk for code modification exists at
each stage of a typical software supply chain, from source to build through
packaging and distribution. Weaknesses in the supply chain undermines
confidence in whether the code that you run is actually the code that you
scanned.

SLSA is designed to support automation that tracks code handling from source
to binary. This makes it possible to protect against tampering regardless of the complexity
of the software supply chain. As a result, SLSA increases trust that the
analysis and review performed on the source code still applies to
the binary consumed after the build and distribution process is complete.

## SLSA in layperson's terms

There has been a [lot of discussion](https://ntia.gov/page/software-bill-materials) about the need for "ingredient labels" for
software, a "software bill of materials" (SBOM) that tells users what is in their
software. Building off this analogy, SLSA can be thought of as all the food
safety handling guidelines that make an ingredient list credible. From standards
for clean factory environments, so contaminants aren't introduced in packaging
plants, to the requirement for tamper-proof seals on lids that ensure nobody
changes the contents of items sitting on grocery store shelves, the entire food
safety framework ensures that consumers can trust that the ingredient list
matches what's actually in the package they buy.

The SLSA framework provides this same kind of trust with guidelines and
tamper-resistant evidence for securing each step of the software production
process. That means you know not only that nothing unexpected was added to the
software product, but also that the ingredient label itself wasn't tampered with
and accurately reflects the software contents. In this way, SLSA helps protect
against the risk of:

-   **Code modification** by adding a tamper-evident "seal" to code after
    source control.
-   **Inaccurate uploaded artifacts** can be marked with a factory "stamp" that shows which build platform created it and avoiding those that were not built by the expected CI/CD platform.
-   **Threats against the build platform** can be mitigated by providing "manufacturing facility" best practices for build platform services.

For more exploration of this analogy, see the blog post
[SLSA + SBOM: Accelerating SBOM success with the help of SLSA](/blog/2022/05/slsa-sbom).

## Who is SLSA for?

Everyone involved in producing and consuming software, or providing
infrastructure for software, can benefit from SLSA, including:

-  **Software producers** such as an open source project team, a software vendor, or a
team writing first-party code for use within the same company. SLSA gives you
protection against tampering, from the supply chain to your consumers,
reduces insider risk and increases confidence that the software you produced
reaches your consumers as you intended.

-  **Software consumers** such as a development team using open source packages, a
government agency using vendored software, or a CISO judging organizational
risk. SLSA gives you a way to judge the security practices of the software you
rely on and be sure that what you receive is what you expected.

-  **Infrastructure providers** who provide infrastructure such as an ecosystem
package manager, build platform, or CI/CD platform. As the bridge between the
producers and consumers, your adoption of SLSA enables a secure software supply
chain between them.

## How SLSA works

We talk about SLSA in terms of *tracks* and *levels*.
A SLSA track focuses on a particular portion of a supply chain, such as the Build part, or the Build Environment, Dependency, or Source parts.

Within each track, ascending levels indicate increasingly hardened security
practices. Higher levels provide better guarantees against supply chain threats,
but come at higher implementation costs. Lower SLSA levels are designed to be
easier to adopt, but with only modest security guarantees. SLSA 0 is sometimes
used to refer to software that doesn't yet meet any SLSA level. 

The combination of track name and numeric level offers an easy way to discuss whether
software meets a specific set of *requirements*. By referring to an artifact as
meeting SLSA Build Level 3, for example, you're indicating in one phrase that
the software artifact was built following a set of security practices that
industry leaders agree protect against a particular supply chain compromise.

## What SLSA doesn't cover

SLSA is only one part of a thorough approach to supply chain security. There
are several areas outside SLSA's current framework that are
important to also consider along with SLSA. They are:

-   **Code quality** - Because SLSA does not tell you whether the developers writing the
    source code followed secure coding practices, this needs to be addressed.
-   **Producer trust** - SLSA does not identify organizations that intentionally
    produce malicious software, but it can reduce insider risks within trusted
    organizations.
-   **Transitive trust for dependencies** - Because the SLSA level of an artifact is
    independent of the level of its dependencies, you can use SLSA recursively to
    also judge an artifact's dependencies on their own. But currently there is
    no single SLSA level that applies to both an artifact and its
    transitive dependencies together. For a more detailed explanation of why,
    see the [FAQ](faq#q-why-is-slsa-not-transitive).
