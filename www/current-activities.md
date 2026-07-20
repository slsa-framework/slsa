---
title: Current activities
description: There's an active community of members, contributors and collaborators working to enhance the SLSA specification with updates to existing and new tracks. This page provides a summary of current ongoing activities.
layout: standard
---

Since the release of <a href="spec/v1.0/">SLSA v1.0</a> in 2023,
the SLSA community has been hard at work to improve the specification
and expand its breadth and depth with updates and new tracks.

Learn how you can [get involved](/community#get-involved)!

## Build Environment track

The goal of a Build Environment track is to enable the detection of tampering
with core components of the compute environment executing builds.

The current [draft version](/spec/draft/build-env-track-basics.md)
of the Build Environment track includes the following requirements:

-   Generation and verification of SLSA Build Provenance for build images.
-   Validation of initial build environment system state against known good
    reference values.
-   Deployment of the hosted build platform on a compute system that supports
    system state measurement and attestation capabilities at the hardware level.

These requirements are **subject to significant change** while this track
is in draft.

## Dependency track

The Dependency Track defines a new SLSA evidence type, Dependency
Ingestion Provenance, emitted per ingested dependency by a Dependency
Ingestion Platform. Three levels grade the platform's claims about
each ingested dep: L1 Inventoried (identity recorded; other verdicts
MAY be recorded as transparency), L2 Controlled (configured ingestion
path including transitive deps; identity-verification verdicts MUST be
`verified`; admission policies the platform applies are recorded in
the Provenance; the platform signs the Provenance), and L3 Screened
(bypass structurally blocked; upstream-provenance verdict recorded;
platform signing infrastructure isolated from dep code and cross-dep
ingestion isolated, so a hostile dep cannot subvert the Provenance —
addressing the Shai Hulud npm-worm threat model).

The track is deliberately integrity-focused. It does not prescribe
specific scans, deny-lists, version-age cutoffs, or install-hook
constraints — those are best-practice decisions left to operator and
verifier policy. The integrity guarantee is that whatever verifications
and admission policies the platform applies are transparent in the
Provenance, signed by the platform, and (at L3) impossible for a
hostile dep to subvert. A small set of S2C2F requirements are imported
(inventory, chokepoint, integrity verification, transitive resolution,
publisher signature, structural enforcement, upstream-provenance
verification). Most of S2C2F's catalog (specific scans, deny-lists,
update tooling) is out of scope for this track and is referred to the
OpenSSF Security Baseline. The full traceability table is in the
[S2C2F mapping appendix](/spec/draft/dependency-track#s2c2f-mapping-appendix).

A formal proposal documenting the restructure — its motivation, the new
predicate format, and open design questions — is open for community review
in
[slsa-framework/slsa-proposals](https://github.com/slsa-framework/slsa-proposals).

The current Working Draft is published at
[/spec/draft/dependency-track](/spec/draft/dependency-track); the predicate
schema is at
[/spec/draft/dependency-provenance](/spec/draft/dependency-provenance).

Join the discussions and ongoing efforts
[on the SLSA Dependency Track Slack channel](https://openssf.slack.com/archives/C03THTH3RSM).
