---
title: SLSA Verified Properties
description: |
  SLSA allows 
---

# SLSA Verified Properties

While SLSA is typically focused on expressing the security state of an artifact
with [levels](principles#simple-levels-with-clear-outcomes), levels may not be
appropriate in all cases. Some software supply chain controls don't fit neatly
within existing SLSA levels or that do may exist with others that users are not
yet able to meet.  SLSA Verified Properties allows a common way to express those
properties (and their requirements) without needing to fit them into existing
levels or introduce new tracks.

These properties MAY be included in the `verifiedLevels` field of
[verification_summaries (VSAs)](verification_summary) when the VSA issuer
determines the requirements have been met.

## SLSA_SOURCE_TWO_PARTY_REVIEWED

Indicates the source code associated with this artifact has been reviewed by
two trusted persons.  This property MUST only be issued in accordance with the
[Source Track](source-requirements)'s
[two-party-review](source-requirements#two-party-review) requirements.

The property MAY be added at any source level in which an SCS can make this
claim.

## SLSA_BUILD_REPRODUCED

Indicates the referenced artifact has been reproduced by two or more builders.

This property MUST only be issued if the referenced artifact has
[build provenance](build-provenance) from two or more independently
operated [Build Platforms](build-requirements#build-platform) which are
trusted by the VSA issuer.
