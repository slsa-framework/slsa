---
title: Security levels
---
<div class="subtitle">

SLSA is organized into a series of levels that provide increasing
[integrity](terminology.md) guarantees. This gives you confidence that
software hasn’t been tampered with and can be securely traced back to its
source.

</div>

This page is an informative overview of the SLSA levels, describing their
purpose and guarantees. For the normative requirements at each level, see
[Requirements](requirements.md). For a background, see
[Terminology](terminology.md).

## What is SLSA?

SLSA is a set of incrementally adoptable security guidelines, established by
industry consensus. The standards set by SLSA are guiding principles for both
software producers and consumers: producers can follow the guidelines to make
their software more secure, and consumers can make decisions based on a software
package's security posture. SLSA's four levels are designed to be incremental
and actionable, and to protect against specific integrity attacks. SLSA 4
represents the ideal end state, and the lower levels represent milestones with
corresponding integrity guarantees.

Importantly, SLSA is intended to be a primitive in a broader determination of a
software's risk. SLSA measures specific aspects of supply chain security,
particularly those that can be fully automated; other aspects, such as developer
trust and code quality, are out of scope. Furthermore, each link in the software
supply chain has its own, independent SLSA level ([FAQ](../faq.md)). The benefit
of this approach is to break up the large supply chain security problem into
tractable subproblems that can be prioritized based on risk and tackled in
parallel. But this does mean that SLSA alone is not sufficient to determine if
an artifact is "safe".

## Summary of levels

| Level | Description                                   | Example                                               |
| :---- | :-------------------------------------------- | :---------------------------------------------------- |
| 1     | Documentation of the build process            | Unsigned provenance                                   |
| 2     | Tamper resistance of the build service        | Hosted source/build, signed provenance                |
| 3     | Extra resistance to specific threats          | Security controls on host, non-falsifiable provenance |
| 4     | Highest levels of confidence and trust        | Two-party review + hermetic builds                    |

It can take years to achieve the ideal security state - intermediate milestones are important. SLSA guides you through gradually improving the security of your software. Artifacts used in critical infrastructure or vital business operations may want to attain a higher level of security, whereas software that poses a low risk can stop when they're comfortable.

## Detailed explanation

| Level | Requirements |
| ----- | ------------ |
| 0     | **No guarantees.** SLSA 0 represents the lack of any SLSA level. |
| 1     | **The build process must be fully scripted/automated and generate provenance.** Provenance is metadata about how an artifact was built, including the build process, top-level source, and dependencies. Knowing the provenance allows software consumers to make risk-based security decisions. Provenance at SLSA 1 does not protect against tampering, but it offers a basic level of code source identification and can aid in vulnerability management. |
| 2     | **Requires using version control and a hosted build service that generates authenticated provenance.** These additional requirements give the software consumer greater confidence in the origin of the software. At this level, the provenance prevents tampering to the extent that the build service is trusted. SLSA 2 also provides an easy upgrade path to SLSA 3. |
| 3     | **The source and build platforms meet specific standards to guarantee the auditability of the source and the integrity of the provenance respectively.** We envision an accreditation process whereby auditors certify that platforms meet the requirements, which consumers can then rely on. SLSA 3 provides much stronger protections against tampering than earlier levels by preventing specific classes of threats, such as cross-build contamination. |
| 4     | **Requires two-person review of all changes and a hermetic, reproducible build process.** Two-person review is an industry best practice for catching mistakes and deterring bad behavior. Hermetic builds guarantee that the provenance’s list of dependencies is complete. Reproducible builds, though not strictly required, provide many auditability and reliability benefits. Overall, SLSA 4 gives the consumer a high degree of confidence that the software has not been tampered with. |

The SLSA level is not transitive ([see our FAQs](../faq.md)). This makes each artifact’s SLSA rating independent from one another, allowing parallel progress and prioritization based on risk. The level describes the integrity protections of an artifact’s build process and top-level source, but nothing about the artifact’s dependencies. Dependencies have their own SLSA ratings, and it is possible for a SLSA 4 artifact to be built from SLSA 0 dependencies.
