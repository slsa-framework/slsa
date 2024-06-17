# SLSA Source Track

## Objective

The SLSA Source Track mitigates [Threat A ("Submit unauthorized change")](/spec/v1.0/threats#a-submit-unauthorized-change), scoped to a code repository and the organization that owns that repository. Concretely: an attacker must compromise the accounts of two organization members to publish code in a Source Level 3-conformant repository, and the evidence of those unauthorized changes cannot be destroyed without further attacks.

## Changes from v0.1

-   **Scope** The Source track is now scoped to Revisions rather than builds.
Why?: To facilitate verification without anchoring it to a build.

-   **Model** Added a model, definitions, and the concept of verification.
Why?: SLSA does not yet have a model for version control systems, and we need such a model to be able to discuss them.

## Outstanding TODOs

-    [] Flesh out the definition and bounds of 'identity', and why they're required.
-    [] Refine requirements/guidance for trusted robots.
-    [] Either identify the unique value of L1 or merge it with L2.

## Source model

The Source track is scoped to a single project that is controlled by some organization. That organization determines what Source level should apply to the project and administers technical controls to enforce that level.

| Term | Description
| --- | ---
| Source | An identifiable set of text and binary files and associated metadata usually used as input for the build system (see SLSA Build Track).
| Organization | A collection of people who collectively create the Source. Examples of organizations include an open-source projects, a company, or a team within a company.
| Change | A set of modifications to one or more source files and associated metadata. Change metadata MUST include any information required to situate the change in relation to other changes (e.g. parent revision).
| Version Control System | Software for tracking and managing changes to source. Git and Subversion are examples of version control systems.
| Revision | The canonical source at a given point in time as identified by the version control system. As an example, you can identify a git revision by its tree hash.
| Change History | A record of the history of changes that went into the revision.
| Source Control Platform | A service or suite of services for hosting version controlled software. GitHub and GitLab are examples of source control platforms, as are combinations of tools like Gerrit code reviews with GitHub source control.

### Source Roles

| Role | Description
| --- | ---
| Administrator | A human who can perform privileged operations on one or more projects. Privileged actions include, but are not limited to, modifying the change history and modifying project- or organization-wide security policies.
| Trusted person | A human who is authorized by the organization to propose and approve changes to the source.
| Trusted robot | Automation with an authentic identity that is authorized by the organization to propose and/or approve changes to the source.
| Untrusted person | A human who has limited access to the project. They MAY be able to read the source. They MAY be able to propose or review changes to the source. They MAY NOT approve changes to the source or perform any privileged actions on the project.
| Proposer | The role that proposes a particular change to the source.
| Reviewer | The role that reviews a particular proposed change to the source.
| Approver | The role that approves a particular change to the source.
| Merger | The role that applies a change to the source. This person may be the proposer or a different trusted person, depending on the version control platform.

## Source Platform Requirements

The version control system MUST provide at least:

-   **[Immutable reference]** There exists a deterministic way to identify this particular revision. This is usually {project identifier + revision ID}. When the revision ID is a digest of the revision, as in git, nothing more is needed. When the revision ID is a number or otherwise not a digest, then the project server MUST guarantee that revisions cannot be altered once created.

-   **[Change history]** There exists a record of the history of changes that went into the revision. Each change MUST contain:
    -   The immutable reference to the new revision.
    -   The identities of the proposer, reviewers (if any), and merger (if different to the proposer).
    -   Timestamps of change submission. If a change is reviewed, then the change history MUST also include timestamps for any reviews.
    -   The change description/justification.
    -   The content of the change.
    -   The parent revisions.

Most popular version control systems meet these requirement, such as git, Subversion, Mercurial, and Perforce.

The source control platform MUST provide at least:

-   An account system or some other means of identifying persons.
-   A mechanism for modifying the canonical source through a **revision process**.

The source control platform SHOULD additionally provide:

-   A mechanism for assigning roles and/or permissions to identities.
-   A mechanism for including code review in the revision process.
-   Two-factor authentication for the account system (L2+ only).
-   Audit logs for sensitive actions, such as modifying security controls.

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
