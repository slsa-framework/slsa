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

The SLSA Source Track mitigates [Threat A ("Submit unauthorized change")](/spec/v1.0/threats#a-submit-unauthorized-change), scoped to a code repository and the organization that owns that repository. Concretely: an attacker must compromise the accounts of two organization members to publish code in a Source Level 3-conformant repository, and the evidence of those unauthorized changes cannot be destroyed without further attacks.

## Source model

The Source track is scoped to a single project that is controlled by some organization. That organization determines what Source level should apply to the project and administers technical controls to enforce that level.

| Term | Description
| --- | ---
| Source | An identifiable set of text and binary files and associated metadata usually used as input for the build system (see SLSA Build Track).
| Organization | A collection of people who collectively create the Source. Examples of organizations include an open-source projects, a company, or a team within a company.
| Change | A set of modifications to one or more source files and associated metadata. Change metadata MUST include any information required to situate the change in relation to other changes (e.g. parent revision).
| Version Control System | Software for tracking and managing changes to source. Git and Subversion are examples of version control systems.
| Revision | A specific identifier provided by the version control system that identifies a given state of the source. As an example, you can identify a git revision by its tree hash.
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

## Source Attestations

There are two uses for source attestations within the source track:

1.  Assertions: Communicate to downstream users what high level security properties a given source revision meets.
2.  Evidence: Provide trustworthy metadata which can be used to determine what high level security properties a given source revision meets.

To provide interoperability and ensure ease of use, it's essential that the 'assertions' are applicable across all Source Control Platforms.
Due to the significant differences in how SCPs operate and how they may chose to meet the Source Track requirements it is preferable to
allow for flexibility with 'evidence' attestations.  To that end SLSA leaves 'evidence' attestations undefined and up to the SCPs to determine
what works best in their environment.

### Source Level Assertions

Source level assertions are issued by the SCP or some other authority that has sufficient evidence to make the determination of a given
revision's source level.

These assertions are communicated in [Verification Summary Attestations (VSAs)](./verification_summary.md) as follows:

1.  `subject.uri` SHOULD be set to a human readable URI of the revision.
2.  `subject.digest` MUST include the revision identifier (e.g. `gitCommit`) and MAY include other digests over the contents of the revision (e.g. `gitTree`, `dirHash`, etc...).
SCPs that do not use cryptographic digests MUST define a canonical type that is used to identify immutable revisions (e.g. `svn_revision_id`)[^1].
3.  `subject.annotations.source_branches` SHOULD be set to a list of branches that pointed to this revision at any point in their history.
4.  `resourceUri` MUST be set to the URI of the repository, preferably using [SPDX Download Location](https://spdx.github.io/spdx-spec/v2.3/package-information/#77-package-download-location-field).
E.g. `git+https://github.com/foo/hello-world`.
5.  `verifiedLevels` MUST include the SLSA source track level the issuer asserts the revision meets. One of `SLSA_SOURCE_LEVEL_0`, `SLSA_SOURCE_LEVEL_1`, `SLSA_SOURCE_LEVEL_2`, `SLSA_SOURCE_LEVEL_3`.
MAY include additional properties as asserted by the issuer.
6.  `dependencyLevels` MAY be empty as source revisions are typically terminal nodes in a supply chain.

Source Level Assertion issuers MAY issue assertions based on their understanding of the underlying system, but SHOULD prefer to issue assertions based on Source Level Evidence appropriate to their SCP.

#### Example

```json
"_type": "https://in-toto.io/Statement/v1",
"subject": [{
  "uri": "https://github.com/foo/hello-world/commit/9a04d1ee393b5be2773b1ce204f61fe0fd02366a",
  "digest": {"gitCommit": "9a04d1ee393b5be2773b1ce204f61fe0fd02366a"},
  "annotations": {"source_branches": ["main", "release_1.0"]}
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

[^1]: in-toto attestations allow non-cryptographic digest types: https://github.com/in-toto/attestation/blob/main/spec/v1/digest_set.md#supported-algorithms.
