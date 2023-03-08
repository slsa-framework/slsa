# Distributing Artifacts

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
with the specific format of the attestation or attestation bundle itself.

## Overview

[Package ecosystem]: #package-ecosystem

A <dfn>package ecosystem</dfn> is a set of conventions and tooling for package
distribution. Every package has an ecosystem, whether it is formal or ad-hoc.
Some ecosystems are formal, such as language distribution (e.g.
[Python/PyPI](https://pypi.org)), operating system distribution (e.g.
[Debian/Apt](https://wiki.debian.org/DebianRepository/Format)), or artifact
distribution (e.g. [OCI](https://github.com/opencontainers/distribution-spec)).
Other ecosystems are informal, such as a convention used within a company. Even
ad-hoc distribution of software, such as through a link on a website, is
considered an "ecosystem".

The package ecosystem's maintainers are responsible for reliably redistributing
artifacts and provenance, making the producers' expectations available to consumers,
and providing tools to enable safe artifact consumption (e.g. whether an artifact
meets its producer's expectations).

## Relationship between releases and attestations

For many ecosystems, a single "release" of a project, package, or library may
include multiple artifacts, resulting from because builds that may happen over
multiple differing platforms, architectures or environments, and may not happen
at roughly the same point in time (and might even span multiple days).

As a result, the complete set of all attestations for a given release may be
incomplete until a build is finished, and in reality, a build may never be
truly 'finished' as in many ecosystems, it is permissible for new artifacts
that support new platforms or architectures to be introduced for old releases
long after the initial release.

As a result, using a single attestation bundle per release is unnecessarily
restrictive and does not work with the way complex, modern software artifacts
are built and distributed.

Thus, it is recommended to support multiple individual attestations or
attestation bundles per release. At the time of a given build, the relevant
build attestations for that build can be added to the release, depending on the
relationship to the given artifacts.

## Relationship between artifacts and attestations

Given the previous recommendation that a single release may have multiple
attestations, this raises the question of the relationship between the
one-or-more artifacts that comprise the output of a release build and the
attestations that correlate to them.

It is recommended to support a one-to-many relationship between build artifacts
and attestations, to ensure that anyone is free to produce and publish any
attestation they may need, but require a strict one-to-one relationship between
the build artifact and the build provenance attestation for that artifact. This
may require a custom filename schema that uniquely identifies the build
attestation over other attestation types, or it may happen as a de-facto
standard based on where the attestation is published.

For example, the build attestation should have a filename that is directly
related to the build artifact filename. For example, for an artifact
`<filename>.<extension>`, the attestation is `<filename>.attestation` (or some
similar extension, for example [in-toto](https://in-toto.io/) recommends
`<filename>.intoto.jsonl`), or for an artifact with a SHA-256 hash of
`abc123...`, the attestation incorporates that hash into the filename or
metadata.

## Where attestations should be published

There are a number of opportunities and venues to publish attestations during
and after the build process. It is recommended to publish attestations in a
number of places:

-   **Publish attestations in a transparency log**: Once a build has been made,
    the resulting attestation should be published to a third-party transparency
    log that exists outside the source repository and artifact repository.
-   **Publish attestations alongside source releases in the source
    repository**: For ecosystems where source releases are commonly published
    to source repositories as well as to artifact repositories (such as GitHub
    releases), if the source repository supports attaching additional artifacts
    on a release, it is recommended to additionally include provenance
    attestations as part of these releases. This option requires no changes to
    the artifact repository to support build attestation formats, but means
    that the source repository in use is now in the dependency chain for
    installers that want to verify policy at build-time.
-   **Publish attestations alongside the artifact in the artifact repository**:
    Many software repositories already support some variety of publishing 1:1
    related files alongside an artifact, sometimes known as “sidecar files”.
    For example, PyPI supports publishing `.asc` files representing the PGP
    signature for an artifact with the same filename (but different extension).
    This requires the mapping between artifact and attestation (or attestation
    vessel) to be 1:1.

A combination of these options allows for a bootstrap process where projects
that want to generate build provenance attestations may begin publishing
attestations in a way that is directly tied to a source release or built
artifact without needing to wait, by publishing it as part of the source
repository release.

Long-term, in order to maintain a single dependency on the artifact repository
already in use, repositories should gain support for both uploading the build
attestation format, and distributing it 1:1 alongside the artifact.

Short term consumers of build artifacts can bootstrap a manual policy by using
the source repository only for projects that publish all artifacts and
attestations to the source repository, and later extend this to all artifacts
published to the artifact repository via the canonical installation tools once
a given ecosystem supports them.

## Immutability of attestations

Attestations should be immutable. Once a build attestation is published as it
corresponds to a given artifact, that attestation is immutable and cannot be
overwritten later with a different attestation that refers to the same
artifact. Instead, a new release (and new artifacts) should be created instead.

## Format of the attestation

The provenance is available to the consumer in a format that the consumer
accepts. The format SHOULD be in-toto [SLSA Provenance](/provenance),
but another format MAY be used if both producer and consumer agree and it meets
all the other requirements.

## Considerations for source-based ecosystems

Some ecosystems have support for installing directly from source repositories
(optional for Python/`pip`, Go, etc). For these examples in these ecosystems,
as there is no "build" step that translates between a source repository and an
artifact that is being installed, there is no need to publish or verify build
provenance.

However, for ecosystems that install from source repositories _via_ some
intermediary (e.g. [Homebrew installing from GitHub release artifacts generated
from the repository or GitHub Packages](https://docs.brew.sh/Bottles), [Go
installing through the Go module proxy](https://proxy.golang.org/), these
intermediaries as transforming the original source repository in some way and
as a result should be providing build provenance, and the recommendations
outlined here apply.
