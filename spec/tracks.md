---
title: Tracks
description: Provides an overview of each track and links to more specific information.
---

SLSA is composed of [multiple tracks](about#how-slsa-works) which are each
composed of multiple levels. Each track addresses different [threats](threats)
and has its own set of requirements and patterns of use.

## Build Track

The SLSA build track describes increasing levels of trustworthiness and
completeness in a package artifact's <dfn>provenance</dfn>. Provenance describes
what entity built the artifact, what process they used, and what the inputs
were. The lowest level only requires the provenance to exist, while higher
levels provide increasing protection against tampering of the build, the
provenance, or the artifact.

The primary purpose of the build track is to enable
[verification](verifying-artifacts.md) that the artifact was built as expected.
Consumers have some way of knowing what the expected provenance should look like
for a given package and then compare each package artifact's actual provenance
to those expectations. Doing so prevents several classes of
[supply chain threats](threats.md).

Each ecosystem (for open source) or organization (for closed source) defines
exactly how this is implemented, including: means of defining expectations, what
provenance format is accepted, whether reproducible builds are used, how
provenance is distributed, when verification happens, and what happens on
failure. Guidelines for implementers can be found in the
[requirements](build-requirements.md).

-   [Terminology](terminology.md)
-   [Basics](build-track-basics.md)
-   [Requirements](build-requirements.md)
-   [Build provenance](build-provenance.md)
-   [Assessing build platforms](assessing-build-platforms.md)

## Source Track

The SLSA source track provides producers and consumers with increasing levels of
trust in the source code they produce and consume. It describes increasing
levels of trustworthiness and completeness of how a source revision was created.

The expected process for creating a new revision is determined solely by that
repository's owner (the organization) who also determines the intent of the
software in the repository and administers technical controls to enforce the
process.

Consumers can review attestations to verify whether a particular revision meets
their standards.

-   [Requirements](source-requirements.md)
-   [Source provenance](source-requirements#source-provenance-attestations)
-   [Assessing source systems](assessing-source-systems.md)
-   [Example controls](source-example-controls.md)

## Build Environment track

The goal of a Build Environment track is to enable the detection of tampering
with core components of the compute environment executing builds. The track
describes increasing levels of integrity for different components of the
build platform and its underlying compute platform.

At a general level, implementers of this track will generate SLSA Build
Provenance for build images, validate the integrity of a build's environment
at boot time against good known values, and at L3 deploy the build system on
compute that supports system state measurement and attestation capabilities at
the hardware level.

-   [Basics](build-env-track-basics.md)

## Dependency Track

The SLSA Dependency Track defines requirements for the ingestion of
third-party build dependencies. It defines a per-ingestion attestation,
Dependency Ingestion Provenance, emitted by a Dependency Ingestion
Platform. Three levels grade the platform's claims about each ingested
dependency: L1 Inventoried (identity recorded; other verdicts MAY be
recorded as transparency), L2 Controlled (configured ingestion path
including transitive deps; identity-verification verdicts MUST be
`verified`; admission policies the platform applies are recorded in
the Provenance; the platform signs the Provenance), and L3 Screened
(bypass structurally blocked; upstream-provenance verdict recorded;
signing infrastructure isolated from dep code and cross-dep ingestion
isolated, so a hostile dep cannot subvert the Provenance about itself
or about other deps — the Shai Hulud threat model).

The track imports the attestable subset of the OpenSSF
[Secure Supply Chain Consumption Framework
(S2C2F)](https://github.com/ossf/s2c2f). S2C2F requirements that
describe organizational practice rather than per-artifact evidence are
referred to the OpenSSF Security Baseline. S2C2F requirements that
describe the ingestor producing their own producer-side Build
attestations over consumed dependencies (via rebuild) are deferred to a
future cross-cutting axis. See the
[S2C2F mapping appendix](dependency-track.md#s2c2f-mapping-appendix).

The track is for any organization that ingests third-party software
dependencies. This includes software producers consuming upstream OSS
and pure consumers such as enterprises that consume OSS internally
without releasing downstream artifacts.

-   [Basics & requirements](dependency-track.md)
-   [Dependency Ingestion Provenance](dependency-provenance.md)
-   [S2C2F mapping appendix](dependency-track.md#s2c2f-mapping-appendix)
