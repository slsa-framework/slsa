# Software Attestations

Author: lodato@google.com \
Date: March 2021 \
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

See [survey](survey.md) for other options.

## Appendix: Naming

TODO(lodato) Provide a survey of possible names we considered, along with
pros/cons: Attestation, Testimony, Testament, Claim, Voucher, Statement,
Predicate, Message, Finding.
