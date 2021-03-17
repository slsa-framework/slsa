# Software Attestations

Author: lodato@google.com \
Date: March 9, 2021 \
Status: IN REVIEW

## Objective

Standardize the terminology, data model, layers, and conventions for software
artifact metadata.

## Model and Terminology

A software **attestation** is a signed statement (metadata) about a software
**artifact** or collection of software artifacts. (Sometimes called a
"[software bill of materials](https://en.wikipedia.org/wiki/Software_bill_of_materials)"
or SBoM. Not to be confused with
[remote attestation](https://en.wikipedia.org/wiki/Trusted_Computing#Remote_attestation)
in the trusted computing world.)

We define the following model to represent any software attestations, regardless
of format. Not all formats will have all fields or all layers, but to be called
an "attestation" it must fit this general model.

<p align="center"><img width="100%" src="images/attestation_layers.svg"></p>

Example in English:

<p align="center"><img width="80%" src="images/attestation_example_english.svg"></p>

Summary:

-   **Artifact:** Immutable blob of data. Examples: file content, git commit,
    Docker image.
-   **Attestation:** Authenticated message containing metadata about one or more
    software artifacts. It has the following layers:
    -   **Envelope:** Authenticates the message (**Signature**) and
        unambiguously identifies how to interpret the next layer
        (**MessageType**). May also contain unauthenticated data, such as a key
        hint.
        -   Note: The envelope layer is not specific to the attestations model
            and can be used for other types of messages.
    -   **Statement:** Binds the attestation to a specific set of artifacts
        (**Subject**) and identifies what the attestation means
        (**PredicateType**). May also reference other artifacts (**Materials**)
        that influenced the Statement.
    -   **Predicate:** Describes arbitrary properties of the subject using a
        type-specific schema.
-   **Bundle:** A collection of Attestations, which are usually but not
    necessarily related.
    -   Note: The bundle itself is unauthenticated. Authenticating multiple
        attestations as a unit is out of scope of this model. For that, consider
        [TUF](https://theupdateframework.io/).
-   **Storage/Lookup:** Convention for where attestors place Attestations and
    how verifiers find Attestations for a given Artifact.

See [Requirements](#requirements) for details and
[Appendix: Known Attestation Formats](#heading=h.38zmbsgw7uys) for examples.

## Intended Use Case

The primary intended use case is to feed into an
[automated policy framework](policy.md). See that doc for more info.

<p align="center"><img width="50%" src="images/policy_model.svg"></p>

Other use cases are "nice-to-haves", including ad-hoc analysis.

## Requirements

We define the minimal set of requirements for attestations to fit into this
framework. The key words MUST, MUST NOT, SHOULD, and MAY are to be interpreted
as described in [RFC 2119](https://tools.ietf.org/html/rfc2119).

General requirements:

*   All layers MUST be machine parsable and suitable for processing via an
    [automated policy framework](policy.md).
*   Each layer SHOULD be independent of the layers above.
*   Layers and fields MAY be omitted if implicit or unnecessary. For example,
    traditional "raw artifact signing" uses a fixed, application-specific
    Statement with no explicit MessageType and no PredicateType/Predicate.
*   Field names MAY differ from the model.

Envelope requirements:

*   Envelope MUST include a cryptographic Signature.
*   Envelope MUST include an authenticated Message containing a Statement.
*   Envelope SHOULD include an authenticated MessageType indicating how to
    interpret Message.
*   Envelope MAY contain other authenticated or unauthenticated data.

Statement requirements:

*   Statement MUST include a Subject identifying at least one Artifact.
    *   Subject MUST refer to immutable Artifacts. Identifier SHOULD be a
        cryptographic content digest whenever possible, but MAY be some other
        trusted immutable identifier. Examples: `sha256:dd2f3...`,
        `svn+https://example.com/svn-repo@341`.
    *   Subject SHOULD support crypto agility by specifying multiple alternative
        digests.
    *   Subject MAY include mutable locators for those Artifacts, such as URIs
        or package names. Example: `pkg:docker/alpine`.
*   Statement SHOULD include a PredicateType and/or Predicate indicating what
    the Statement means.
*   Statement MAY include Materials identifying other Artifacts that influenced
    the Statement. Being in this layer allows uniform processing of references
    independent of the predicate type, which may be desirable in some cases.

## Recommended Suite

We recommend a single suite of formats and conventions that work well together
and have desirable security properties. Our hope is to align the industry around
this particular suite because it makes everything easier. That said, we
recognize that other choices may be necessary in various cases.

Summary: Generate [in-toto](https://in-toto.io) attestations.

*   Envelope:
    **[secure-systems-lab/signing-spec](https://github.com/secure-systems-lab/signing-spec/)**
    (TODO: Recommend Crypto/PKI)
*   Statement:
    **[in-toto/attestation-spec](https://github.com/in-toto/attestation-spec/)**
*   Predicate: Choose as appopriate. (TODO link to specific specs)
    *   Provenance
    *   [SPDX]
    *   If none are a good fit, invent a new one.
*   Bundle and Storage/Lookup:
    *   Local Filesystem: TODO
    *   Docker/OCI Registry:
        **[sigstore/cosign](https://github.com/sigstore/cosign)**

## Survey of Known Formats

The following list shows how existing formats map to our model, along with
various properties we think may be valuable.

### Envelope Layer (not specific to Attestations)

[signing-spec]: https://github.com/secure-systems-lab/signing-spec/
[OpenPGP]: https://tools.ietf.org/html/rfc4880
[JWS]: https://tools.ietf.org/html/rfc7515
[JWT]: https://tools.ietf.org/html/rfc7519
[in-toto v1]: https://github.com/in-toto/docs/blob/master/in-toto-spec.md
[PASETO]: https://paseto.io
[JSS]: https://jsonenc.info/jss/1.0/

Property                | [signing-spec] | [OpenPGP] | [JWS]/[JWT] | [PASETO] | [in-toto v1] | [JSS]
----------------------- | -------------- | --------- | ----------- | -------- | ------------ | -----
Authenticated Purpose   | ✓              | ✗         | ✓           | ✗        | ✓            | ✗
Arbitrary Message Type  | ✓              | ✓         | ✗           | ✗        | ✗            | ✗
Simple                  | ✓              | ✗         | ✗           | ✓        | ✓            | ✓
Avoids Canonicalization | ✓              | ✓         | ✓           | ✓        | ✗            | ✓
Pluggable Crypto        | ✓              | ✗         | ✓           | ✗        | ✓            | ✓
Efficient Encoding      | ✓              | ✗         | ✗           | ✗        | ✓            | ✗
Widely Adopted          | ✗ (not yet!)   | ✓         | ✓           | ✗        | ✗            | ✗

Properties:

-   **Authenticated Purpose:** Does the envelope authenticate how the verifier
    should interpret the message in order to prevent confusion attacks?
    -   ✓ signing-spec: `payloadType`, JWS: `typ`, JWT: `aud`, in-toto v1:
        `_type`
-   **Arbitrary Message Type:** Does the envelope support arbitrary message
    types / encodings?
    -   ✗ PASETO, JWS/JWT, in-toto v1, JSS: only supports JSON messages
-   **Simple:** Is the standard simple, easy to understand, and unlikely to be
    implemented incorrectly?
    -   ✗ PGP: Enformous RFC.
    -   ✗ JWS/JWT: Enormous RFC, many vulnerabilities in the past.
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
    -   ✗ signing-spec: Not yet used, though in-toto and TUF plan to.
    -   ✗ PASETO: Not common.
    -   ✗ in-toto v1: Only by in-toto and TUF.
    -   ✗ JSS: Abandoned, never used.

### Statement Layer

[in-toto v2]: https://github.com/in-toto/attestations
[Simple Signing]: https://github.com/containers/image/blob/master/docs/containers-signature.5.md
[Notary v2]: https://github.com/notaryproject/nv2
[SPDX]: https://github.com/spdx/spdx-spec

Property              | [in-toto v2] | [in-toto v1] | [Simple Signing] | [Notary v2] | Raw Signing
--------------------- | ------------ | ------------ | ---------------- | ----------- | -----------
Recommended Envelope  | signing-spec | in-toto v1   | OpenPGP          | JWT         | (various)
Subject: Clear        | ✓            | ✗            | ✓                | ✓           | ✓
Subject: Any Type     | ✓            | ✓            | ✗                | ✓           | (depends)
Subject: Multi-Digest | ✓            | ✓            | ✗                | ✗           | (depends)
Predicate: Supported  | ✓            | ✓            | ✓                | ✗           | ✗
Predicate: Flexible   | ✓            | ✗ (*)        | ✓                | (n/a)       | (n/a)
Predicate: Typed      | ✓            | ✗            | ✗                | (n/a)       | (n/a)
Materials: Supported  | ✓            | ✓            | ✗                | ✗           | ✗
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
    -   ✗ Only one digest supported. (The `multihash` algorithm mentioned in the
        OCI image-spec is not defined or implemented anywhere.)
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
-   **Materials: Supported:** Are Materials standardized in the Statement layer?
-   **Layered:** Does the schema clearly match the layers of our
    [model](#model-and-terminology)?
    -   ✗ in-toto v1: Statement and Predicate fields are mixed together.
-   **Evolvable:** Can the spec be modified to support required features?
    -   ✗ Simple Signing: The `critical` field can effectively never change
        because the producer and consumer must agree in lock step.

### Bundle + Storage/Lookup

-   Local filesystem
    -   (none yet)
-   OCI/Docker Registry:
    -   [sigstore/cosign](https://github.com/sigstore/cosign) **(recommended)**
    -   [Notary v2]

### Raw artifact signing

For reference, we list examples of raw artifact signing, where the statement
only contains the subject.

-   [Node.js](https://github.com/nodejs/node#verifying-binaries)
    ([example](https://nodejs.org/dist/v14.16.0/SHASUMS256.txt.asc))
    -   Envelope: PGP Signed Message.
    -   Statement: List of (sha256, filename) pairs.

## TODO

Show how the following are related:

-   [Binary Authorization](https://cloud.google.com/sdk/gcloud/reference/beta/container/binauthz/create-signature-payload)
-   Secure Boot - Also uses the term "attestation", possibly with a different
    meaning. Need to make sure it's compatible. Ask
    [kmoy](https://moma.corp.google.com/person/kmoy) and
    [arimed](https://moma.corp.google.com/person/arimed).
-   Cosign / SigStore
-   Drydock
-   Docker Content Trust
-   Notary v1
-   "attached" signatures. RPMs, Maven artifacts, Windows drivers, OSX app store
    apps
-   Android APK signatures
-   (Public) transparency ledger?
