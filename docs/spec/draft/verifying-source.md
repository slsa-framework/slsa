---
title: Verifying source
description: |
  SLSA uses attestations to indicate security claims associated with a repository revision, but attestations don't do anything unless somebody inspects them.
  SLSA calls that inspection verification, and this page describes how to verify properties of source revisions using their SLSA source provenance attestations.
  The intended audience is platform implementers, security engineers, and software consumers.
---

SLSA uses attestations to indicate security claims associated with a repository revision, but attestations don't do anything unless somebody inspects them.
SLSA calls that inspection **verification**, and this page describes how to verify properties of source revisions using their SLSA source provenance attestations.

Source Control Systems (SCSs) may issue attestations of the process that was used to create specific revisions of a repository.

A Verification Summary Attestation (VSA) can make verification more efficient by recording the result of prior verifications.
VSA may be issued by a VSA provider to make a SLSA source level determination based on the content of those attestations.

## How to verify SLSA a source revision

Verification of a source revision revolves around use of the
[Verification Summary Attestation (VSA)] that applies to that source revision
(a 'Source VSA') by the consumer of the source code. This shields the consumer
from the details of an SCS's bespoke provenance formats, and from the specifics
about the producer's change management process.

Instead the source consumer checks:

1.  If they trust the SCS that issued the VSA and if the VSA applies to the
   revision they've fetched.
2.  If the claims made in the VSA match their expectations for how the source
   should be managed.

[Verification Summary Attestation (VSA)]: source-requirements#summary-attestation

### Step 1: Check the SCS

First, check the SLSA Source level by comparing the artifact to its VSA and the
VSA to a preconfigured root of trust. The goal is to ensure that the VSA
actually applies to the artifact in question and to assess the trustworthiness
of the VSA. This mitigates threats within "B" and "C", depending on SLSA Source
level.

Once, when bootstrapping the verifier:

-   Configure the verifier's roots of trust, meaning the recognized SCS
    identities and the maximum SLSA Source level each SCS is trusted up to.
    Different verifiers MAY use different roots of trust for repositories. The
    root of trust configuration is likely in the form of a map from (SCS public
    key identity, VSA `verifier.id`) to (SLSA Source level).

    <details>
    <summary>Example root of trust configuration</summary>

    The following snippet shows conceptually how a verifier's roots of trust
    might be configured using made-up syntax.

    ```jsonc
    "slsaSourceRootsOfTrust": [
        // A SCS trusted at SLSA Source L3, using a fixed public key.
        {
            "publicKey": "HKJEwI...",
            "scsId": "https://somescs.example.com/slsa/l3",
            "slsaSourceLevel": 3
        },
        // A different SCS that claims to be SLSA Source L3,
        // but this verifier only trusts it to L2.
        {
            "publicKey": "tLykq9...",
            "scsId": "https://differentscs.example.com/slsa/l3",
            "slsaSourceLevel": 2
        },
        // A SCS that uses Sigstore for authentication.
        {
            "sigstore": {
                "root": "global",  // identifies fulcio/rekor roots
                "subjectAlternativeNamePattern": "https://github.com/slsa-framework/slsa-source-poc/.github/workflows/compute_slsa_source.yml@refs/tags/v*.*.*"
            },
            "scsId": "https://github.com/slsa-framework/slsa-source-poc/.github/workflows/compute_slsa_source.yml@refs/tags/v*.*.*",
            "slsaSourceLevel": 3,
        }
        ...
    ],
    ```

    </details>

Given a revision and its VSA:

1.  [Verify][validation-model] the envelope's signature using the roots of
    trust, resulting in a list of recognized public keys (or equivalent).
2.  [Verify][validation-model] that statement's `subject` matches the digest of
    the revision in question.
3.  Verify that the `predicateType` is `https://slsa.dev/verification_summary/v1`.
4.  Look up the SLSA Source Level in the roots of trust, using the recognized
    public keys and the `verifier.id`, defaulting to SLSA Source L1.

[validation-model]: https://github.com/in-toto/attestation/blob/main/docs/validation.md#validation-model

### Step 2: Check Expectations

Next, check that the revision's VSA meets your expectations in order to mitigate
[threat "B"].

In our threat model, the adversary has the ability to create revisions within
the repository and get consumers to fetch that revision.  The adversary is not
able to subvert controls implemented by the Producer and enforced by the SCS.
Your expectations SHOULD be sufficient to detect an un-official revision and
SHOULD make it more difficult for an adversary to create a malicious official
revision.

You SHOULD compare the VSA against expected values for at least the following
fields:

