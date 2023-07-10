# Related work

In parallel to the SLSA specification, there is work to develop core formats and
data models. Currently this is joint work between
[Binary Authorization](https://cloud.google.com/binary-authorization) and
[in-toto](https://in-toto.io/) but we invite wider participation.

-   [Standard attestation format](https://github.com/in-toto/attestation#in-toto-attestations)
    to express provenance and other attributes. This will allow sources and
    builders to express properties in a standard way that can be consumed by
    anyone. Also includes reference implementations for generating these
    attestations.
-   Policy data model and reference implementation.

For a broader view of the software supply chain problem:

-   [Know, Prevent, Fix: A framework for shifting the discussion around
    vulnerabilities in open
    source](https://security.googleblog.com/2021/02/know-prevent-fix-framework-for-shifting.html)
-   [Threats, Risks, and Mitigations in the Open Source Ecosystem]

Prior iterations of the ideas presented here:

-   [Building Secure and Reliable Systems, Chapter 14: Deploying Code](https://sre.google/static/pdf/building_secure_and_reliable_systems.pdf#page=339)
-   [Binary Authorization for Borg] - This is how Google implements the SLSA
    idea internally.

Other related work:

-   [CII Best Practices Badge](https://bestpractices.coreinfrastructure.org/en)
-   [Security Scorecards](https://github.com/ossf/scorecard) - Perhaps SLSA
    could be implemented as an aggregation of scorecard entries, for at least
    the checks that can be automated.
-   [Trustmarks](https://trustmark.gtri.gatech.edu/)

Other takes on provenance and CI/CD:

-   [The Path to Code Provenance](https://medium.com/uber-security-privacy/code-provenance-application-security-77ebfa4b6bc5)
-   [How to Build a Compromise-Resilient CI/CD](https://www.youtube.com/watch?v=9hCiHr1f0zM)

<!-- Links -->

[Threats, Risks, and Mitigations in the Open Source Ecosystem]: https://github.com/Open-Source-Security-Coalition/Open-Source-Security-Coalition/blob/master/publications/threats-risks-mitigations/v1.1/Threats%2C%20Risks%2C%20and%20Mitigations%20in%20the%20Open%20Source%20Ecosystem%20-%20v1.1.pdf
[Binary Authorization for Borg]: https://cloud.google.com/docs/security/binary-authorization-for-borg
