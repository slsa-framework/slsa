# SLSA Source Track

## Objective

The SLSA Source Track mitigates
[Threat A ("Submit unauthorized change")](/spec/v1.0/threats#a-submit-unauthorized-change),
scoped to a code repository and the organization that owns that repository.

Concretely, in a Source Level 3-conformant repository:

-   Each revision of a source repository must provide an attestation of the
    process that produced it, including all relevant security claims.
-   An attacker must compromise the accounts of two authorized members to publish
    code.
-   Evidence of changes cannot be destroyed without compromise of the SCP or VCS
    platform.

## Outstanding TODOs

The SLSA Source Track is still a work in progress. The following GitLab Issues
are the main outstanding issues that need to be solved:

-   [Structure & formatting don't match the build track](https://github.com/slsa-framework/slsa/issues/1069)
-   [Clarify the value of L1 in the source track](https://github.com/slsa-framework/slsa/issues/1070)
-   [How to communicate SLSA source track metadata?](https://github.com/slsa-framework/slsa/issues/1071)
-   [Clarify source-track objective](https://github.com/slsa-framework/slsa/issues/1072)
-   [Should the source track mention 'administrator robots'?](https://github.com/slsa-framework/slsa/issues/1073)
-   [Clarify the 'merger' identity in source track](https://github.com/slsa-framework/slsa/issues/1074)
-   [Source control platforms also provide identity](https://github.com/slsa-framework/slsa/issues/1075)
-   [VCS and SCP concerns are mixed or too prescriptive](https://github.com/slsa-framework/slsa/issues/1076)
-   [Clarify that self-hosted SCPs are allowed](https://github.com/slsa-framework/slsa/issues/1076)
-   [Create guidance for consumers on how to evaluate the source platform](https://github.com/slsa-framework/slsa/issues/1078)
-   [Clarify what must be retained during source migrations](https://github.com/slsa-framework/slsa/issues/1079)
-   [Clarify Robot Approval](https://github.com/slsa-framework/slsa/issues/1080)
-   [Clarify how previous changes get reviewed](https://github.com/slsa-framework/slsa/issues/1081)

## Source model

The Source track is scoped to a single repository that is controlled by an organization.
That organization determines what Source level should apply to the repository and administers technical controls to enforce that level.

| Term | Description
| --- | ---
| Source | An identifiable set of text and binary files and associated metadata.
| Organization | A collection of people who collectively create the Source. Examples of organizations include open-source projects, a company, or a team within a company.
| Repository | A uniquely identifiable instance of a VCS hosted on an SCP. It controls access to the Source in the VCS.
| Change | A set of modifications to one or more source files and associated metadata. Change metadata MUST include any information required to situate the change in relation to other changes (e.g. parent revision).
| Version Control System | Software for tracking and managing changes to source. Git and Subversion are examples of version control systems.
| Revision | A specific identifier provided by the version control system that identifies a given state of the source. As an example, you can identify a git revision by its tree hash.
| Change History | A record of the history of changes that went into the revision.
| Source Control Platform | A service or suite of services for hosting version-controlled software. GitHub and GitLab are examples of source control platforms, as are combinations of tools like Gerrit code reviews with GitHub source control.
| Source Provenance Attestation | A signed document describing a revision and the security claims associated with it.

### Source Roles

| Role | Description
| --- | ---
| Administrator  | An actor that can perform privileged operations on one or more repositories. Privileged actions include, but are not limited to, modifying the change history and modifying project- or organization-wide security policies.
| Trusted person | A human who is authorized by the organization to propose and approve changes to the source.
| Untrusted person | A human who has limited access to the repository. They MAY be able to read the source. They MAY be able to propose or review changes to the source. They MAY NOT approve changes to the source or perform any privileged actions on the repository.
| Trusted robot  | Automation with an authentic identity that is authorized by the organization to propose and/or approve changes to the source.
| Proposer | The actor that proposes a particular change to the source.
| Reviewer | The actor that reviews a particular proposed change to the source.
| Approver | The actor that approves a particular change to the source.
| Merger   | The actor that creates the final revision based on the proposed change.

## Source Platform and Version Control System Requirements

The combination of SCP and VCS MUST provide:

-   **[Immutable reference]** There exists a deterministic way to identify this particular revision.
This is usually {repository identifier + revision ID}.
When the revision ID is a digest of the revision, as in git, nothing more is needed.
When the revision ID is a number or otherwise not a digest, then the repository server MUST guarantee that revisions cannot be altered once created.

-   **[Change history]** There exists a record of the history of changes conducted on this SCP that went into the revision.
A merged GitHub pull request is an example of a change record. Each change MUST contain:

    -   The immutable reference to the new revision.
    -   The parent revisions.
    -   The change description/justification.
    -   The content of the change.

-   **[Identity Management]** There exists an identity management system or some other means of identifying actors.

    -   There exists a way to determine the number of unique actors who reviewed a proposed diff.

-   **[Change Management]** There exists a trusted mechanism for modifying the canonical source through a **revision process**. The revision process MUST record at least:

    -   The identities of the proposer, reviewers (if any), and merger (if different from the proposer).
    -   Timestamps of change submission. If a change is reviewed, then the change history MUST also include timestamps for any reviews.
    -   The specific change reviewed during the revision process or instructions to recreate it. In git, this might be the two compared object ids and the computed best merge base between them at the time of review.

The combination of SCP and VCS SHOULD additionally provide:

-   A mechanism for assigning roles and/or permissions to actors.
-   A mechanism for including code review in the revision process.
-   Two-factor authentication for the account system (L2+ only).
-   Audit logs for sensitive actions, such as modifying security controls.
-   A mechanism to define code ownership for all files in the source repository.

## Levels

### Level 1: Version controlled

Summary: The source is stored and managed through a modern version control system.

Intended for: Organizations that are unwilling or unable to host their source on a source control platform. If possible, skip to Level 2.

Requirements:

-   **[Version controlled]** Every change to the source is tracked in a version control system that meets the requirements listed in [Source Platform Requirements](#source-platform-requirements).

Benefits:

Version control solves software development challenges ranging from change attribution to effective collaboration.
It is a software development best practice with more benefits than we can discuss here.

### Level 2: Verified history

Summary: The source code and its change history metadata are retained and authenticated to allow trustworthy auditing and analysis of the source code.

Intended for: Organizations that are unwilling or unable to incorporate code review into their software development practices.

Requirements:

-   **[Strong authentication]** User accounts that can modify the source or the repository's configuration must use multi-factor authentication or its equivalent.

-   **[Verified timestamps]** Each entry in the change history must contain at least one timestamp that is determined by the source control platform and cannot be modified by clients.
It MUST be clear in the change history which timestamps are determined by the source control platform.

-   **[Retained history]** The change history MUST be preserved as long as the source is hosted on the source control system.
The source MAY migrate to another source control system, but the organization MUST retain the change history if possible.
It MUST NOT be possible for persons to delete or modify the change history, even with multi-party approval, except by trusted platform admins following an established deletion policy.

Benefits:

-   Attributes changes in the version history to specific actors and timestamps, which allows for post-auditing, incident response, and deterrence of bad actors.
-   Multi-factor authentication makes account compromise more difficult, further ensuring the integrity of change attribution.

### Level 3: Changes are authorized

Summary: All changes to the source are approved by two trusted humans prior to being merged.

Intended for: Enterprise repositories and mature open source repositories.

Requirements:

**[Code review]** All changes to the source are approved by two trusted humans prior to being merged.
User accounts that can perform code reviews MUST use two-factor authentication or its equivalent.
The following combinations of trusted humans are acceptable:

-   Proposer and reviewer are two different trusted humans.
-   Two different reviewers are trusted humans.

The code review system MUST meet the following requirements:

-   **[Informed review]** The reviewer is able and encouraged to make an informed decision about what they're approving. The reviewer MUST be presented with a full, meaningful content diff between the proposed revision and the previously reviewed revision. For example, it is not sufficient to just indicate that a file changed without showing the delta.

-   **[Context-specific approvals]** Approvals are for a specific context.
Reviewers may approve a specific diff being applied to a specific repo + target branch + revision in git.
Approvals are not transferable between contexts, though exceptions may be granted for automated processes conducted by trusted robots.

-   **[Atomic change sets]** Changes are recorded in the change history as a single revision that consists of the net delta between the proposed revision and the parent revision.
In the case of a nonlinear version control system, where a revision can have more than one parent, the diff must be against the "first common parent" between the parents.
In other words, when a feature branch is merged back into the main branch, only the merge itself is in scope.

**[Different persons]** The organization strives to ensure that no two user accounts correspond to the same person.
Should the organization discover that it issued multiple accounts to the same person, it MUST act to rectify the situation.
For example, it might revoke repository privileges for all but one of the accounts and perform retroactive code reviews on any changes where that person's accounts are the author and/or code reviewer(s).

**[Trusted robots]** Trusted robots MAY be exempted from the code review process.
It is RECOMMENDED that trusted robot software be built at Build L3+ from sources that meet Source L3+.

Benefits:

A compromise of a single human or account does not result in compromise of the repository, since all changes require review from two humans.
