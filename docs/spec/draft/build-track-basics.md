---
title: Build Track Basics
description: The software supply chain is divided into different types of activities that are needed to produce software artifacts: build, build environment, dependency, and source. This page covers the basic overview of the build track portion of the supply chain.
---

The software supply chain is divided into different types of activities that are needed to produce secure software artifacts: [build](build-track-basics.md), [build environment](build-env-track-basics), [dependency](depend-track-basics.md), and [source](source-track-basic.md). This page covers the basic overview of the build track portion of the supply chain. 

Other pages in the build section cover the following topics directly related to the build track:

1. [Build: Requirements](build-requirements.md)
2. [Build: Provenence](build-provenence.md)
3. [Build: Attestation formats](build-attestation.md)
4. [Build: Verification systems](build-verification.md)

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD",
"SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be
interpreted as described in [RFC 2119](https://www.rfc-editor.org/rfc/rfc2119).

## Build Track Overview

The requirements for the build portion of a supply chain are divided into levels, allowing you to specify the amount of effort you are able to put into each portion of the chain. The levels go from Level 0 (none) to Level 3 (most). The levels are outlined on this page, but specific level requirements are defined in the [Build: Requirements](build-requirements.md) page.

In order to produce artifacts with a specific build level, responsibility is
split between the [Producer] and [Build platform]. The build platform MUST
strengthen the security controls in order to achieve a specific level while the
producer MUST choose and adopt a build platform capable of achieving a desired
build level, implementing any controls as specified by the chosen platform.

### Responsibilities

<table class="no-alternate">
<tr>
  <th>Implementer
  <th>Requirement
  <th>Degree
  <th>L1<th>L2<th>L3
<tr>
  <td rowspan=3><a href="#producer">Producer</a>
  <td colspan=2><a href="#choose-an-appropriate-build-platform">Choose an appropriate build platform</a>
  <td>✓<td>✓<td>✓
<tr>
  <td colspan=2><a href="#follow-a-consistent-build-process">Follow a consistent build process</a>
  <td>✓<td>✓<td>✓
<tr>
  <td colspan=2><a href="#distribute-provenance">Distribute provenance</a>
  <td>✓<td>✓<td>✓
<tr>
  <td rowspan=5><a href="#build-platform">Build platform</a>
  <td rowspan=3><a href="#provenance-generation">Provenance generation</a>
  <td><a href="#provenance-exists">Exists</a>
  <td>✓<td>✓<td>✓
<tr>
  <td><a href="#provenance-authentic">Authentic</a>
  <td> <td>✓<td>✓
<tr>
  <td><a href="#provenance-unforgeable">Unforgeable</a>
  <td> <td> <td>✓
<tr>
  <td rowspan=2><a href="#isolation-strength">Isolation strength</a>
  <td><a href="#hosted">Hosted</a>
  <td> <td>✓<td>✓
<tr>
  <td><a href="#isolated">Isolated</a>
  <td> <td> <td>✓
</table>

### Security Best Practices

While the exact definition of what constitutes a secure platform is beyond the
scope of this specification, all implementations MUST use industry security
best practices to be conformant to this specification. This includes, but is
not limited to, using proper access controls, securing communications,
implementing proper management of cryptographic secrets, doing frequent updates,
and promptly fixing known vulnerabilities.

Various relevant standards and guides can be consulted for that matter such as
the [CIS Critical Security Controls](https://www.cisecurity.org/controls/cis-controls-list).

## Producer Responsibilities

[Producer]: #producer

A package's <dfn>producer</dfn> is the organization that owns and releases the
software. It might be an open-source project, a company, a team within a
company, or even an individual.

NOTE: There were more requirements for producers in the initial
[draft version (v0.1)](../v0.1/requirements.md#scripted-build) which impacted
how a package can be built. These were removed in the v1.0 specification and
will be reassessed and re-added as indicated in the
[future directions](future-directions.md).

### Choose an appropriate build platform

The producer MUST select a build platform that is capable of reaching their
desired SLSA Build Level.

For example, if a producer wishes to produce a Build Level 3 artifact, they MUST
choose a builder capable of producing Build Level 3 provenance.

### Follow a consistent build process

The producer MUST build their artifact in a consistent
manner such that verifiers can form expectations about the build process. In
some implementations, the producer MAY provide explicit metadata to a verifier
about their build process. In others, the verifier will form their expectations
implicitly (e.g. trust on first use).

If a producer wishes to distribute their artifact through a [package ecosystem]
that requires explicit metadata about the build process in the form of a
configuration file, the producer MUST complete the configuration file and keep
it up to date. This metadata might include information related to the artifact's
source repository and build parameters.

## Build Platform Responsibilities

[Build platform]: #build-platform

A package's <dfn>build platform</dfn> is the infrastructure used to transform the
software from source to package. This includes the transitive closure of all
hardware, software, persons, and organizations that can influence the build. A
build platform is often a hosted, multi-tenant build service, but it could be a
system of multiple independent rebuilders, a special-purpose build platform used
by a single software project, or even an individual's workstation. Ideally, one
build platform is used by many different software packages so that consumers can
[minimize the number of trusted platforms](principles.md). For more background,
see [Build Model](terminology.md#build-model).

The build platform is responsible for providing two things: [provenance
generation] and [isolation between builds]. The
[Build level](build-track-basics) describes the degree to which each of these
properties is met.




