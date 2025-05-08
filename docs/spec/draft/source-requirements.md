# SLSA Source Track

## Outstanding TODOs

Open issues are tracked with the [source-track](https://github.com/slsa-framework/slsa/issues?q=is%3Aissue+is%3Aopen+label%3Asource-track) label in the [slsa-framework/slsa](https://github.com/slsa-framework/slsa) repository.
Source Track issues are triaged on the [SLSA Source Track](https://github.com/orgs/slsa-framework/projects/5) project board.

## Objective

The SLSA source track describes increasing levels of trustworthiness and completeness in a repository revision's provenance (e.g. how it was generated, who the contributors were, etc...).

The Source track is scoped to revisions of a single repository that is controlled by an organization.
That organization determines the intent of the software in the repository, what Source level should apply to the repository and administers technical controls to enforce that level.

The primary purpose of the Source track is to enable verification that the creation of a revision followed the expected process.
Consumers can examine the various source provenance attestations to determine if all sources used during the build meet their requirements.

## Definitions

| Term | Description
| --- | ---
| Source | An identifiable set of text and binary files and associated metadata. Source is regularly used as input to a build system (see [SLSA Build Track](requirements.md)).
| Organization | A set of people who collectively create the Source. Examples of organizations include open-source projects, a company, or a team within a company. The organization defines the goals and methods of the source.
| Version Control System (VCS)| Software for tracking and managing changes to source. Git and Subversion are examples of version control systems.
| Revision | A specific state of the source with an identifier provided by the version control system. As an example, you can identify a git revision by its tree hash.
| Source Control System (SCS) | A suite of tools and services (self-hosted or SaaS) relied upon by the organization to produce new revisions of the source. The role of the SCS may be fulfilled by a single service (e.g., GitHub / GitLab) or rely on a combination of services (e.g., GitLab with Gerrit code reviews, GitHub with OpenSSF Scorecard, etc).
| Source Provenance | Information about how a revision came to exist, where it was hosted, when it was generated, what process was used, who the contributors were, and what parent revisions it was based on.
| Repository / Repo | A uniquely identifiable instance of a VCS. The repository controls access to the Source in the VCS. The objective of a repository is to reflect the intent of the organization that controls it.
| Branch | A named, moveable, pointer to a revision that tracks development in the named context over time. Branches may be modified to point to different revisions by authorized actors. Different branches may have different security requirements.
| Tag | A named pointer to a revision that does not typically move. Similar to branches, tags may be modified by authorized actors. Tags are often used by producers to indicate a more permanent name for a revision.
| Change | A set of modifications to the source in a specific context. A change can be proposed and reviewed before being accepted.
| Change History | A record of the history of revisions that preceded a specific revision.
| Push / upload / publish | When an actor authenticates to a Repository to add or modify content. Typically makes a new revision reachable from a branch.
| Review / approve / vote | When an actor authenticates to a change review tool to comment upon, endorse, or reject a source change proposal.

## Source Roles

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
from that time or revision forward.

No claims are made for prior revisions.

## Levels

### Level 1: Version controlled

Summary:
The source is stored and managed through a modern version control system.

Intended for: Organizations currently storing source in non-standard ways who want to quickly gain some benefits of SLSA and better integrate with the SLSA ecosystem with minimal impact to their current workflows.

Benefits:
Migrating to the appropriate tools is an important first step on the road to operational maturity.

### Level 2: Branch History

Summary:
Clarifies which branches in a repo are consumable and guarantees that all changes to protected branches are recorded.

Intended for:
All organizations of any size producing software of any kind.

Benefits:
Allows source consumers to track changes to the software over time and attribute those changes to the people that made them.

### Level 3: Authenticatable and Auditable Provenance

Summary:
The SCS generates credible, tamper-resistant, and contemporaneous evidence of how a specific revision was created.
It is provided to authorized users of the source repository in a documented format.
of how a specific revision was created to authorized users of the source repository.

Intended for:
Organizations that want strong guarantees and auditability of their change management processes.

Benefits:
Provides authenticatable and auditable information to policy enforcement tools and reduces the risk of tampering
within the SCS's storage systems.

### Level 4: Two-party review

Summary:
The SCS requires two trusted persons to review all changes to protected
branches.

Intended for:
Organizations that want strong guarantees that the software they produce is not
subject to unilateral changes that would subvert their intent.

Benefits:
Makes it harder for an actor to introduce malicious changes into the software
and makes it more likely that the source reflects the intent of the
organization.

## Requirements

Many examples in this document use the [git version control system](https://git-scm.com/), but use of git is not a requirement to meet any level on the SLSA source track.

### Organization

[Organization]: #organization

<table>
<tr><th>Requirement<th>Description<th>L1<th>L2<th>L3<th>L4

<tr id="choose-scs"><td>Choose an appropriate source control system<td>

An organization producing source revisions MUST select a SCS capable of reaching
their desired SLSA Source Level.

For example, if an organization wishes to produce revisions at Source Level 3,
they MUST choose a source control system capable of producing Source Level 3
attestations.

<td>✓<td>✓<td>✓<td>✓

<tr id="choose-process"><td>Choose an appropriate change management process<td>

An organization producing source revisions MUST implement a change management
process to ensure changes to source matches the organization's intent.

<td><td>✓<td>✓<td>✓

<tr id="specify-protection"><td>Specify which branches and tags are protected<td>

The organization MUST indicate which branches and tags it protects with Source
Level 2+ controls.

For example, if an organization has branches 'main' and 'experimental' and it
intends for 'main' to be protected then it MUST indicate to the SCS that 'main'
should be protected. From that point forward revisions on 'main' will be
eligible for Source Level 2+ while revisions made solely on 'experimental' will
not.

<td><td>✓<td>✓<td>✓

<tr id="safe-expunging-process"><td>Safe Expunging Process<td>

SCSs MAY allow the organization to expunge (remove) content from a repository and its change history without leaving a public record of the removed content,
but the organization MUST only allow these changes in order to meet legal or privacy compliance requirements.
Content changed under this process includes changing files, history, references, or any other metadata stored by the SCS.

#### Warning

Removing a revision from a repository is similar to deleting a package version from a registry: it's almost impossible to estimate the amount of downstream supply chain impact.
For example, in VCSs like Git, each revision ID is based on the ones before it. When you remove a revision, you must generate new revisions (and new revision IDs) for any revisions that were built on top of it. Consumers who took a dependency on the old revisions may now be unable to refer to the source they've already integrated into their products.

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

<tr id="specify-control-expectations"><td>Specify control expectations<td>

The organization MUST specify what technical controls consumers can expect to be
enforced for revisions in each branch using the
[Enforced change management process](#enforced-change-management-process).

For example, an organization may wish claim that revisions on 'main' require
unit tests to have passed prior to merge.  The organization could then
configure the SCS to enforce this requirement and embed the
`USER_SOURCE_UNIT_TESTED` tag in the
[source summary attestations](#summary-attestation) and have the SCS store
corresponding [test result attestations] for all affected revisions.
Consumers of those revisions would be able to determine if these expectations
have been met by looking for the `USER_SOURCE_UNIT_TESTED` tag in the VSA and,
if desired, consult the [test result attestations] as well.

[test result attestations]: https://github.com/in-toto/attestation/blob/main/spec/predicates/test-result.md

<td><td><td>✓<td>✓

</table>

### Source Control System

#### Revision management

<table>
<tr><th>Requirement<th>Description<th>L1<th>L2<th>L3<th>L4

<tr id="repository-ids"><td>Repositories are uniquely identifiable<td>

The repository ID is defined by the SCS and MUST be uniquely identifiable within the context of the SCS.

<td>✓<td>✓<td>✓<td>✓
<tr id="revision-ids"><td>Revisions are immutable and uniquely identifiable<td>
The revision ID is defined by the SCS and MUST be uniquely identifiable within the context of the repository.
When the revision ID is a digest of the content of the revision (as in git) nothing more is needed.
When the revision ID is a number or otherwise not a digest, then the SCS MUST document how the immutability of the revision is established.
The same revision ID MAY be present in multiple repositories.
See also [Use cases for non-cryptographic, immutable, digests](https://github.com/in-toto/attestation/blob/main/spec/v1/digest_set.md#use-cases-for-non-cryptographic-immutable-digests).

<td>✓<td>✓<td>✓<td>✓
<tr id="source-summary"><td>Source Summary Attestations<td>

The SCS MUST generate a [source summary attestation](#summary-attestation) to
indicate the SLSA Source Level of any revision at Level 1 or above.

If a consumer is authorized to access a revision, they MUST be able to fetch the
corresponding source summary attestations.

If the SCS DOES NOT generate a summary attestation for a revision, the revision
cannot be verified and thus has Source Level 0.

When source provenance is available the SCS MAY use it to generate the
source summary attestation.

<td>✓<td>✓<td>✓<td>✓
<tr id="branches"><td>Protected Branches<td>

The SCS MUST provide a mechanism for organizations to indicate which branches
should be protected by SLSA Source Level 2+ requirements.

E.g. The organization may configure the SCS to protect `main` and
`refs/heads/releases/*`, but not `refs/heads/playground/*`.

<td><td>✓<td>✓<td>✓
<tr id="continuity"><td>Branch Continuity<td>

It MUST NOT be possible to rewrite the history of protected branches.
In other words, if the organization updates a branch from commit A to commit B, commit B MUST be a descendant of A.
For systems like GitHub or GitLab, this can be accomplished by enabling branch protection rules that prevent force pushes and branch deletions.

It MUST NOT be possible to delete the entire repository (including all branches) and replace it with different source.

Continuity exceptions are allowed via the [safe expunging process](#safe-expunging-process).

<td><td>✓<td>✓<td>✓
<tr id="tag-hygiene"><td>Tag Hygiene<td>

If the SCS supports tags (or other non-branch tracks), additional care must be
taken to prevent unintentional changes.
Unlike branches, tags have no built-in continuity enforcement mechanisms or
change management processes.

If a tag is used to identify a specific commit to external systems, it MUST NOT
be possible to move or delete those tags.

<td><td>✓<td>✓<td>✓
<tr id="identity-management"><td>Identity Management<td>

There exists an identity management system or some other means of identifying
and authenticating actors. Depending on the SCS, identity management may be
provided by source control services (e.g., GitHub, GitLab), implemented using
cryptographic signatures (e.g., using gittuf to manage public keys for actors),
or extend existing authentication systems used by the organization (e.g., Active
Directory, Okta, etc.).

The SCS MUST document how actors are identified for the purposes of attribution.

Activities conducted on the SCS SHOULD be attributed to authenticated identities.

<td><td>✓<td>✓<td>✓
<tr id="multi-factor-authentication"><td>Multi-factor Authentication<td>

User accounts that can modify the source or the project's configuration must
use multi-factor authentication or its equivalent.
The SCS MUST declare which forms of identity it considers to be trustworthy
for this purpose. All other forms of identity SHOULD be considered informational
and SHOULD NOT be used for authentication.

A second factor MUST be required when a user enrolls new access tokens that
enable modifications (e.g. ssh keys, PATs), or when enrolling additional
second factors (e.g. hardware tokens, authenticator apps).

See [source roles](#source-roles).

<td><td><td>✓<td>✓
<tr id="source-provenance"><td>Source Provenance<td>

[Source Provenance](#provenance-attestations) are attestations that contain
information about how a specific revision was created and how it came to exist
on a protected branch or how a tag came to point at it. They are associated
with the revision identifier delivered to consumers and are a statement of fact
from the perspective of the SCS.

At Source Level 3 Source Provenance MUST be created contemporaneously with the
branch being updated to use that revision such that they provide a credible,
auditable, record of changes.

If a consumer is authorized to access, they MUST be able to fetch the source
provenance documents for relevant revisions.

It is possible that an SCS can make no claims about a particular revision.
For example, this would happen if the revision was created on another SCS,
or if the revision was not the result of an accepted change management process.

<td><td><td>✓<td>✓
<tr id="enforced-change-management-process"><td>Enforced change management process<td>

The SCS MUST

-   Ensure organization-defined technical controls are enforced for changes made
   to protected branches.
-   Allow organizations to specify
   [additional tags](#additional-tags) to be included in the
   [source summary](#summary-attestation) when the corresponding controls are
enforced.
-   Allow organizations to distribute additional attestations related to their
   technical controls to consumers authorized to access the corresponding source
   revision.

The SCS MUST NOT allow organization specified tags to begin with any value other
than `USER_SOURCE_` or `INTERNAL_USER_` unless the SCS endorses the veracity of
any corresponding claims.

Enforcement of the organization defined technical controls could be accomplished
by, for example:

-   The configuration of branch protection rules (e.g.[GitHub](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets), [GitLab](https://docs.gitlab.com/ee/user/project/repository/branches/protected.html)) which require additional checks to 'pass'
    (e.g. unit tests, linters), or
-   the application and verification of [gittuf](https://github.com/gittuf/gittuf) policies, or
-   some other mechanism as enforced by the [Change management tool](#change-management-tool-requirements).

<td><td><td>✓<td>✓
<tr id="two-party-review"><td>Two party review<td>

Changes in protected branches MUST be agreed to by two or more trusted persons prior to submission.
The following combinations are acceptable:

-   Uploader and reviewer are two different trusted persons.
-   Two different reviewers are trusted persons.

Reviews SHOULD cover, at least, security relevant properties of the code.

**[Final revision approved]** This requirement applies to the final revision
submitted. I.e. if a change is made during the review process that change MUST
be reviewed as well.

**[Context-specific approvals]** Approvals are for a specific context, such as a
repo + branch in git. Moving fully reviewed content from one context to another
still requires review. (Exact definition of “context” depends on the project,
and this does not preclude well-understood automatic or reviewless merges, such
as cutting a release branch.)

**[Trusted Robot Contributions]** An organization MAY choose to allow a Trusted
Robot to author and submit changes to source code without 2-party approval if
the Robot’s identity is specifically allowed to bypass two-party review for the
protected branch.

Examples:

-   Import and migration bots that move code from one repo to another.
-   Dependabot

<td><td><td><td>✓
</table>

### Provide a change management tool

The change management tool MUST be able to authoritatively state that each new revision reachable from the protected branch represents only the changes managed via the [process](#enforced-change-management-process).

<table>
<tr><th>Requirement<th>Description<th>L1<th>L2<th>L3<th>L4

<tr id="context"><td>Context<td>

The change management tool MUST record the specific code change (a "diff" in git) or instructions to recreate it.
In git, this typically defined to be three revision IDs: the tip of the "topic" branch, the tip of the target branch, and closest shared ancestor between the two (such as determined by `git-merge-base`).

The change management tool MUST record the "target" context for the change proposal and the previous revision in that context.
For example, for the git version control system, the change management tool MUST record the branch name that was updated.

Branches may have differing security postures, and a change can be approved for one context while being unapproved for another.

<td><td><td>✓<td>✓
<tr id="verified-timestamps"><td>Verified Timestamps<td>

The change management tool MUST record timestamps for all contributions and review-related activities.
User-provided timestamps MUST NOT be used.

<td><td><td>✓<td>✓
</table>

## Communicating source levels

SLSA source level details are communicated using attestations.
These attestations either refer to a source revision itself or provide context needed to evaluate an attestation that _does_ refer to a revision.

There are two broad categories of source attestations within the source track:

1.  Summary attestations: Used to communicate to downstream users what high level security properties a given source revision meets.
2.  Provenance attestations: Provide trustworthy, tamper-proof, metadata with the necessary information to determine what high level security properties a given source revision has.

To provide interoperability and ensure ease of use, it's essential that the summary attestations are applicable across all Source Control Systems.
Due to the significant differences in how SCSs operate and how they may chose to meet the Source Track requirements it is preferable to
allow for flexibility with the full attestations.  To that end SLSA leaves provenance attestations undefined and up to the SCSs to determine
what works best in their environment.

### Summary attestation

Summary attestations are issued by some authority that has sufficient evidence to make the determination of a given
revision's source level.  Summary attestations convey properties about the revision as a whole and summarize properties computed over all
the changes that contributed to that revision over its history.

The source track issues summary attestations using [Verification Summary Attestations (VSAs)](./verification_summary.md) as follows:

1.  `subject.uri` SHOULD be set to a human readable URI of the revision.
2.  `subject.digest` MUST include the revision identifier (e.g. `gitCommit`) and MAY include other digests over the contents of the revision (e.g. `gitTree`, `dirHash`, etc...).
SCSs that do not use cryptographic digests MUST define a canonical type that is used to identify immutable revisions (e.g. `svn_revision_id`)[^1].
3.  `subject.annotations.source_refs` SHOULD be set to a list of references that pointed to this revision when the attestation was created. The list MAY NOT be exhaustive
    -   git references MUST be fully qualified (e.g. `refs/head/main` or `refs/tags/v1.0`) to reduce the likelihood of confusing downstream tooling.
4.  `resourceUri` MUST be set to the URI of the repository, preferably using [SPDX Download Location](https://spdx.github.io/spdx-spec/v2.3/package-information/#77-package-download-location-field).
E.g. `git+https://github.com/foo/hello-world`.
5.  `verifiedLevels` MUST include the SLSA source track level the SCS asserts the revision meets. One of `SLSA_SOURCE_LEVEL_0`, `SLSA_SOURCE_LEVEL_1`, `SLSA_SOURCE_LEVEL_2`, `SLSA_SOURCE_LEVEL_3`.
MAY include additional properties as asserted by the SCS.  The SCS MUST include _only_ the highest SLSA source level met by the revision.
6.  `dependencyLevels` MAY be empty as source revisions are typically terminal nodes in a supply chain.

The SCS MAY issue these attestations based on its understanding of the underlying system (e.g. based on design docs, security reviews, etc...),
but at SLSA Source Level 3 MUST use tamper-proof [provenance attestations](#provenance-attestations) appropriate to their SCS when making the assessment.

#### Additional tags

The SLSA source track MAY create additional tags to include in `verifiedLevels` which attest
to other properties of a revision (e.g. if it was code reviewed).  All SLSA source tags will start with `SLSA_SOURCE_`.  Consumers MAY assume all SLSA source tags are meant

The SCS MAY embed user-provided tags within `verifiedLevels` corresponding to
technical controls enforced by the SCS if they are prefixed with:

-   `USER_SOURCE_` to indicate a tag that is meant for consumption by external
   consumers.
-   `INTERNAL_USER_` to indicate a tag that is not meant for consumption by
   external consumers.

The meaning of the tags is left entirely to the organization. Inclusion of user
provided tags within `verifiedLevels` SHOULD NOT be considered an endorsement of
the veracity of the organization defined claim by the SCS.

#### Populating source_refs

The summary attestation issuer may choose to populate `source_refs` in any way they wish.
Downstream users are expected to be familiar with the method used by the issuer.

Example implementations:

-   Issue a new VSA for each merged Pull Request and add the destination branch to `source_refs`.
-   Issue a new VSA each time a 'consumable branch' is updated to point to a new revision.
-   Issue a new VSA each time a 'consumable tag' is created to point to a new revision.

#### Example

```json
"_type": "https://in-toto.io/Statement/v1",
"subject": [{
  "uri": "https://github.com/foo/hello-world/commit/9a04d1ee393b5be2773b1ce204f61fe0fd02366a",
  "digest": {"gitCommit": "9a04d1ee393b5be2773b1ce204f61fe0fd02366a"},
  "annotations": {"source_refs": ["refs/heads/main", "refs/heads/release_1.0"]}
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
-   Users SHOULD check that an allowed branch is listed in `subject.annotations.source_refs` to ensure the revision is from an appropriate context within the repository.
-   Users SHOULD check that the expected `SLSA_SOURCE_LEVEL_` is listed within `verifiedLevels`.
-   Users MUST ignore any unrecognized values in `verifiedLevels`.

### Provenance attestations

Source provenance attestations provide tamper-proof evidence (ideally signed [in-toto attestations](https://github.com/in-toto/attestation/blob/main/README.md))
that can be used to determine what SLSA Source Level or other high level properties a given revision meets.
This evidence can be used by an authority as the basis for issuing a [Summary Attestation](#summary-attestation).

SCSs may have different methods of operating that necessitate different forms of evidence.
E.g. GitHub-based workflows may need different evidence than Gerrit-based workflows, which would both likely be different from workflows that
operate over Subversion repositories.

These differences also mean that depending on the configuration the issuers of provenance attestations may vary from implementation to implementation, often because entities with the knowledge to issue them may vary.
The authority that issues [summary-attestations](#summary-attestation) MUST understand which entity should issue each provenance attestation type and ensure the full attestations come from the appropriate issuer.

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

[^1]: in-toto attestations allow non-cryptographic digest types: https://github.com/in-toto/attestation/blob/main/spec/v1/digest_set.md#supported-algorithms.

## Future Considerations

### Authentication

-   Better protection against phishing by forbidding second factors that are not
  phishing resistant.
-   Protect against authentication token theft by forbidding bearer tokens
  (e.g. PATs).
