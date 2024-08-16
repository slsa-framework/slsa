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
| Repository / Repo | A uniquely identifiable instance of a VCS hosted on an SCP. The repository controls access to the Source in the version control system. The objective of a repository is to reflect the intent of the organization that controls it.
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

On the git VCS, force pushes allow you to remove data from a branch.
If a branch has been identified as consumable branch, force pushes to that branch must follow the safe expunging process.

TODO: Determine how organizations can provide transparency around this process.
At a minimum the organization would need to declare why data was removed from the branch.

The goal of this sections is to document that this process is allowed.
Different organizations and tech stacks may have different approaches to the problem.

Scenarios that need to be addressed:

### Legal Takedowns

A DMCA takedown request will be addressed by following an agreed-upon process.
That process should be documented itself and followed.
It may be the case that the specific set of commits targeted by the takedown can be expunged in ways that do not impact revisions.

### Commit metadata rewrites

A team may decide that all reachable commits in the history of a revision need to follow a new metadata convention.
In git VCS, compliance with this new policy will require history to be rewritten (commit metadata is included in the computation of the revision id).
Policies in this category include things like commit signatures, author / committer formatting restrictions, closed-issue-linkage, etc.

### Repository renames

When a repo is transferred to a new organization ("donated"), or if a repo must be renamed or otherwise have its url changed within the same org, attestations for previous revisions of this repo will no longer be matched because the combination of the repository id and the revision id will have changed.

## Levels

