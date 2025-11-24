---
title: "Source: Example controls"
description: "This page provides examples of additional controls that
  organizations may want to implement as they adopt the SLSA Source track."
---

At SLSA Source L3+ organizations are allowed and encouraged to define their own
controls that go over and above specific requirements outlined by SLSA. This
page provides some examples of what these additional controls could be.

If an organization has indicated that use of these controls is part of
their repository's expectations, consumers SHOULD be able to verify that the
process was followed for the revision they are consuming by examining the
[summary](./source-requirements#source-verification-summary-attestation) or
[source provenance](./source-requirements#source-provenance-attestations)
attestations.

> For example: consumers can look for the related `ORG_SOURCE` properties in
> the `verifiedLevels` field of the [summary
> attestation](./source-requirements#source-verification-summary-attestation).

## Expert Code Review

<dl class="as-table">
<dt>Summary<dd>

All changes to the source are pre-approved by experts.

<dt>Intended for<dd>

Enterprise repositories and mature open source projects.

<dt>Benefits<dd>

Prevents mistakes by developers unfamiliar with the area.

</dl>

### Requirements

-   **Code ownership**

    Each part of the source MUST have a clearly identified set of experts.

-   **Approvals from all relevant experts**

    For each portion of the source modified by a change proposal, pre-approval
    MUST be granted by a member of the defined expert set. An approval from an
    actor that is a member of multiple expert groups may satisfy the
    requirement for all groups in which they are a member.

## Review Every Single Revision

<dl class="as-table">
<dt>Summary<dd>

The final revision was reviewed by experts prior to submission.

<dt>Intended for<dd>

The highest-of-high-security-posture repos.

<dt>Benefits<dd>

Provides maximum chance for experts to spot problems.

</dl>

### Requirements

-   **Reset votes on all changes**

    If the proposal is modified after receiving expert approval, all previously
    granted approvals MUST be revoked. A new approval MUST be granted from ALL
    required reviewers.

    The new approval MAY be granted by an actor who approved a previous
    iteration.

## Automated testing

<dl class="as-table">
<dt>Summary<dd>

The final revision was validated by automated tests.

<dt>Intended for<dd>

All organizations and repositories.

<dt>Benefits<dd>

Improves accuracy, prevents errors, and reduces human load.

</dl>

### Requirements

The organization MUST configure a branch protection rule to require that only
revisions with passing test results can be pointed-to by the branch.

Automatic tests SHOULD be executed in a trustworthy environment (see SLSA
build track).

Results of each test (or an aggregate) MUST be collected by the change review
tool and made available for verification.

Tests SHOULD be run against a revision created for testing by merging the topic
branch (containing the proposed changes) into the target branch.

Use of the proposed merge commit should be preferred to using the tip of the
topic branch.

## Every revision reachable from a branch was approved

<dl class="as-table">
<dt>Summary<dd>

New revisions are created based ONLY on approved changes.

<dt>Intended for<dd>

All organizations and repositories.

<dt>Benefits<dd>

Prevents attacks that hide malicious, unreviewed commits.

</dl>

### Context

In many organizations, it is normal to review only the "net difference"
between the tip of the topic branch and the "best merge base", the closest
shared commit between the topic and target branches computed at the time of
review.

The topic branch may contain many commits of which not all were intended to
represent a shippable state of the repository.

If a repository merges branches with a standard merge commit, all those
unreviewed commits on the topic branch will become "reachable" from the
protected branch by virtue of the multi-parent merge commit.

When a repo is cloned, all commits _reachable_ from the main branch are
fetched and become accessible from the local checkout.

This combination of factors allows attacks where the victim performs a `git
clone` operation followed by a `git reset --hard <unreviewed revision ID>`.

### Requirements

-   **Informed Review**

    The reviewer is able and encouraged to make an informed decision about
    what they're approving. The reviewer MUST be presented with a full,
    meaningful content diff between the proposed revision and the
    previously reviewed revision.

    It is not sufficient to indicate that a file changed without showing
    the contents.

-   **Use only rebase operations on the protected branch**

    Require a squash merge strategy for the protected branch.

    To guarantee that only commits representing reviewed diffs are cloned,
    the SCS MUST rebase (or "squash") the reviewed diff into a single new
    commit (the "squashed" commit) that has only a single parent (the
    revision previously pointed-to by the protected branch). This is
    different than a standard merge commit strategy which would cause all
    the user-contributed commits to become reachable from the protected
    branch via the second parent.

    It is not acceptable to replay the sequence of commits from the topic
    branch onto the protected branch. The intent is to reduce the accepted
    changes to the exact diffs that were reviewed. Constituent commits of
    the topic branch may or may not have been reviewed on an individual
    basis, and should not become reachable from the protected branch.

## Immutable Change Discussion

<dl class="as-table">
<dt>Summary<dd>

The discussion around a change is preserved and immutable.

<dt>Intended for<dd>

Large orgs, or where discussion is vital to change management.

<dt>Benefits<dd>

Enables future education, forensics, and security auditing.

</dl>

### Requirements

The SCS SHOULD record a description of the proposed change and all discussions
/ commentary related to it.

The SCS MUST link this discussion to the revision itself. This is regularly
done via commit metadata.

All collected content SHOULD be made immutable if the change is accepted. It
SHOULD NOT be possible to edit the discussion around a revision after it has
been accepted.

## Merge trains

<dl class="as-table">
<dt>Summary<dd>

A buffer branch (or "train") collects a certain number of approved changes
before merging into the protected branch.

<dt>Intended for<dd>

Large organizations with high-velocity repositories where the protected branch
needs to remain stable for longer periods.

<dt>Benefits<dd>

Allows more time for human and automatic code review by stabilizing the
protected branch.

</dl>

### Requirements

Large organizations must keep the number of updates to key protected branches
under certain limits to allow time for code review to happen. For example, if
a team tries to merge 60 change requests per hour into the `main` branch, the
tip of the `main` branch would only be stable for about 1 minute. This would
leave only 1 minute for a new diff to be both generated and reviewed before
it becomes stale again.

The normal way to work in this environment is to create a buffer branch
(sometimes called a "train") to collect a certain number of approved changes.
In this model, when a change is approved for submission to the protected
branch, it is added to the train branch instead. After a certain amount of
time, the train branch will be merged into the protected branch. If there are
problems detected with the contents on the train branch, it's normal for the
whole train to be abandoned and a new train to be formed. Approved changes
will be re-applied to a new train in this scenario.

The key benefit to this approach is that the protected branch remains stable
for longer, allowing more time for human and automatic code review. A key
downside to this approach is that organizations will not know the final
revision ID that represents a change until the entire train process completes.

A change review process will now be associated with multiple distinct
revisions.

-   ID 1: The revision which was reviewed before concluding the change review
    process. It represents the ideal state of the protected branch applying
    only this proposed change.
-   ID 2: The revision created when the change is applied to the train branch.
    It represents the state of the protected branch _after other changes have
    been applied_.

It is important to note that no human or automatic review will have the chance
to pre-approve ID2. This will appear to violate any organization policies that
require pre-approval of changes before submission. The SCS and the
organization MUST protect this process in the same way they protect other
artifact build pipelines.

At a minimum the SCS MUST issue an attestation that the revision ID generated
by a merged train is identical ("MERGESAME" in git terminology) to the state
of the protected branch after applying each approved changeset in sequence.
No other content may be added or removed during this process.
