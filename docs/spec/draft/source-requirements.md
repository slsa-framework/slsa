---
title: "Source: Requirements for producing source"
description: "This page covers the technical requirements for producing source revisions at each SLSA level." 
---

# {Source Track: Requirements for Producing Source}

**About this page:** the *Source Track: Requirements for Producing Source* page covers the detailed requirements for producing source revisions at each SLSA level.

**Intended audience:** source control system implementers and security engineers

**Topics covered:** source track terminology, track-level specifics and requirements, source track systems and attestations

**Internet standards:** [RFC 2119](https://www.rfc-editor.org/rfc/rfc2119)

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

## Source Track Requirements

Many examples in this document use the
[git version control system](https://git-scm.com/), but use of git is not a
requirement to meet any level on the SLSA source track.

### Organization Requirements

[Organization]: #organization

<table>
<tr><th>Requirement<th>Description<th>L1<th>L2<th>L3<th>L4

<tr id="choose-scs"><td>Choose an appropriate Source Control System <a href="#choose-scs">🔗</a><td>

An organization producing Source Revisions MUST select an SCS capable of reaching
their desired SLSA Source Level.

> For example, if an organization wishes to produce revisions at Source Level 3,
they MUST choose a Source Control System capable of producing Source Level 3
attestations.

<td>✓<td>✓<td>✓<td>✓

<tr id="access-and-history"><td>Configure the SCS to control access and enforce history <a href="#access-and-history">🔗</a><td>

The organization MUST configure access controls to restrict sensitive operations
on the Source Repository. These controls MUST be implemented using the
SCS-provided [Identity Management capability](#identity-management).

> For example, an organization may configure the SCS to assign users to a
`maintainers` role and only allow users in `maintainers` to make updates to
`main`.

The SCS MUST be configured to produce a reliable [Change History](#history) for
its consumable Source Revisions.
If the SCS provides this capability by design, no additional controls are needed.
Otherwise the organization MUST provide evidence of [continuous enforcement](#continuity).

If the SCS supports [Tags](#tag), the SCS MUST be configured to prevent them
from being moved or deleted.

> For example, if a git tag `release1` is used to indicate a release revision
with ID `abc123`, controls must be configured to prevent that tag from being
updated to any other revision in the future.
Evidence of these controls (and their continuity) will appear in the Source
Provenance documents for revision `abc123`.

<td><td>✓<td>✓<td>✓
<tr id="safe-expunging-process"><td>Safe Expunging Process <a href="#safe-expunging-process">🔗</a><td>

SCSs MAY allow the organization to expunge (remove) content from a repository
and its change history without leaving a public record of the removed content,
but the organization MUST only allow these changes in order to meet legal or
privacy compliance requirements. Content changed under this process includes
changing files, history, references, or any other metadata stored by the SCS.

#### Warning: Revision Removal

Removing a revision from a repository is similar to deleting a package version
from a registry: it's almost impossible to estimate the amount of downstream
supply chain impact.

> For example, in Git, each revision ID is based on the ones before it.
When you remove a revision, you must generate new revisions (and new revision IDs)
for any revisions that were built on top of it. Consumers who took a dependency
on the old revisions may now be unable to refer to the revision they've already
integrated into their products.

It may be the case that the specific set of changes targeted by a legal takedown
can be expunged in ways that do not impact consumed revisions, which can mitigate
these problems.

It is also the case that removing content from a repository won't necessarily
remove it everywhere.
The content may still exist in other copies of the repository, either in backups
or on developer machines.

#### Documentation Process Requirements

An organization MUST document the Safe Expunging Process and describe how
requests and actions are tracked and SHOULD log the fact that content was
removed. Different organizations and tech stacks may have different approaches
to the problem.

SCSs SHOULD have technical mechanisms in place which require an Administrator
plus at least one additional 'trusted person' to trigger any expunging
(removals) made under this process.

The application of the Safe Expunging Process and the resulting logs MAY be
private to prevent calling attention to potentially sensitive data or to comply
with local laws and regulations. Organizations SHOULD prefer to make logs public
if possible.

<td><td>✓<td>✓<td>✓
<tr id="technical-controls"><td>Continuous technical controls <a href="#technical-controls">🔗</a><td>

The organization MUST provide evidence of continuous enforcement via technical
controls for any claims made in the Source Provenance attestations or VSAs (see
[control continuity](#continuity)).

The organization MUST document the meaning of their enforced technical controls.

> For example, if an organization implements a technical control via a custom
tool (such as required GitHub Actions workflow), it must indicate the name of
this tool, what it accomplishes, and how to find its evidence in the provenance
attestation.

> For another example, if the organization claims that all consumable Source
Revisions on the `main` branch were tested prior to acceptance, this MUST be
explicitly enforced in the SCS.

<td><td><td>✓<td>✓

</table>

### Source Control System Requirements

<table>
<tr><th>Requirement<th>Description<th>L1<th>L2<th>L3<th>L4

<tr id="repository-ids"><td>Repositories are uniquely identifiable <a href="#repository-ids">🔗</a><td>

The repository ID is defined by the SCS and MUST be uniquely identifiable within
the context of the SCS with a stable locator, such as a URI.

<td>✓<td>✓<td>✓<td>✓
<tr id="revision-ids"><td>Revisions are immutable and uniquely identifiable <a href="#revision-ids">🔗</a><td>
The revision ID is defined by the SCS and MUST be uniquely identifiable within the context of the repository.
When the revision ID is a digest of the content of the revision (as in git) nothing more is needed.
When the revision ID is a number or otherwise not a digest, then the SCS MUST document how the immutability of the revision is established.
The same revision ID MAY be present in multiple repositories.

See also [Use cases for non-cryptographic, immutable, digests](https://github.com/in-toto/attestation/blob/main/spec/v1/digest_set.md#use-cases-for-non-cryptographic-immutable-digests).

<td>✓<td>✓<td>✓<td>✓
<tr id="human-readable-diff"><td>Human readable changes <a href="#human-readable-diff">🔗</a><td>

The SCS MUST provide tooling to display Changes between one Source Revision and
another in a human readable form (e.g. 'diffs') for all plain-text changes and
SHOULD provide mechanisms to provide human understandable interpretations of
non-plain-text changes (e.g. render images, verify and display provenance for
binaries, etc.).

<td>✓<td>✓<td>✓<td>✓
<tr id="source-summary"><td>Source Verification Summary Attestations <a href="#source-summary">🔗</a><td>

The SCS MUST generate a
[source verification summary attestation](#source-verification-summary-attestation) (Source VSA)
to indicate the SLSA Source Level of any revision at Level 1 or above.

If a consumer is authorized to access a revision, they MUST be able to fetch the
corresponding Source VSA.

If the SCS DOES NOT generate a VSA for a revision, the revision has Source Level
0.

At Source Levels 1 and 2 the SCS MAY issue these attestations based on its
understanding of the underlying system (e.g. based on design docs, security
reviews, etc.), but at Level 2+ the SCS MUST use the SCS-issued
[source provenance](#source-provenance) when issuing the VSAs.

<td>✓<td>✓<td>✓<td>✓

<tr id="history"><td>History <a href="#history">🔗</a><td>

There are three key aspects to change history:

1.  What were all the previous states of a Branch?
2.  How and when did they change?
3.  How does the current revision relate to previous revisions?

To answer these questions, the SCS MUST record all changes to Named References,
including when they occurred, who made them, and the new Source Revision ID.

If Source Revisions have ancestry relationships in the VCS, the SCS MUST ensure
that a Branch can only be updated to point to revisions that descend from the
current revision.
In git, this requires a technical control to prohibit `git push --force`.

This requirement captures evidence that the organization intended to make the
changes captured by the new revision.

> For example, if a branch currently points to revision `a`, it may only be
moved to a new revision `b` if `a` is an ancestor of `b`.

<td><td>✓<td>✓<td>✓
<tr id="continuity"><td>Continuity <a href="#continuity">🔗</a><td>

Technical Controls are only effective if they are used continuously in the
history of a Branch.
'Control continuity' reflects an organization's ongoing commitment to a
technical control.

For each technical control claimed in a VSA, continuity MUST be established and
tracked from a specific start revision.
If there is a lapse in continuity for a specific control, continuity of that
control MUST be re-established from a new revision.

Exceptions to the continuity requirement are allowed via the [safe expunging process](#safe-expunging-process).

> For example, the `main` branch currently points to revision `a` when a new
technical control `t` is configured.
The next revision on the `main` branch, `b` will be the first revision that was
protected by `t` and `b` is the first revision in the "continuity" of `t`.
Any revisions added to `main` while `t` is disabled will reset the continuity of `t`.

<td><td>✓<td>✓<td>✓

<tr id="identity-management"><td>Identity Management <a href="#identity-management">🔗</a><td>

The SCS MUST provide an identity management system or some other means of
identifying and authenticating actors.

The SCS MUST allow organizations to specify which actors and roles are allowed
to perform sensitive actions within a repository (e.g. creation or updates of
branches, approval of changes).

Depending on the SCS, identity management may be provided by source control
services (e.g., GitHub, GitLab), implemented using cryptographic signatures
(e.g., using gittuf to manage public keys for actors), or extending existing
authentication systems used by the organization (e.g., Active Directory, Okta,
etc.).

The SCS MUST document how actors are identified for the purposes of attribution.

Activities conducted on the SCS SHOULD be attributed to authenticated
identities.

<td><td>✓<td>✓<td>✓

<tr id="source-provenance"><td>Source Provenance <a href="#source-provenance">🔗</a><td>

[Source Provenance](#source-provenance-attestations) are attestations that
contain information about how a specific revision was created and how it came to
exist on a protected branch or how a tag came to point at it. They are
associated with the revision identifier delivered to consumers and are a
statement of fact from the perspective of the SCS. The SCS MUST document the
format and intent of all Source Provenance attestations it produces.

Source Provenance MUST be created contemporaneously with the branch being
updated such that they provide a credible, auditable, record of changes.

If a consumer is authorized to access a revision, they MUST be able to access the
corresponding Source Provenance documents for that revision.

It is possible that an SCS can make no claims about a particular revision.

> For example, this would happen if the revision was created on another SCS,
on an unprotected branch (such as a `topic` branch), or if the revision was not
the result of the expected process.

<td><td>✓<td>✓<td>✓
<tr id="protected-refs"><td>Protected Named References <a href="#protected-refs">🔗</a><td>

The SCS MUST provide the ability for an organization to enforce customized technical controls for Named References.

The SCS MUST provide a mechanism for organizations to indicate which Named
References should be protected by technical controls.

> For example, the organization may instruct the SCS to protect `main` and
`refs/heads/releases/*`, but not `refs/heads/experimental/*` using branch
protection rules (e.g. [GitHub](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets),
[GitLab](https://docs.gitlab.com/ee/user/project/repository/branches/protected.html))
or via the application and verification of [gittuf](https://github.com/gittuf/gittuf)
policies.

> For another example, the organization may instruct the SCS to prevent the deletion of
all `refs/tags/releases/*` using tag protection rules
(e.g. [GitHub](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets),
[GitLab](https://docs.gitlab.com/user/project/protected_tags/))
or via the application and verification of [gittuf](https://github.com/gittuf/gittuf)
policies.

The SCS MUST

-   Record technical controls enforced on Named References in contemporaneously
   produced attestations associated with the corresponding Source Revisions.
-   Allow organizations to provide
   [organization-specified properties](#additional-properties) to be included in the
   [Source VSA](#source-verification-summary-attestation) when the corresponding controls are
   enforced.
-   Allow organizations to distribute additional attestations related to their
   technical controls to consumers authorized to access the corresponding Source
   Revision.
-   Prevent organization-specified properties from beginning with any value
   other than `ORG_SOURCE_`.

<td><td><td>✓<td>✓
<tr id="two-party-review"><td>Two-party review <a href="#two-party-review">🔗</a><td>

Changes in protected branches MUST be agreed to by two or more trusted persons prior to submission.
The following combinations are acceptable:

-   Uploader and reviewer are two different trusted persons.
-   Two different reviewers are trusted persons.

Reviews SHOULD cover, at least, security relevant properties of the code.

**[Final revision approved]** This requirement applies to the final revision
submitted. I.e., if additional changes are made during the review process, those changes MUST
be reviewed as well.

**[Context-specific approvals]** Approvals are for a specific context, such as a
repo + branch in git. Moving fully reviewed content from one context to another
still requires review. The exact definition of “context” depends on the project,
and this does not preclude well-understood automatic merges, such as cutting a release branch.

**[Informed Review]** The SCS MUST present reviewers with a clear representation of the result of accepting the proposed change. See [Human Readable Changes](#human-readable-diff).

**[Trusted Robot Contributions]** An organization MAY choose to grant a Trusted
Robot a perpetual exception to a policy (e.g. a bot may be able to merge a change
that has not been reviewed by two parties).

Examples:

-   Import and migration bots that move code from one repo to another.
-   Dependabot

<td><td><td><td>✓
</table>

## Source Track Attestations

SLSA source level details are communicated using attestations.
These attestations either refer to a source revision itself or provide context needed to evaluate an attestation that _does_ refer to a revision.

There are two broad categories of source attestations within the source track:

1.  Source verification summary attestations (Source VSAs): Used to communicate to downstream users what high level security properties a given source revision meets.
2.  Source provenance attestations: Provide trustworthy, tamper-proof, metadata with the necessary information to determine what high level security properties a given source revision has.

To provide interoperability and ensure ease of use, it's essential that the Source VSAs are applicable across all Source Control Systems.
However, due to the significant differences in how SCSs operate and how they may choose to meet the Source Track requirements, it is preferable to
allow for flexibility with the full source provenance attestations. To that end, SLSA leaves source provenance attestations undefined and up to the SCSs to determine
what works best in their environment.

### Source verification summary attestation

Source verification summary attestations (Source VSAs) are issued by some authority that has sufficient evidence to make the determination of a given
revision's source level.  Source VSAs convey properties about the revision as a whole and summarize properties computed over all
the changes that contributed to that revision over its history.

The source track issues Source VSAs using the [Verification Summary Attestations](./verification_summary.md) format as follows:

1.  `subject.uri` SHOULD be set to a URI where a human can find details about
    the revision. This field is not intended for policy decisions. Instead, it
    is only intended to direct a human investigating verification failures.
    -   For example: `https://github.com/slsa-framework/slsa/commit/6ff3cd75c8c9e0fcedc62bd6a79cf006f185cedb`
2.  `subject.digest` MUST include the revision identifier (e.g. `gitCommit`) and MAY include other digests over the contents of the revision (e.g. `gitTree`, `dirHash`, etc.).
SCSs that do not use cryptographic digests MUST define a canonical type that is used to identify immutable revisions and MUST include the repository within the type[^1].
    -   For example: `svn_revision_id: svn+https://svn.myproject.org/svn/MyProject/trunk@2019`
3.  `subject.annotations.sourceRefs` SHOULD be set to a list of references that pointed to this revision when the attestation was created. The list MAY be non-exhaustive.
    -   git references MUST be fully qualified (e.g. `refs/heads/main` or `refs/tags/v1.0`) to reduce the likelihood of confusing downstream tooling.
4.  `resourceUri` MUST be set to the URI of the repository, preferably using [SPDX Download Location](https://spdx.github.io/spdx-spec/v2.3/package-information/#77-package-download-location-field).
E.g. `git+https://github.com/foo/hello-world`.
5.  `verifiedLevels` MUST include the SLSA source track level the SCS asserts the revision meets. One of `SLSA_SOURCE_LEVEL_0`, `SLSA_SOURCE_LEVEL_1`, `SLSA_SOURCE_LEVEL_2`, `SLSA_SOURCE_LEVEL_3`.
MAY include additional properties as asserted by the SCS.  The SCS MUST include _only_ the highest SLSA source level met by the revision.
6.  `dependencyLevels` MAY be empty as source revisions are typically terminal nodes in a supply chain. For example, this could be used to indicate the source level of any git submodules present in the revision.

#### Additional properties

The SLSA source track MAY create additional properties to include in
`verifiedLevels` which attest to other claims concerning a revision.

The SCS MAY embed additional properties within `verifiedLevels` provided by the
organization as long as they are prefixed by `ORG_SOURCE_`  to distinguish them
from other properties the SCS may wish to use. The SCS MUST enforce the use of
this prefix for such properties. An organization MAY further differentiate
properties using:

-   `ORG_SOURCE_` to indicate a property that is meant for consumption by
   external consumers.
-   `ORG_SOURCE_INTERNAL_` to indicate a property that is not meant for
   consumption by external consumers.

The meaning of the properties is left entirely to the organization.

#### Populating sourceRefs

The Source VSA issuer may choose to populate `sourceRefs` in any way they wish.
Downstream users are expected to be familiar with the method used by the issuer.

Example implementations:

-   Issue a new VSA for each merged Pull Request and add the destination branch to `sourceRefs`.
-   Issue a new VSA each time a Named Reference is updated to point to a new revision.

#### Example

```json
"_type": "https://in-toto.io/Statement/v1",
"subject": [{
  "uri": "https://github.com/foo/hello-world/commit/9a04d1ee393b5be2773b1ce204f61fe0fd02366a",
  "digest": {"gitCommit": "9a04d1ee393b5be2773b1ce204f61fe0fd02366a"},
  "annotations": {"sourceRefs": ["refs/heads/main", "refs/heads/release_1.0"]}
}],

"predicateType": "https://slsa.dev/verification_summary/v1",
"predicate": {
  "verifier": {
    "id": "https://example.com/source_verifier",
  },
  "timeVerified": "1985-04-12T23:20:50.52Z",
  "resourceUri": "git+https://github.com/foo/hello-world",
  "policy": {
    "uri": "https://example.com/slsa_source.policy",
  },
  "verificationResult": "PASSED",
  "verifiedLevels": ["SLSA_SOURCE_LEVEL_3"],
}
```

#### How to verify

See [Verifying Source](./verifying-source.md) for instructions how to verify
VSAs for Source Revisions.

### Source provenance attestations

Source provenance attestations provide tamper-proof evidence ([attestation model](attestation-model))
that can be used to determine what SLSA Source Level or other high-level properties a given revision meets.
This evidence can be used by:

-   an authority as the basis for issuing a [Source VSA](#source-verification-summary-attestation)
-   a consumer to cross-check a [Source VSA](#source-verification-summary-attestation) they received for a revision
-   a consumer to enforce a more detailed policy than the organization's own process

SCSs may have different methods of operating that necessitate different forms of evidence.
E.g. GitHub-based workflows may need different evidence than Gerrit-based workflows, which would both likely be different from workflows that
operate over Subversion repositories.

These differences also mean that, depending on the configuration, the issuers of provenance attestations may vary from implementation to implementation, often because entities with the knowledge to issue them may vary.
The authority that issues [Source VSAs](#source-verification-summary-attestation) MUST understand which entity should issue each provenance attestation type, and ensure all source provenance attestations come from their expected issuers.

'Source provenance attestations' is a generic term used to refer to any type of attestation that provides evidence of the process used to create a revision.

Example source provenance attestations:

-   A TBD attestation which describes the revision's parents and the actors involved in creating this revision.
-   A "code review" attestation which describes the basics of any code review that took place.
-   An "authentication" attestation which describes how the actors involved in any revision were authenticated.
-   A [Vuln Scan attestation](https://github.com/in-toto/attestation/blob/main/spec/predicates/vuln.md)
    which describes the results of a vulnerability scan over the contents of the revision.
-   A [Test Results attestation](https://github.com/in-toto/attestation/blob/main/spec/predicates/test-result.md)
 which describes the results of any tests run on the revision.
-   An [SPDX attestation](https://github.com/in-toto/attestation/blob/main/spec/predicates/spdx.md)
 which provides a software bill of materials for the revision.
-   A [SCAI attestation](https://github.com/in-toto/attestation/blob/main/spec/predicates/scai.md) used to
 describe which source quality tools were run on the revision.

Irrespective of the types of provenance attestations generated by an SCS and
their implementations, the SCS MUST document provenance
formats, and how each provenance attestation can be used to reason about the
revision's properties recorded in the summary attestation.

[^1]: in-toto attestations allow non-cryptographic digest types: https://github.com/in-toto/attestation/blob/main/spec/v1/digest_set.md#supported-algorithms.

## Disclaimer

When onboarding a branch to the SLSA Source Track or increasing the level of
that branch, organizations are making claims about how the branch is managed
from that revision forward. This establishes [continuity](#continuity).

No claims are made for prior revisions.

## Future Considerations

### Authentication

-   Better protection against phishing by forbidding second factors that are not
  phishing resistant.
-   Protect against authentication token theft by forbidding bearer tokens
  (e.g. PATs).
-   Including length of continuity in the VSAs
