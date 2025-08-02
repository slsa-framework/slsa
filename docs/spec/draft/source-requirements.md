---
title: "Source: Requirements for producing source"
description: "This page covers the detailed technical requirements for producing producing source revisions at each SLSA level. The intended audience is source control system implementers and security engineers."
---

## Objective

The primary purpose of the SLSA Source track is to provide producers and consumers with increasing levels of trust in the source code they produce and consume.
It describes increasing levels of trustworthiness and completeness of how a source revision was created.

The expected process for creating a new revision is determined solely by that repository's owner (the organization) who also determines the intent of the software in the repository and administers technical controls to enforce the process.

Consumers can review attestations to verify whether a particular revision meets their standards.

## Definitions

| Term | Description
| --- | ---
| Source | An identifiable set of text and binary files and associated metadata. Source is regularly used as input to a build system (see [SLSA Build Track](build-requirements.md)).
| Organization | A set of people who collectively create the Source. Examples of organizations include open-source projects, a company, or a team within a company. The organization defines the goals and methods of the source.
| Version Control System (VCS)| Software for tracking and managing changes to source. Git and Subversion are examples of version control systems.
| Revision | A specific state of the source with an identifier provided by the version control system. As an example, you can identify a git revision by its commit object ID.
| Source Control System (SCS) | A suite of tools and services (self-hosted or SaaS) relied upon by the organization to produce new revisions of the source. The role of the SCS may be fulfilled by a single service (e.g., GitHub / GitLab) or a combination of services (e.g., GitLab with Gerrit code reviews, GitHub with OpenSSF Scorecard, etc).
| Source Provenance | Information about how a revision came to exist, where it was hosted, when it was generated, what process was used, who the contributors were, and which parent revisions preceded it.
| Repository / Repo | A uniquely identifiable instance of a VCS. The repository controls access to the Source in the VCS. The objective of a repository is to reflect the intent of the organization that controls it.
| Branch | A named, moveable, pointer to a revision that tracks development in the named context over time. Branches may be modified to point to different revisions by authorized actors. Different branches may have different security requirements.
| Tag | A named pointer to a revision that does not typically move. Similar to branches, tags may be modified by authorized actors. Tags are often used by producers to indicate a more permanent name for a revision.
| Change | A set of modifications to the source in a specific context. A change can be proposed and reviewed before being accepted.
| Change History | A record of the history of revisions that preceded a specific revision.
| Push / upload / publish | When an actor adds or modifies the Source, Branches or Tags in the repository.
| Review / approve / vote | When an actor uses a change management tool to comment upon, endorse, or reject a source change proposal.

### Source Roles

| Role | Description
| --- | ---
| Administrator | A human who can perform privileged operations on one or more projects. Privileged actions include, but are not limited to, modifying the change history and modifying project- or organization-wide security policies.
| Trusted person | A human who is authorized by the organization to propose and approve changes to the source.
| Trusted robot | Automation authorized by the organization to act in explicitly defined contexts. The Robot’s identity and codebase cannot be unilaterally influenced.
| Untrusted person | A human who has limited access to the project. They MAY be able to read the source. They MAY be able to propose or review changes to the source. They MAY NOT approve changes to the source or perform any privileged actions on the project.
| Proposer | An actor that proposes (or uploads) a particular change to the source.
| Reviewer / Voter / Approver | An actor that reviews (or votes on) a particular change to the source.
| Merger | An actor that applies a change to the source. This actor may be the proposer.

## Onboarding

