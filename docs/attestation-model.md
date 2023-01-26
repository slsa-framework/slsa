---
title: Software attestations
layout: specifications
---

<div class="subtitle">

A software attestation is an authenticated statement (metadata) about a
software artifact or collection of software artifacts.

The primary intended use case is to feed into automated policy engines, such as
[in-toto] and [Binary Authorization].

</div>

This page provides a high-level overview of the attestation model, including
standardized terminology, data model, layers, and conventions for software
attestations.

## Overview

A **software attestation**, not to be confused with a [remote attestation] in
the trusted computing world, is an authenticated statement (metadata) about a
software artifact or collection of software artifacts. Software attestations
are a generalization of raw artifact/code signing.

With raw signing, a signature is directly over the artifact (or a hash of the
artifact) and *implies* a single bit of metadata about the artifact, based on
the public key. The exact meaning MUST be negotiated between signer and
verifier, and a new keyset MUST be provisioned for each bit of information. For
example, a signature might denote who produced an artifact, or it might denote
fitness for some purpose, or something else entirely.

With an attestation, the metadata is *explicit* and the signature only denotes
who created the attestation (authenticity). A single keyset can express an
arbitrary amount of information, including things that are not possible with
raw signing. For example, an attestation might state exactly how an artifact
was produced, including the build command that was run and all of its
dependencies (as in the case of SLSA [Provenance]).

## Model and Terminology

We define the following model to represent any software attestations, regardless
of format. Not all formats will have all fields or all layers, but to be called
a "software attestation" it MUST fit this general model.

The key words MUST, SHOULD, and MAY are to be interpreted as described in
[RFC 2119].

![Attestation model diagram](images/attestation_layers.svg)

An example of an attestation in English follows with the components of the
attestation mapped to the component names (and colors from the model diagram above):

![Attestation model to English mapping](images/attestation_example_english.svg)

Components:

-   **Artifact:** Immutable blob of data described by an attestation, usually
    identified by cryptographic content hash. Examples: file content, git
    commit, container digest. MAY also include a mutable locator, such as
    a package name or URI.
-   **Attestation:** Authenticated, machine-readable metadata about one or more
    software artifacts. An attestation MUST contain at least:
    -   **Envelope:** Authenticates the message. At a minimum, it MUST contain:
        -   **Message:** Content (statement) of the attestation. The message
            type SHOULD be authenticated and unambiguous to avoid confusion
            attacks.
        -   **Signature:** Denotes the **attester** who created the attestation.
    -   **Statement:** Binds the attestation to a particular set of artifacts.
        This is a separate layer to allow for predicate-agnostic processing
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
-   **Storage/Lookup:** Convention for where attesters place attestations and
    how verifiers find attestations for a given artifact.

## Recommended Suite

We recommend a single suite of formats and conventions that work well together
and have desirable security properties. Our hope is to align the industry around
this particular suite because it makes everything easier. That said, we
recognize that other choices MAY be necessary in various cases.

| Component | Recommendation |
| --- | --- |
| Envelope | **[DSSE]** (**TODO**: Recommend Crypto/PKI) |
| Statement | **[in-toto attestations]** |
| Predicate | Choose as appropriate, i.e.; [Provenance], [SPDX], [other predicates defined by third-parties]. If none are a good fit, invent a new one |
| Bundle | **[JSON Lines]**, see [attestation bundle] |
| Storage/Lookup | **TBD** |

[attestation bundle]: https://github.com/in-toto/attestation/blob/main/spec/bundle.md
[Binary Authorization]: https://cloud.google.com/binary-authorization
[DSSE]: https://github.com/secure-systems-lab/dsse/
[hypergraph]: https://en.wikipedia.org/wiki/Hypergraph
[in-toto]: https://in-toto.io
[in-toto attestations]: https://github.com/in-toto/attestation/
[JSON Lines]: https://jsonlines.org/
[other predicates defined by third-parties]: https://github.com/in-toto/attestation/issues/98
[Provenance]: /provenance
[remote attestation]: https://en.wikipedia.org/wiki/Trusted_Computing#Remote_attestation
[RFC 2119]: https://tools.ietf.org/html/rfc2119
[sigstore/cosign]: https://github.com/sigstore/cosign
[SPDX]: https://github.com/in-toto/attestation/blob/main/spec/predicates/spdx.md
