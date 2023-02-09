# Future directions

The initial [draft version (v0.1)] of SLSA had a larger scope including
protections against tampering with source code and a higher level of build
integrity (Build L4). This page collects some early thoughts on how SLSA
**might** evolve in future to re-introduce those notions and add other
additional aspects of automatable supply chain security.

<section id="build-l4">

## Build track

### Build L4

A build L4 could include further hardening of the build service and enabling
corraboration of the provenance, for example by providing complete knowledge of
the build inputs.

The initial [draft version (v0.1)] of SLSA defined a "SLSA 4" that included the
following requirements, which **may or may not** be part of a future Build L4:

-   Pinned dependencies, which guarantee that each build runs on exactly the
    same set of inputs.
-   Hermetic builds, which guarantee that no extraneous dependencies are used.
-   All dependencies listed in the provenance, which enables downstream systems
    to recursively apply SLSA to dependencies.
-   Reproducible builds, which enable other systems to corroborate the
    provenance.

Draft requirements text for each of these requirements can be viewed below.
Each entry might or might not be included in the future, in whole or in part.
The list is not exhaustive.

> WARNING: The draft requirements here are unversioned and subject to change.

<details id="parameterless">
<summary>Parameterless (draft)</summary>

The build output cannot be affected by user parameters other than the build
entry point and the top-level source location. In other words, the build is
fully defined through the build script and nothing else.

Examples:

