---
title: What's new in SLSA v1.0
description: SLSA v1.0 is the first stable release of SLSA. This document describes what has changed since v0.1.
---

SLSA v1.0 is the first stable release of SLSA, creating a solid foundation on
which future versions can expand. This document describes the major changes in
v1.0 relative to the prior release, [v0.1].

## Summary of changes

SLSA v1.0 is a significant rework of the specification in response to ongoing
feedback, filed issues, suggestions for course corrections, and other input from
the SLSA community and early adopters. Overall, the changes prioritize
simplicity, practicality, and stability.

Overall, SLSA v1.0 is more stable and better defined than v0.1, but less
ambitious. It corresponds roughly to the build and provenance requirements of
the prior version's SLSA Levels 1 through 3, deferring SLSA Level 4 and the
source and common requirements to a future version. The rationale is explained
[below][stability].

Other significant changes:

-   [Division of the levels into multiple tracks][tracks], which are separate
    sets of levels that measure different aspects of software supply chain
    security
-   [Reorganization and simplification of the core specification][core-spec] to
    make it easier to understand and to provide better guidance
-   [New guidance on verification][verification] of artifacts and build systems
-   [Updated provenance and VSA schemas][provenance-spec], with a clearer build
    model

## Stability and scope

[stability]: #stability-and-scope

The v1.0 release marks the first stable version of SLSA. We are confident that
the specification represents broad consensus and will not change significantly
in the future. Having a stable foundation enables organizations and ecosystems
to begin implementing and adopting SLSA with minimal risk of future breaking
changes.

That said, some concepts from v0.1 had to be deferred to a [future
version][future] in order to allow us to release v1.0 in a reasonable time
frame. The deferred concepts---source requirements, hermetic builds (SLSA L4),
and common requirements---were at significant risk of breaking changes in the
future to address concerns from v0.1. We believed it was more valuable to
release a small but stable base now while we work towards solidifying those
concepts in a future version.

