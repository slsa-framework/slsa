---
title: What's new in SLSA v1.1
description: SLSA v1.1 is a minor release of SLSA. That is, all changes are intended to be backwards compatible. This document describes what has changed since v1.0.
---

SLSA v1.1 is a minor release of SLSA v1 which adds additional content without
changing the meaning of the specification. This document describes the major
changes in v1.1 relative to the prior release, [v1.0].

## Summary of changes

-   Clarify that attestation format schema are informative and the
    specification texts (SLSA and [in-toto attestation]) are the canonical
    source of definitions.
-   Add procedure for verifying VSAs.
-   Add verifier metadata to VSA format.
-   It is now recommended that the `digest` field of `ResourceDescriptor` is
    set in a Verification Summary Attestation's (VSA) `policy` object.
-   Further refine the [threat model](threats).
-   Add a draft Source track.

<!-- Footnotes and link definitions -->

[in-toto attestation]: https://github.com/in-toto/attestation
[v1.0]: /spec/v1.0/
