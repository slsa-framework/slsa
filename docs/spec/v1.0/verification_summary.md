---
title: SLSA Verification Summary Attestation (VSA)
description: SLSA v1.0 specification for a verification summary of artifacts by a trusted verifier entity.
layout: standard
---

Verification summary attestations convey high-level information about an
artifact's verification, allowing  consumers to delegate verification decisions
to trusted third parties.

This document defines the following predicate type within the [in-toto
attestation] framework:

```json
"predicateType": "https://slsa.dev/verification_summary/v1"
```

> Important: Always use the above string for `predicateType` rather than what is
> in the URL bar. The `predicateType` URI will always resolve to the latest
> minor version of this specification. See [parsing rules](#parsing-rules) for
> more information.

## Purpose

Assert that the verifier has verified an artifact or set of artifacts. Optionally
include details about the verification process, such as the verified SLSA
level(s) and the verifier's expectations.

VSAs allow software consumers to make a decision about the validity of an
artifact without needing to have access to all of the attestations about the
artifact or all of its transitive dependencies. Consumers can use VSAs to delegate
complex policy decisions to some trusted party and then simply trust that
party's decision regarding the artifact.

VSAs also allow software producers to keep the details of their build pipeline
confidential while still communicating that some verification has taken place.
This might be necessary for legal reasons (keeping a software supplier
confidential) or for security reasons (not revealing that an embargoed patch has
been included).

## Model

A Verification Summary Attestation (VSA) is an attestation that some entity
(`verifier`) verified one or more software artifacts (the `subject` of an
in-toto attestation [Statement]) by evaluating the artifact and its associated
attestation(s) against the `policy` for `resourceUri`. Consumers who trust
the `verifier` may assume that the artifacts identified by the
`(subject, resourceUri)` pair met the indicated SLSA level without
themselves needing to evaluate the artifact or to have access to the
attestations the `verifier` used to make its determination.

VSAs can also be chained together to meet higher level goals, such as tracking
the verified SLSA level(s) for the `subject`'s transitive dependencies. Rather
than verifying provenance for the artifact and each of its transitive
dependencies all at once, the verifier can verify each dependency independently
and produce VSAs. Finally, the verifier combines those VSAs; the artifact
is the final VSA's `subject` and each transitive dependency is an
entry in `dependencyLevels`.

## Schema

```jsonc
// Standard attestation fields:
"_type": "https://in-toto.io/Statement/v1",
"subject": [{
  "name": <NAME>,
  "digest": { <digest-in-request> }
}],

// Predicate
"predicateType": "https://slsa.dev/verification_summary/v1",
"predicate": {
  // Required
  "verifier": {
    "id": "<URI>"
  },
  "timeVerified": <TIMESTAMP>,
  "resourceUri": <artifact-URI-in-request>,
  "policy": {
    "uri": "<URI>",
    "digest": { /* DigestSet */ }
  }
  "inputAttestations": [
    {
      "uri": "<URI>",
      "digest": { <digest-of-attestation-data> }
    },
    ...
  ],
  "verificationResult": "<PASSED|FAILED>",
  "verifiedLevels": ["<SlsaResult>"],
  "dependencyLevels": {
    "<SlsaResult>": <Int>,
    "<SlsaResult>": <Int>,
    ...
  },
  "slsaVersion": "<MAJOR>.<MINOR>",
}
```

### Parsing rules

This predicate follows the in-toto attestation [parsing rules]. Summary:

-   Consumers MUST ignore unrecognized fields.
-   The `predicateType` URI includes the major version number and will always
    change whenever there is a backwards incompatible change.
-   Minor version changes are always backwards compatible and "monotonic." Such
    changes do not update the `predicateType`.
-   Producers MAY add extension fields using field names that are URIs.

### Fields

_NOTE: This section describes the fields within `predicate`. For a description
of the other top-level fields, such as `subject`, see [Statement]._

<a id="verifier"></a>
`verifier` _object, required_

> Identifies the entity that performed the verification.
>
> The identity MUST reflect the trust base that consumers care about. How
> detailed to be is a judgment call.
>
> Consumers MUST accept only specific (signer, verifier) pairs. For example,
> "GitHub" can sign provenance for the "GitHub Actions" verifier, and "Google"
> can sign provenance for the "Google Cloud Deploy" verifier, but "GitHub" cannot
> sign for the "Google Cloud Deploy" verifier.
>
> This field is required, even if it is implicit from the signer, to aid readability and
> debugging. It is an object to allow additional fields in the future, in case one
> URI is not sufficient.

<a id="verifier.id"></a>
`verifier.id` _string ([TypeURI]), required_

> URI indicating the verifier’s identity.

<a id="timeVerified"></a>
`timeVerified` _string ([Timestamp]), optional_

> Timestamp indicating what time the verification occurred.

<a id="resourceUri"></a>
`resourceUri` _string ([ResourceURI]), required_

> URI that identifies the resource associated with the artifact being verified.
>
> This field is required to prevent confusion attacks. E.g., a VSA indicating
> that a package can be published as `foo` should not be usable to publish
> the package as `bar`; a VSA indicating that a package passed the policy for
> a `dev` environment should not be usable to deploy the package to a `prod`
> environment.

<a id="policy"></a>
`policy` _object ([ResourceDescriptor]), optional_

> Describes the policy that the `subject` was verified against.
>
> This field is RECOMMENDED.

<a id="inputAttestations"></a>
`inputAttestations` _array ([ResourceDescriptor]), optional_

> The collection of attestations that were used to perform verification.
> Conceptually similar to the `resolvedDependencies` field in [SLSA Provenance].
>
> This field MAY be absent if the verifier does not support this feature.
> If non-empty, this field MUST contain information on _all_ the attestations
> used to perform verification.
>
> Each entry MUST contain a `digest` of the attestation and SHOULD contains a
> `uri` that can be used to fetch the attestation.

<a id="verificationResult"></a>
`verificationResult` _string, required_

> Either “PASSED” or “FAILED” to indicate if the artifact passed or failed the policy verification.

<a id="verifiedLevels"></a>
`verifiedLevels` _array ([SlsaResult]), required_

> Indicates the highest level of each track verified for the artifact (and not
> its dependencies), or "FAILED" if policy verification failed.
>
> VSA producers MUST NOT include more than one level per SLSA track. Note that
> each SLSA  level implies all levels below it (e.g. SLSA_BUILD_LEVEL_3 implies
> SLSA_BUILD_LEVEL_2 and SLSA_BUILD_LEVEL_1), so there is no need to
> include more than one level per track.
>
> VSA producers MAY add additional, non-SLSA properties to this field provided
> the values do not conflict with the definition of [SlsaResult]. VSA Producers
> SHOULD negotiate the meaning of such properties with their intended verifier.
>
> This field MAY be absent if the verifier is not attesting to a specific SLSA
> level.

<a id="dependencyLevels"></a>
`dependencyLevels` _object, optional_

> A count of the dependencies at each SLSA level.
>
> Map from [SlsaResult] to the number of the artifact's _transitive_ dependencies
> that were verified at the indicated level. Absence of a given level of
> [SlsaResult] MUST be interpreted as reporting _0_ dependencies at that level.
>
> VSA producers MUST count each dependency only once per SLSA track, at the
> highest level verified. For example, if a dependency meets SLSA_BUILD_LEVEL_2,
> you include it with the count for SLSA_BUILD_LEVEL_2 but not the count for
>SLSA_BUILD_LEVEL_1.

<a id="slsaVersion"></a>
`slsaVersion` _string, optional_

> Indicates the version of the SLSA specification that the verifier used, in the
> form `<MAJOR>.<MINOR>`. Example: `1.0`. If unset, the default is an
> unspecified minor version of `1.x`.

## Example

WARNING: This is just for demonstration purposes.

```jsonc
"_type": "https://in-toto.io/Statement/v1",
"subject": [{
  "name": "out/example-1.2.3.tar.gz",
  "digest": {"sha256": "5678..."}
}],

// Predicate
"predicateType": "https://slsa.dev/verification_summary/v1",
"predicate": {
  "verifier": {
    "id": "https://example.com/publication_verifier"
  },
  "timeVerified": "1985-04-12T23:20:50.52Z",
  "resourceUri": "https://example.com/example-1.2.3.tar.gz",
  "policy": {
    "uri": "https://example.com/example_tarball.policy",
    "digest": {"sha256": "1234..."}
  },
  "inputAttestations": [
    {
      "uri": "https://example.com/provenances/example-1.2.3.tar.gz.intoto.jsonl",
      "digest": {"sha256": "abcd..."}
    }
  ],
  "verificationResult": "PASSED",
  "verifiedLevels": ["SLSA_BUILD_LEVEL_3"],
  "dependencyLevels": {
    "SLSA_BUILD_LEVEL_3": 5,
    "SLSA_BUILD_LEVEL_2": 7,
    "SLSA_BUILD_LEVEL_1": 1,
  },
  "slsaVersion": "1.0"
}
```

<div id="slsaresult">

## How to verify

Consumers use VSAs to accomplish goals based on delegated trust. We call the
process of establishing a VSA's authenticity and determining whether it meets
the consumer's goals 'verification'. Goals differ, as do levels of confidence
in VSA producers, so the verification procedure changes to suit its context.
However, there are certain steps that most verification procedures have in
common.

Verification MUST include the following steps:

1.  Verify the signature on the VSA envelope using the preconfigured roots of
    trust. This step ensures that the VSA was produced by a trusted producer
    and that it hasn't been tampered with.

2.  Verify the statement's `subject` matches the digest of the artifact in
    question. This step ensures that the VSA pertains to the intended artifact.

3.  Verify that the `predicateType` is
    `https://slsa.dev/verification_summary/v1`. This step ensures that the
    in-toto predicate is using this version of the VSA format.

4.  Verify that the `verifier` matches the public key (or equivalent) used to
    verify the signature in step 1. This step identifies the VSA producer in
    cases where their identity is not implicitly revealed in step 1.

5.  Verify that the value for `resourceUri` in the VSA matches the expected
    value. This step ensures that the consumer is using the VSA for the
    producer's intended purpose.

6.  Verify that the value for `slsaResult` is `PASSED`. This step ensures the
    artifact is suitable for the consumer's purposes.

7.  Verify that `verifiedLevels` contains the expected value. This step ensures
    that the artifact is suitable for the consumer's purposes.

Verification MAY additionally contain the following step:

1.  (Optional) Verify additional fields required to determine whether the VSA
    meets your goal.

Verification mitigates different threats depending on the VSA's contents and the
verification procudure.

IMPORTANT: A VSA does not protect against compromise of the verifier, such as by
a malicious insider. Instead, VSA consumers SHOULD carefully consider which
verifiers they add to their roots of trust.

### Examples

1.  Suppose consumer C wants to delegate to verifier V the decision for whether
    to accept artifact A as resource R. Consumer C verifies that:

    -   The signature on the VSA envelope using V's public signing key from their
      preconfigured root of trust.

    -   `subject` is A.

    -   `predicateType` is `https://slsa.dev/verification_summary/v1`.

    -   `verifier.id` is V.

    -   `resourceUri` is R.

    -   `slsaResult` is `PASSED`.

    -   `verifiedLevels` contains `SLSA_BUILD_LEVEL_UNEVALUATED`.

    Note: This example is analogous to traditional code signing. The expected
    value for `verifiedLevels` is arbitrary but prenegotiated by the producer and
    the consumer. The consumer does not need to check additional fields, as C
    fully delegates the decision to V.

2.  Suppose consumer C wants to enforce the rule "Artifact A at resource R must
    have a passing VSA from verifier V showing it meets SLSA Build Level 2+."
    Consumer C verifies that:

    -   The signature on the VSA envelope using V's public signing key from their
      preconfigured root of trust.

    -   `subject` is A.

    -   `predicateType` is `https://slsa.dev/verification_summary/v1`.

    -   `verifier.id` is V.

    -   `resourceUri` is R.

    -   `slsaResult` is `PASSED`.

    -   `verifiedLevels` is `SLSA_BUILD_LEVEL_2` or `SLSA_BUILD_LEVEL_3`.

    Note: In this example, verifying the VSA mitigates the same threats as
    verifying the artifact's SLSA provenance. See
    [Verifying artifacts](/spec/v1.0/verifying-artifacts) for details about which
    threats are addressed by verifying each SLSA level.

## _SlsaResult (String)_

</div>

The result of evaluating an artifact (or set of artifacts) against SLSA.
SHOULD be one of these values:

-   SLSA_BUILD_LEVEL_UNEVALUATED
-   SLSA_BUILD_LEVEL_0
-   SLSA_BUILD_LEVEL_1
-   SLSA_BUILD_LEVEL_2
-   SLSA_BUILD_LEVEL_3
-   FAILED (Indicates policy evaluation failed)

Note that each SLSA level implies the levels below it. For example,
SLSA_BUILD_LEVEL_3 means (SLSA_BUILD_LEVEL_1 + SLSA_BUILD_LEVEL_2 +
SLSA_BUILD_LEVEL_3).

VSA producers MAY use custom values here but MUST NOT use custom values starting
with `SLSA_`.

## Change history

-   1.1:
    -   Added Verification section with examples.
    -   Made `policy` optional.
    -   Made `timeVerified` optional.
-   1.0:
    -   Replaced `materials` with `resolvedDependencies`.
    -   Relaxed `SlsaResult` to allow other values.
    -   Converted to lowerCamelCase for consistency with [SLSA Provenance].
    -   Added `slsaVersion` field.
-   0.2:
    -   Added `resource_uri` field.
    -   Added optional `input_attestations` field.
-   0.1: Initial version.

[SLSA Provenance]: /provenance
[SlsaResult]: #slsaresult
[DigestSet]: https://github.com/in-toto/attestation/blob/main/spec/v1/digest_set.md
[ResourceURI]: https://github.com/in-toto/attestation/blob/main/spec/v1/field_types.md#ResourceURI
[ResourceDescriptor]: https://github.com/in-toto/attestation/blob/main/spec/v1/resource_descriptor.md
[Statement]: https://github.com/in-toto/attestation/blob/main/spec/v1/statement.md
[Timestamp]: https://github.com/in-toto/attestation/blob/main/spec/v1/field_types.md#Timestamp
[TypeURI]: https://github.com/in-toto/attestation/blob/main/spec/v1/field_types.md#TypeURI
[in-toto attestation]: https://github.com/in-toto/attestation
[parsing rules]: https://github.com/in-toto/attestation/blob/main/spec/v1/README.md#parsing-rules
