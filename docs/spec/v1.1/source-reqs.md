# SLSA Source Track

## Objective

The SLSA Source Track mitigates [Threat A ("Submit unauthorized change")](/spec/v1.0/threats#a-submit-unauthorized-change), scoped to a code repository and the organization that owns that repository. Concretely: an attacker must compromise the accounts of two organization members to publish code in a Source Level 3-conformant repository, and the evidence of those unauthorized changes cannot be destroyed without further attacks.

## Changes from v0.1

-   **Scope** The Source track is now scoped to Revisions rather than builds.
Why?: To facilitate verification without anchoring it to a build.

-   **Model** Added a model, definitions, and the concept of verification.
Why?: SLSA does not yet have a model for version control systems, and we need such a model to be able to discuss them.

## Infrastructure Requirements

The version control platform MUST provide at least:

-   An account system or some other means of identifying persons. This account system MUST support two-factor authentication or an equivalent.
-   A mechanism for modifying the canonical source through a **revision process**.

The version control platform SHOULD additionally provide:

-   A mechanism for assigning roles and/or permissions to identities.
-   A mechanism for including code review in the revision process.
-   Mechanisms for **strongly authenticating** identities, such as 2FA.
-   Audit logs

## Levels

### Level 0: No guarantees

Summary: L0 represents the lack of a Source level. Projects are L0 by definition before adopting SLSA.

Intended for: Experimental Projects, or other Projects early in their lifecycle.

Requirements: N/A

Benefits: N/A

### Level 1: Version controlled

Summary: The project source is stored and managed through a modern version control system.

Intended for: Organizations that are unwilling or unable to host their source on a version control platform. If possible, skip to Level 2.

Requirements:

**[Version controlled]** Every change to the source is tracked in a version control system that meets the following requirements

-   **[Change history]** There exists a record of the history of changes that went into the revision. Each change MUST contain:
    -   The immutable reference to the new revision
    -   The identities of the uploader, reviewers (if any), and submitter/merger (if different to the uploader)
    -   Timestamps of the reviews (if any) and submission
    -   The change description/justification
    -   The content of the change
    -   The parent revisions.

-   **[Immutable reference]** There exists a way to indefinitely reference this particular, immutable revision. This is usually {project identifier + revision ID}. When the revision ID is a digest of the revision, as in git, nothing more is needed. When the revision ID is a number or otherwise not a digest, then the project server MUST guarantee the immutability of the reference.

Most popular version control systems meet these requirement, such as git, Subversion, Mercurial, and Perforce.

Benefits: Version control solves software development challenges from ranging change attribution to effective collaboration. It is a software development best practice with more benefits than we can discuss here.

### Level 2: Verified history

Summary: The project is stored and managed through a source control platform that ensures the change history's integrity..

Intended for: Organizations that are unwilling or unable to incorporate code review into their software development practices.

Requirements:
**[Strong authentication]** User accounts that can modify the source or the project's configuration must use two-factor authentication or its equivalent.

**[Verified timestamps]** Each entry in the change history must contain at least one timestamp that is determined by the source control platform and cannot be modified by clients. It MUST be clear in the change history which timestamps are determined by the source control platform.

**[Retained history]** The change history MUST be preserved as long as the source is hosted on the source control system. The source MAY migrate to another source control system, but the organization MUST retain the change history if possible. It MUST NOT be possible for persons to delete or modify the change history, even with multi-party approval, except by trusted platform admins following an established deletion policy.

Benefits: Attributes changes in the version history to specific actors and timestamps, which allows for post-auditing, incident response, and deterrence for bad actors.

### Level 3: Changes are authorized

Summary: All changes to the source are approved by two trusted persons prior to submission.

Intended for: Enterprise projects and mature open source projects.

Requirements:

**[Code review]** All changes to the source are approved by two trusted persons prior to submission. User accounts that can perform code reviews MUST use two-factor authentication or its equivalent.
The following combinations are acceptable:

-   Contributor and reviewer are two different trusted persons.
-   Two different reviewers are trusted persons.

The code review system must meet the following requirements:

-   **[Informed review]** The reviewer is able and encouraged to make an informed decision about what they're approving. The reviewer MUST be presented with a full, meaningful content diff between the proposed revision and the previously reviewed revision. For example, it is not sufficient to just indicate that a file changed without showing the contents.
-   **[Context-specific approvals]** Approvals are for a specific context, such as a repo + target branch + revision in git. Moving fully reviewed content from one context to another still requires review. (Exact definition of "context" depends on the project, and this does not preclude well-understood automatic or reviewless merges, such as cutting a release branch.) Git example: If a fully reviewed commit in one repo is merged into a different repo, or a commit in one branch is merged into a different branch, then the merge still requires review.
-   **[Atomic change sets]** Changes are recorded in the change history as a single revision that consists of the net delta between the proposed revision and the parent revision. In the case of a nonlinear version control system, where a revision can have more than one parent, the diff must be against the "first common parent" between the parents. In other words, when a feature branch is merged back into the main branch, only the merge itself is in scope.

Trusted robots MAY be exempted from the code review process. It is RECOMMENDED that trusted robots so exempted be run only software built at Build L3+ from sources that meet Source L3.

**[Different persons]** The organization strives to ensure that no two user accounts correspond to the same person. Should the organization discover that it issued multiple accounts to the same person, it MUST act to rectify the situation. For example, it might revoke project privileges for all but one of the accounts and perform retroactive code reviews on any changes where that person's accounts are the author and/or code reviewer(s).

Benefits: A compromise of a single human or account does not result in compromise of the project, since all changes require review from two humans.
