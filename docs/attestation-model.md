---
title: Software attestations
layout: standard
hero_text: A software attestation is a signed statement (metadata) about a software artifact or collection of software artifacts.
---

## Purpose

The software attestations model provides standardized terminology, data model, layers,
and conventions for authenticated software artifact metadata.

The primary intended use case is to feed into automated policy engines, such as
[in-toto] and [Binary Authorization].

## Overview

A software attestation is a signed statement (metadata) about a software
artifact or collection of software artifacts. (Not to be confused with
[remote attestation] in the trusted computing world.)

An attestation is the generalization of raw artifact/code signing, where the
signature is directly over the artifact or a hash of artifact:

-   With raw signing, a signature *implies* a single bit of metadata about the
    artifact, based on the public key. The exact meaning must be negotiated
    between signer and verifier, and a new keyset must be provisioned for each
    bit of information. For example, a signature might denote who produced an
    artifact, or it might denote fitness for some purpose, or something else
    entirely.

-   With an attestation, the metadata is *explicit* and the signature only
    denotes who created the attestation. A single keyset can express an
    arbitrary amount of information, including things that are not possible with
    raw signing. For example, an attestation might state exactly how an artifact
    was produced, including the build command that was run and all of its
    dependencies.

## Model and Terminology

We define the following model to represent any software attestations, regardless
of format. Not all formats will have all fields or all layers, but to be called
an "attestation" it MUST fit this general model.

The key words MUST, SHOULD, and MAY are to be interpreted as described in
[RFC 2119].

![Attestation model diagram](../images/attestation_layers.svg)

Example in English:

![Attestation model to English mapping](../images/attestation_example_english.svg)

Summary:

-   **Artifact:** Immutable blob of data described by an attestation, usually
    identified by cryptographic content hash. Examples: file content, git
    commit, Docker image. May also include a mutable locator, such as a package
    name or URI.

-   **Attestation:** Authenticated, machine-readable metadata about one or more
    software artifacts. An attestation MUST contain at least:

    -   **Envelope:** Authenticates the message. At a minimum, it contains:

        -   **Message:** Content (statement) of the attestation. The message
            type SHOULD be authenticated and unambiguous to avoid confusion
            attacks.

        -   **Signature:** Denotes the **attester** who created the attestation.

    -   **Statement:** Binds the attestation to a particular set of artifacts.
        This is a separate layer is to allow for predicate-agnostic processing
        and storage/lookup. MUST contain at least:

        -   **Subject:** Identifies which artifacts the predicate applies to.

        -   **Predicate:** Metadata about the subject. The predicate type SHOULD
            be explicit to avoid misinterpretation.

    -   **Predicate:** Arbitrary metadata in a predicate-specific schema. MAY
        contain:

        -   **Link:** *(repeated)* Reference to a related artifact, such as
            build dependency. Effectively forms a [hypergraph] where the
            nodes are artifacts and the hyperedges are attestations. It is
            helpful for the link to be standardized to allow predicate-agnostic
            graph processing.

-   **Bundle:** A collection of Attestations, which are usually but not
    necessarily related.

    -   Note: The bundle itself is unauthenticated. Authenticating multiple
        attestations as a unit is [TBD](#compound-statement).

-   **Storage/Lookup:** Convention for where attesters place attestations and
    how verifiers find attestations for a given artifact.

## Recommended Suite

We recommend a single suite of formats and conventions that work well together
and have desirable security properties. Our hope is to align the industry around
this particular suite because it makes everything easier. That said, we
recognize that other choices may be necessary in various cases.

Summary: Generate [in-toto] attestations.

-   Envelope: **[DSSE]** (TODO: Recommend Crypto/PKI)
-   Statement: **[in-toto/attestation]**
-   Predicate: Choose as appropriate:
    -   [Provenance]
    -   [SPDX]
    -   [Other predicates defined by third-parties]
    -   If none are a good fit, invent a new one.
-   Bundle and Storage/Lookup:
    -   Local Filesystem: TODO
    -   Docker/OCI Registry: **[sigstore/cosign]**

[Binary Authorization]: https://cloud.google.com/binary-authorization
[DSSE]: https://github.com/secure-systems-lab/dsse/
[hypergraph]: https://en.wikipedia.org/wiki/Hypergraph
[in-toto]: https://in-toto.io
[in-toto/attestation]: https://github.com/in-toto/attestation/
[Other predicates defined by third-parties]: https://github.com/in-toto/attestation/issues/98
[Provenance]: https://slsa.dev/provenance
[remote attestation]: https://en.wikipedia.org/wiki/Trusted_Computing#Remote_attestation
[RFC 2119]: https://tools.ietf.org/html/rfc2119
[sigstore/cosign]: https://github.com/sigstore/cosign
[SPDX]: https://github.com/in-toto/attestation/blob/main/spec/predicates/spdx.md
