# SLSA Source Track

## Outstanding TODOs

Open issues are tracked with the [source-track](https://github.com/slsa-framework/slsa/issues?q=is%3Aissue+is%3Aopen+label%3Asource-track) label in the [slsa-framework/slsa](https://github.com/slsa-framework/slsa) repository.

-   [] [Structure & formatting don't match the build track](https://github.com/slsa-framework/slsa/issues/1069)
-   [] [Either identify the unique value of L1 or merge it with L2](https://github.com/slsa-framework/slsa/issues/1070)
-   [] [How to communicate SLSA source track metadata?](https://github.com/slsa-framework/slsa/issues/1071)
-   [] [Clarify source track objective](https://github.com/slsa-framework/slsa/issues/1072)
-   [] [Clarify the 'merger' identity in source track](https://github.com/slsa-framework/slsa/issues/1074)
-   [] [Flesh out the definition and bounds of 'identity', and why they're required](https://github.com/slsa-framework/slsa/issues/1075)
-   [] [VCS and SCP concerns are mixed or too prescriptive](https://github.com/slsa-framework/slsa/issues/1076)
-   [] [Clarify that self-hosted SCPs are allowed](https://github.com/slsa-framework/slsa/issues/1077)
-   [] [Create guidance for consumers on how to evaluate the source platform](https://github.com/slsa-framework/slsa/issues/1078)
-   [] [Clarify what must be retained during source migrations](https://github.com/slsa-framework/slsa/issues/1079)
-   [] [Refine requirements/guidance for trusted robots](https://github.com/slsa-framework/slsa/issues/1080)

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
| Version Control System (VCS)| Software for tracking and managing changes to source. Git and Subversion are examples of version control systems.
| Revision | A specific state of the source with an identifier provided by the version control system. As an example, you can identify a git revision by its tree hash.
| Source Control Platform (SCP) | A service or suite of services (self-hosted or SaaS) for hosting version-controlled software. GitHub and GitLab are examples of source control platforms, as are combinations of tools like Gerrit code reviews with GitHub source control.
| Source Provenance | Information about which Source Control Platform (SCP) produced a revision, when it was generated, what process was used, who the contributors were, and what parent revisions it was based on.
| Organization | A collection of people who collectively create the Source. Examples of organizations include open-source projects, a company, or a team within a company. The organization defines the goals and methods of the repository.
| Repository | A uniquely identifiable instance of a VCS hosted on an SCP. The repository controls access to the Source in the version control system. The objective of a repository is to reflect the intent of the organization that controls it.
| Branch | A named pointer to a revision. Branches may be modified by authorized actors. In git, cloning a repo will download all revisions in the history of the "default" branch to the local machine.
| Change | A set of modifications to the source in a specific context. As an example, a proposed change to a "releases/1" branch may require higher scrutiny than a change to "users/1".
| Change History | A record of the history of revisions that preceded a specific revision.
| Push / upload / publish | When an actor authenticates to an SCP to upload content.
| Review / approve / vote | When an actor authenticates to an change review tool and positively or negatively endorses the exact source change they were presented.

## Source Roles

| Role | Description
| --- | ---
| Administrator | A human who can perform privileged operations on one or more projects. Privileged actions include, but are not limited to, modifying the change history and modifying project- or organization-wide security policies.
| Trusted person | A human who is authorized by the organization to propose and approve changes to the source.
| Trusted robot | Automation with an authentic identity that is authorized by the organization to propose and/or approve changes to the source.
| Untrusted person | A human who has limited access to the project. They MAY be able to read the source. They MAY be able to propose or review changes to the source. They MAY NOT approve changes to the source or perform any privileged actions on the project.
| Proposer | An actor that proposes a particular change to the source.
| Reviewer | An actor that reviews a particular change to the source.
| Approver | An actor that approves a particular change to the source.
| Merger | An actor that applies a change to the source. This typically involves creating the new revision and updating a branch. This person may be the proposer or a different trusted person, depending on the version control platform.

## Safe Expunging Process

Administrators have the ability to expunge (remove) content from a repository and its change history without leaving a record of the removed content (to accommodate legal or privacy compliance requirements).
This includes changing files, history, or changing references in git.
When used as an attack, this is called “repo hijacking” (or “repo-jacking”) and is one of the primary threats source provenance attestations protect against.

TODO: Determine how organizations can provide transparency around this process.

## Levels

### Level 1: Version controlled

Summary: The source is stored and managed through a modern version control system with a revision process.

Intended for: Organizations wanting to easily and quickly gain some benefits of SLSA and better integrate with the SLSA ecosystem without changing their source workflows.

Benefits: Version control solves software development challenges ranging from change attribution to effective collaboration.
It is a software development best practice with more benefits than we can discuss here.

Requirements: The combination of SCP and VCS MUST provide:

#### Immutable revisions

There exists a deterministic way to identify a particular revision.

This is usually a combination of the repository ID and revision ID.
When the revision ID is a digest of the revision, as in git, nothing more is needed.
When the revision ID is a number or otherwise not a digest, then the SCP MUST document how the immutability of the revision is established.  See also [Use cases for non-cryptographic, immutable, digests](https://github.com/in-toto/attestation/blob/main/spec/v1/digest_set.md#use-cases-for-non-cryptographic-immutable-digests).
The SCP MUST guarantee that repository IDs track the complete history of changes that occur to the source while hosted on the platform.

#### Identity Management

There exists an identity management system or some other means of identifying actors.
This system may be a federated authentication system (AAD, Google, Okta, GitHub, etc) or custom (gittuf, gpg-signatures on commits, etc).

#### Revision process

There exists a trusted mechanism for modifying the source pointed-to by a [branch](#definitions).
For each [branch](#definitions), the SCP MUST record and keep the full history of changes conducted on this SCP, with exceptions allowed following the [Safe Expunging Process](#safe-expunging-process).

The revision process MUST:

-   Provide an accurate description of the currently proprosed change, or instructions to recreate it.
-   Provide the ability to require pre-approval from specific actors before a change proposal is accepted.
-   Record all actors that contributed to the process, see [Source Roles](#source-roles).
-   Record timestamps of critical activities including process start, process completion, reception of change proposals by the SCP, and reviews.

### Level 2: TODO, but maybe: Generates Source Provenance Attestations

Summary: A consumer can ask the SCP for everything it knows about a specific revision of a repository.

Intended for: Organizations that need to enforce policy on consumed source.

Benefits: Prevents many classes of accidents and pin-to-sha attacks. Provides information to VSA-generation bots.

Requirements:

#### Source provenance attestation

Results from the revision process are codified into a source provenance attestation document.
Must record who, what, when.

##### Who

Source provenance attestation issuers SHOULD use a single identity definiton.

The strongly authenticated idenenty used to login to the SCP MUST be used for the generation of source provenance attestations.
This is typically the identity used to push to a git server.

Other forms of identity MAY be included as informational.
Examples include a git commit "author" and "committer," and a gpg signature's "user id."
These forms of identity are user-provided and not typically verified by the issuer.

##### What

Must record the proposal provided to reviewers for approval or instructions to reproduce it.
Git-specific stuff: TODO: provide instructions for three sha merge-same diff generation.

Must record target branch.

##### When

Must record when commits and review are received by the server.

### Level 3: TODO but maybe: Changes are authorized

Summary: All changes to the source are approved by two trusted actors prior to submission.

Intended for: Enterprise repositories and mature open source projects.

Benefits: A compromise of a single account does not result in compromise of the source.

Requirements:

#### Code review by two authorized actors

All changes to the source are approved by two authorized actors prior to submission.
User accounts that can perform code reviews MUST use two-factor authentication or its equivalent.

If the proposer is also an authorized actor, the proposer MAY approve their own proposal and count as one of the two required actors.

The code review system must meet the following requirements:

-   **[Informed review]** The reviewer is able and encouraged to make an informed decision about what they're approving. The reviewer MUST be presented with a full, meaningful content diff between the proposed revision and the previously reviewed revision. For example, it is not sufficient to just indicate that a file changed without showing the contents.
-   **[Context-specific approvals]** Approvals are for a specific context, such as a repo + target branch in git. Moving fully reviewed content from one context to another still requires review, except for well-understood automatic processes. For example, you do not need to review each change to cut a release branch, but you do need review when backporting changes from the main branch to an existing release branch.
-   **[Atomic change sets]** Changes are recorded in the change history as a single revision that consists of the net delta between the proposed revision and the parent revision. In the case of a nonlinear version control system, where a revision can have more than one parent, the diff must be against the "first common parent" between the parents. In other words, when a feature branch is merged back into the main branch, only the merge itself is in scope.
-   **[Record keeping]** Provenance must include the timestamp and the state of proposed revision at the point when each approval was granted. This is most relevant when the proposal content is allowed to change after aprovals have been granted.

#### Different actors

The organization strives to ensure that no two user accounts correspond to the same actors.
Should the organization discover that it issued multiple accounts to the same actors, it MUST act to rectify the situation.
For example, it might revoke project privileges for all but one of the accounts and perform retroactive code reviews on any changes where that actors' accounts are the author and/or code reviewer(s).

### Level 4: TODO but maybe: Maximum security

Summary: All changes are reviewed by experts.

Intended for: The highest of high-security-posture repos / code that is flying to Mars.

Benefits: Provides the maximum chance for experts to spot and reject problems before they ship.

Requirements:

#### Reset votes on all changes

The code review tool MUST ensure that the final proposal is approved by actors identified as experts for all changed files.

If a file is modified after receiving expert approval, a new approval MUST be granted.
The new approval MAY be granted by the same actor who granted the first approval.
