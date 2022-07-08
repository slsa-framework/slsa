# Survey of Known Technologies

Author: lodato@google.com \
Date: March 2021 \
Status: IN REVIEW

## Objective

Document all known technologies that relate to SLSA, how they map to our model,
and a (hopefully not too biased) assessment of various properties of each.

See [Attestations](attestations.md) and [Policy](policy.md) for the
corresponding [models and terminology](attestations.md#model-and-terminology).

## Overview

The following table provides an overview of how various technologies map to our
model. Subsequent sections analyze each layer.

[Binary Authorization]: https://cloud.google.com/binary-authorization
[DSSE]: https://github.com/secure-systems-lab/dsse/
[JSS]: https://jsonenc.info/jss/1.0/
[JWS]: https://tools.ietf.org/html/rfc7515
[JWT]: https://tools.ietf.org/html/rfc7519
[Notary v2]: https://github.com/notaryproject/nv2
[OpenPGP]: https://tools.ietf.org/html/rfc4880
[PASETO]: https://paseto.io
[SPDX]: https://github.com/spdx/spdx-spec
[Simple Signing]: https://github.com/containers/image/blob/master/docs/containers-signature.5.md
[in-toto v1]: https://github.com/in-toto/docs/blob/master/in-toto-spec.md
[in-toto v2]: https://github.com/in-toto/attestation

Project                | Envelope | Statement | Predicate | Storage | Generation | Policy | Status
---------------------- | -------- | --------- | --------- | ------- | ---------- | ------ | ------
Raw signing            | ✓        | ✓         | ✗         |         |            |        | (varies)
[JSS]                  | ✓        |           |           |         |            |        | Abandoned
[JWS]                  | ✓        |           |           |         |            |        | IETF Standard
[JWT]                  | ✓        |           |           |         |            |        | IETF Standard
[OpenPGP]              | ✓        |           |           |         |            |        | IETF Standard
[PASETO]               | ✓        |           |           |         |            |        | Stable
[DSSE]                 | ✓        |           |           |         |            |        | In development
[in-toto v1]           | ✓        | ✓         | ✓         |         | ✓          | ✓      | Stable
[Notary v2]            | ~        | ✓         | ✗         | ✓       |            | ✓      | In development
[Simple Signing]       | ~        | ✓         |           |         |            |        | Stable
[in-toto v2]           | ~        | ✓         |           |         |            |        | In development
[SPDX]                 |          |           | ✓         |         |            |        | Stable
[Binary Authorization] | ~        | ~         | ✗         | ~       |            | ✓      | Stable

Legend:

-   ✓ Defines this layer
-   ✗ Does not support this layer
-   ~ Imposes requirements on this layer
-   (blank) No opinion on this layer

Columns:

-   Envelope: Defines the envelope layer of the attestation.
-   Statement: Defines the statement layer of the attestation.
-   Predicate: Defines the predicate layer of the attestation.
-   Storage: Provides a mechanism for attestation storage and retrieval.
-   Generation: Provides a mechanism for generating attestations.
-   Policy: Provides a mechanism for consuming attestations and rendering policy
    decisions.
-   Status: Is it available now?

## Envelope Layer (not specific to Attestations)

Property                | [DSSE]         | [OpenPGP] | [JWS] | [JWT] | [PASETO] | [in-toto v1] | [JSS]
----------------------- | -------------- | --------- | ----- | ----- | -------- | ------------ | -----
Authenticated Purpose   | ✓              | ✗         | ✓     | ✓     | ✗        | ✓            | ✗
Arbitrary Message Type  | ✓              | ✓         | ✓     | ✗     | ✗        | ✗            | ✗
Simple                  | ✓              | ✗         | ✗     | ✗     | ✓        | ✓            | ✓
Avoids Canonicalization | ✓              | ✓         | ✓     | ✓     | ✓        | ✗            | ✓
Pluggable Crypto        | ✓              | ✗         | ✓     | ✓     | ✗        | ✓            | ✓
Efficient Encoding      | ✓              | ✗         | ✗     | ✗     | ✗        | ✓            | ✗
Widely Adopted          | ✗ (not yet!)   | ✓         | ✓     | ✓     | ✗        | ✗            | ✗

Properties:

-   **Authenticated Purpose:** Does the envelope authenticate how the verifier
    should interpret the message in order to prevent confusion attacks?
    -   ✓ DSSE: `payloadType`, JWS: `typ`, JWT: `aud`, in-toto v1:
        `_type`
-   **Arbitrary Message Type:** Does the envelope support arbitrary message
    types / encodings?
    -   ✗ PASETO, JWT, in-toto v1, JSS: only supports JSON messages
-   **Simple:** Is the standard simple, easy to understand, and unlikely to be
    implemented incorrectly?
    -   ✗ PGP: Enformous RFC.
    -   ✗ JWS, JWT: Enormous RFC, many vulnerabilities in the past.
-   **Avoids Canonicalization:** Does the protocol avoid relying on
    canonicalization for security, in order to reduce attack surface?
    -   ✗ in-toto v1: Relies on Canonical JSON
-   **Pluggable Crypto:** If desired, can the cryptographic algorithm and key
    management be swapped out if desired? (Not always desirable.)
    -   ✗ OpenPGP: Uses PGP
    -   ✗ PASETO: Mandates very specific algorithms, e.g. ed25519
-   **Efficient Encoding:** Does the standard avoid base64, or can the envelope
    be re-encoded in a more efficient format, such as protobuf or CBOR, without
    invalidating the signature?
-   **Widely Adopted:** Is the standard widely adopted?
    -   ✗ DSSE: Not yet used, though in-toto and TUF plan to.
    -   ✗ PASETO: Not common.
    -   ✗ in-toto v1: Only by in-toto and TUF.
    -   ✗ JSS: Abandoned, never used.

## Statement Layer

Property              | [in-toto v2] | [in-toto v1] | [Simple Signing] | [Notary v2] | Raw Signing
--------------------- | ------------ | ------------ | ---------------- | ----------- | -----------
Recommended Envelope  | DSSE         | in-toto v1   | OpenPGP          | JWT         | (various)
Subject: Clear        | ✓            | ✗            | ✓                | ✓           | ✓
Subject: Any Type     | ✓            | ✓            | ✗                | ✓           | (depends)
Subject: Multi-Digest | ✓            | ✓            | ✗                | ✗           | (depends)
Predicate: Supported  | ✓            | ✓            | ✓                | ✗           | ✗
Predicate: Flexible   | ✓            | ✗ (*)        | ✓                | (n/a)       | (n/a)
Predicate: Typed      | ✓            | ✗            | ✗                | (n/a)       | (n/a)
Layered               | ✓            | ✗            | ✓                | (n/a)       | (n/a)
Evolvable             | ✓            | ✓            | ✗                | ✓           | ✗

Properties:

-   **Recommended Envelope:** Which envelope is recommended (or possibly
    required)?
-   **Subject: Clear:** Is the Attestation clearly about a particular
    attestation?
    -   ✗ in-toto v1: Subject is ambiguous between `materials` and `products`.
-   **Subject: Any Type:** Does Subject support arbitrary Artifact types?
    -   ✗ Simple Signing: `critical.image` only supports Docker/OCI image
        manifests (and because it's `critical`, that field is required.) Also,
        `critical.identity` is required but not applicable to all use cases
        (e.g. build provenance, where the identity is not yet known).
-   **Subject: Multi-Digest:** Does Subject support specifying multiple digest
    algorithms for crypto agility?
    -   ✗ Simple Signing, Notary v2: Only one digest supported. (The `multihash`
        algorithm mentioned in the OCI image-spec is not defined or implemented
        anywhere.)
-   **Predicate: Supported:** Can a predicate be supplied?
    -   ✗ Notary v2: Does not officially support a predicate. Undefined what
        happens if extra predicate fields are added to the JWT.
-   **Predicate: Flexible:** Can a user-defined predicate be used?
    -   ✗ in-toto v1: Several fixed, required predicate fields. Technically
        arbitrary data can be added to `environment` but that is not well
        documented or standardized.
    -   ✓ Simple Signing: Can use `optional` field.
-   **Predicate: Typed:** Is there a well-established convention of indicating
    the meaning of the Attestation and/or the schema of the user-defined
    predicate unambiguous?
-   **Layered:** Does the schema clearly match the layers of our
    [model](attestations.md#model-and-terminology)?
    -   ✗ in-toto v1: Statement and Predicate fields are mixed together.
-   **Evolvable:** Can the spec be modified to support required features?
    -   ✗ Simple Signing: The `critical` field can effectively never change
        because the producer and consumer must agree in lock step.

## Bundle + Storage/Lookup

-   Local filesystem
    -   (none yet)
-   OCI/Docker Registry:
    -   [sigstore/cosign](https://github.com/sigstore/cosign) **(recommended)**
    -   [Notary v2]

## Raw artifact signing

For reference, we list examples of raw artifact signing, where the statement
only contains the subject.

-   [Node.js](https://github.com/nodejs/node#verifying-binaries)
    ([example](https://nodejs.org/dist/v14.16.0/SHASUMS256.txt.asc))
    -   Envelope: PGP Signed Message.
    -   Statement: List of (sha256, filename) pairs.

## TODO

Show how the following are related:

-   Cosign / SigStore
-   Kritis
-   Grafeas / Container Analysis
-   Docker Content Trust
-   Notary v1
-   "attached" signatures. RPMs, Maven artifacts, Windows drivers, OSX app store
    apps
-   Android APK signatures
-   (Public) transparency ledger?
