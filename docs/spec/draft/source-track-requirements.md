---
title: "Source Track: Requirements
description: "This page covers the technical requirements for producing source revisions at each SLSA level." 
---

# {Source Track: Requirements}

**About this page:** the *Source Track: Requirements* page covers the detailed requirements for producing source revisions at each SLSA level.

**Intended audience:** source control system implementers and security engineers

**Topics covered:** detailed source track-level specifics and requirements, source track systems and attestations

**Internet standards:** [RFC 2119](https://www.rfc-editor.org/rfc/rfc2119), {other standards as required}

>The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD",
"SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be
interpreted as described in [RFC 2119](https://www.rfc-editor.org/rfc/rfc2119).

**For more information, see:** {optional}

## Source Track Requirements Overview

Many examples in this document use the
[git version control system](https://git-scm.com/), but use of git is not a
requirement to meet any level on the SLSA source track.

### Organization Requirements

[Organization]: #organization

<table>
<tr><th>Requirement<th>Description<th>L1<th>L2<th>L3<th>L4

<tr id="choose-scs"><td>Choose an appropriate Source Control System <a href="#choose-scs">🔗</a><td>

An organization producing Source Revisions MUST select an SCS capable of reaching
their desired SLSA Source Level.

> For example, if an organization wishes to produce revisions at Source Level 3,
they MUST choose a Source Control System capable of producing Source Level 3
attestations.

<td>✓<td>✓<td>✓<td>✓

<tr id="access-and-history"><td>Configure the SCS to control access and enforce history <a href="#access-and-history">🔗</a><td>

The organization MUST configure access controls to restrict sensitive operations
on the Source Repository. These controls MUST be implemented using the
SCS-provided [Identity Management capability](#identity-management).

> For example, an organization may configure the SCS to assign users to a
`maintainers` role and only allow users in `maintainers` to make updates to
`main`.

The SCS MUST be configured to produce a reliable [Change History](#history) for
its consumable Source Revisions.
If the SCS provides this capability by design, no additional controls are needed.
Otherwise the organization MUST provide evidence of [continuous enforcement](#continuity).

If the SCS supports [Tags](#tag), the SCS MUST be configured to prevent them
from being moved or deleted.

> For example, if a git tag `release1` is used to indicate a release revision
with ID `abc123`, controls must be configured to prevent that tag from being
updated to any other revision in the future.
Evidence of these controls (and their continuity) will appear in the Source
Provenance documents for revision `abc123`.

<td><td>✓<td>✓<td>✓
<tr id="safe-expunging-process"><td>Safe Expunging Process <a href="#safe-expunging-process">🔗</a><td>

SCSs MAY allow the organization to expunge (remove) content from a repository
and its change history without leaving a public record of the removed content,
but the organization MUST only allow these changes in order to meet legal or
privacy compliance requirements. Content changed under this process includes
changing files, history, references, or any other metadata stored by the SCS.

#### Warning: Revision Removal

Removing a revision from a repository is similar to deleting a package version
from a registry: it's almost impossible to estimate the amount of downstream
supply chain impact.

> For example, in Git, each revision ID is based on the ones before it.
When you remove a revision, you must generate new revisions (and new revision IDs)
for any revisions that were built on top of it. Consumers who took a dependency
on the old revisions may now be unable to refer to the revision they've already
integrated into their products.

It may be the case that the specific set of changes targeted by a legal takedown
can be expunged in ways that do not impact consumed revisions, which can mitigate
these problems.

It is also the case that removing content from a repository won't necessarily
remove it everywhere.
The content may still exist in other copies of the repository, either in backups
or on developer machines.

#### Documentation Process Requirements

An organization MUST document the Safe Expunging Process and describe how
requests and actions are tracked and SHOULD log the fact that content was
removed. Different organizations and tech stacks may have different approaches
to the problem.

SCSs SHOULD have technical mechanisms in place which require an Administrator
plus at least one additional 'trusted person' to trigger any expunging
(removals) made under this process.

The application of the Safe Expunging Process and the resulting logs MAY be
private to prevent calling attention to potentially sensitive data or to comply
with local laws and regulations. Organizations SHOULD prefer to make logs public
if possible.

<td><td>✓<td>✓<td>✓
<tr id="technical-controls"><td>Continuous technical controls <a href="#technical-controls">🔗</a><td>

The organization MUST provide evidence of continuous enforcement via technical
controls for any claims made in the Source Provenance attestations or VSAs (see
[control continuity](#continuity)).

The organization MUST document the meaning of their enforced technical controls.

> For example, if an organization implements a technical control via a custom
tool (such as required GitHub Actions workflow), it must indicate the name of
this tool, what it accomplishes, and how to find its evidence in the provenance
attestation.

> For another example, if the organization claims that all consumable Source
Revisions on the `main` branch were tested prior to acceptance, this MUST be
explicitly enforced in the SCS.

<td><td><td>✓<td>✓

</table>

### Source Control System Requirements

<table>
<tr><th>Requirement<th>Description<th>L1<th>L2<th>L3<th>L4

<tr id="repository-ids"><td>Repositories are uniquely identifiable <a href="#repository-ids">🔗</a><td>

The repository ID is defined by the SCS and MUST be uniquely identifiable within
the context of the SCS with a stable locator, such as a URI.

<td>✓<td>✓<td>✓<td>✓
<tr id="revision-ids"><td>Revisions are immutable and uniquely identifiable <a href="#revision-ids">🔗</a><td>
The revision ID is defined by the SCS and MUST be uniquely identifiable within the context of the repository.
When the revision ID is a digest of the content of the revision (as in git) nothing more is needed.
When the revision ID is a number or otherwise not a digest, then the SCS MUST document how the immutability of the revision is established.
The same revision ID MAY be present in multiple repositories.

See also [Use cases for non-cryptographic, immutable, digests](https://github.com/in-toto/attestation/blob/main/spec/v1/digest_set.md#use-cases-for-non-cryptographic-immutable-digests).

<td>✓<td>✓<td>✓<td>✓
<tr id="human-readable-diff"><td>Human readable changes <a href="#human-readable-diff">🔗</a><td>

The SCS MUST provide tooling to display Changes between one Source Revision and
another in a human readable form (e.g. 'diffs') for all plain-text changes and
SHOULD provide mechanisms to provide human understandable interpretations of
non-plain-text changes (e.g. render images, verify and display provenance for
binaries, etc.).

<td>✓<td>✓<td>✓<td>✓
<tr id="source-summary"><td>Source Verification Summary Attestations <a href="#source-summary">🔗</a><td>

The SCS MUST generate a
[source verification summary attestation](#source-verification-summary-attestation) (Source VSA)
to indicate the SLSA Source Level of any revision at Level 1 or above.

If a consumer is authorized to access a revision, they MUST be able to fetch the
corresponding Source VSA.

If the SCS DOES NOT generate a VSA for a revision, the revision has Source Level
0.

At Source Levels 1 and 2 the SCS MAY issue these attestations based on its
understanding of the underlying system (e.g. based on design docs, security
reviews, etc.), but at Level 2+ the SCS MUST use the SCS-issued
[source provenance](#source-provenance) when issuing the VSAs.

<td>✓<td>✓<td>✓<td>✓

<tr id="history"><td>History <a href="#history">🔗</a><td>

There are three key aspects to change history:

1.  What were all the previous states of a Branch?
2.  How and when did they change?
3.  How does the current revision relate to previous revisions?

To answer these questions, the SCS MUST record all changes to Named References,
including when they occurred, who made them, and the new Source Revision ID.

If Source Revisions have ancestry relationships in the VCS, the SCS MUST ensure
that a Branch can only be updated to point to revisions that descend from the
current revision.
In git, this requires a technical control to prohibit `git push --force`.

This requirement captures evidence that the organization intended to make the
changes captured by the new revision.

> For example, if a branch currently points to revision `a`, it may only be
moved to a new revision `b` if `a` is an ancestor of `b`.

<td><td>✓<td>✓<td>✓
<tr id="continuity"><td>Continuity <a href="#continuity">🔗</a><td>

Technical Controls are only effective if they are used continuously in the
history of a Branch.
'Control continuity' reflects an organization's ongoing commitment to a
technical control.

For each technical control claimed in a VSA, continuity MUST be established and
tracked from a specific start revision.
If there is a lapse in continuity for a specific control, continuity of that
control MUST be re-established from a new revision.

Exceptions to the continuity requirement are allowed via the [safe expunging process](#safe-expunging-process).

> For example, the `main` branch currently points to revision `a` when a new
technical control `t` is configured.
The next revision on the `main` branch, `b` will be the first revision that was
protected by `t` and `b` is the first revision in the "continuity" of `t`.
Any revisions added to `main` while `t` is disabled will reset the continuity of `t`.

<td><td>✓<td>✓<td>✓

<tr id="identity-management"><td>Identity Management <a href="#identity-management">🔗</a><td>

The SCS MUST provide an identity management system or some other means of
identifying and authenticating actors.

The SCS MUST allow organizations to specify which actors and roles are allowed
to perform sensitive actions within a repository (e.g. creation or updates of
branches, approval of changes).

Depending on the SCS, identity management may be provided by source control
services (e.g., GitHub, GitLab), implemented using cryptographic signatures
(e.g., using gittuf to manage public keys for actors), or extending existing
authentication systems used by the organization (e.g., Active Directory, Okta,
etc.).

The SCS MUST document how actors are identified for the purposes of attribution.

Activities conducted on the SCS SHOULD be attributed to authenticated
identities.

<td><td>✓<td>✓<td>✓

