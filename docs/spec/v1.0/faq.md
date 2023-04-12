---
title: Frequently asked questions
description: Answers to questions frequently asked about SLSA.
layout: specifications
---

## Q: Why is SLSA not transitive?

SLSA Build levels only cover the trustworthiness of a single build, with no
requirements about the build levels of transitive dependencies. The reason for
this is to make the problem tractable. If a SLSA Build level required
dependencies to be the same level, then reaching a level would require starting
at the very beginning of the supply chain and working forward. This is
backwards, forcing us to work on the least risky component first and blocking
any progress further downstream. By making each artifact's SLSA rating
independent from one another, it allows parallel progress and prioritization
based on risk. (This is a lesson we learned when deploying other security
controls at scale throughout Google.) We expect SLSA ratings to be composed to
describe a supply chain's overall security stance, as described in the case
study [vision](../../example.md#vision-case-study).

## Q: What about reproducible builds?

When talking about [reproducible builds](https://reproducible-builds.org), there
are two related but distinct concepts: "reproducible" and "verified
reproducible."

"Reproducible" means that repeating the build with the same inputs results in
bit-for-bit identical output. This property
[provides](https://reproducible-builds.org/docs/buy-in/)
[many](https://wiki.debian.org/ReproducibleBuilds/About)
[benefits](https://static.googleusercontent.com/media/sre.google/en//static/pdf/building_secure_and_reliable_systems.pdf#page=357),
including easier debugging, more confident cherry-pick releases, better build
caching and storage efficiency, and accurate dependency tracking.

"Verified reproducible" means using two or more independent build platforms to
corroborate the provenance of a build. In this way, one can create an overall
platform that is more trustworthy than any of the individual components. This is
often
[suggested](https://www.linuxfoundation.org/en/blog/preventing-supply-chain-attacks-like-solarwinds/)
as a solution to supply chain integrity. Indeed, this is one option to secure
build steps of a supply chain. When designed correctly, such a platform can
satisfy all of the SLSA Build level requirements.

That said, verified reproducible builds are not a complete solution to supply
chain integrity, nor are they practical in all cases:

-   Reproducible builds do not address source, dependency, or distribution
    threats.
-   Reproducers must truly be independent, lest they all be susceptible to the
    same attack. For example, if all rebuilders run the same pipeline software,
    and that software has a vulnerability that can be triggered by sending a
    build request, then an attacker can compromise all rebuilders, violating the
    assumption above.
-   Some builds cannot easily be made reproducible, as noted above.
-   Closed-source reproducible builds require the code owner to either grant
    source access to multiple independent rebuilders, which is unacceptable in
    many cases, or develop multiple, independent in-house rebuilders, which is
    likely prohibitively expensive.

Therefore, SLSA does not require verified reproducible builds directly. Instead,
verified reproducible builds are one option for implementing the requirements.

For more on reproducibility, see
[Hermetic, Reproducible, or Verifiable?](https://sre.google/static/pdf/building_secure_and_reliable_systems.pdf#page=357)

## Q: How does SLSA relate to in-toto?

[in-toto](https://in-toto.io/) is a framework to secure software supply chains
hosted at the [Cloud Native Computing Foundation](https://cncf.io/). The in-toto
specification provides a generalized workflow to secure different steps in a
software supply chain. The SLSA specification recommends
[in-toto attestations](https://github.com/in-toto/attestation) as the vehicle to
express Provenance and other attributes of software supply chains. Thus, in-toto
can be thought of as the unopinionated layer to express information pertaining
to a software supply chain, and SLSA as the opinionated layer specifying exactly
what information must be captured in in-toto metadata to achieve the guarantees
of a particular level.

in-toto's official implementations written in
[Go](https://github.com/in-toto/in-toto-golang),
[Java](https://github.com/in-toto/in-toto-java), and
[Rust](https://github.com/in-toto/in-toto-rs) include support for generating
SLSA Provenance metadata. These APIs are used in other tools generating SLSA
Provenance such as Sigstore's cosign, the SLSA GitHub Generator, and the in-toto
Jenkins plugin.

## Q. What is the difference between a build platform, system, and service?

Build platform and build system have been used interchangably in the past. With
the v1.0 specification, however, there has been a unification around the term
platform as indicated in the [Terminology](terminology.md). The use of the word
`system` still exists related to software and services within the build platform
and to systems outside of a build platform like change management systems.

A build service is a hosted build platform that is often run on shared infrastructure
instead of individuals' machines and workstations. Its use has also been replaced outside
of the requirements as it relates to the build platform.

## Q: How does SLSA and SLSA Provenance relate to SBOM?

[Software Bill of Materials (SBOM)] are a frequently recommended tool for
increased software supply chain rigor. An SBOM is typically focused on
understanding software in order to evaluate risk through known vulnerabilities
and license compliance. These use-cases require fine-grained and timely data
which can be refined to improve signal-to-noise ratio.

[SLSA Provenance] and the [Build track] are focused on trustworthiness of the
build process. To improve trustworthiness, Provenance is generated in the build
platform's trusted control plane, which in practice results in it being coarse
grained.

While they likely include similar data, SBOMs and SLSA Provenance operate at
different levels of abstraction. While an SBOM is not well suited as a
requirement for the Build track, SBOMs are good practice which may form part
of a future SLSA Vulnerabilities track. Further, SLSA Provenance can increase the
trustworthiness of an SBOM by describing how the SBOM was created.

[Software Bill of Materials (SBOM)]: https://ntia.gov/sbom
[SLSA Provenance]: ../../provenance/v1.md
[Build track]: levels.md#build-track
