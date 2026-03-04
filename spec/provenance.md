---
title: Provenance
description: Provides a description of the concept of provenance and links to the various tracks specific definitions.
---

In SLSA 'provenance' refers to verifiable information that can be used to track
an artifact back, through all the moving parts in a complex supply chain, to
where it came from. It’s the verifiable information about software artifacts
describing where, when, and how something was produced.

The different SLSA tracks have their own, more specific, implementations of
provenance to account for their unique needs.

NOTE: If you landed here via the
[in-toto attestation](https://github.com/in-toto/attestation) predicate type
`https://slsa.dev/provenance/v1` please see
[Build provenance](build-provenance.md).

-   [Build provenance](build-provenance.md) - tracks the output of a build process
   back to the source code used to produce that output.
-   [Source provenance](source-requirements#source-provenance-attestations) - tracks the
    creation of source code revisions and the change management processes
    that were in place during their creation.