| What | Why
| ---- | ---
| Verifier (SCS) identity from [Step 1] | To prevent an adversary from substituting a VSA making false claims from an unintended SCS.
| `predicate.resourceUri` | To prevent an adversary from substituting a VSA for the intended repository (e.g. `git+https://github.com/IntendedOrg/hello-world`) for another (e.g. `git+https://github.com/AdversaryOrg/hello-world`)
| `subject.annotations.source_refs` | To prevent an adversary from substituting the intended revision from one branch (e.g. `release`) with another (e.g. `experimental_auth`).
| `verifiedLevels` | To ensure the expected controls were in place for the creation of the revision. E.g. `SLSA_SOURCE_LEVEL_3`, `ACME_STATIC_ANALYSIS`, etc...

[Threat "B"]: threats#b-modifying-the-source

### Step 3: Verify Evidence using Source Provenance [optional]

Optionally, at SLSA Source Level 3 and up, check the [source provenance
attestations](source-requirements#provenance-attestations) directly.

As the format and implementation of source provenance attestations are left to
the SCS, you SHOULD form expectations about the claims in source provenance
attestations and how they map to a revision's properties claimed in its VSA in
conjunction with the SCS and the producer.

## Forming Expectations

<dfn>Expectations</dfn> are known values that indicate the corresponding
revision is authentic. For example, an SCS may maintain a mapping between
repository branches & tags and the controls they claim to implement. That
mapping constitutes a set of expectations.

Possible models for forming expectations include:

-   **Trust on first use:** Accept the first version of the revision as-is. On
    each update, compare the old VSA to the new VSA and alert on any
    differences.

-   **Defined by producer:** The revision producer tells the verifier what their
    expectations ought to be. In this model, the verifier SHOULD provide an
    authenticated communication mechanism for the producer to set the revision's
    expectations, and there SHOULD be some protection against an adversary
    unilaterally modifying them. For example, modifications might require
    two-party control, or consumers might have to accept each policy change
    (another form of trust on first use).

It is important to note that expectations are tied to a *repository branch or
tag*, whereas a VSA is tied to an *revision*. Different revisions will have
different VSAs and the claims made by those VSAs may differ.

## Architecture options

There are several options (non-mutually exclusive) for where VSA verification
can happen: the build system at source fetch time, the package ecosystem at
build artifact upload time, the consumers at download time, or
via a continuous monitoring system. Each option comes with its own set of
considerations, but all are valid and at least one SHOULD be used.

More than one component can verify VSAs. For example, even if a builder verifies
source VSAs, package ecosystems may wish to verify the source VSAs for the
artifacts they host that claim to be built from that source (as indicated by the
build provenance).

## Common Source Controls and their Applications

Source attestations provide a trustworthy way to communicate security claims, but what should you be looking for in those claims?
Here are a few extremely common examples and important implementation details.

In addition to the requirements for SLSA Source L3, most organizations will require multiple of these controls as part of their required branch protections.

If an organization has indicated that use of these these controls are part of their repository's expectations, consumers SHOULD verify that the process was followed for the revision they are consuming.

### Changes are pre-authorized by two different authorized actors

Summary: All changes to the source are approved by two trusted actors prior to acceptance.

Intended for: Enterprise repositories and mature open source projects.

Benefits: A compromise of a single account does not result in compromise of the source.

Requirements:

#### Two authorized actors

All changes to the source are approved by two authorized actors prior to acceptance.
If the proposer is also an authorized actor, the proposer MAY approve their own proposal and count as one of the two required actors.

#### Different actors

It MUST NOT be possible for a single actor to control more than one voting accounts.

Should the organization discover that it issued multiple accounts to the same actors, it MUST act to rectify the situation.
For example, it might revoke project privileges for all but one of the accounts and perform retroactive code reviews on any changes where that actors' accounts are the author and/or code reviewer(s).

#### Post-approval changes allowed

When performing a review a reviewer may both approve the change and request modifications. Any modifications made need not reset the approval status of the change.  To protect against post-approval change see [Review Every Single Revision](#review-every-single-revision).

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

When a repo is cloned, all commits *reachable* from the main branch are fetched and become accessible from the local checkout.

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
-   ID 2: The revision created when the change is applied to the train branch. It represents the state of the protected branch *after other changes have been applied*.

It is important to note that no human or automatic review will have the chance to pre-approve ID2. This will appear to violate any organization policies that require pre-approval of changes before submission.
The SCS and the organization MUST protect this process in the same way they protect other artifact build pipelines.

At a minimum the SCS MUST issue an attestation that the revision id generated by a merged train is identical ("MERGESAME" in git terminology) to the state of the protected branch after applying each approved changeset in sequence.
No other content may be added or removed during this process.
