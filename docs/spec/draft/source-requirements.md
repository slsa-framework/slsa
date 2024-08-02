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
| Branch | A named pointer to a revision. Branches may be modified by authorized actors. In git, cloning a repo will download all revisions in the history of the "default" branch to the local machine. Branches may have different security requirements.
| Change | A set of modifications to the source in a specific context. Can be proposed and reviewed before being accepted.
| Change History | A record of the history of revisions that preceded a specific revision.
| Push / upload / publish | When an actor authenticates to an SCP to add or modify content. Typically makes a new revision reachable from a branch.
| Review / approve / vote | When an actor authenticates to a change review tool to leave comments or endorse / reject the source change proposal they were presented.

## Source Roles

| Role | Description
| --- | ---
| Administrator | A human who can perform privileged operations on one or more projects. Privileged actions include, but are not limited to, modifying the change history and modifying project- or organization-wide security policies.
| Trusted person | A human who is authorized by the organization to propose and approve changes to the source.
| Trusted robot | Automation with an authentic identity that is authorized by the organization to propose and/or approve changes to the source.
| Untrusted person | A human who has limited access to the project. They MAY be able to read the source. They MAY be able to propose or review changes to the source. They MAY NOT approve changes to the source or perform any privileged actions on the project.
| Proposer | An actor that proposes (or uploads) a particular change to the source.
| Reviewer / Voter / Approver | An actor that reviews (or votes on) a particular change to the source.
| Merger | An actor that applies a change to the source. This actor may be the proposer.

## Safe Expunging Process

Administrators have the ability to expunge (remove) content from a repository and its change history without leaving a record of the removed content.
This includes changing files, history, or changing references in git and is used to accommodate legal or privacy compliance requirements.
When used as an attack, this is called “repo hijacking” (or “repo-jacking”) and is one of the primary threats source provenance attestations protect against.

TODO: Determine how organizations can provide transparency around this process.

## Levels

### Level 1: Immutable revisions and Change Management Processeses

Summary: The source is stored and managed through a modern version control system and modified via a codified revision process.

Intended for: Organizations wanting to easily and quickly gain some benefits of SLSA and better integrate with the SLSA ecosystem without changing their source workflows.

Benefits:
Version control solves software development challenges ranging from change attribution to effective collaboration.
It is a software development best practice with more benefits than we can discuss here.

Requirements: The combination of SCP and VCS MUST provide:

#### Revisions are immutable and uniquely identifiable

There exists a deterministic way to identify a particular revision.

This is usually a combination of the repository ID and revision ID.
When the revision ID is a digest of the content of the revision (as in git) nothing more is needed.
When the revision ID is a number or otherwise not a digest, then the SCP MUST document how the immutability of the revision is established.
See also [Use cases for non-cryptographic, immutable, digests](https://github.com/in-toto/attestation/blob/main/spec/v1/digest_set.md#use-cases-for-non-cryptographic-immutable-digests).

#### Identity Management

There exists an identity management system or some other means of identifying actors.
This system may be a federated authentication system (AAD, Google, Okta, GitHub, etc) or custom implementation (gittuf, gpg-signatures on commits, etc).
The SCP MUST document how actors are identified for the purposes of attribution.

Activities conducted on the SCP SHOULD be attributed to authenticated identities.

#### Trusted revision process

There exists a trusted mechanism for modifying the source pointed-to by a [branch](#definitions).
It MUST NOT be possible to modify the content of a branch without following the documented process.

An example of a revision process could be: all proposed changes MUST be pre-approved by code experts before being included on a protected branch in git.

The revision process MUST specify the branch a contributor is proposing to update.

### Level 2: Provenance

Summary: A consumer can ask the SCP for everything it knows about a specific revision of a repository. The information is provided in a standardized format.

Intended for: Organizations that want strong guarantees and auditability of their change management processes.

Benefits: Provides reliable information to policy enforcement tools.

Requirements:

#### Source provenance attestation

Source attestations are associated with the revision identifier delivered to consumers and are a record of everything the SCP knows about the revision's creation process.

For example, if you perform a `git clone` operation, a consumer MUST be able to fetch the source attestation documents using the commit id at the tip of the checked-out branch.

Failure of the SCP to return source attestations for the commit id is the same as saying the revision was not known to have been produced on the SCP.

#### Trusted revision process requirements

The change management tool MUST provide at a minimum:

##### Strong Authentication

The strongly authenticated identity used to login to the SCP MUST be used for the generation of source provenance attestations.
This is typically the identity used to push to a git server.

Other forms of identity MAY be included as informational.
Examples include a git commit "author" and "committer" and a gpg signature's "user id."
These forms of identity are user-provided and not typically verified by the source provenance attestation issuer.

See [source roles](#source-roles).

##### Change context

The change management tool MUST record the "target" context for the change proposal and the previous / current revision in that context.

##### Informed Review

The change management tool MUST record the specific code change proposal (a "diff" in git) displayed to reviewers (if any) or instructions to recreate it.
The reviewer is able and encouraged to make an informed decision about what they're approving.
The reviewer MUST be presented with a full, meaningful content diff between the proposed revision and the previously reviewed revision.
It is not sufficient to indicate that a file changed without showing the contents.

##### Verified Timestamps

The change management tool MUST record timestamps for all contributions and review activities.
User-provided values MUST NOT be used.

##### Human-readable change description

The change management tool SHOULD record a description of the proposed change and all discussions / commentary related to it.
All collected content SHOULD be made immutable if the change is accepted.

## Choose your own adventure

Now that you have a trustworthy way to communicate your security claims, what should you be looking for in those claims?
Here are a few extremely common examples.

### Changes are pre-authorized by two different authorized actors

Summary: All changes to the source are approved by two trusted actors prior to acceptance.

Intended for: Enterprise repositories and mature open source projects.

Benefits: A compromise of a single account does not result in compromise of the source.

Requirements:

#### Two authorized actors

All changes to the source are approved by two authorized actors prior to submission.
If the proposer is also an authorized actor, the proposer MAY approve their own proposal and count as one of the two required actors.

#### Different actors

It MUST NOT be possible for a single actor to control more than one voting accounts.

Should the organization discover that it issued multiple accounts to the same actors, it MUST act to rectify the situation.
For example, it might revoke project privileges for all but one of the accounts and perform retroactive code reviews on any changes where that actors' accounts are the author and/or code reviewer(s).

### Expert Code Review

Summary: All changes to the source are pre-approved by experts in those areas.

Intended for: Enterprise repositories and mature open source projects.

Benefits: Prevents mistakes made by developers who are unfamiliar with the area.

Requirements:

#### Code ownership

Each part of the source MUST have a clearly identified set of experts.

#### Approvals from all relevant experts

For each portion of the source modified by a change proposal, pre-approval MUST be granted by a member of the defined expert set.
A approval from an actor that is a member of multiple expert groups may satisfy the requirement for all groups in which they are a member.

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

Summary: The final revision was validated against a suite of vetted automated tests.

Intended for: All organizations and repositories.

Benefits: Automatic testing has many benefits, including improved accuracy, error prevention and reduced workload on your human developers.

Requirements: For each configured automatic test, results MUST be collected by the change review tool and included in the source provenance attestation.

For example, you may configure a "required GitHub Actions workflow" to run your test suites.
Only change proposals with a successful workflow run id would be allowed to be submitted.
