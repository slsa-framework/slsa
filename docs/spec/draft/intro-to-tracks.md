---
title: Introduction to Tracks and Attestations
description: This page provides an overview of the four SLSA tracks and Attestation formats.
---

# {Introduction to Tracks and Attestations}

## Tracks and Attestations overview

The SLSA Specification is composed of four tracks that have multiple levels of security. These tracks address different types of threats to the supply chain and each has their own set of requirements and patterns of use. The tracks are introduced below and the individual sections of this specification will explain their standards and requirements in greater detail. 

Each track can generate Provenance attestations to facilitate automated security level testing. Because the attestation formats are common to all tracks, they are supplied in a four-part section after all the track pages.

## Build Track

The SLSA build track describes increasing levels of trustworthiness and
completeness in a package artifact's <dfn>provenance</dfn>. Provenance describes
what entity built the artifact, what process they used, and what the inputs
were. The lowest track level only requires the provenance to exist, while higher
levels provide increasing protection against tampering of the build, the
provenance, or the artifact.

The primary purpose of the build track is to enable
verification that the artifact was built as expected.
Consumers have a way of knowing what the expected provenance should look like
for a given package. They then can compare each package artifact's actual provenance
to those expectations. This comparison provides certainty of the package contents, preventing several classes of supply chain threats.

Each software supply chain ecosystem (for open source) or organization (for closed source) defines
exactly how this is implemented. The implementation includes: a means of defining expectations, what
provenance format is accepted, whether reproducible builds are used, how
provenance is distributed, when verification happens, and what happens on
failure.

Guidelines for implementers can be found in the
requirements page of the build track. The build track will cover these five topics:

- Basics
- Requirements
- Provenance
- Verification
- Assessment

## Build Environment track

The build environment track
describes the increasing levels of integrity for different components of the
build platform and its underlying compute platform.
The goal of this track is to enable the detection of tampering
with core components of the compute environment executing builds. 

Implementers of this track will: generate SLSA Build
Provenance for build images, validate the integrity of a build's environment
at boot time against good known values, and at level 3 (L3) deploy the build system on
compute that supports system state measurement and attestation capabilities at
the hardware level.

This track will cover the same five topics as the build track:

- Basics
- Requirements
- Provenance
- Verification
- Assessment

**Note:** The build environment track is currently being developed. Some of the topics are not complete at this time.

## Dependency Track

The goal of the Dependency Track is to enable a software producer to measure, control and reduce risk introduced from third party dependencies. This track is primarily aimed at enterprises/organizations, with medium- to large-sized organizations benefiting the most from adoption of the dependency track levels. Organizations can include business enterprises, but also large open source projects that want to manage third party dependency risk.

This track will cover the same five topics as the build track:

- Basics
- Requirements
- Provenance
- Verification
- Assessment

**Note:** The dependency track is also still being developed. Some of the topics are not complete at this time.

## Source Track

The SLSA source track provides producers and consumers with levels of
trust in the source code they produce and consume. It describes increasing
levels of trustworthiness and completeness of how a source revision was created.

The expected process for creating a new revision is determined solely by the
repository's owner. The owner also determines the intent of the
software in the repository and administers technical controls to enforce the
process. Consumers can review attestations to verify whether a particular revision meets
their standards.

This track will cover the same five topics as the build track, but it has one additional topic for example controls:

- Basics
- Requirements
- Provenance
- Verification
- Assessment
- Example controls

## Attestation Formats

SLSA provides specific attestation formats to be used for atomated Provenance testing. A software attestation is an authenticated statement (metadata) about a software artifact or collection of software artifacts. The primary intended use case is to feed into automated policy engines. Attestation formats can speed up the security testing of an artifact at every level, but must be backed up by humans verifying the Provenance using the Verification procedures for that track.

The Attestation formats are covered in these four pages:

- General model
- Provenance
- Build Provenance
- Verification Summary Attestations (VSA) **Note:** Verified Properties are explained in the VSA page. These properties are to be used in place of attestations when the security state of an artifact is not appropriate.