Many examples in this document use the [git version control system](https://git-scm.com/), but use of git is not a requirement to meet any level on the SLSA source track.

### Level 1: Version controlled

Summary:
The source is stored and managed through a modern version control system.

Intended for: Organizations currently storing source in non-standard ways who want to quickly gain some benefits of SLSA and better integrate with the SLSA ecosystem with minimal impact to their current workflows.

Benefits:
Migrating to the appropriate tools is an important first step on the road to operational maturity.

Requirements:

#### Use modern tools

The organization MUST manage the source using tools specifically designed to manage source code.
Tools like git, Perforce, Subversion are great examples.
They may be self-hosted or hosted in the cloud using vendors like GitLab, GitHub, Bitbucket, etc.

When self-hosting a solution, local, unauthenticated storage is not acceptable.

Branch protection is not required, nor are there any other constraints on the configuration of the tools.

#### Canonical location

The source MUST have a location where the "official" revisions are stored and managed.

#### Revisions are immutable and uniquely identifiable

This requirement ensures that a consumer can determine that the source revision they have is the same as a canonical revision.
The combination of SCP and VCS MUST provide a deterministic way to identify a particular revision.

Virtually all modern tools provide this guarantee via a combination of the repository ID and revision ID.

##### Repository IDs

The repository ID is generated by the SCP and MUST be unique in the context of that instance of the SCP.

##### Revision IDs

When the revision ID is a digest of the content of the revision (as in git) nothing more is needed.
When the revision ID is a number or otherwise not a digest, then the SCP and VCS MUST document how the immutability of the revision is established.
The same revision ID MAY be present in multiple repositories.
See also [Use cases for non-cryptographic, immutable, digests](https://github.com/in-toto/attestation/blob/main/spec/v1/digest_set.md#use-cases-for-non-cryptographic-immutable-digests).

### Level 2: Branch History

Summary:
Clarifies which branches in a repo are consumable and guarantees that all changes to protected branches are recorded.

Intended for:
All organizations of any size producing software of any kind.

Benefits:
Allows source consumers to track changes to the software over time and attribute those changes to the people that made them.

Requirements:

#### Branches

If the SCP and VCS combination supports multiple branches, the organization MUST indicate which branches are intended for consumption.
This may be implied or explicit.

For example, an organization may declare that the `default` branch of a repo contains revisions intended for consumption my protected it.

They may also declare that branches named with the prefix `refs/heads/releases/*` contain revisions held to an even higher standard.

They may also declare all revisions are intended to be consumed "except those reachable only from branches beginning with `refs/heads/users/*`."
This is a typical setup for teams who leverage code review tools.

##### Continuity

For all branches intended for consumption, whenever a branch is updated to point to a new revision, that revision MUST document how it related to the previous revision.
Exceptions are allowed via the [safe expunging process](#safe-expunging-process).

On VCS like git, the organization MUST enable branch protections that prohibit updating the branch to point to revisions that are not direct descendants of the current revision.
At a minimum, this typically means preventing "force pushes" and "branch deletion."

It MUST NOT be possible to delete the entire repository (including all branches) and replace it with different source.
Exceptions are allowed via the [safe expunging process](#safe-expunging-process).

#### Identity Management

There exists an identity management system or some other means of identifying actors.
This system may be a federated authentication system (AAD, Google, Okta, GitHub, etc) or custom implementation (gittuf, gpg-signatures on commits, etc).
The SCP MUST document how actors are identified for the purposes of attribution.

Activities conducted on the SCP SHOULD be attributed to authenticated identities.

### Level 3: Source Provenance Attestations

Summary:
A consumer can ask the SCP for everything it knows about a specific revision of a repository.
The information is provided in a documented and tamper-resistant format.

Intended for:
Organizations that want strong guarantees and auditability of their change management processes.

Benefits:
Provides reliable information to policy enforcement tools.

Requirements:

#### Source attestations

A source attestation contains information about how a specific revision was created and how it came to exist in its present context.
They are associated with the revision identifier delivered to consumers and are a statement of fact from the perspective of the SCP.

If a consumer is authorized to access source on a particular branch, they MUST be able to fetch the source attestation documents for revisions in the history of that branch.

It is possible that an SCP can make no claims about a particular revision.
For example, this would happen if the revision was created on another SCP, or if the revision was not the result of an accepted change management process.

#### Change management process

The repo must define how the content of a [branch](#definitions) is allowed to change.
This is typically done via the configuration of branch protection rules.
It MUST NOT be possible to modify the content of a branch without following its documented process.

SLSA Source Level 2 ensures that all changes are recorded and attributable to an actor.
SLSA Source Level 3 ensures that the documented process was followed.

The change management tool MUST be able to authoritatively state that each new revision reachable from the protected branch represents only the changes reviewed via the process.

The change management tool MUST provide at a minimum:

##### Strong Authentication

User accounts that can modify the source or the project's configuration must use multi-factor authentication or its equivalent.
This strongly authenticated identity MUST be used for the generation of source provenance attestations.
The SCP MUST declare which forms of identity it considers to be trustworthy for this purpose.
For cloud-based SCPs, this will typically be the identity used to push to a git server.

Other forms of identity MAY be included as informational.
Examples include a git commit's "author" and "committer" fields and a gpg signature's "user id."
These forms of identity are user-provided and not typically verified by the source provenance attestation issuer.

See [source roles](#source-roles).

##### Context

The change management tool MUST record the specific code change (a "diff" in git) or instructions to recreate it.
In git, this typically defined to be three revision IDs: the tip of the "topic" branch, the tip of the target branch, and closest shared ancestor between the two (such as determined by `git-merge-base`).

The change management tool MUST record the "target" context for the change proposal and the previous revision in that context.
For example, for the git version control system, the change management tool MUST record the branch name that was updated.

Branches may have differing security postures, and a change can be approved for one context while being unapproved for another.

##### Verified Timestamps

The change management tool MUST record timestamps for all contributions and review-related activities.
User-provided timestamps MUST NOT be used.

## Communicating source levels

SLSA source level details are communicated using attestations.
These attestations either refer to a source revision itself or provide context needed to evaluate an attestation that _does_ refer to a revision.

There are two broad categories of source attestations within the source track:

1.  Summary attestations: Used to communicate to downstream users what high level security properties a given source revision meets.
2.  Full attestations: Provide trustworthy, tamper-proof, metadata with the necessary information to determine what high level security properties a given source revision has.

To provide interoperability and ensure ease of use, it's essential that the summary attestations are applicable across all Source Control Platforms.
Due to the significant differences in how SCPs operate and how they may chose to meet the Source Track requirements it is preferable to
allow for flexibility with the full attestations.  To that end SLSA leaves full attestations undefined and up to the SCPs to determine
what works best in their environment.

### Summary attestation

Summary attestations are issued by some authority that has sufficient evidence to make the determination of a given
revision's source level.  Summary attestations convey properties about the revision as a whole and summarize properties computed over all
the changes that contributed to that revision over its history.

The source track issues summary attestations using [Verification Summary Attestations (VSAs)](./verification_summary.md) as follows:

1.  `subject.uri` SHOULD be set to a human readable URI of the revision.
2.  `subject.digest` MUST include the revision identifier (e.g. `gitCommit`) and MAY include other digests over the contents of the revision (e.g. `gitTree`, `dirHash`, etc...).
SCPs that do not use cryptographic digests MUST define a canonical type that is used to identify immutable revisions (e.g. `svn_revision_id`)[^1].
3.  `subject.annotations.source_branches` SHOULD be set to a list of branches that pointed to this revision at any point in their history.
    -   git branches MUST be fully qualified (e.g. `refs/head/main`) to reduce the likelyhood of confusing downstream tooling.
4.  `resourceUri` MUST be set to the URI of the repository, preferably using [SPDX Download Location](https://spdx.github.io/spdx-spec/v2.3/package-information/#77-package-download-location-field).
E.g. `git+https://github.com/foo/hello-world`.
5.  `verifiedLevels` MUST include the SLSA source track level the verifier asserts the revision meets. One of `SLSA_SOURCE_LEVEL_0`, `SLSA_SOURCE_LEVEL_1`, `SLSA_SOURCE_LEVEL_2`, `SLSA_SOURCE_LEVEL_3`.
MAY include additional properties as asserted by the verifier.  The verifier MUST include _only_ the highest SLSA source level met by the revision.
6.  `dependencyLevels` MAY be empty as source revisions are typically terminal nodes in a supply chain.

Verifiers MAY issue these attestations based on their understanding of the underlying system (e.g. based on design docs, security reviews, etc...),
but at SLSA Source Level 3 MUST used tamper-proof [full attestations](#full-attestations) appropriate to their SCP when making the assessment.

#### Example

```json
"_type": "https://in-toto.io/Statement/v1",
"subject": [{
  "uri": "https://github.com/foo/hello-world/commit/9a04d1ee393b5be2773b1ce204f61fe0fd02366a",
  "digest": {"gitCommit": "9a04d1ee393b5be2773b1ce204f61fe0fd02366a"},
  "annotations": {"source_branches": ["refs/heads/main", "refs/heads/release_1.0"]}
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

#### How to verify

-   VSAs for source revisions MUST follow [the standard method of VSA verification](./verification_summary.md#how-to-verify).
-   Users SHOULD check that an allowed branch is listed in `subject.annotations.source_branches` to ensure the revision is from an appropriate context within the repository.
-   Users SHOULD check that the expected `SLSA_SOURCE_LEVEL_` is listed within `verifiedLevels`.
-   Users MUST ignore any unrecognized values in `verifiedLevels`.

### Full attestations

Full attestations provide tamper-proof evidence (ideally signed in-toto attestations) that can be used to determine
what SLSA Source Level or other high level properties a given revision meets
This evidence can be used by an authority as the basis for issuing a [Summary Attestation](#summary-attestation).

SCPs and VCSes may have different methods of operating that necessitate different forms of evidence.
E.g. GitHub based workflows may need different evidence than Gerrit based workflows, which would both likely be different from workflows that
operate over Subversion repositories.

Examples of evidence:

-   A TBD attestation which describes the revision's parents and the actors involved in creating this revision.
-   A "code review" attestation which describes the basics of any code review that took place.
-   An "authentication" attestation which describes how the actors involved in any revision were authenticated.
-   A [Vuln Scan attestation](https://github.com/in-toto/attestation/blob/main/spec/predicates/vuln.md)
    which describes the results of a vulnerability scan over the contents of the revision.
-   A [Test Results attestation](https://github.com/in-toto/attestation/blob/main/spec/predicates/test-result.md)
 which describes the results of any tests run on the revision.
-   An [SPDX attestation](https://github.com/in-toto/attestation/blob/main/spec/predicates/spdx.md)
 which provides a software bill of materials for the revision.

TODO: Can we define or recommend any canonical formats?

[^1]: in-toto attestations allow non-cryptographic digest types: https://github.com/in-toto/attestation/blob/main/spec/v1/digest_set.md#supported-algorithms.
