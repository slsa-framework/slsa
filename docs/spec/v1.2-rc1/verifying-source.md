---
title: Verifying source
description: |
  SLSA uses attestations to indicate security claims associated with a repository revision, but attestations don't do anything unless somebody inspects them.
  SLSA calls that inspection verification, and this page describes how to verify properties of source revisions using their SLSA source provenance attestations.
  The intended audience is platform implementers, security engineers, and software consumers.
---

SLSA uses attestations to indicate security claims associated with a repository
revision, but attestations don't do anything unless somebody inspects them. SLSA
calls that inspection **verification**, and this page describes how to verify
properties of source revisions using
[the attestations](source-requirements#communicating-source-levels) associated
with those revisions.

At Source L3+, Source Control Systems (SCSs) issue detailed
[provenance attestations](source-requirements#source-provenance-attestations) of
the process that was used to create specific revisions of a repository. These
provenance attestations are issued in bespoke formats and may be too burdensome
to use in some use cases.

[Source Verification Summary Attestations](source-requirements#source-verification-summary-attestation)
(Source VSAs) address this, making verification more efficient and ergonomic by
recording the result of prior verifications. Source VSAs may be issued by a VSA
provider to make a SLSA source level determination based on the content of those
attestations.

## How to verify SLSA a source revision

The source consumer checks:

1.  If they trust the SCS that issued the VSA and if the VSA applies to the
   revision they've fetched.
2.  If the claims made in the VSA match their expectations for how the source
   should be managed.
3.  (Optional): If the evidence presented in the source provenance matches the
   claims made in the VSA.

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
| `verifiedLevels` | To ensure the expected controls were in place for the creation of the revision. E.g. `SLSA_SOURCE_LEVEL_3`, `ORG_SOURCE_STATIC_ANALYSIS`, etc...

[Threat "B"]: threats#b-modifying-the-source

### Step 3: Verify Evidence using Source Provenance [optional]

Optionally, at SLSA Source Level 3 and up, check the [source provenance
attestations](source-requirements#source-provenance-attestations) directly.

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
