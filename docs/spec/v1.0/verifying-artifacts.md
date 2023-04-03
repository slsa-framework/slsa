---
title: Verifying artifacts
description: SLSA uses provenance to indicate whether an artifact is authentic or not, but provenance doesn't do anything unless somebody inspects it. SLSA calls that inspection verification, and this page describes how to verify artifacts and their SLSA provenenance. The intended audience is system implementers, security engineers, and software consumers.
---

SLSA uses provenance to indicate whether an artifact is authentic or not, but
provenance doesn't do anything unless somebody inspects it. SLSA calls that
inspection **verification**, and this page describes recommendations for how to
verify artifacts and their SLSA provenance.

This page is divided into several sections. The first discusses choices for
where provenance verification can happen. The second describes how to set the
expectations used to verify provenance. The third describes the procedure for
verifying an artifact and its provenance against a set of expectations.

## Architecture options

System implementers decide which part(s) of the system will verify provenance:
the package ecosystem at upload time, the consumers at download time, or via a
continuous monitoring system. Each option comes with its own set of
considerations, but all are valid. The options are not mutually exclusive, but
at least one part of a SLSA-conformant system SHOULD verify provenance.

More than one component can verify provenance. For example, if a package
ecosystem verifies provenance, then consumers who get artifacts from that
package ecosystem do not have to verify provenance. Consumers can do so with
client-side verification tooling or by polling a monitor, but there is no
requirement that they do so.

<!-- **TODO** Add a diagram. -->

### Package ecosystem

[Package ecosystem]: #package-ecosystem

