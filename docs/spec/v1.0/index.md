---
next_page:
  title: What's New in SLSA v1.0
  url: whats-new
---

# SLSA Specification

<div class="subtitle">

SLSA is a specification for describing and incrementally improving supply chain
security, established by industry consensus. It is organized into a series of
levels that describe increasing security guarantees.

</div>

This is **version 1.0** of the SLSA specification, which defines the SLSA
levels. For other versions, use the chooser <span class="hidden md:inline">to
the right</span><span class="md:hidden">at the bottom of this page</span>. For
the recommended attestation formats, including provenance, see "Specifications"
in the menu at the top.

## About this release candidate

This release candidate is a preview of version 1.0. It contains all
anticipated concepts and major changes for v1.0, but there are still outstanding
TODOs and cleanups. We expect to cover all TODOs and address feedback before the
1.0 final release.

Known issues:

-   TODO: Use consistent terminology throughout the site: "publish" vs
    "release", "publisher" vs "maintainer" vs "developer", "consumer" vs
    "ecosystem" vs "downstream system", "build" vs "produce.

-   Verifying artifacts and setting expectations are still in flux. We would
    like feedback on whether to move these parts out of the build track.

## Understanding SLSA

These pages provide an overview of SLSA, how it helps protect against common
supply-chain attacks, and common use cases. If you're new to SLSA or supply-chain security, start here.

| Page | Description |
| ---- | --- |
| [What's new in v1.0](whats-new.md) | What's new in SLSA Version 1.0 |
| [SLSA overview](principles.md) | An introductory guide to SLSA
| [Supply-chain threats](threats-overview) | An introduction to supply-chain threats |
| [Use cases](/use-cases) | Use cases |
| [FAQ](faq.md) | Questions and more information |
| [Future directions](future-directions.md) | Additions and changes being considered for future SLSA versions |

## Core specification

These pages describe SLSA's security levels and requirements for each track. If you want to achieve SLSA a particular level, these are the requirements you'll need to meet.

| Page | Description |
| ---- | --- |
| [Terminology](terminology.md) | Terminology and model used by SLSA |
| [Security levels](levels.md) | Overview of SLSA's tracks and levels, intended for all audiences |
| [Producing artifacts](requirements.md) | Detailed technical requirements for producing software artifacts, intended for system implementers |
| [Verifying build systems](verifying-systems.md) | Guidelines for securing SLSA Build L3+ builders, intended for system implementers |
| [Verifying artifacts](verifying-artifacts.md) | Guidance for verifying software artifacts and their SLSA provenance, intended for system implementers and software consumers |
| [Threats & mitigations](threats.md) | Detailed information about specific supply-chain attacks and how SLSA helps |

## Attestation formats

These pages include the concrete schemas for SLSA attestations. The Provenance and VSA formats are recommended, but not required by the specification.
| Page | Description |
| ---- | --- |
| [General model](/attestation-model) | General attestation model|
| [Provenance](/provenance/v1) | Suggested provenance format and explanation |
| [VSA](/verification_summary/v1) | Suggested VSA format and explanation |

## How to SLSA

These instructions tell you how to apply the core SLSA specification to use SLSA in your specific situation.
| Page | Description |
| ---- | --- |
| [For developers](/get-started) | How to apply SLSA requirements to your build|
| [For organizations](X) | TODO add|
| [For implementers](X) | TODO add |
