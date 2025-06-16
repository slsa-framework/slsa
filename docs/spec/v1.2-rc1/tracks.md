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

Consumers can review attestations to verify whether a particular revision meets their standards.

-   [Requirements](source-requirements.md)
-   [Source provenance](source-requirements#source-provenance-attestations)
-   [Assessing source systems](assessing-source-systems.md)