A <dfn>package ecosystem</dfn> is a set of rules and conventions governing
how packages are distributed. Every package artifact has an ecosystem, whether it is
formal or ad-hoc. Some ecosystems are formal, such as language distribution
(e.g. [Python/PyPA](https://www.pypa.io)), operating system distribution (e.g.
[Debian/Apt](https://wiki.debian.org/DebianRepository/Format)), or artifact
distribution (e.g. [OCI](https://github.com/opencontainers/distribution-spec)).
Other ecosystems are informal, such as a convention used within a company. Even
ad-hoc distribution of software, such as through a link on a website, is
considered an "ecosystem". For more background, see
[Package Model](terminology.md#package-model).

During package upload, a package ecosystem can ensure that the artifact's
provenance matches the known expectations for that package name before accepting
it into the package registry.  If possible, system implementers SHOULD prefer this
option because doing so benefits all of the package ecosystem's clients.

The package ecosystem is responsible for reliably redistributing
artifacts and provenance, making the producers' expectations available to consumers,
and providing tools to enable safe artifact consumption (e.g. whether an artifact
meets its producer's expectations).

### Consumer

[Consumer]: #consumer

A package artifact's <dfn>consumer</dfn> is the organization or individual that uses the
package artifact.

Consumers can set their own expectations for artifacts or use default
expectations provided by the package producer and/or package ecosystem.
In this situation, the consumer uses client-side verification tooling to ensure
that the artifact's provenance matches their expectations for that package
before use (e.g. during installation or deployment). Client-side verification
tooling can be either standalone, such as
[slsa-verifier](https://github.com/slsa-framework/slsa-verifier), or built into
the package ecosystem client.

### Monitor

[Monitor]: #monitor

A <dfn>monitor</dfn> is a service that verifies provenance for a set
of packages and publishes the result of that verification. The set of
packages verified by a monitor is arbitrary, though it MAY mimic the set
of packages published through one or more package ecosystems. The monitor
SHOULD publish its expectations for all the packages it verifies.

Consumers can continuously poll a monitor to detect artifacts that
do not meet the monitor's expectations. Detecting artifacts that fail
verification is of limited benefit unless a human or another part of the system
responds to the failed verification.

## Setting Expectations

<dfn>Expectations</dfn> are known provenance values that indicate the
corresponding artifact is authentic. For example, a package ecosystem may
maintain a mapping between package names and their canonical source
repositories. That mapping constitutes a set of expectations. The package
ecosystem tooling tests those expectations during upload to ensure all packages
in the ecosystem are built from their canonical source repo, which
indicates their authenticity.

Expectations SHOULD be sufficient to detect or prevent an adversary from injecting
unofficial behavior into the package. Example [threats](threats.md) in this
category include building from an unofficial fork or abusing a build parameter
to modify the build. Usually expectations identify the canonical source
repository (which is the main external parameter) and any other
security-relevant external parameters.

It is important to note that expectations are tied to a *package name*, whereas
provenance is tied to an *artifact*. Different versions of the same package name
may have different artifacts and therefore different provenance. Similarly, an
artifact may have different names in different package ecosystems but use the same
provenance file.

Package ecosystems
using the [RECOMMENDED suite](/attestation-model#recommended-suite) of attestation
formats SHOULD list the package name in the provenance attestation statement's
`subject` field, though the precise semantics for binding a package name to an
artifact are defined by the package ecosystem.

<table>
<tr><th>Recommendation<th>Description

<tr id="expectations-known">
<td>Expectations known
<td>

The package ecosystem SHOULD ensure that expectations are defined for the package before it is made available to package ecosystem users.

There are several approaches a package ecosystem could take to setting expectations, for example:

-   Requiring the producer to set expectations when registering a new package
    in the package ecosystem.
-   Using the values from the package's provenance during its initial
    publication (trust on first use).

<tr id="expectations-changes-auth">
<td>Changes authorized
<td>

The package ecosystem SHOULD ensure that any changes to expectations are
authorized by the package's producer. This is to prevent a malicious actor
from updating the expectations to allow building and publishing from a fork
under the malicious actor's control. Some ways this could be achieved include:

-   Requiring two authorized individuals from the package producer to approve
    the change.
-   Requiring consumers to approve changes, in a similar fashion to how SSH
    host fingerprint changes have to be approved by users.
-   Disallowing changes altogether, for example by binding the package name to
    the source repository.

</table>

## How to verify

Verification SHOULD include the following steps:

-   Ensuring that the builder identity is one of those in the map of trusted
    builder id's to SLSA level.
-   Verifying the signature on the provenance envelope.
-   Ensuring that the values for `BuildType` and `ExternalParameters` in the
    provenance match the known expectations. The package ecosystem MAY allow
    an approved list of `ExternalParameters` to be ignored during verification.
    Any unrecognized `ExternalParameters` SHOULD cause verification to fail.

![Threats covered by each step](/images/v1.0/supply-chain-threats-build-verification.svg)

Note: This section assumes that the provenance is in the recommended
[provenance format](/provenance/v1). If it is not, then the verifier SHOULD
perform equivalent checks on provenance fields that correspond to the ones
referenced here.

### Step 1: Check SLSA Build level

[Step 1]: #step-1-check-slsa-build-level

First, check the SLSA Build level by comparing the artifact to its provenance
and the provenance to a preconfigured root of trust. The goal is to ensure that
the provenance actually applies to the artifact in question and to assess the
trustworthiness of the provenance. This mitigates some or all of [threats] "D",
"F", "G", and "H", depending on SLSA Build level and where verification happens.

Once, when bootstrapping the verifier:

-   Configure the verifier's roots of trust, meaning the recognized builder
    identities and the maximum SLSA Build level each builder is trusted up to.
    Different verifiers might use different roots of trust, but usually a
    verifier uses the same roots of trust for all packages. This configuration
    is likely in the form of a map from (builder public key identity,
    `builder.id`) to (SLSA Build level) drawn from the SLSA Conformance
    Program (coming soon).

    <details>
    <summary>Example root of trust configuration</summary>

    The following snippet shows conceptually how a verifier's roots of trust
    might be configured using made-up syntax.

    ```jsonc
    "slsaRootsOfTrust": [
        // A builder trusted at SLSA Build L3, using a fixed public key.
        {
            "publicKey": "HKJEwI...",
            "builderId": "https://somebuilder.example.com/slsa/l3",
            "slsaBuildLevel": 3
        },
        // A different builder that claims to be SLSA Build L3,
        // but this verifier only trusts it to L2.
        {
            "publicKey": "tLykq9...",
            "builderId": "https://differentbuilder.example.com/slsa/l3",
            "slsaBuildLevel": 2
        },
        // A builder that uses Sigstore for authentication.
        {
            "sigstore": {
                "root": "global",  // identifies fulcio/rekor roots
                "subjectAlternativeNamePattern": "https://github.com/slsa-framework/slsa-github-generator/.github/workflows/generator_generic_slsa3.yml@refs/tags/v*.*.*"
            }
            "builderId": "https://github.com/slsa-framework/slsa-github-generator/.github/workflows/generator_generic_slsa3.yml@refs/tags/v*.*.*",
            "slsaBuildLevel": 3,
        }
        ...
    ],
    ```

    </details>

Given an artifact and its provenance:

1.  [Verify][processing-model] the envelope's signature using the roots of
    trust, resulting in a list of recognized public keys (or equivalent).
2.  [Verify][processing-model] that statement's `subject` matches the digest of
    the artifact in question.
3.  Verify that the `predicateType` is `https://slsa.dev/provenance/v1?draft`.
4.  Look up the SLSA Build Level in the roots of trust, using the recognized
    public keys and the `builder.id`, defaulting to SLSA Build L1.

Resulting threat mitigation:

-   [Threat "D"]: SLSA Build L3 requires protection against compromise of the
    build process and provenance generation by an external adversary, such as
    persistence between builds or theft of the provenance signing key. In other
    words, SLSA Build L3 establishes that the provenance is accurate and
    trustworthy, assuming you trust the build platform.
    -   IMPORTANT: SLSA Build L3 does **not** cover compromise of the build
        platform itself, such as by a malicious insider. Instead, verifiers
        SHOULD carefully consider which build platforms are added to the roots
        of trust. For advice on establishing trust in build platforms, see
        [Verifying build systems](/spec/v1.0/verifying-systems).
-   [Threat "F"]: SLSA Build L2 covers tampering of the artifact or provenance
    after the build. This is accomplished by verifying the `subject` and
    signature in the steps above.
-   [Threat "G"]: Verification by the consumer or otherwise outside of the
    package registry covers compromise of the registry itself. (Verifying within
    the registry at publication time is also valuable, but does not cover Threat
    "G" or "H".)
-   [Threat "H"]: Verification by the consumer covers compromise of the package
    in transit. (Many ecosystems also address this threat using package
    signatures or checksums.)
    -   NOTE: SLSA does not cover adversaries tricking a consumer to use an
        unintended package, such as through typosquatting.

[Threat "D"]: /spec/v1.0/threats#d-compromise-build-process
[Threat "F"]: /spec/v1.0/threats#f-upload-modified-package
[Threat "G"]: /spec/v1.0/threats#g-compromise-package-repo
[Threat "H"]: /spec/v1.0/threats#h-use-compromised-package

[processing-model]: https://github.com/in-toto/attestation/tree/main/spec#processing-model

### Step 2: Check expectations

[verify-step-2]: #check-expectations

Next, check that the package's provenance meets expectations for that package in
order to mitigate [threat "C"].

In our threat model, the adversary has ability to invoke a build and to publish
to the registry but not to write to the source repository, nor do they have
insider access to any trusted systems. Expectations SHOULD be sufficient to detect
or prevent this adversary from injecting unofficial behavior into the package.
Example threats in this category include building from an unofficial fork or
abusing a build parameter to modify the build. Usually expectations identify the
canonical source repository (which is the entry in `externalParameters`) and any
other security-relevant external parameters.

The expectations SHOULD cover the following:

| What | Why |
| ---- | --- |
| Builder identity from [Step 1] | To prevent an adversary from building the correct code on an unintended system |
| `buildType` | To ensure that `externalParameters` are interpreted as intended |
| `externalParameters` | To prevent an adversary from injecting unofficial behavior |

Verification tools SHOULD reject unrecognized fields in `externalParameters` to
err on the side of caution. It is acceptable to allow a parameter to have a
range of values (possibly any value) if it is known that any value in the range
is safe. JSON comparison is sufficient for verifying parameters.

Possible models for implementing expectation setting in package ecosystems (not
exhaustive):

-   **Trust on first use:** Accept the first version of the package as-is. On
    each version update, compare the old provenance to the new provenance and
    alert on any differences. This can be augmented by having rules about what
    changes are benign, such as a parameter known to be safe or a heuristic
    about safe git refs.

-   **Explicit policy:** Package producer defines the expectations for the
    package and distributes it to the verifier; the verifier uses these
    expectations after verifying their authenticity. In this model, there SHOULD
    be some protection against an adversary unilaterally modifying the policy.
    For example, this might involve two-party control over policy modifications,
    or having consumers accept each policy change (another form of trust on
    first use).

-   **Immutable policy:** Expectations for a package cannot change. In this
    model, the package name is immutably bound to a source repository and all
    other expectations are defined in the source repository. This is how go
    works, for example, since the package name *is* the source repository
    location.

TIP: Difficulty in setting meaningful expectations for `externalParameters` can
be a sign that the `buildType`'s level of abstraction is too low. For example,
`externalParameters` that record a list of commands to run is likely impractical
to verify because the commands change on every build. Instead, consider a
`buildType` that defines the list of commands in a configuration file in a
source repository, then put only the source repository in
`externalParameters`. Such a design is easier to verify because the source
repository is constant across builds.

[Threat "C"]: /spec/v1.0/threats#c-build-from-modified-source

### Step 3: (Optional) Check dependencies recursively

[verify-step-3]: #step-3-optional-check-dependencies-recursively

Finally, recursively check the `resolvedDependencies` as available and to the
extent desired. Note that SLSA v1.0 does not have any requirements on the
completeness or verification of `resolvedDependencies`. However, one might wish
to verify dependencies in order to mitigate [threat "E"] and protect against
threats further up the supply chain. If `resolvedDependencies` is incomplete,
these checks can be done on a best-effort basis.

A [Verification Summary Attestation (VSA)][VSA] can make dependency verification
more efficient by recording the result of prior verifications. A trimming
heuristic or exception mechanism is almost always necessary when verifying
dependencies because there will be transitive dependencies that are SLSA Build
L0. (For example, consider the compiler's compiler's compiler's ... compiler.)

[Threat "E"]: /spec/v1.0/threats#e-use-compromised-dependency
[VSA]: /verification_summary
[threats]: /spec/v1.0/threats
