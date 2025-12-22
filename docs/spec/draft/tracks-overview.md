---
title: Overview of SLSA tracks
description: The SLSA specification divides up Software Supply Chain activities into four independent tracks.
---

## Overview of SLSA Tracks.

Multiple activities can make up a supply chain management system.  

Currently there are four separate tracks that are covered by the SLSA specificaton:

| Track Name    | Activity |
| ---           | ---      |
| Build Track  | Process that transforms a set of input artifacts into a set of output artifacts. The inputs may be sources, dependencies, or ephemeral build outputs. |
| Build Environment Track | Describes how a build image was created, how the hosted build platform deployed a build image in its environment, and the compute platform they used. |
| Dependency Track | Software artifacts fetched or otherwise made available to the build environment during the build of the artifact. This includes open and closed source binary dependencies. |
| Source Track | Source code used to create software artificts. Descriptions of how the Source Control System (SCS) and Version Control System (VCS) provide producers and consumers with increasing levels of trust in the source code they produce and consume. |

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

-   [Basics](build-track-basics.md)

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

The goal of Dependency Track is to enable a software producer to measure, control and reduce risk introduced from third party dependencies.

The Dependency Track is primarily aimed at enterprises/organizations, with medium to large-sized organizations benefiting the most from adoption of the dependency track levels. Organizations include enterprises, but also large open source projects that want to manage third party dependency risk.

-   [Basics](depend-track-basics.md)

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

-   [Basics](source-track-basics.md)






