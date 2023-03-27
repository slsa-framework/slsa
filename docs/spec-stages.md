---
title: Specification Stages and Versioning
description: SLSA specifications go through various stages of development from which you should have different expectations. This document defines the different stages the SLSA project uses and their meaning for readers and contributors.
layout: specifications
---

## Specification Stages

Specifications go through various stages of development from which you
should have different expectations. This document defines the different
stages the SLSA project uses and their meaning for readers and
contributors.

Every specification page should prominently display a *Status* section
stating which stage the specification is in with a link to its
definition.

### Draft

This is the first stage of development a specification goes
through. At this point, not much should be expected of it. The
specification may be very incomplete and may change at any time and
even be abandoned. It is therefore not suitable for reference or for
implementation beyond experimentation.

A specification may be published several times during this stage as
work progresses. The status section of the document may provide
additional information as to its development status and whether
reviews and feedback are welcome.

See the
[Governance](https://github.com/slsa-framework/governance/blob/main/5._Governance.md#4-specification-development-process)
for other considerations related to a
[Draft Specification](https://github.com/slsa-framework/governance/blob/main/1._Community_Specification_License-v1.md).

### Candidate

At this stage the document is considered to be feature complete and is
published as a way to invite final reviews. Editorial changes may
still be made but no addition of new features is expected and short of
problems being found no significant changes are expected to happen
anymore.

See the
[Governance](https://github.com/slsa-framework/governance/blob/main/5._Governance.md#4-specification-development-process)
for other considerations related to a
[Candidate for Approved Specification](https://github.com/slsa-framework/governance/blob/main/1._Community_Specification_License-v1.md).

### Approved

At this stage the document is considered stable. No changes that would
constitute a significant departure from the existing specification are
expected although changes to address ambiguities and edge cases may
still occur.

See the
[Governance](https://github.com/slsa-framework/governance/blob/main/5._Governance.md#4-specification-development-process)
for other considerations related to an
[Approved Specification](https://github.com/slsa-framework/governance/blob/main/1._Community_Specification_License-v1.md).

### Retired

This stage indicates that the specification is no longer maintained.
It has been either rendered obsolete by a newer version or
abandoned for some reason. The status of the document may provide
additional information and point to the new document to use intead if
there is one.

## Versioning

SLSA needs revision from time to time, so we version the specification to
facilitate conformance efforts and prevent confusion. We assign
version numbers to the Core Specification and Attestation Formats, collectivly
known as the SLSA Specification.

Given a version MAJOR.MINOR, we will increment
-   MAJOR version when making backwards incompatible changes to the Core
  Specification. 
-   MINOR version when making backwards compatible changes to the Core
  Specification, or  when making changes to the Attestation Formats.

Backwards incompatible changes to the core specification
include adding a new track and either adding or removing requirements
from an existing track. All other changes to the Core
Specification are considered backwards compatible. 

Although we may revise the meaning of level, we will never fundamentally
change it (e.g. SLSA Build Level 2 will retain its general meaning between
versions). If you require precision when referring to SLSA levels, then include
their version number using the syntax "SLSA <Track> <Level> (<Version>)" (e.g.
"SLSA Build L3 (v1.0)").
