# Certification

## **TODO**

- [ ] Create a certification registry repo and add links in this doc.
- [x] Create a self-certification questionnaire.
      <https://docs.google.com/spreadsheets/d/1KZidrnUhmUC8qNvkq5l1FkvRmaUlWzTTVLC8KUMNSEs/edit?usp=sharing>
- [x] Add a link to the SLSA Self-Certification Questionnaire.

## Overview

> User's looking for certifications for a particular build system can find them
> on the Certification Registry (**TODO:** create repo for certification
> registry and link here).

The SLSA Framework defines a series of levels that describe increasing security
guarantees. The certification process is intended to verify that a build system
meets the requirements of a particular SLSA level and is provided to help users
determine the level of trust they can place in a build system and the artifacts
it produces.

## Certification Tiers

These tiers are intended to provide users with a way to determine the level of
trust they can place in a build system. The following tiers are defined:

### Tier 0 - No evidence of conformance

> **Note:** If a build system is not listed in the Certification Registry
> (**TODO:** create repo for certification registry and link here), you should
> assume that it is in Tier 0.

The Tier 0 trust tier is the lowest level of trust. Build systems in this tier
have not produced any supporting evidence for their claimed level of SLSA
conformance and no third-party verification has been performed. It is
recommended that users exercise caution or take additional steps to verify the
build system before using it.

### Tier 1 - Self-certified conformance

> Build systems in this trust tier are listed in the Certification Registry
> (**TODO:** create repo for certification registry and link here).

Tier 1 signifies that a build system owner has self-certified their build system
to a particular SLSA level. This certification is intended to be a reasonable
level of trust. Users should still exercise reasonable caution when using a
build system in this trust tier and should consider reviewing the full responses
to the self-certification questionnaire.

<ins>**Process**</ins>

The self-certification process consists of several steps which are intended to
ensure that the build system owner has implemented the requirements necessary to
produce artifacts at a particular SLSA level. The process is as follows:

**1 - Self-assessment Questionnaire**

The build system owner is expected to answer a series of questions that document
their build system's conformance to a particular SLSA level. These questions are
based on the [Verifying Build Systems](verifying-systems.md) document and are
provided as a
[spreadsheet](https://docs.google.com/spreadsheets/d/1KZidrnUhmUC8qNvkq5l1FkvRmaUlWzTTVLC8KUMNSEs/edit?usp=sharing).
The build system owner is expected to maintain a current copy of the answers and
update it as their build system evolves.

**2 - Attestation**

The build system owner is expected to attest to the accuracy of the
questionnaire responses and publish it on their website. This attestation should
be made by a person with authority to make such statements on behalf of the
build system owner.

**3 - Build System Identification**

Build system workers are required to sign provenance in a secure way that
provides strong identification of the builder. The prefered method of this is by
utilizing sigstore with keyless signing and an OIDC identity provider that
provides strong identification of the builder. Additionally a PKI system with a
root certificate and subkeys for each worker can be used in combination with the
[rekor transparency log](https://github.com/sigstore/rekor).

These options are also available but are not recommended and are only provided
to allow organizations to use existing tooling:

> **Note:** The following options will be deprecated in the future and will
> generate warnings in tooling.

- Provide a root certificate and distribute signed worker certificates to their
  build system workers.
- Provide a link to a public key or list of public keys that are associated with
  the build system.

The method used to sign the provenance should be included in the submission to
the Certification Registry (**TODO:** create repo for certification registry and
link here). This will allow tools to automatically link builders with their Tier
1 responses.

**4 - Submission to Certification Registry**

The build system owner submits a pull request to add their build system to the
Certification Registry (**TODO:** create repo for certification registry and
link here) utilizing the provided PR template. The PR template provides all the
required fields for the submission to be accepted.

### Tier 2 - Third-party verified conformance [TODO]

**Note:** This tier is not yet implemented.
