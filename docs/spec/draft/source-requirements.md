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

Administrators have the ability to expunge (remove) content from a repository and its change history without leaving a record of the removed content.
This includes changing files, history, or changing references in git.
When used as an attack, this is called “repo hijacking” (or “repo-jacking”) and is one of the primary threats source provenance attestations protect against.

TODO: Determine how organizations can provide transparency around this process.

## Source Control Platform and Version Control System Requirements

The combination of SCP and VCS MUST provide:

### Immutable reference

There exists a deterministic way to identify a particular revision.

This is usually a combination of the repository ID and revision ID.
When the revision ID is a digest of the revision, as in git, nothing more is needed.
When the revision ID is a number or otherwise not a digest, then the SCP MUST document how the immutability of the revision is established.  See also [Use cases for non-cryptographic, immutable, digests](https://github.com/in-toto/attestation/blob/main/spec/v1/digest_set.md#use-cases-for-non-cryptographic-immutable-digests).
The SCP MUST guarantee that repository IDs track the complete history of changes that occur to the source while hosted on the platform.

### Identity Management

There exists an identity management system or some other means of identifying actors.
This system may be a federated authentication system (AAD, Google, Okta, GitHub, etc) or custom (gittuf, gpg-signatures on commits, etc).
SCPs SHOULD pick one and use a single identity management system when issuing source provenance attestations.

When there are conflicting identity claims the authenticated identity MUST be used.
For example in a single git commit the "author", "committer," and the gpg signature's "user id" may be different, and they may all be different than the authenticated identity used to push the commit to the SCP.

### Revision process

There exists a trusted mechanism for modifying the source pointed-to by a [branch](#definitions).
For each [branch](#definitions), the SCP MUST record and keep the full history of changes conducted on this SCP, with exceptions allowed following the [Safe Expunging Process](#safe-expunging-process).

The revision process MUST:

-   Provide an accurate description of the currently proprosed change, or instructions to recreate it.
-   Provide the ability to review a change before it is accepted.
-   Provide the ability to require pre-approval from specific actors before a change proposal is accepted.
-   Record all actors that contributed to the process, see [Source Roles](#source-roles).
-   Record timestamps of critical activities including process start, process completion, reception of change proposals by the SCP, and reviews.
-   Record the specific state of the process when each approval was granted. This is most relevant when the proposal content is allowed to change after aprovals have been granted.

### Additional features

The combination of SCP and VCS SHOULD provide:

-   A mechanism for assigning roles and/or permissions to [actors](#source-roles).
-   Two-factor authentication for the [identity management system](#identity-management).
-   Audit logs for sensitive actions, such as modifying security controls.
-   A mechanism to define code ownership for all files in the source.

## Levels

### Level 1: Version controlled

Summary: The project source is stored and managed through a modern version control system.

Intended for: Organizations that are unwilling or unable to host their source on a source control platform. If possible, skip to Level 2.

Requirements:

**[Version controlled]** Every change to the source is tracked in a version control system that meets the requirements listed in [Source Platform Requirements](#source-platform-requirements).

Benefits: Version control solves software development challenges ranging from change attribution to effective collaboration. It is a software development best practice with more benefits than we can discuss here.

### Level 2: Verified history

Summary: The source code and its change history metadata are retained and authenticated to allow trustworthy auditing and analysis of the source code.

Intended for: Organizations that are unwilling or unable to incorporate code review into their software development practices.

Requirements:
**[Strong authentication]** User accounts that can modify the source or the project's configuration must use multi-factor authentication or its equivalent.

**[Verified timestamps]** Each entry in the change history must contain at least one timestamp that is determined by the source control platform and cannot be modified by clients. It MUST be clear in the change history which timestamps are determined by the source control platform.

**[Retained history]** The change history MUST be preserved as long as the source is hosted on the source control system. The source MAY migrate to another source control system, but the organization MUST retain the change history if possible. It MUST NOT be possible for persons to delete or modify the change history, even with multi-party approval, except by trusted platform admins following an established deletion policy.

Benefits: Attributes changes in the version history to specific actors and timestamps, which allows for post-auditing, incident response, and deterrence for bad actors. Multi-factor authentication makes account compromise more difficult, further ensuring the integrity of change attribution.

### Level 3: Changes are authorized

Summary: All changes to the source are approved by two trusted persons prior to submission.

Intended for: Enterprise projects and mature open source projects.

Requirements:

**[Code review]** All changes to the source are approved by two trusted persons prior to submission. User accounts that can perform code reviews MUST use two-factor authentication or its equivalent.
The following combinations of trusted persons are acceptable:

-   Proposer and reviewer are two different trusted persons.
-   Two different reviewers are trusted persons.

The code review system must meet the following requirements:

-   **[Informed review]** The reviewer is able and encouraged to make an informed decision about what they're approving. The reviewer MUST be presented with a full, meaningful content diff between the proposed revision and the previously reviewed revision. For example, it is not sufficient to just indicate that a file changed without showing the contents.
-   **[Context-specific approvals]** Approvals are for a specific context, such as a repo + target branch + revision in git. Moving fully reviewed content from one context to another still requires review, except for well-understood automatic processes. For example, you do not need to review each change to cut a release branch, but you do need review when backporting changes from the main branch to an existing release branch.
-   **[Atomic change sets]** Changes are recorded in the change history as a single revision that consists of the net delta between the proposed revision and the parent revision. In the case of a nonlinear version control system, where a revision can have more than one parent, the diff must be against the "first common parent" between the parents. In other words, when a feature branch is merged back into the main branch, only the merge itself is in scope.

Trusted robots MAY be exempted from the code review process. It is RECOMMENDED that trusted robots so exempted be run only software built at Build L3+ from sources that meet Source L3.

**[Different persons]** The organization strives to ensure that no two user accounts correspond to the same person. Should the organization discover that it issued multiple accounts to the same person, it MUST act to rectify the situation. For example, it might revoke project privileges for all but one of the accounts and perform retroactive code reviews on any changes where that person's accounts are the author and/or code reviewer(s).

Benefits: A compromise of a single human or account does not result in compromise of the project, since all changes require review from two humans.
