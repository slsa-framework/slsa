# SLSA Source Requirements

This document enumerates all of the detailed requirements for a source to meet
[SLSA](README.md).

## Definitions

A source **revision** is an immutable, coherent state of the source. In Git, for
example, a revision is a commit in the history reachable from a specific branch
in a specific repository. Different revisions within one repo MAY have different
levels. Example: the most recent revision on a branch meets SLSA 3 but very old
historical revisions before the cutoff do not.

A source repository has a set of "trusted persons" who own the project and a
"platform" that runs the infrastructure. For example, for
https://github.com/MarkLodato/dotfiles, there is just one "trusted person" (Mark
Lodato) and the platform is GitHub, while for
https://hg.mozilla.org/mozilla-central the set of "trusted persons" are those
with write access to the mozilla-central repository and the platform is
Mozilla's mercurial hosting.

## SLSA 1

There are no source requirements at SLSA 1.

## SLSA 1.5

A revision meets SLSA 1.5 if all of the following are true:

-   **[Version Controlled]** There exists a record of the history of changes
    that went into the revision. Each change must contain: the identities of the
    uploader and reviewers (if any), timestamps of the reviews (if any) and
    submission, the change description / justification, the content of the
    change, and the parent revisions.

    -   **[Immutable Reference]** There exists a way to indefinitely reference
        this particular, immutable revision. In git, this is the {repo URL +
        branch/tag/ref + commit ID}.

Almost any popular version control system meets this requirement, such as git,
Mercurial, Subversion, or Perforce.

NOTE: This does NOT require that the code, uploader/reviewer identities, or
change history be made public. Rather, some organization must attest to the fact
that these requirements are met, and it is up to the consumer whether this
attestation is sufficient.

## SLSA 2

_NOTE: The SLSA 2 requirements are subject to change._

A revision meets SLSA 2 if all of the following are true:

-   The revision meets [SLSA 1.5](#slsa-15).

-   **[Verified History]** Every change in the revision's history has at least
    one strongly authenticated actor identities (author, uploader, reviewer,
    etc.) and timestamp. It must be clear which identities were verified, and
    those identities must use
    [two-step verification](https://www.google.com/landing/2step/) or similar.
    (Exceptions noted below.)

    -   **[First-Parent History]** In the case of a non-linear version control
        system, where a revision can have more than one parent, only the "first
        parent history" is in scope. In other words, when a feature branch is
        merged back into the main branch, only the merge itself is in scope.
    -   **[Historical Cutoff]** There is some TBD exception to allow existing
        projects to meet SLSA 2/3 even if historical revisions were present in
        the history. Current thinking is that this could be either last N months
        or a platform attestation guaranteeing that future changes in the next N
        months will meet the requirements.

-   **[Retained Indefinitely]** The revision and its change history are
    preserved indefinitely and cannot be deleted, except when subject to an
    established and transparent policy for obliteration, such as a legal or
    policy requirement.

    -   **[Immutable History]** It must not be possible for persons to delete or
        modify the history, even with multi-party approval, except by trusted
        platform admins with two-party approval following the obliterate policy.
    -   **[Limited Retention for SLSA 2]** At SLSA 2 (but not 3), it is
        acceptable for the retention to be limited to 18 months, as attested by
        the source control platform.
        -   Example: If a commit is made on 2020-04-05 and then a retention
            attestation is generated on 2021-01-01, the commit must be retained
            until at least 2022-07-01.

## SLSA 3

_NOTE: The SLSA 3 requirements are subject to change._

A revision meets SLSA 3 if all of the following are true:

-   The revision meets [SLSA 2](#slsa-2).

-   **[Two-Person Reviewed]** Every change in the revision's history was agreed
    to by two trusted persons prior to submission, and both of these trusted
    persons were strongly authenticated. (Exceptions from [Verified History]
    apply here as well.)

    -   The following combinations are acceptable:
        -   Uploader and reviewer are two different trusted persons.
        -   Two different reviewers are trusted persons.
    -   **[Different Persons]** The platform ensures that no person can use
        alternate identities to bypass the two-person review requirement.
        -   Example: if a person uploads with identity X then reviews with alias
            Y, the platform understands that this is the same person and does
            not consider the review requirement satisfied.
    -   **[Informed Review]** The reviewer is able and encouraged to make an
        informed decision about what they're approving. For example, it is not
        acceptable to only display "path X was updated from hash abcd to hash
        1234" because the reviewer would not be able to differentiate between a
        benign change and a malicious one. Instead, the reviewer should be
        presented with a diff between the proposed revision and the previous
        SLSA 3 revisions.
    -   **[Context-specific Approvals]** Approvals are for a specific context,
        such as a repo + branch in git. Moving fully reviewed content from one
        context to another still requires review. (Exact definition of "context"
        depends on the project, and this does not preclude well-understood
        automatic or reviewless merges, such as cutting a release branch.)
        -   Git example: If a fully reviewed commit in one repo is merged into a
            different repo, or a commit in one branch is merged into a different
            branch, then the merge still requires review.