-   GitHub Actions
    [workflow_dispatch](https://docs.github.com/en/actions/reference/events-that-trigger-workflows#workflow_dispatch)
    `inputs` MUST be empty.
-   Google Cloud Build
    [user-defined substitutions](https://cloud.google.com/build/docs/configuring-builds/substitute-variable-values)
    MUST be empty. (Default substitutions, whose values are defined by the
    server, are acceptable.)

</details>
<details id="hermetic">
<summary>Hermetic (draft)</summary>

All transitive build steps, sources, and dependencies were fully declared up
front with *immutable references*, and the build steps ran with no network
access.

An **immutable reference** is an identifier that is
guaranteed to always point to the same, immutable artifact. This MUST allow the
consumer to locate the artifact and SHOULD include a cryptographic hash of the
artifact's contents to ensure integrity. Examples: git URL + branch/tag/ref \+
commit ID; cloud storage bucket ID + SHA-256 hash; Subversion URL (no hash).

The user-defined build script:

-   MUST declare all dependencies, including sources and other build steps,
    using *immutable references* in a format that the build service understands.

The build service:

-   MUST fetch all artifacts in a trusted control plane.
-   MUST NOT allow mutable references.
-   MUST verify the integrity of each artifact.
    -   If the *immutable reference* includes a cryptographic hash, the service
        MUST verify the hash and reject the fetch if the verification fails.
    -   Otherwise, the service MUST fetch the artifact over a channel that
        ensures transport integrity, such as TLS or code signing.
-   MUST prevent network access while running the build steps.
    -   This requirement is "best effort." It SHOULD deter a reasonable team
        from having a non-hermetic build, but it need not stop a determined
        adversary. For example, using a container to prevent network access is
        sufficient.

</details>
<details id="reproducible">
<summary>Reproducible (draft)</summary>

Re-running the build steps with identical input artifacts results in bit-for-bit
identical output. Builds that cannot meet this MUST provide a justification why
the build cannot be made reproducible.

"○" means that this requirement is "best effort". The user-provided build script
SHOULD declare whether the build is intended to be reproducible or a
justification why not. The build service MAY blindly propagate this intent
without verifying reproducibility. A consumer MAY reject the build if it does
not reproduce.

</details>
<details id="dependencies-complete">
<summary>Dependencies complete (draft)</summary>

Provenance records all build dependencies that were available while running the
build steps. This includes the initial state of the machine, VM, or container of
the build worker.

-   MUST include all user-specified build steps, sources, dependencies.
-   SHOULD include all service-provided artifacts.

</details>

</section>

<section id="source-track">

## Source track

A Source track could provide protection against tampering of the source code.

The initial [draft version (v0.1)](../v0.1/requirements.md#source-requirements)
of SLSA included the following source requirements, which **may or may not**
form the basis for a future Source track:

-   Strong authentication of author and reviewer identities, such as 2-factor
    authentication using a hardware security key, to resist account and
    credential compromise.
-   Retention of the source code to allow for after-the-fact inspection and
    future rebuilds.
-   Mandatory two-person review of all changes to the source to prevent a single
    compromised actor or account from introducing malicious changes.

Draft requirements text for each of these requirements can be viewed below.
Each entry might or might not be included in the future, in whole or in part.
The list is not exhaustive.

> WARNING: The draft requirements here are unversioned and subject to change.

<details id="version-controlled">
<summary>Version controlled (draft)</summary>

Every change to the source is tracked in a version control system that meets the
following requirements:

-   **[Change history]** There exists a record of the history of changes
    that went into the revision. Each change MUST contain: the identities of
    the uploader and reviewers (if any), timestamps of the reviews (if any)
    and submission, the change description/justification, the content of
    the change, and the parent revisions.

-   **\[Immutable reference]** There exists a way to indefinitely reference
    this particular, immutable revision. In git, this is the {repo URL +
    branch/tag/ref + commit ID}.

Most popular version control system meet this requirement, such as git,
Mercurial, Subversion, or Perforce.

NOTE: This does NOT require that the code, uploader/reviewer identities, or
change history be made public. Rather, some organization attests to the fact
that these requirements are met, and it is up to the consumer whether this
attestation is sufficient.

"○" = RECOMMENDED.

</details>
<details id="verified-history">
<summary>Verified history (draft)</summary>

Every change in the revision's history has at least one strongly authenticated
actor identity (author, uploader, reviewer, etc.) and timestamp. It MUST be
clear which identities were verified, and those identities MUST use [two-step
verification](https://www.google.com/landing/2step/) or similar. (Exceptions
noted below.)

-   **[First-parent history]** In the case of a non-linear version control
    system, where a revision can have more than one parent, only the "first
    parent history" is in scope. In other words, when a feature branch is merged
    back into the main branch, only the merge itself is in scope.
-   **[Historical cutoff]** There is some TBD exception to allow existing
    projects to meet SLSA 3/4 even if historical revisions were present in the
    history. Current thinking is that this could be either last N months or a
    platform attestation guaranteeing that future changes in the next N months
    will meet the requirements.

"Strongly authenticated" means that the actor was mapped to a specific person
using an authentication mechanism which is resistant to account and credential
compromise. For example, 2-factor authentication (2FA) where one factor is a
hardware security key (i.e. YubiKey).

</details>
<details id="retained-indefinitely">
<summary>Retained indefinitely (draft)</summary>

The revision and its change history are preserved indefinitely and cannot be
deleted, except when subject to an established and transparent policy for
obliteration, such as a legal or policy requirement.

-   **[Immutable history]** It MUST not be possible for persons to delete or
    modify the history, even with multi-party approval, except by trusted
    platform admins with two-party approval following the obliterate policy.
-   **[Limited retention for SLSA 3]** At SLSA 3 (but not 4), it is acceptable
    for the retention to be limited to 18 months, as attested by the source
    control platform.
    -   Example: If a commit is made on 2020-04-05 and then a retention
        attestation is generated on 2021-01-01, the commit MUST be retained
        until at least 2022-07-01.

</details>
<details id="two-person-reviewed">
<summary>Two-person reviewed (draft)</summary>

Every change in the revision's history was agreed to by two trusted persons
prior to submission, and both of these trusted persons were strongly
authenticated. (Exceptions from [Verified History](#verified-history) apply here
as well.)

-   The following combinations are acceptable:
    -   Uploader and reviewer are two different trusted persons.
    -   Two different reviewers are trusted persons.
-   **[Different persons]** The platform ensures that no person can use
  alternate identities to bypass the two-person review requirement.
    -   Example: if a person uploads with identity X then reviews with alias Y,
        the platform understands that this is the same person and does not
        consider the review requirement satisfied.
-   **[Informed review]** The reviewer is able and encouraged to make an
    informed decision about what they're approving. The reviewer SHOULD be
    presented with a full, meaningful content diff between the proposed revision
    and the previously reviewed revision. For example, it is not sufficient to
    just indicate that file changed without showing the contents.
-   **[Context-specific approvals]** Approvals are for a specific context, such
    as a repo + branch in git. Moving fully reviewed content from one context to
    another still requires review. (Exact definition of "context" depends on the
    project, and this does not preclude well-understood automatic or reviewless
    merges, such as cutting a release branch.)
    -   Git example: If a fully reviewed commit in one repo is merged into a
        different repo, or a commit in one branch is merged into a different
        branch, then the merge still requires review.

"Trusted persons" are the set of persons who are granted the authority to
maintain a software project. For example, https://github.com/MarkLodato/dotfiles
has just one trusted person (MarkLodato), while
https://hg.mozilla.org/mozilla-central has a set of trusted persons with write
access to the mozilla-central repository.

</details>

</section>

[draft version (v0.1)]: ../v0.1/requirements.md
