---
title: Distributing artifacts
description: This page covers the detailed technical requirements for distributing artifacts at each SLSA level. The intended audience is system implementers and software distributors.
prev_page:
  url: requirements
next_page:
  url: verifying-artifacts
---

SLSA requires the distribution and verification of provenance metadata in the
form of SLSA attestations, in order to make provenance for related artifacts
available after generation for verification.

This document specifies how these attestations should be distributed, or the
relationship between build artifacts and attestations. It is primarily
concerned with artifacts for ecosystems that distribute "built distributions",
but some attention is also paid to ecosystems that distribute container images
or only distribute source artifacts, as many of the same principles generally
apply to any artifact or group of artifacts.

In addition, this document is primarily for the benefit of artifact
distributors, to understand how they should adopt the distribution of SLSA
provenance. It is primarily concerned with the means of distributing
attestations and the relationship of attestations to build artifacts, and not
with the specific format of the attestation itself.

## Background

The [package ecosystem](terminology.md#package-model)'s maintainers are
responsible for reliably redistributing artifacts and provenance, making the
producers' expectations available to consumers, and providing tools to enable
safe artifact consumption (e.g. whether an artifact meets its producer's
expectations).

## Relationship between releases and attestations

Attestations should be bound to artifacts, not releases.

A single "release" of a project, package, or library may include multiple
artifacts. These artifacts result from builds on different platforms,
architectures or environments. The builds need not happen at roughly the same
point in time and might even span multiple days.

The complete set of attestations for a given release is incomplete until all
builds for a given release are finished. However, it is difficult or impossible
to determine when a release is 'finished' because many ecosystems allow adding
new artifacts to old releases when adding support for new platforms or
architectures.

Thus, package ecosystems SHOULD support multiple individual attestations per
release. At the time of a given build, the relevant build attestations for that
build can be added to the release, depending on the relationship to the given
artifacts.

## Relationship between artifacts and attestations

Package ecosystems SHOULD support a one-to-many relationship between build
artifacts and attestations to ensure that anyone is free to produce and publish
any attestation they may need. Package ecosystems MUST require a strict
one-to-one relationship between the build artifact and the build provenance
attestation for that artifact.  The mappings can be either implicit (e.g.
require a custom filename schema that uniquely identifies the build attestation
over other attestation types) or explicit (e.g. it may happen as a de-facto
standard based on where the attestation is published).

The build attestation SHOULD have a filename that is directly related to the
build artifact filename. For example, for an artifact `<filename>.<extension>`,
the attestation is `<filename>.attestation` (or some similar extension, for
example [in-toto](https://in-toto.io/) recommends `<filename>.intoto.jsonl`),
or for an artifact with a SHA-256 hash of `abc123...`, the attestation
incorporates that hash into the filename or metadata.

## Where attestations should be published

There are a number of opportunities and venues to publish attestations during
and after the build process. Producers SHOULD publish attestations in a number
of places:

-   **Publish attestations in a transparency log**: Once a build has been made,
    the resulting attestation (or a hash of the attestation and a pointer to
    where it is indexed) SHOULD be published to a third-party transparency log
    that exists outside the source repository and package registry. Not only
    are transparency logs guaranteed to be immutable, but they also more
    easily enable monitoring.  Requiring the presence of the attestation in a
    monitored transparency log during verification helps ensure the attestation
    is trustworthy.
-   **Publish attestations alongside source releases in the source
    repository**: For ecosystems where source releases are commonly published
    to source repositories as well as to package registries (such as GitHub
    releases), producers SHOULD include provenance attestations as part of
    these releases if the source repository supports attaching additional
    artifacts to a release. This option requires no changes to the package
    registry to support build attestation formats, but means that the source
    repository in use is now in the dependency chain for installers that want
    to verify policy at build-time.
-   **Publish attestations alongside the artifact in the package registry**:
    Many software repositories already support some variety of publishing 1:1
    related files alongside an artifact, sometimes known as “sidecar files”.
    For example, PyPI supports publishing `.asc` files representing the PGP
    signature for an artifact with the same filename (but different extension).
    This option requires the mapping between artifact and attestation (or
    attestation vessel) to be 1:1.

A combination of these options allows for a bootstrap process where projects
that want to generate build provenance attestations may begin publishing
attestations in a way that is directly tied to a source release or built
artifact without needing to wait for the upstream package registry to support
publishing attestations, by publishing it as part of the source repository
release.

Long-term, in order to maintain a single dependency on the package registry
already in use, repositories should gain support for both uploading and
distributing the build attestation alongside the artifact.

Short term, consumers of build artifacts can bootstrap a manual policy by using
the source repository only for projects that publish all artifacts and
attestations to the source repository, and later extend this to all artifacts
published to the package registry via the canonical installation tools once
a given ecosystem supports them.

## Immutability of attestations

Attestations MUST be immutable. Once a build attestation is published as it
corresponds to a given artifact, that attestation is immutable and cannot be
overwritten later with a different attestation that refers to the same
artifact. Instead, a new release (and new artifacts) MUST be created.

## Format of the attestation

The provenance is available to the consumer in a format that the consumer
accepts. The format SHOULD be in-toto [SLSA Provenance](/provenance), but
another format MAY be used if both producer and consumer agree and it meets all
the other requirements.

## Considerations for source-based ecosystems

Some ecosystems have support for installing directly from source repositories
(optional for Python/`pip`, Go, etc). In these cases, there is no need to publish
or verify provenance because there is no "build" step that translates between
a source repository and an artifact that is being installed.

However, for ecosystems that install from source repositories _via_ some
intermediary (e.g. [Homebrew installing from GitHub release artifacts generated
from the repository or GitHub Packages](https://docs.brew.sh/Bottles), [Go
installing through the Go module proxy](https://proxy.golang.org/)), these
ecosystems distribute "source archives" that are not the bit-for-bit identical
form from version control.  These intermediaries as transforming the original
source repository in some way that constitutes a "build" and as a result should
be providing build provenance for this "package", and the recommendations
outlined here apply.