Going forward, we commit to a consistent [versioning](/spec-stages#versioning)
scheme based on semantic versioning. Backwards-incompatible changes will result
in a major version increase (v2.0, v3.0, etc.); significant backwards-compatible
changes will result in a minor version increase (v1.1, v1.2, etc.), while
editorial changes may be made without a version increase.

For further explanation of the decisions behind v1.0, see the [SLSA v1.0
Proposal][proposal].

## Tracks

[Tracks]: #tracks

A significant conceptual change from v0.1 is the division of SLSA's level
requirements into multiple tracks. Previously, each SLSA level encompassed
requirements across multiple software supply chain aspects: there were source,
build, provenance, and common requirements. To reach a particular level,
adopters needed to meet [all requirements in each of the four areas][v0.1-reqs].
Organizing the specification in that way made adoption cumbersome, since
requirements were split across unrelated domains—improvements in one area were
not recognized until improvements were made in all areas.

Now, the requirements are divided into SLSA tracks that each focus on one area
of the software supply chain. We anticipate this division will make SLSA
adoption easier for users. Division into tracks also benefits the SLSA
community: developers contributing to SLSA can parallelize work on multiple
tracks without blocking each other, and members of the community can contribute
specifically to their areas of expertise.

SLSA v1.0 defines the SLSA Build track to begin this separation of
requirements, with other tracks to come in future versions. The new
[SLSA Build track Levels 1-3](levels#build-track) roughly
correspond to [Levels 1-3 of v0.1](requirements#build-requirements),
minus the source requirements. We anticipate future versions of the
specification to continue building on requirements without changing the existing
requirements defined in v1.0. The specification will likely expand to
incorporate both new tracks and additional levels for existing tracks. We
currently have [plans][future] for Build Level 4 and a Source track.

The v1.0 also defines the [principles](principles) behind SLSA track
requirements, which will guide future track additions. For more information
about the rationale for tracks, see the [proposal].

## Improvements to core specification

[core-spec]: #improvements-to-core-specification

We've simplified and reorganized the specification to make it easier to
understand and apply. We've also split the requirements into multiple pages to
better reflect the division of labor across the software supply chain: producing
artifacts, distributing provenance, verifying artifacts, and verifying build
platforms.

[Terminology](terminology) has been expanded to fully define all necessary
concepts and to be consistent across the specification.

[Security levels](levels) has been completely rewritten to provide a high
level overview of the SLSA [tracks] and levels. Importantly, it explains the
benefits provided by each level.

[Producing artifacts](requirements) explains requirements for the software
producer and the build platform. While the requirements are largely the same as
before---aside from those [deferred][stability] to a future version---there are
some minor changes to make SLSA easier to adopt. These changes include:
renaming, simplifying, and merging some requirements; removing the redundant
"scripted build" and "config as code" requirements; merging of the provenance
requirements into the recommended [provenance format][provenance-spec]; and
splitting the requirements between those for the Producer and the Build
platform.

[Distributing provenance](distributing-provenance) *(new for v1.0)* provides
guidance to software producers and package ecosystems on how to distribute
provenance alongside artifacts. We hope this brings consistency across open
source package ecosystems as they adopt SLSA.

[Verifying artifacts](verifying-artifacts) *(new for v1.0)* provides guidance to
package ecosystems and consumers for how to verify provenance and compare it to
expectations. It is discussed more in the following section.

[Verifying build platforms](verifying-systems) *(new for v1.0)* provides a list
of prompts for evaluating a build platform's SLSA conformance. It covers similar
ground as v0.1's common requirements, but in a different form. It is also
discussed in the following section.

[Threats & mitigations](threats) has been updated for v1.0, filling out parts
that were missing in v0.1. Note that labels D and E have swapped positions from
v0.1 to align with the grouping of Source (A-C), Dependency (D), and Build (E-H)
threats.

## Verification

[verification]: #verification

Another significant change in the v1.0 is documenting the need for provenance
verification.

SLSA v0.1 specified guidance for how to produce provenance but not how to verify
it. This left a large gap as most threats targeted by SLSA are only mitigated by
verifying provenance and comparing it to expectations.

SLSA v1.0 addresses this gap by providing more explicit guidance on how to
verify provenance. This is split between establishing
[trust in build platforms](verifying-systems) themselves versus establishing
[trust in artifacts](verifying-artifacts) produced by those build platforms.
Build platforms implement the requirements around isolation and provenance
generation, and consumers choose whether to trust those build platforms. Once
that trust is established, consumers or package managers can verify artifacts by
comparing the provenance to expectations for the package in question.

Ecosystems are already creating verification tooling, such as [npm's forthcoming
SLSA support](https://github.com/github/roadmap/issues/612). Tooling for
organizations that need to protect first-party software is also available, such
as [slsa-verifier](https://github.com/slsa-framework/slsa-verifier).

## Provenance and VSA formats

[provenance-spec]: #provenance-and-vsa-formats

SLSA v1.0 simplifies SLSA's build model and recommended provenance format to
make it easier to understand and apply to arbitrary build platforms.

A major source of confusion for SLSA v0.1 was how to model a build and represent
it in provenance. The v0.1 spec and v0.x provenance formats were overly rigid
about a build's inputs, differentiating between "source", "build config", "entry
point", and so on. Many implementers found that their build platforms did not
clearly fit into this model, and the intent of each field was not clear.
Furthermore, provenance requirements were described both abstractly in the SLSA
specification and concretely in the provenance format, using different language.
Implementers needed to jump back and forth and mentally map one concept to
another.

SLSA v1.0 and the recommended [provenance v1 format](/provenance/v1) attempt to
address this confusion by simplifying the model and aligning terminology between
the two. The main change is to represent all "external parameters" that are
exposed to the build platform's users, instead of differentiating between
various inputs. Now, you can represent arbitrary parameters, as long as it is
possible to compare these parameters to expectations. Other parts of the
provenance format were renamed, though most concepts translate from the old
format to the new format. For a detailed list of changes, see
[provenance change history](/provenance/v1#change-history).

In addition, the recommended
[verification summary attestation (VSA)](/verification_summary/v1) has been
updated to v1.0.

<!-- Footnotes and link definitions -->

[future]: future-directions
[proposal]: https://github.com/slsa-framework/slsa-proposals/blob/main/0003/README.md
[v0.1-reqs]: /spec/v0.1/requirements
[v0.1]: /spec/v0.1/