When onboarding a branch to the SLSA Source Track or increasing the level of
that branch, organizations are making claims about how the branch is managed
from that revision forward. This establishes [continuity](#continuity).

No claims are made for prior revisions.

## Basics

NOTE: This table presents a simplified view of the requirements. See the
[Requirements](#requirements) section for the full list of requirements for each
level.

| Track/Level | Requirements | Focus
| ----------- | ------------ | -----
| [Source L1](#source-l1)  | Use a version control system | First steps towards operational maturity
| [Source L2](#source-l2)  | History and controls for protected branches & tags | Preserve history and ensure the process has been followed
| [Source L3](#source-l3)  | Signed provenance | Tampering by the source control system
| [Source L4](#source-l4)  | Code review | Tampering by project contributors

<section id="source-l1">

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

### Level 2: Controls

<dl class="as-table">
<dt>Summary<dd>

Clarifies which branches and tags in a repo are consumable and guarantees that
all changes to protected branches and tags are recorded and subject to the
organization's technical controls.

<dt>Intended for<dd>

All organizations of any size producing software of any kind.

<dt>Benefits<dd>

Allows organizations and source consumers the ability to ensure the change
management process has been followed to track changes to the software over time
and attribute those changes to the actors that made them.

</dl>
</section>
<section id="source-l3">

### Level 3: Signed and Auditable Provenance

<dl class="as-table">
<dt>Summary<dd>

The SCS generates credible, tamper-resistant, and contemporaneous evidence of how a specific revision was created.
It is provided to authorized users of the source repository in a documented format.

<dt>Intended for<dd>

Organizations that want strong guarantees and auditability of their change management processes.

<dt>Benefits<dd>

Provides information to policy enforcement tools to reduce the risk of tampering
within the SCS's storage systems.

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

## Requirements

Many examples in this document use the [git version control system](https://git-scm.com/), but use of git is not a requirement to meet any level on the SLSA source track.

### Organization

[Organization]: #organization

<table>
<tr><th>Requirement<th>Description<th>L1<th>L2<th>L3<th>L4

<tr id="choose-scs"><td>Choose an appropriate source control system <a href="#choose-scs">🔗</a><td>

An organization producing source revisions MUST select a SCS capable of reaching
their desired SLSA Source Level.

> For example, if an organization wishes to produce revisions at Source Level 3,
they MUST choose a source control system capable of producing Source Level 3
attestations.

<td>✓<td>✓<td>✓<td>✓

<tr id="protect-consumable-branches-and-tags"><td>Protect consumable branches and tags <a href="#protect-consumable-branches-and-tags">🔗</a><td>

An organization producing source revisions MUST implement a change management
process to ensure changes to source matches the organization's intent.

The organization MUST specify which branches and tags are covered by the process
and are intended for use in its own applications or services or those of
downstream consumers of the software.

> For example, if an organization has branches 'main' and 'experimental' and it
intends for 'main' to be protected then it MUST indicate to the SCS that 'main'
should be protected. From that point forward revisions on 'main' will be
eligible for Source Level 2+ while revisions made solely on 'experimental' will
not.

The organization MUST use the SCS provided
[Identity Management capability](#identity-management) to configure the actors
and roles that are allowed to perform sensitive actions on protected branches
and tags.

> For example, an organization may configure the SCS to assign users to a `maintainers` role and only allow users in `maintainers` to make updates to `main`.

The organization MUST specify what technical controls consumers can expect to be
enforced for revisions in each protected branch and tag using the
[Enforced change management process](#enforced-change-management-process)
and it MUST document the meaning of those controls.

> For example, an organization may claim that revisions on `main` passed unit
tests before being accepted.  The organization could then configure the SCS to
enforce this requirement and store corresponding [test result attestations] for
all affected revisions.  They may then embed the `ORG_SOURCE_UNIT_TESTED`
property in the [Source VSA](#source-verification-summary-attestation). Consumers
would then expect that future revisions on `main` have been united tested and
determine if that expectation has been met by looking for the
`ORG_SOURCE_UNIT_TESTED` property in the VSAs and, if desired, consult the
[test result attestations] as well.

[test result attestations]: https://github.com/in-toto/attestation/blob/main/spec/predicates/test-result.md

<td><td>✓<td>✓<td>✓

<tr id="safe-expunging-process"><td>Safe Expunging Process <a href="#safe-expunging-process">🔗</a><td>

SCSs MAY allow the organization to expunge (remove) content from a repository and its change history without leaving a public record of the removed content,
but the organization MUST only allow these changes in order to meet legal or privacy compliance requirements.
Content changed under this process includes changing files, history, references, or any other metadata stored by the SCS.

#### Warning

Removing a revision from a repository is similar to deleting a package version from a registry: it's almost impossible to estimate the amount of downstream supply chain impact.
> For example, in VCSs like Git, each revision ID is based on the ones before it. When you remove a revision, you must generate new revisions (and new revision IDs) for any revisions that were built on top of it. Consumers who took a dependency on the old revisions may now be unable to refer to the source they've already integrated into their products.

It may be the case that the specific set of changes targeted by a legal takedown can be expunged in ways that do not impact consumed revisions, which can mitigate these problems.

It is also the case that removing content from a repository won't necessarily remove it everywhere.
The content may still exist in other copies of the repository, either in backups or on developer machines.

#### Process

An organization MUST document the Safe Expunging Process and describe how requests and actions are tracked and SHOULD log the fact that content was removed.
Different organizations and tech stacks may have different approaches to the problem.

SCSs SHOULD have technical mechanisms in place which require an Administrator plus, at least, one additional 'trusted person' to trigger any expunging (removals) made under this process.

The application of the safe expunging process and the resulting logs MAY be private to both prevent calling attention to potentially sensitive data (e.g. PII) or to comply with local laws
and regulations which may require the change to be kept private to the extent possible.
Organizations SHOULD prefer to make logs public if possible.

<td><td>✓<td>✓<td>✓

</table>

### Source Control System

<table>
<tr><th>Requirement<th>Description<th>L1<th>L2<th>L3<th>L4

<tr id="repository-ids"><td>Repositories are uniquely identifiable <a href="#repository-ids">🔗</a><td>

The repository ID is defined by the SCS and MUST be uniquely identifiable within the context of the SCS.

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
binaries, etc...).

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
reviews, etc...), but at Level 3+ the SCS MUST use
the SCS issued [source provenance](#source-provenance) when making the issuing
the VSAs.

<td>✓<td>✓<td>✓<td>✓
<tr id="branches"><td>Protected Branches <a href="#branches">🔗</a><td>

The SCS MUST provide a mechanism for organizations to indicate which branches
should be protected by SLSA Source Level 2+ requirements.

E.g. The organization may configure the SCS to protect `main` and
`refs/heads/releases/*`, but not `refs/heads/playground/*`.

<td><td>✓<td>✓<td>✓
<tr id="history"><td>History <a href="#history">🔗</a><td>

Revisions are created by applying specific code changes (a "diff" in git) on
top of earlier revisions of a branch. This sequence of changes, the revisions
they produced, and how they were introduced into a branch constitute the history
of that branch.

The SCS MUST record the sequence of changes, the revisions they created,
the actors that introduced them and the context they were introduced into.

The SCS MUST prevent tampering with these records on protected branches.

> For example, in systems like GitHub or GitLab, this can be accomplished by
enabling branch protection rules that prevent force pushes and branch deletions.

<td><td>✓<td>✓<td>✓
<tr id="enforced-change-management-process"><td>Enforced change management process <a href="#enforced-change-management-process">🔗</a><td>

The SCS MUST

-   Ensure organization-defined technical controls are enforced for changes made
   to protected branches.
-   Allow organizations to specify
   [additional properties](#additional-properties) to be included in the
   [Source VSA](#source-verification-summary-attestation) when the corresponding controls are
   enforced.
-   Allow organizations to distribute additional attestations related to their
   technical controls to consumers authorized to access the corresponding source
   revision.
-   Prevent organization-specified properties from beginning with any value
   other than `ORG_SOURCE_` unless the SCS endorses the veracity of the
   corresponding claims.

> For example: enforcement of the organization-defined technical controls could
be accomplished by the configuration of branch protection rules (e.g.
[GitHub](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets),
[GitLab](https://docs.gitlab.com/ee/user/project/repository/branches/protected.html))
which require additional checks to 'pass' (e.g. unit tests, linters) or the
application and verification of [gittuf](https://github.com/gittuf/gittuf)
policies.

<td><td>✓<td>✓<td>✓
<tr id="continuity"><td>Continuity <a href="#continuity">🔗</a><td>

In a source control system, each new revision is built on top of prior
revisions. Controls (e.g. [history](#history) or
[enforced change management process](#enforced-change-management-process)) are
only effective if they are used continuously from one revision to another. If
a control is disabled for the introduction of a new revision and then re-enabled
it is difficult to reason about the effectiveness of the control. 'Continuity' is
the concept of ensuring controls are enforced continuously from the time they
were introduced, leading to a higher degree of trust in the revisions produced
after their introduction.

On [protected branches](#branches) continuity for [history](#history) and
[enforced change management process](#enforced-change-management-process)
controls MUST be established and tracked from a specific revision forward
through each new revision created. If there is a lapse in continuity for a
specific control, continuity of that control MUST be re-established from a new
revision.

Continuity exceptions are allowed via the [safe expunging process](#safe-expunging-process).

<td><td>✓<td>✓<td>✓
<tr id="protected-tags"><td>Protected Tags <a href="#protected-tags">🔗</a><td>

If the SCS supports tags (or other non-branch revision trackers), additional
care must be taken to prevent unintentional changes.
Unlike branches, tags have no built-in continuity enforcement mechanisms or
change management processes.

The SCS MUST provide a mechanism for organizations to indicate which tags should
be protected by SLSA Source Level 2+ requirements.

The SCS MUST prevent protected tags from being moved or deleted.

<td><td>✓<td>✓<td>✓
<tr id="identity-management"><td>Identity Management <a href="#identity-management">🔗</a><td>

The SCS MUST provide an identity management system or some other means of
identifying and authenticating actors.

The SCS MUST allow organizations to specify which actors and roles are allowed
to perform sensitive actions within a repository (e.g. creation or updates of
branches, approval of changes).

Depending on the SCS, identity management may be provided by source control
services (e.g., GitHub, GitLab), implemented using cryptographic signatures
(e.g., using gittuf to manage public keys for actors), or extend existing
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

At Source Level 3, Source Provenance MUST be created contemporaneously with the
branch being updated to use that revision such that they provide a credible,
auditable, record of changes.

If a consumer is authorized to access a revision, they MUST be able to fetch the
corresponding source provenance documents for that revision.

It is possible that an SCS can make no claims about a particular revision.

> For example, this would happen if the revision was created on another SCS,
or if the revision was not the result of an accepted change management process.

<td><td><td>✓<td>✓
<tr id="two-party-review"><td>Two party review <a href="#two-party-review">🔗</a><td>

Changes in protected branches MUST be agreed to by two or more trusted persons prior to submission.
The following combinations are acceptable:

-   Uploader and reviewer are two different trusted persons.
-   Two different reviewers are trusted persons.

Reviews SHOULD cover, at least, security relevant properties of the code.

**[Final revision approved]** This requirement applies to the final revision
submitted. I.e. if additional changes are made during the review process, those changes MUST
be reviewed as well.

**[Context-specific approvals]** Approvals are for a specific context, such as a
repo + branch in git. Moving fully reviewed content from one context to another
still requires review. The exact definition of “context” depends on the project,
and this does not preclude well-understood automatic merges, such as cutting a release branch.

**[Informed Review]** The SCS MUST present reviewers with difference between
the old and new revisions. E.g. by using [the diff tool](#human-readable-diff).

**[Trusted Robot Contributions]** An organization MAY choose to grant a Trusted
Robot a perpetual exception to a policy (e.g. a bot may be able to merge a change
that has not been reviewed by two parties).

Examples:

-   Import and migration bots that move code from one repo to another.
-   Dependabot

<td><td><td><td>✓
</table>

## Communicating source levels

SLSA source level details are communicated using attestations.
These attestations either refer to a source revision itself or provide context needed to evaluate an attestation that _does_ refer to a revision.

There are two broad categories of source attestations within the source track:

1.  Source verification summary attestations (Source VSAs): Used to communicate to downstream users what high level security properties a given source revision meets.
2.  Source provenance attestations: Provide trustworthy, tamper-proof, metadata with the necessary information to determine what high level security properties a given source revision has.

To provide interoperability and ensure ease of use, it's essential that the Source VSAs are applicable across all Source Control Systems.
However, due to the significant differences in how SCSs operate and how they may chose to meet the Source Track requirements, it is preferable to
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
2.  `subject.digest` MUST include the revision identifier (e.g. `gitCommit`) and MAY include other digests over the contents of the revision (e.g. `gitTree`, `dirHash`, etc...).
SCSs that do not use cryptographic digests MUST define a canonical type that is used to identify immutable revisions and MUST include the repository within the type[^1].
    -   For example: `svn_revision_id: svn+https://svn.myproject.org/svn/MyProject/trunk@2019`
3.  `subject.annotations.sourceRefs` SHOULD be set to a list of references that pointed to this revision when the attestation was created. The list MAY be non-exhaustive.
    -   git references MUST be fully qualified (e.g. `refs/head/main` or `refs/tags/v1.0`) to reduce the likelihood of confusing downstream tooling.
4.  `resourceUri` MUST be set to the URI of the repository, preferably using [SPDX Download Location](https://spdx.github.io/spdx-spec/v2.3/package-information/#77-package-download-location-field).
E.g. `git+https://github.com/foo/hello-world`.
5.  `verifiedLevels` MUST include the SLSA source track level the SCS asserts the revision meets. One of `SLSA_SOURCE_LEVEL_0`, `SLSA_SOURCE_LEVEL_1`, `SLSA_SOURCE_LEVEL_2`, `SLSA_SOURCE_LEVEL_3`.
MAY include additional properties as asserted by the SCS.  The SCS MUST include _only_ the highest SLSA source level met by the revision.
6.  `dependencyLevels` MAY be empty as source revisions are typically terminal nodes in a supply chain. For example, this could be used to indicate the source level of any git submodules present in the revision.

#### Additional properties

The SLSA source track MAY create additional properties to include in
`verifiedLevels` which attest to other claims concerning a revision (e.g. if it
was code reviewed).

The SCS MAY embed organization-provided properties within `verifiedLevels`
corresponding to technical controls enforced by the SCS. If such properties are
provided they MUST be prefixed with `ORG_SOURCE_` to distinguish them from other
properties the SCS may wish use.

-   `ORG_SOURCE_` to indicate a property that is meant for consumption by
   external consumers.
-   `ORG_SOURCE_INTERNAL_` to indicate a property that is not meant for
   consumption by external consumers.

The meaning of the properties is left entirely to the organization. Inclusion of
organization-provided properties within `verifiedLevels` SHOULD NOT be
considered an endorsement of the veracity of the organization defined property
by the SCS.

#### Populating sourceRefs

The Source VSA issuer may choose to populate `sourceRefs` in any way they wish.
Downstream users are expected to be familiar with the method used by the issuer.

Example implementations:

-   Issue a new VSA for each merged Pull Request and add the destination branch to `sourceRefs`.
-   Issue a new VSA each time a 'consumable branch' is updated to point to a new revision.
-   Issue a new VSA each time a 'consumable tag' is created to point to a new revision.

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

-   VSAs for source revisions MUST follow [the standard method of VSA verification](./verification_summary.md#how-to-verify).
-   Users SHOULD check that an allowed branch is listed in `subject.annotations.sourceRefs` to ensure the revision is from an appropriate context within the repository.
-   Users SHOULD check that the expected `SLSA_SOURCE_LEVEL_` is listed within `verifiedLevels`.
-   Users MUST ignore any unrecognized values in `verifiedLevels`.

### Source provenance attestations

Source provenance attestations provide tamper-proof evidence ([attestation model](attestation-model)))
that can be used to determine what SLSA Source Level or other high level properties a given revision meets.
This evidence can be used by:

-   an authority as the basis for issuing a [Source VSA](#source-verification-summary-attestation)
-   a consumer to cross-check a [Source VSA](#source-verification-summary-attestation) they received for a revision
-   a consumer to enforce a more detailed policy than the organization's change management process

SCSs may have different methods of operating that necessitate different forms of evidence.
E.g. GitHub-based workflows may need different evidence than Gerrit-based workflows, which would both likely be different from workflows that
operate over Subversion repositories.

These differences also mean that, depending on the configuration, the issuers of provenance attestations may vary from implementation to implementation, often because entities with the knowledge to issue them may vary.
The authority that issues [Source VSAs](#source-verification-summary-attestation) MUST understand which entity should issue each provenance attestation type, and ensure all source provenance attestations come from their expected issuers.

'Source provenance attestations' is a generic term used to refer to any type of attestation that provides evidence the process used to create a revision.

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

## Potential Change Management Controls

In addition to the requirements for SLSA Source L4, most organizations will
require multiple of these controls as part of their required protections.

If an organization has indicated that use of these these controls are part of
their repository's expectations, consumers SHOULD be able to verify that the
process was followed for the revision they are consuming by examining the
[summary](#source-verification-summary-attestation) or [source
provenance](#source-provenance-attestations) attestations.

> For example: consumers can look for the related `ORG_SOURCE` properties in the
`verifiedLevels` field of the [summary attestation](#source-verification-summary-attestation).

### Expert Code Review

Summary: All changes to the source are pre-approved by experts in those areas.

Intended for: Enterprise repositories and mature open source projects.

Benefits: Prevents mistakes made by developers who are unfamiliar with the area.

Requirements:

#### Code ownership

Each part of the source MUST have a clearly identified set of experts.

#### Approvals from all relevant experts

For each portion of the source modified by a change proposal, pre-approval MUST be granted by a member of the defined expert set.
An approval from an actor that is a member of multiple expert groups may satisfy the requirement for all groups in which they are a member.

### Review Every Single Revision

Summary: The final revision was reviewed by all relevant experts prior to submission.

Intended for: The highest-of-high-security-posture repos.

Benefits: Provides the maximum chance for experts to spot and reject problems before they ship.

Requirements:

#### Reset votes on all changes

If the proposal is modified after receiving expert approval, all previously granted approvals MUST be revoked.
A new approval MUST be granted from ALL required reviewers.

The new approval MAY be granted by an actor who approved a previous iteration.

### Automated testing

Summary:
The final revision was validated against a suite of automated tests.

Intended for:
All organizations and repositories.

Benefits:
Automatic testing has many benefits, including improved accuracy, error prevention and reduced workload on human developers.

Requirements:
The organization MUST configure a branch protection rule to require that only revisions with passing test results can be pointed-to by the branch.

Automatic tests SHOULD be executed in a trustworthy environment (see SLSA build track).

Results of each test (or an aggregate) MUST be collected by the change review tool and made available for verification.

Tests SHOULD be run against a revision created for testing by merging the topic branch (containing the proposed changes) into the target branch.

Use of the proposed merge commit should be preferred to using the tip of the topic branch.

### Every revision reachable from a branch was approved

Summary:
New revisions are created based ONLY on the changes that were approved.

Benefits:
Prevents a large class of internal threat attacks based on hiding a malicious commit in a series of good commits such that the malicious commit does not appear in the reviewed diff.

Requirements:

#### Context

In many organizations it is normal to review only the "net difference" between the tip of  the topic branch and the "best merge base", the closest shared commit between the topic and target branches computed at the time of review.

The topic branch may contain many commits of which not all were intended to represent a shippable state of the repository.

If a repository merges branches with a standard merge commit, all those unreviewed commits on the topic branch will become "reachable" from the protected branch by virtue of the multi-parent merge commit.

When a repo is cloned, all commits _reachable_ from the main branch are fetched and become accessible from the local checkout.

This combination of factors allows attacks where the victim performs a `git clone` operation followed by a `git reset --hard <unreviewed revision id>`.

#### Mitigations

##### Informed Review

The reviewer is able and encouraged to make an informed decision about what they're approving.
The reviewer MUST be presented with a full, meaningful content diff between the proposed revision and the previously reviewed revision.

It is not sufficient to indicate that a file changed without showing the contents.

##### Use only rebase operations on the protected branch

Require a squash merge strategy for the protected branch.

To guarantee that only commits representing reviewed diffs are cloned, the SCS MUST rebase (or "squash") the reviewed diff into a single new commit (the "squashed" commit) that has only a single parent (the revision previously pointed-to by the protected branch).
This is different than a standard merge commit strategy which would cause all the user-contributed commits to become reachable from the protected branch via the second parent.

It is not acceptable to replay the sequence of commits from the topic branch onto the protected branch.
The intent is to reduce the accepted changes to the exact diffs that were reviewed.
Constituent commits of the topic branch may or may not have been reviewed on an individual basis, and should not become reachable from the protected branch.

### Immutable Change Discussion

Summary:
The discussion around a change may often be as important as the change itself.

Intended for:
Large organizations, or any where discussion is an important part of the change management process.

Benefits:
From any revision, it's possible for future developers to read through the discussion that ultimately produced it.
This has many educational, forensics, and security auditing benefits.

Requirements:

The change management tool SHOULD record a description of the proposed change and all discussions / commentary related to it.

The change management tool MUST link this discussion to the revision itself. This is regularly done via commit metadata.

All collected content SHOULD be made immutable if the change is accepted.
It SHOULD NOT be possible to edit the discussion around a revision after it has been accepted.

### Fast moving repos and "merge trains"

Large organizations must keep the number of updates to key protected branches under certain limits to allow time for code review to happen.
For example, if a team tries to merge 60 change requests per hour into the `main` branch, the tip of the `main` branch would only be stable for about 1 minute.
This would leave only 1 minute for a new diff to be both generated and reviewed before it becomes stale again.

The normal way to work in this environment is to create a buffer branch (sometimes called a "train") to collect a certain number of approved changes.
In this model, when a change is approved for submission to the protected branch, it is added to the train branch instead.
After a certain amount of time, the train branch will be merged into the protected branch.
If there are problems detected with the contents on the train branch, it's normal for the whole train to be abandoned and a new train to be formed.
Approved changes will be re-applied to a new train in this scenario.

The key benefit to this approach is that the protected branch remains stable for longer, allowing more time for human and automatic code review.
A key downside to this approach is that organizations will not know the final revision id that represents a change until the entire train process completes.

A change review process will now be associated with multiple distinct revisions.

-   ID 1: The revision which was reviewed before concluding the change review process. It represents the ideal state of the protected branch applying only this proposed change.
-   ID 2: The revision created when the change is applied to the train branch. It represents the state of the protected branch _after other changes have been applied_.

It is important to note that no human or automatic review will have the chance to pre-approve ID2. This will appear to violate any organization policies that require pre-approval of changes before submission.
The SCS and the organization MUST protect this process in the same way they protect other artifact build pipelines.

At a minimum the SCS MUST issue an attestation that the revision id generated by a merged train is identical ("MERGESAME" in git terminology) to the state of the protected branch after applying each approved changeset in sequence.
No other content may be added or removed during this process.

## Future Considerations

### Authentication

-   Better protection against phishing by forbidding second factors that are not
  phishing resistant.
-   Protect against authentication token theft by forbidding bearer tokens
  (e.g. PATs).
-   Including length of continuity in the VSAs
