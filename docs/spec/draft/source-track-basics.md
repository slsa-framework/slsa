---
title: Source Track: Basics
description: This page introduces the SLSA source track part of the supply chain, terminology, and the levels of the source security requirements.
---

# {Source Track: Basics}

**About this page:** the *Source Track: Basics* page introduces the SLSA source track part of the supply chain, terminology, and the levels of the source security requirements.

**Intended audience:** source control system implementers and security engineers

**Topics covered:** source track overview, terminology, and introduction to source track levels of security

**Internet standards:** [RFC 2119](https://www.rfc-editor.org/rfc/rfc2119), {other standards as required}

>The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD",
"SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be
interpreted as described in [RFC 2119](https://www.rfc-editor.org/rfc/rfc2119).

**For more information, see:** {optional}

## Overview

The primary purpose of the SLSA Source track is to provide producers and consumers with increasing levels of trust in the source code they produce and consume. This track describes increasing levels of trustworthiness and completeness of how a source revision was created. This page will show track-level specifics and requirements.

The expected process for creating a new revision is determined solely by that repository's owner (the organization) who also determines the intent of the software in the repository and administers technical controls to enforce the process.

Consumers can review attestations to verify whether a particular revision meets their standards for consuming artifacts. Information on how to use attestations is defined in this document.

## Source Track Terminology

These terms apply to the Source track. See the general terminology [list](terms-generic.md) for terms used throughout the SLSA specification.

### Version Control Systems terminology

A **Version Control System (VCS)** is a system of software and protocols for
managing the version history of a set of files. Git, Mercurial, and Subversion
are all examples of version control systems. The following terms apply to Version Control Systems:

| Term | Description |
| --- | --- |
| Branch | A Named Reference that moves to track the Change History of a cohesive line of development within a Source Repository; e.g. `main`, `develop`, `feature-x`. |
| Change | A modification to the state of the Source Repository, such as creation of a new Source Revision based on a previous Source Revision, or creation, deletion, or modification of a Named Reference. |
| Change History | A record of the history of Source Revisions that preceded a specific revision. |
| Named Reference | A user-friendly name for a specific source revision, such as `main` or `v1.2.3`. |
| Source Repository (Repo) | A self-contained unit that holds the content and revision history for a set of files, along with related metadata like Branches and Tags. |
| Source Revision | A specific, logically immutable snapshot of the repository's tracked files. It is uniquely identified by a revision identifier, such as a cryptographic hash like a Git commit SHA or a path-qualified sequential number like `25@trunk/` in SVN. A Source Revision includes both the content (the files) and its associated version control metadata, such as the author, timestamp, and parent revision(s). Note: Path qualification is needed for version control systems that represent Branches and Tags using paths, such as Subversion and Perforce. |
| <span id="tag">Tag</span> | A Named Reference that is intended to be immutable. Once created, it is not moved to point to a different revision; e.g. `v1.2.3`, `release-20250722`. |

> **NOTE:** The 'branch' and 'tag' features within version control systems may
not always align with the 'Branch' and 'Tag' definitions provided in this
specification. For example, in git and other version control systems, the UX may
allow 'tags' to be moved. Patterns like `latest` and `nightly` tags rely on this.
For the purposes of this specification these would be classified as 'Named References' and not as 'Tags'.

### Source Control Systems terminology

A **Source Control System (SCS)** is a platform or combination of services
(self-hosted or SaaS) that hosts a Source Repository and provides a trusted
foundation for managing source revisions by enforcing policies for
authentication, authorization, and change management, such as mandatory code
reviews or passing status checks. The following terms apply to Source Control Systems:

| Term | Description
| --- | ---
| Organization | A set of people who collectively create Source Revisions within a Source Repository. Examples of organizations include open-source projects, a company, or a team within a company. The organization defines the goals of a Source Repository and the methods used to produce new Source Revisions. |
| Proposed Change | A proposal to make a Change in a Source Repository. |
| Source Provenance | Information about how a Source Revision came to exist, where it was hosted, when it was generated, what process was used, who the contributors were, and which parent revisions preceded it. |

### Source Roles terminology

| Role | Description
| --- | ---
| Administrator | A human who can perform privileged operations on one or more projects. Privileged actions include, but are not limited to, modifying the change history and modifying project- or organization-wide security policies. |
| Trusted person | A human who is authorized by the organization to propose and approve changes to the source. |
| Trusted robot | Automation authorized by the organization to act in explicitly defined contexts. The robot’s identity and codebase cannot be unilaterally influenced. |
| Untrusted person | A human who has limited access to the project. They MAY be able to read the source. They MAY be able to propose or review changes to the source. They MAY NOT approve changes to the source or perform any privileged actions on the project. |


## Source Track Level Introduction

NOTE: This table presents a simplified view of the requirements. See the
[Source Track Requirements](#source-track-requirements) section later in this document for the full list of requirements for each
level.

| Track/Level | Requirements | Focus
| ----------- | ------------ | -----
| [Source L1](#source-l1) | Use a version control system. | Generation of discrete Source Revisions for precise consumption.
| [Source L2](#source-l2) | Preserve Change History and generate Source Provenance. | Reliable history through enforced controls and evidence.
| [Source L3](#source-l3) | Enforce organizational technical controls. | Consumer knowledge of guaranteed technical controls.
| [Source L4](#source-l4) | Require code review. | Improved code quality and resistance to insider threats.

<section id="source-l1">

## Source Track Level Specifics

### Level 1: Version controlled

<dl class="as-table">
<dt>Summary<dd>

The source is stored and managed through a modern version control system.

<dt>Intended for<dd>

Organizations currently storing source in non-standard ways who want to quickly gain some benefits of SLSA and better integrate with the SLSA ecosystem with minimal impact to their current workflows.

<dt>Benefits<dd>

Migrating to the appropriate tools is an important first step on the road to operational maturity.

</dl>
</section>
<section id="source-l2">

### Level 2: History & Provenance

<dl class="as-table">
<dt>Summary<dd>

Branch history is continuous, immutable, and retained, and the
SCS issues Source Provenance Attestations for each new Source Revision.
The attestations provide contemporaneous, tamper-resistant evidence of when
changes were made, who made them, and which technical controls were enforced.

<dt>Intended for<dd>

All organizations of any size producing software of any kind.

<dt>Benefits<dd>

Reliable history allows organizations and consumers to track changes to software
over time, enabling attribution of those changes to the actors that made them.
Source Provenance provides strong, tamper-resistant evidence of the process that
was followed to produce a Source Revision.

</dl>
</section>
<section id="source-l3">

### Level 3: Continuous technical controls

<dl class="as-table">
<dt>Summary<dd>

The SCS is configured to enforce the Organization's technical controls for specific Named References within the Source Repository.

<dt>Intended for<dd>

Organizations that want to show evidence of their additional technical controls.

<dt>Benefits<dd>

A verifier can use this published data to ensure that a given Source Revision
was created in the correct way by verifying the Source Provenance or VSA.
Provides verifiers strong evidence of all technical controls enforced during the update of a Named Reference.

</dl>
</section>
<section id="source-l4">

### Level 4: Two-party review

<dl class="as-table">
<dt>Summary<dd>

The SCS requires two trusted persons to review all changes to protected
branches.

<dt>Intended for<dd>

Organizations that want strong guarantees that the software they produce is not
subject to unilateral changes that would subvert their intent.

<dt>Benefits<dd>

Makes it harder for an actor to introduce malicious changes into the software
and makes it more likely that the source reflects the intent of the
organization.

</dl>
</section>
