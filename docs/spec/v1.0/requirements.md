---
title: Producing artifacts
---
<div class="subtitle">

This page covers the detailed technical requirements for producing artifacts at
each SLSA level. The intended audience is system implementers and security
engineers.

</div>

For an informative description of the levels intended for all audiences, see
[Levels](levels.md). For background, see [Terminology](terminology.md). To
better understand the reasoning behind the requirements, see
[Threats and mitigations](threats.md).

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD",
"SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be
interpreted as described in [RFC 2119](https://www.rfc-editor.org/rfc/rfc2119).

## Overview

### Build levels

Responsibility to implement SLSA is spread across the following parties.

<table class="no-alternate">
<tr>
  <th>Implementer
  <th>Requirement
  <th>Degree
  <th>L1<th>L2<th>L3
<tr>
  <td rowspan=3><a href="#producer">Producer</a>
  <td colspan=2>Define expectations
  <td>✓<td>✓<td>✓
<tr>
  <td colspan=2>Meet expectations
  <td>✓<td>✓<td>✓
<tr>
  <td colspan=2>Distribute provenance
  <td>✓<td>✓<td>✓
<tr>
  <td rowspan=5><a href="#build-system">Build system</a>
  <td rowspan=3><a href="#provenance-generation">Provenance generation</a>
  <td><a href="#provenance-exists">Exists</a>
  <td>✓<td>✓<td>✓
<tr>
  <td><a href="#provenance-authentic">Authentic</a>
  <td> <td>✓<td>✓
<tr>
  <td><a href="#provenance-non-forgeable">Non-forgeable</a>
  <td> <td> <td>✓
<tr>
  <td rowspan=2><a href="#isolation-strength">Isolation strength</a>
  <td><a href="#build-service">Build service</a>
  <td> <td>✓<td>✓
<tr>
  <td><a href="#ephemeral-isolated">Ephemeral and isolated</a>
  <td> <td> <td>✓
</table>

### Security Best Practices

While the exact definition of what constitutes a secure system is beyond the
scope of this specification, to be conformant all implementations MUST use
industry security best practices. This includes, but is not limited to, using
proper access controls, securing communications, implementing proper management
of cryptographic secrets, doing frequent updates, and promptly fixing known
vulnerabilities.

Various relevant standards and guides can be consulted for that matter such as
the [CIS Critical Security
Controls](https://www.cisecurity.org/controls/cis-controls-list).

## Producer

[Producer]: #producer

A package's <dfn>producer</dfn> is the organization that owns and releases the
software. It might be an open-source project, a company, a team within a
company, or even an individual.

### Define expectations

Verifying provenance requires having expectations about the provenance values for
an authentic artifact. The producer can set those expectations either implicitly (e.g.
trust on first use) or explicitly (e.g. valid builds come from a known source repo).
If the expectations are set implicitly, then the producer doesn't need to do anything.
If the expectations are set explicitly, then the producer MUST provide the
expectations.

### Meet expectations

The producer MUST select a build system that is capable of reaching their
desired SLSA Build Level. Note that not all build systems are capable of
reaching the highest SLSA Build Levels. Additionally, the producer MUST meet any
expectations they provided to the artifact verifier.

### Distribute provenance

The producer MUST distribute provenance to artifact consumers. The producer
MAY delegate this responsibility to the package ecosystem, provided that the
package ecosystem is capable of distributing provenance.

## Build system

[Build system]: #build-system

A package's <dfn>build system</dfn> is the infrastructure used to transform the
software from source to package. This includes the transitive closure of all
hardware, software, persons, and organizations that can influence the build. A
build system is often a hosted, multi-tenant build service, but it could be a
system of multiple independent rebuilders, a special-purpose build system used
by a single software project, or even a developer's workstation. Ideally, one
build system is used by many different software packages so that consumers can
[minimize the number of trusted systems](principles.md). For more background,
see [Build Model](terminology.md#build-model).

The build system is responsible for providing two things: [provenance
generation] and [isolation between builds]. The [Build level](levels.md#build-track) describes
the degree to which each of these properties is met.

### Provenance generation

[Provenance generation]: #provenance-generation

The build system is responsible for generating provenance describing how the
package was produced.

The SLSA Build level describes the minimum bound for:

-   *Completeness:* What information is contained in the provenance?
-   *Authenticity:* How strongly can the provenance be tied back to the builder?
-   *Accuracy:* How resistant is the provenance generation to tampering within
    the build process?

<table>
<tr><th>Requirement<th>Description<th>L1<th>L2<th>L3

<tr id="provenance-exists"><td>Provenance Exists<td>

The build process MUST generate provenance that unambiguously identifies the
output package and describes how that package was produced.

The format MUST be acceptable to the [package ecosystem] and/or [consumer]. It
is RECOMMENDED to use the [SLSA Provenance] format and [associated suite]
because it is designed to be interoperable, universal, and unambiguous when
used for SLSA. See that format's documentation for requirements and
implementation guidelines. If using an alternate format, it MUST contain the
equivalent information as SLSA Provenance at each level and SHOULD be
bi-directionally translatable to SLSA Provenance.

-   *Completeness:* Best effort. The provenance at L1 SHOULD contain sufficient
    information to catch mistakes and simulate the user experience at higher
    levels in the absence of tampering. In other words, the contents of the
    provenance SHOULD be the same at all Build levels, but a few fields MAY be
    absent at L1 if they are prohibitively expensive to implement.
-   *Authenticity:* No requirements.
-   *Accuracy:* No requirements.

[SLSA Provenance]: ../../provenance/v1
[associated suite]: ../../attestation-model#recommended-suite

<td>✓<td>✓<td>✓
<tr id="provenance-authentic"><td>Provenance is Authentic<td>

*Authenticity:* Consumers MUST be able to validate the authenticity of the
provenance attestation in order to:

-   *Ensure integrity:* Verify that the digital signature of the provenance
    attestation is valid and the provenance was not tampered with after the
    build.
-   *Define trust:* Identify the build system and other entities that are
    necessary to trust in order to trust the artifact they produced.

This SHOULD be through a digital signature from a private key accessible only to
the service that generated the provenance attestation.

This allows the consumer to trust the contents of the provenance attestation,
such as the identity of the build system.

*Accuracy:* The provenance MUST be generated by the build system (i.e. within
the trust boundary identified in the provenance) and not by a tenant of the
build system (i.e. outside the trust boundary).

-   The data in the provenance MUST be obtained from the build service, either
    because the generator *is* the build service or because the provenance
    generator reads the data directly from the build service.
-   The build system MUST have some security control to prevent tenants from
    tampering with the provenance. However, there is no minimum bound on the
    strength. The purpose is to deter adversaries who might face legal or
    financial risk from evading controls.

*Completeness:* SHOULD be complete, but there MAY be external parameters that
are not sufficiently captured in the provenance.

<td> <td>✓<td>✓
<tr id="provenance-non-forgeable"><td>Provenance is Non-forgeable<td>

*Accuracy:* Provenance MUST be strongly resistant to influence by tenants.

-   Any secret material used to demonstrate the non-forgeable nature of
    the provenance, for example the signing key used to generate a digital
    signature, MUST be stored in a secure management system appropriate for
    such material and accessible only to the build service account.
-   Such secret material MUST NOT be accessible to the environment running
    the user-defined build steps.
-   Every field in the provenance MUST be generated or verified by the build
    service in a trusted control plane. The user-controlled build steps MUST
    NOT be able to inject or alter the contents.

*Completeness:* MUST be complete. In particular, the external parameters MUST be
fully enumerated in the provenance.

Note: This requirement was called "non-falsifiable" in the initial
[draft version (v0.1)](../v0.1/requirements.md#non-falsifiable).

<td> <td> <td>✓
</table>

### Isolation strength

[Isolation strength]: #isolation-strength
[Isolation between builds]: #isolation-strength

The build system is responsible for isolating between builds, even within the
same tenant project. In other words, how strong of a guarantee do we have that
the build really executed correctly, without external influence?

The SLSA Build level describes the minimum bar for isolation strength. For more
information on assessing a build system's isolation strength, see
[Verifying build systems](verifying-systems.md).

<table>
<tr><th>Requirement<th>Description<th>L1<th>L2<th>L3

<tr id="build-service">
<td>Build service
<td>

All build steps ran using some build service, not on a maintainer's
workstation.

Examples: GitHub Actions, Google Cloud Build, Travis CI.

<td> <td>✓<td>✓
<tr id="ephemeral-isolated">
<td>Ephemeral and isolated
<td>

The build service ensured that the build steps ran in an ephemeral and isolated
environment provisioned solely for this build, free of influence from other
build instances, whether prior or concurrent.

-   It MUST NOT be possible for a build to access any secrets of the build service, such as the provenance signing key.
-   It MUST NOT be possible for two builds that overlap in time to influence one another.
-   It MUST NOT be possible for one build to persist or influence the build environment of a subsequent build.
-   Build caches, if used, MUST be purely content-addressable to prevent tampering.
-   The build SHOULD NOT call out to remote execution unless it's considered part of the "builder" within the trust boundary.
-   The build SHOULD NOT open services that allow for remote influence.

Note: This requirement was split into "Isolated" and "Ephemeral Environment" the
initial [draft version (v0.1)](../v0.1/requirements.md).

<td> <td> <td>✓
</table>
