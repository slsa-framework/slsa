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

Definitions:

-   **Artifact:** Immutable blob of data. Examples: file content, git commit,
    Docker image.
-   **Attestation:** Authenticated message containing metadata about one or more
    software artifacts. It has the following layers:
    -   **Envelope:** Authenticates the message (**Signature**) and
        unambiguously identifies how to interpret the next layer
        (**MessageType**). MAY also contain unauthenticated data, such as a key
        hint.
        -   Note: The envelope layer is not specific to the attestations model
            and can be used for other types of messages.
    -   **Statement:** Binds the attestation to a specific set of artifacts
        (**Subject**) and identifies what the attestation means
        (**PredicateType**).
    -   **Predicate:** Describes arbitrary properties of the subject using a
        type-specific schema.
-   **Bundle:** A collection of Attestations, which are usually but not
    necessarily related.
    -   Note: The bundle itself is unauthenticated. Authenticating multiple
        attestations as a unit is out of scope of this model. For that, consider
        [TUF](https://theupdateframework.io/).

See [Appendix: Known Attestation Formats](#heading=h.38zmbsgw7uys) for examples.

Notes:

-   Most implementations do not follow this layering model strictly but do have
    similar concepts.
-   Some implementations omit components that are implicit. Examples:
    -   Traditional "raw artifact signing" uses a fixed, application-specific
        message type with no predicate. In this case, the public key must only
        ever be used for one message type and one purpose.
    -   In-toto uses a fixed message type with a particular schema, and the
        public key implies the predicate type.
-   Subject MUST provide an immutable identifier, usually a content hash, and
    MAY also include a mutable reference, such as a package name or URI.
    Examples of acceptable subjects: Docker image digest (`sha256:dd2fe…`),
    Docker image reference (`alpine@sha256:dd2fe…`), or server-guaranteed
    immutable reference (`svn+https://example.com/svn-repo@341`).

## Intended Use Case

The primary intended use case is to feed into [attestation-based security
policies](policy.md).

<p align="center"><img width="50%" src="images/policy_model.svg"></p>

## Recommended Technology Suite

### Specifications and Interfaces

We expect to recommend a single specification/convention for each category to
make integration easier.

<table>
<thead>
<tr><th>Category<th>Sub-category<th>Project</tr>
</thead>
<tbody>
<tr>
  <td rowspan="4">Attestation Format
  <td>Envelope Layer
  <td><a href="https://github.com/secure-systems-lab/signing-spec/">secure-systems-lab/signing-spec</a>
</tr>
<tr>
  <td>Statement Layer
  <td rowspan="3"><a href="https://github.com/in-toto/attestation-spec/">in-toto/attestation-spec</a><br>
      (<strong>new</strong> - split from
      <a href="https://github.com/in-toto/ITE/pull/15">ITE-6</a>)
</tr>
<tr>
  <td>Predicate Layer
</tr>
<tr>
  <td>Recommended Predicate Types
</tr>
<tr>
  <td rowspan="2">Attestation Storage
  <td>Local Filesystem
  <td><a href="https://github.com/in-toto/attestation-spec/">in-toto/attestation-spec</a>
</tr>
<tr>
  <td>Docker/OCI Registry</td>
  <td><a href="https://github.com/sigstore/cosign">sigstore/cosign</a><br>
      (Competing: <a href="https://github.com/notaryproject/nv2">notaryproject/nv2</a>)
</tr>
</tbody>
</table>

**Meta:** Model, terminology, and index of sub-projects and compatible
implementations. (This document.) \
**Attestation Format:** Data structures and protocols for expressing
attestations. Our strong desire is to get the industry to agree on a *single*
suite of formats to make producing and consuming attestations simple. This
includes:

-   Envelope Layer (protocol and data structure)
-   Statement Layer (data structure, typing, subject representation)
-   Predicate Layer (convention/API)
-   A small number of recommended Predicate schemas/types, such as Provenance or
    CodeReview. However, custom schemas/types will always be supported.
    -   The expectation is that users develop their own schemas, then as
        commonality emerges, we can standardize it when there is a benefit to
        doing so.

**Attestation Storage:** Conventions for storage and retrieval of attestations,
given a particular resource identifier. We expect one convention per
application, particularly:

-   Local Filesystem: Given a file path, how should attesters save attestations
    for that file, and how should verifiers find attestations for that file?
-   Docker/OCI Registry: Given a blob in an image/artifact registry, how should
    attesters save attestations for that blob, and how should verifiers find
    attestations for that blob?
-   Others on an as-needed basis.

### Compatible Implementations

We expect multiple competing implementations, each with their own benefits and
drawbacks. We list ones here that we would like to onboard into the ecosystem.

<table>
<thead>
<tr>
<th><strong>Category</strong></th>
<th><strong>Project Name</strong></th>
<th><strong>GitHub Repo</strong></th>
<th><strong>Status</strong></th>
</tr>
</thead>
<tbody>
<tr>
<td>Predicate Types</td>
<td>SPDX</td>
<td><a href="https://github.com/spdx/spdx-spec">spdx/spdx-spec</a></td>
<td>not started</td>
</tr>
<tr>
<td>Crypto</td>
<td>SigStore</td>
<td><a href="https://sigstore.dev/">sigstore</a></td>
<td>not started</td>
</tr>
<tr>
<td>Attestation Generation & Consumption</td>
<td>In-toto</td>
<td><a
href="https://github.com/in-toto/in-toto">in-toto/in-toto</a></td>
<td>pending</td>
</tr>
<tr>
<td></td>
<td>Kritis</td>
<td><a href="https://github.com/grafeas/kritis">grafeas/kritis</a></td>
<td>not started</td>
</tr>
<tr>
<td></td>
<td>Tekton Chains</td>
<td><a href="http://github.com/tektoncd/chains">tektoncd/chains</a></td>
<td>not started</td>
</tr>
<tr>
<td></td>
<td>Voucher</td>
<td><a
href="https://github.com/grafeas/voucher">grafeas/voucher</a></td>
<td>not started</td>
</tr>
<tr>
<td></td>
<td>Copasetic (prototype)</td>
<td><a
href="https://github.com/sigstore/cosign/tree/main/copasetic">SigStore/cosign/copasetic</a></td>
<td>not started</td>
</tr>
<tr>
<td></td>
<td>Binary Authorization</td>
<td>n/a (<a
href="https://cloud.google.com/binary-authorization">closed-source</a>)</td>
<td>pending</td>
</tr>
<tr>
<td></td>
<td>Binary Authorization for Borg</td>
<td>n/a (<a
href="https://cloud.google.com/security/binary-authorization-for-borg">Google-internal</a>)</td>
<td>pending</td>
</tr>
<tr>
<td>Policy Decision Points</td>
<td>(none yet)</td>
<td></td>
<td></td>
</tr>
</tbody>
</table>

**Predicate Types:** Additional predicate types that are not part of the core
specification. \
**Crypto:** Cryptographic signature algorithms and key management. There will
not be a one-size-fits-all crypto solution, so the crypto piece is pluggable in
this model. \
**Attestation Generation & Consumption:** Tools and services to generate and/or
consume attestations. Consumption is usually policy engines. \
**Policy Decision Points:** Software distribution systems where
attestation-based policies are supported. Includes container/artifact
registries, software repositories, package managers, and so on.

## Appendix: Known Formats and Tools

The following list shows how existing formats and tools map to our model.

### Envelopes (not specific to attestations)

<table>
<thead>
<tr>
<th>Property</th>
<th><a
href="https://github.com/secure-systems-lab/signing-spec/">signing-</a><br>
<a
href="https://github.com/secure-systems-lab/signing-spec/">spec</a></th>
<th><a href="https://tools.ietf.org/html/rfc4880">OpenPGP
Message</a></th>
<th><a href="https://paseto.io/">PASETO</a></th>
<th><a href="http://jwt.io/">JWS/</a><br>
<a href="http://jwt.io/">JWT</a></th>
<th><a
href="https://github.com/in-toto/docs/blob/master/in-toto-spec.md">in-toto/</a><br>
<a
href="https://github.com/in-toto/docs/blob/master/in-toto-spec.md">TUF</a></th>
<th><a href="https://jsonenc.info/jss/1.0/">JSON Simple Signing</a></th>
</tr>
</thead>
<tbody>
<tr>
<td>Authenticated Purpose</td>
<td>✓</td>
<td>✗</td>
<td>✗</td>
<td>✓</td>
<td>✓</td>
<td>✗</td>
</tr>
<tr>
<td>Arbitrary Message Type</td>
<td>✓</td>
<td>✓</td>
<td>✗</td>
<td>✗</td>
<td>✗</td>
<td>✗</td>
</tr>
<tr>
<td>Simple</td>
<td>✓</td>
<td>✗</td>
<td>✓</td>
<td>✗</td>
<td>✓</td>
<td>✓</td>
</tr>
<tr>
<td>Avoids Canonicalization</td>
<td>✓</td>
<td>✓</td>
<td>✓</td>
<td>✓</td>
<td>✗</td>
<td>✓</td>
</tr>
<tr>
<td>Pluggable Crypto</td>
<td>✓</td>
<td>✗</td>
<td>✗</td>
<td>✓</td>
<td>✓</td>
<td>✓</td>
</tr>
<tr>
<td>Efficient Encoding</td>
<td>✓</td>
<td>✗</td>
<td>✗</td>
<td>✗</td>
<td>✓</td>
<td>✗</td>
</tr>
<tr>
<td>Widely Adopted</td>
<td>✗ (not yet!)</td>
<td>✓</td>
<td>✗</td>
<td>✓</td>
<td>✗</td>
<td>✗</td>
</tr>
</tbody>
</table>

Properties:

-   **Authenticated Purpose:** Does the envelope authenticate how the verifier
    should interpret the message in order to prevent confusion attacks?

    -   ✓ signing-spec: `payloadType`, JWS: `typ`, JWT: `aud`, in-toto/TUF:
        `_type`

-   **Arbitrary Message Type:** Does the envelope support arbitrary message
    types / encodings?

    -   ✗ PASETO, JWS/JWT, in-toto/TUF, JSS: only supports JSON messages

-   **Simple:** Is the standard simple, easy to understand, and unlikely to be
    implemented incorrectly?

    -   ✗ PGP: Enformous RFC.
    -   ✗ JWS/JWT: Enormous RFC, many vulnerabilities in the past.

-   **Avoids Canonicalization:** Does the protocol avoid relying on
    canonicalization for security, in order to reduce attack surface?

    -   ✗ in-toto/TUF: Relies on Canonical JSON

-   **Pluggable Crypto:** If desired, can the cryptographic algorithm and key
    management be swapped out if desired? (Not always desirable.)

    -   ✗ OpenPGP: Uses PGP
    -   ✗ PASETO: Mandates very specific algorithms, e.g. ed25519

-   **Efficient Encoding:** Does the standard avoid base64, or can the envelope
    be re-encoded in a more efficient format, such as protobuf or CBOR?

-   **Widely Adopted:** Is the standard widely adopted?

    -   ✗ signing-spec: Not yet used, but our hope is to fix this!
    -   ✗ PASETO: Not common.
    -   ✗ in-toto/TUF: Only by in-toto/TUF.
    -   ✗ JSS: Abandoned, never used.

### Attestation formats (Statement + Predicate layer)

<table>
<thead>
<tr>
<th>Property</th>
<th>Raw Signing</th>
<th><a
href="https://github.com/in-toto/docs/blob/master/in-toto-spec.md">In-toto
Link 1.0</a></th>
<th><a
href="https://github.com/containers/image/blob/master/docs/containers-signature.5.md">"Simple
Signing"</a></th>
<th><a href="https://github.com/notaryproject/nv2">Notary v2</a></th>
<th><a href="https://github.com/spdx/spdx-spec">SPDX</a></th>
</tr>
</thead>
<tbody>
<tr>
<td>Envelope</td>
<td>(various)</td>
<td>Custom</td>
<td>PGP</td>
<td>JWT</td>
<td>(none)</td>
</tr>
<tr>
<td>Statement</td>
<td></td>
<td></td>
<td></td>
<td></td>
<td>(none)</td>
</tr>
<tr>
<td>Subject</td>
<td></td>
<td></td>
<td></td>
<td></td>
<td>n/a</td>
</tr>
<tr>
<td>Typed Predicate</td>
<td></td>
<td>✗</td>
<td></td>
<td></td>
<td>n/a</td>
</tr>
<tr>
<td>Not Specific to One Artifact Type</td>
<td>(depends)</td>
<td>✓</td>
<td>✗ (Docker)</td>
<td>✗ (Docker)</td>
<td>n/a</td>
</tr>
<tr>
<td>Predicate</td>
<td>✗</td>
<td>✓</td>
<td></td>
<td>✗</td>
<td>✓</td>
</tr>
<tr>
<td></td>
<td>n/a</td>
<td></td>
<td></td>
<td>n/a</td>
<td></td>
</tr>
<tr>
<td></td>
<td>n/a</td>
<td></td>
<td></td>
<td>n/a</td>
<td></td>
</tr>
<tr>
<td></td>
<td>n/a</td>
<td></td>
<td></td>
<td>n/a</td>
<td></td>
</tr>
</tbody>
</table>

-   [In-toto Link 1.0](https://github.com/in-toto/docs/blob/master/in-toto-spec.md)

    -   Mapping to our model:

        -   Envelope: Custom - JSON encoding, raw signature over Canonical JSON.
        -   Statement: JSON object with fixed `_type`. Subject is some subset of
            `materials` and/or `products`. No explicit PredicateType.
        -   Predicate: fixed schema.

    -   Problems:

        -   No clear subject.
        -   Predicate schema too constrained.
        -   Nitpicks: Naming is confusing. Does not cleanly separate into the
            layers above. No explicit PredicateType.

-   [RedHat "Simple Signing"](https://github.com/containers/image/blob/master/docs/containers-signature.5.md)
    ([blog post](https://www.redhat.com/en/blog/container-image-signing))

    -   Mapping to our model:

        -   Envelope: PGP Signed Message (suggested but not required)
        -   Statement: JSON object with fixed `critical.type`. Subject is
            `critical.image` + `critical.identity`. No explicit PredicateType.
        -   Predicate: `optional` field (arbitrary JSON object)

    -   Problems:

        -   `critical`+`optional` is simultaneously too brittle and too loose.
            The critical fields can effectively never change because the
            producer and consumer must agree in lock step, while the optional
            fields lack validation, typing, or versioning.

            -   _Suggested solution:_ Explicit MessageType and PredicateType,
                each mapping to a versioned schema.

        -   `critical.image` is too inflexible and ambiguous. Does not specify
            ALL vs ANY semantics when multiple members are present. Does not
            support multiple, alternative digests. Does not support multiple
            artifacts.

            -   _Suggested solution:_ ANY semantics, ignore
                unrecognized/unsupported members.

        -   `critical.identity` is required but does not make sense in all
            contexts. For example, a "provenance" attestation likely does not
            yet know the identity.

            -   _Suggested solution: _Make it optional.

        -   Nitpicks: Naming is too container-centric. Does not cleanly separate
            into the layers above.

-   [Notary v2](https://github.com/notaryproject/nv2)

    -   Mapping to our model:

        -   Envelope: JWT
        -   Statement: JWT
        -   Predicate: None. (Technically you could put predicates in the JWT,
            but the spec does not say anything about that one way or the other,
            and it is not designed to do this.)

    -   Problems:

        -   Docker/OCI-specific, especially `references`.
        -   Does not naturally support multiple digest algorithms.
        -   Does not officially support predicates.
        -   (matter of opinion) Subject does not naturally support multiple
            artifacts, though you can sign an index which in turn lists multiple
            artifacts. But it is awkward and detached.
        -   Nitpicks: Does not cleanly separate into layers above.

-   [Binary Authorization](https://cloud.google.com/sdk/gcloud/reference/beta/container/binauthz/create-signature-payload)

    -   Mapping to our model:
        -   Envelope: (TODO)
        -   Statement: RedHat "Simple Signing"
        -   Predicate: not supported

-   [SPDX](https://github.com/spdx/spdx-spec)

    -   Mapping to our model: just Predicate (AFAICT)
    -   Problems:
        -   Does not specify envelope or statement layer.
        -   Too complex. Trying to be all things to all parties with a fixed
            schema.
        -   Not extensible. Cannot add custom metadata (AFAICT). In particular,
            does not easily support the few fields we care about for provenance.

TODO - Table of the above.

### Raw artifact signing (Statement ≅ Subject)

-   [Node.js](https://github.com/nodejs/node#verifying-binaries)
    ([example](https://nodejs.org/dist/v14.16.0/SHASUMS256.txt.asc))
    -   Envelope: PGP Signed Message.
    -   Statement: List of (sha256, filename) pairs.

### Policy Engine + Software Distribution

-   [Binary Authorization](https://cloud.google.com/sdk/gcloud/reference/beta/container/binauthz/create-signature-payload)
    -   Envelope

TODO:

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
