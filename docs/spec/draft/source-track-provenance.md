---
title: "Source Track: Provenance
description: This page covers the distribution and verification of provenance metadata in the form of SLSA attestations for the source track. 
---

# {Source Track: Provenance}

**About this page:** the *Source Track: Provenance* page covers the distribution and verification of provenance metadata in the form of SLSA attestations for the source track. 

**Intended audience:** source control system implementers and security engineers

**Topics covered:** source track provenance

**Internet standards:** [RFC 2119](https://www.rfc-editor.org/rfc/rfc2119)

>The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD",
"SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be
interpreted as described in [RFC 2119](https://www.rfc-editor.org/rfc/rfc2119).

**For more information, see:** {optional}

## Overview of Source Track Provenance

<tr id="source-provenance"><td>Source Provenance <a href="#source-provenance">🔗</a><td>

[Source Provenance](#source-provenance-attestations) are attestations that
contain information about how a specific revision was created and how it came to
exist on a protected branch or how a tag came to point at it. They are
associated with the revision identifier delivered to consumers and are a
statement of fact from the perspective of the SCS. The SCS MUST document the
format and intent of all Source Provenance attestations it produces.

Source Provenance MUST be created contemporaneously with the branch being
updated such that they provide a credible, auditable, record of changes.

If a consumer is authorized to access a revision, they MUST be able to access the
corresponding Source Provenance documents for that revision.

It is possible that an SCS can make no claims about a particular revision.

> For example, this would happen if the revision was created on another SCS,
on an unprotected branch (such as a `topic` branch), or if the revision was not
the result of the expected process.

<td><td>✓<td>✓<td>✓
<tr id="protected-refs"><td>Protected Named References <a href="#protected-refs">🔗</a><td>

The SCS MUST provide the ability for an organization to enforce customized technical controls for Named References.

The SCS MUST provide a mechanism for organizations to indicate which Named
References should be protected by technical controls.

> For example, the organization may instruct the SCS to protect `main` and
`refs/heads/releases/*`, but not `refs/heads/experimental/*` using branch
protection rules (e.g. [GitHub](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets),
[GitLab](https://docs.gitlab.com/ee/user/project/repository/branches/protected.html))
or via the application and verification of [gittuf](https://github.com/gittuf/gittuf)
policies.

> For another example, the organization may instruct the SCS to prevent the deletion of
all `refs/tags/releases/*` using tag protection rules
(e.g. [GitHub](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets),
[GitLab](https://docs.gitlab.com/user/project/protected_tags/))
or via the application and verification of [gittuf](https://github.com/gittuf/gittuf)
policies.

The SCS MUST

-   Record technical controls enforced on Named References in contemporaneously
   produced attestations associated with the corresponding Source Revisions.
-   Allow organizations to provide
   [organization-specified properties](#additional-properties) to be included in the
   [Source VSA](#source-verification-summary-attestation) when the corresponding controls are
   enforced.
-   Allow organizations to distribute additional attestations related to their
   technical controls to consumers authorized to access the corresponding Source
   Revision.
-   Prevent organization-specified properties from beginning with any value
   other than `ORG_SOURCE_`.

<td><td><td>✓<td>✓
<tr id="two-party-review"><td>Two-party review <a href="#two-party-review">🔗</a><td>

Changes in protected branches MUST be agreed to by two or more trusted persons prior to submission.
The following combinations are acceptable:

-   Uploader and reviewer are two different trusted persons.
-   Two different reviewers are trusted persons.

Reviews SHOULD cover, at least, security relevant properties of the code.

**[Final revision approved]** This requirement applies to the final revision
submitted. I.e., if additional changes are made during the review process, those changes MUST
be reviewed as well.

**[Context-specific approvals]** Approvals are for a specific context, such as a
repo + branch in git. Moving fully reviewed content from one context to another
still requires review. The exact definition of “context” depends on the project,
and this does not preclude well-understood automatic merges, such as cutting a release branch.

**[Informed Review]** The SCS MUST present reviewers with a clear representation of the result of accepting the proposed change. See [Human Readable Changes](#human-readable-diff).

**[Trusted Robot Contributions]** An organization MAY choose to grant a Trusted
Robot a perpetual exception to a policy (e.g. a bot may be able to merge a change
that has not been reviewed by two parties).

Examples:

-   Import and migration bots that move code from one repo to another.
-   Dependabot

<td><td><td><td>✓
</table>

## Source Track Attestations

SLSA source level details are communicated using attestations.
These attestations either refer to a source revision itself or provide context needed to evaluate an attestation that _does_ refer to a revision.

There are two broad categories of source attestations within the source track:

1.  Source verification summary attestations (Source VSAs): Used to communicate to downstream users what high level security properties a given source revision meets.
2.  Source provenance attestations: Provide trustworthy, tamper-proof, metadata with the necessary information to determine what high level security properties a given source revision has.

To provide interoperability and ensure ease of use, it's essential that the Source VSAs are applicable across all Source Control Systems.
However, due to the significant differences in how SCSs operate and how they may choose to meet the Source Track requirements, it is preferable to
allow for flexibility with the full source provenance attestations. To that end, SLSA leaves source provenance attestations undefined and up to the SCSs to determine
what works best in their environment.

### Source verification summary attestation

Source verification summary attestations (Source VSAs) are issued by some authority that has sufficient evidence to make the determination of a given
revision's source level.  Source VSAs convey properties about the revision as a whole and summarize properties computed over all
the changes that contributed to that revision over its history.

The source track issues Source VSAs using the [Verification Summary Attestations](./verification_summary.md) format as follows:

1.  `subject.uri` SHOULD be set to a URI where a human can find details about
    the revision. This field is not intended for policy decisions. Instead, it
    is only intended to direct a human investigating verification failures.
    -   For example: `https://github.com/slsa-framework/slsa/commit/6ff3cd75c8c9e0fcedc62bd6a79cf006f185cedb`
2.  `subject.digest` MUST include the revision identifier (e.g. `gitCommit`) and MAY include other digests over the contents of the revision (e.g. `gitTree`, `dirHash`, etc.).
SCSs that do not use cryptographic digests MUST define a canonical type that is used to identify immutable revisions and MUST include the repository within the type[^1].
    -   For example: `svn_revision_id: svn+https://svn.myproject.org/svn/MyProject/trunk@2019`
3.  `subject.annotations.sourceRefs` SHOULD be set to a list of references that pointed to this revision when the attestation was created. The list MAY be non-exhaustive.
    -   git references MUST be fully qualified (e.g. `refs/heads/main` or `refs/tags/v1.0`) to reduce the likelihood of confusing downstream tooling.
4.  `resourceUri` MUST be set to the URI of the repository, preferably using [SPDX Download Location](https://spdx.github.io/spdx-spec/v2.3/package-information/#77-package-download-location-field).
E.g. `git+https://github.com/foo/hello-world`.
5.  `verifiedLevels` MUST include the SLSA source track level the SCS asserts the revision meets. One of `SLSA_SOURCE_LEVEL_0`, `SLSA_SOURCE_LEVEL_1`, `SLSA_SOURCE_LEVEL_2`, `SLSA_SOURCE_LEVEL_3`.
MAY include additional properties as asserted by the SCS.  The SCS MUST include _only_ the highest SLSA source level met by the revision.
6.  `dependencyLevels` MAY be empty as source revisions are typically terminal nodes in a supply chain. For example, this could be used to indicate the source level of any git submodules present in the revision.

#### Additional properties

The SLSA source track MAY create additional properties to include in
`verifiedLevels` which attest to other claims concerning a revision.

The SCS MAY embed additional properties within `verifiedLevels` provided by the
organization as long as they are prefixed by `ORG_SOURCE_`  to distinguish them
from other properties the SCS may wish to use. The SCS MUST enforce the use of
this prefix for such properties. An organization MAY further differentiate
properties using:

-   `ORG_SOURCE_` to indicate a property that is meant for consumption by
   external consumers.
-   `ORG_SOURCE_INTERNAL_` to indicate a property that is not meant for
   consumption by external consumers.

The meaning of the properties is left entirely to the organization.

#### Populating sourceRefs

The Source VSA issuer may choose to populate `sourceRefs` in any way they wish.
Downstream users are expected to be familiar with the method used by the issuer.

Example implementations:

-   Issue a new VSA for each merged Pull Request and add the destination branch to `sourceRefs`.
-   Issue a new VSA each time a Named Reference is updated to point to a new revision.

#### Example

```json
"_type": "https://in-toto.io/Statement/v1",
"subject": [{
  "uri": "https://github.com/foo/hello-world/commit/9a04d1ee393b5be2773b1ce204f61fe0fd02366a",
  "digest": {"gitCommit": "9a04d1ee393b5be2773b1ce204f61fe0fd02366a"},
  "annotations": {"sourceRefs": ["refs/heads/main", "refs/heads/release_1.0"]}
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

See [Verifying Source](./verifying-source.md) for instructions how to verify
VSAs for Source Revisions.

### Source provenance attestations

Source provenance attestations provide tamper-proof evidence ([attestation model](attestation-model))
that can be used to determine what SLSA Source Level or other high-level properties a given revision meets.
This evidence can be used by:

-   an authority as the basis for issuing a [Source VSA](#source-verification-summary-attestation)
-   a consumer to cross-check a [Source VSA](#source-verification-summary-attestation) they received for a revision
-   a consumer to enforce a more detailed policy than the organization's own process

SCSs may have different methods of operating that necessitate different forms of evidence.
E.g. GitHub-based workflows may need different evidence than Gerrit-based workflows, which would both likely be different from workflows that
operate over Subversion repositories.

These differences also mean that, depending on the configuration, the issuers of provenance attestations may vary from implementation to implementation, often because entities with the knowledge to issue them may vary.
The authority that issues [Source VSAs](#source-verification-summary-attestation) MUST understand which entity should issue each provenance attestation type, and ensure all source provenance attestations come from their expected issuers.

'Source provenance attestations' is a generic term used to refer to any type of attestation that provides evidence of the process used to create a revision.

Example source provenance attestations:

-   A TBD attestation which describes the revision's parents and the actors involved in creating this revision.
-   A "code review" attestation which describes the basics of any code review that took place.
-   An "authentication" attestation which describes how the actors involved in any revision were authenticated.
-   A [Vuln Scan attestation](https://github.com/in-toto/attestation/blob/main/spec/predicates/vuln.md)
    which describes the results of a vulnerability scan over the contents of the revision.
-   A [Test Results attestation](https://github.com/in-toto/attestation/blob/main/spec/predicates/test-result.md)
 which describes the results of any tests run on the revision.
-   An [SPDX attestation](https://github.com/in-toto/attestation/blob/main/spec/predicates/spdx.md)
 which provides a software bill of materials for the revision.
-   A [SCAI attestation](https://github.com/in-toto/attestation/blob/main/spec/predicates/scai.md) used to
 describe which source quality tools were run on the revision.

Irrespective of the types of provenance attestations generated by an SCS and
their implementations, the SCS MUST document provenance
formats, and how each provenance attestation can be used to reason about the
revision's properties recorded in the summary attestation.

[^1]: in-toto attestations allow non-cryptographic digest types: https://github.com/in-toto/attestation/blob/main/spec/v1/digest_set.md#supported-algorithms.

## Disclaimer

When onboarding a branch to the SLSA Source Track or increasing the level of
that branch, organizations are making claims about how the branch is managed
from that revision forward. This establishes [continuity](#continuity).

No claims are made for prior revisions.

## Future Considerations

### Authentication

-   Better protection against phishing by forbidding second factors that are not
  phishing resistant.
-   Protect against authentication token theft by forbidding bearer tokens
  (e.g. PATs).
-   Including length of continuity in the VSAs


