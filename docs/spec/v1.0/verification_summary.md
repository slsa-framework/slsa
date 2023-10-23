---
title: Verification Summary Attestation (VSA)
description: Specification for a verification summary of artifacts by a trusted verifier entity.
layout: standard
---

Verification summary attestations communicate that an artifact has been verified
at a specific SLSA level and details about that verification.

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

Describe what SLSA level an artifact or set of artifacts was verified at
and other details about the verification process including what SLSA level
the dependencies were verified at.

This allows software consumers to make a decision about the validity of an
artifact without needing to have access to all of the attestations about the
artifact or all of its transitive dependencies.  They can use it to delegate
complex policy decisions to some trusted party and then simply trust that
party's decision regarding the artifact.

It also allows software producers to keep the details of their build pipeline
confidential while still communicating that some verification has taken place.
This might be necessary for legal reasons (keeping a software supplier
confidential) or for security reasons (not revealing that an embargoed patch has
been included).

## Model

A Verification Summary Attestation (VSA) is an attestation that some entity
(`verifier`) verified one or more software artifacts (the `subject` of an
in-toto attestation [Statement]) by evaluating the artifact and a `bundle`
of attestations against some `policy`.  Users who trust the `verifier` may
assume that the artifacts met the indicated SLSA level without themselves
needing to evaluate the artifact or to have access to the attestations the
`verifier` used to make its determination.

The VSA also allows consumers to determine the verified levels of
all of an artifact’s _transitive_ dependencies.  The verifier does this by
either a) verifying the provenance of each non-source dependency listed in
the [resolvedDependencies](/provenance/v1#resolvedDependencies) of the artifact
being verified (recursively) or b) matching the non-source dependency
listed in `resolvedDependencies` (`subject.digest` ==
`resolvedDependencies.digest` and, ideally, `vsa.resourceUri` ==
`resolvedDependencies.uri`) to a VSA _for that dependency_ and using
`vsa.verifiedLevels` and `vsa.dependencyLevels`.  Policy verifiers wishing
to establish minimum requirements on dependencies SLSA levels may use
`vsa.dependencyLevels` to do so.

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
> The field is required, even if it is implicit from the signer, to aid readability and
> debugging. It is an object to allow additional fields in the future, in case one
> URI is not sufficient.

<a id="verifier.id"></a>
`verifier.id` _string ([TypeURI]), required_

> URI indicating the verifier’s identity.

<a id="timeVerified"></a>
`timeVerified` _string ([Timestamp]), required_

> Timestamp indicating what time the verification occurred.

<a id="resourceUri"></a>
`resourceUri` _string ([ResourceURI]), required_

> URI that identifies the resource associated with the artifact being verified.

<a id="policy"></a>
`policy` _object ([ResourceDescriptor]), required_

> Describes the policy that the `subject` was verified against.
>
> The entry MUST contain a `uri`.

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
> Users MUST NOT include more than one level per SLSA track. Note that each SLSA
> level implies all levels below it (e.g. `SLSA_BUILD_LEVEL_3` implies
> `SLSA_BUILD_LEVEL_2` and `SLSA_BUILD_LEVEL_1`), so there is no need to
> include more than one level per track.

<a id="dependencyLevels"></a>
`dependencyLevels` _object, optional_

> A count of the dependencies at each SLSA level.
>
> Map from [SlsaResult] to the number of the artifact's _transitive_ dependencies
> that were verified at the indicated level. Absence of a given level of
> [SlsaResult] MUST be interpreted as reporting _0_ dependencies at that level.
> A set but empty `dependencyLevels` object means that the artifact has **no**
> dependency at all, while an unset or null `dependencyLevels` means that the
> verifier makes no claims about the artifact's dependencies.
>
> Users MUST count each dependency only once per SLSA track, at the highest
> level verified. For example, if a dependency meets `SLSA_BUILD_LEVEL_2`,
> you include it with the count for `SLSA_BUILD_LEVEL_2` but not the count for
> `SLSA_BUILD_LEVEL_1`.

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

## _SlsaResult (String)_

</div>

The result of evaluating an artifact (or set of artifacts) against SLSA.
SHOULD be one of these values:

-   `SLSA_BUILD_LEVEL_0`
-   `SLSA_BUILD_LEVEL_1`
-   `SLSA_BUILD_LEVEL_2`
-   `SLSA_BUILD_LEVEL_3`
-   `FAILED` (Indicates policy evaluation failed)

Note that each SLSA level implies the levels below it in the same track.
For example, `SLSA_BUILD_LEVEL_3` means (`SLSA_BUILD_LEVEL_1` +
`SLSA_BUILD_LEVEL_2` + `SLSA_BUILD_LEVEL_3`).

Users MAY use custom values here but MUST NOT use custom values starting with
`SLSA_`.

## Change history

-   1:
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
