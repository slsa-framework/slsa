---
title: "Dependency: Provenance"
description: Description of the SLSA Dependency Ingestion Provenance specification for attesting how a third-party dependency entered the ingestor's environment.
layout: standard
---

A Dependency Ingestion Provenance is the per-ingestion attestation
emitted by a
[Dependency Ingestion Platform](dependency-track.md#dependency-ingestion-platform).
It records the upstream identity of the consumed dependency, the
platform that admitted it, and (where applicable) the
identity-verification verdicts (integrity, publisher signature) and any
admission-policy evaluations the platform applied. At higher levels of
the [Dependency Track](dependency-track.md) it also records the
upstream-provenance verdict and the platform's signing-infrastructure
and ingestion isolation attestations.

This document defines the following predicate type within the
[in-toto attestation] framework:

```json
"predicateType": "https://slsa.dev/dependency/v1"
```

> Important: Always use the above string for `predicateType` rather than
> what is in the URL bar. The `predicateType` URI will always resolve to
> the latest minor version of this specification. See
> [parsing rules](#parsing-rules) for more information.

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT",
"SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this
document are to be interpreted as described in
[RFC 2119](https://www.rfc-editor.org/rfc/rfc2119).

## Purpose

Describe how a single third-party dependency entered an ingestor's
environment so that:

-   Verifiers can confirm the dependency was admitted by a known
    Dependency Ingestion Platform, was integrity-verified, was screened
    against the policies appropriate to the claimed
    [Dependency Track level](dependency-track.md#levels), and (at Dep L3)
    references any verified upstream Build provenance.
-   Downstream parties, including the consumers of an artifact built from
    the dependency, can verify the chain from ingestion through build.

This predicate is the RECOMMENDED way to satisfy the
[Dependency Track requirements](dependency-track.md#requirements).

## Model

A Dependency Ingestion Provenance is an attestation that a particular
[Dependency Ingestion Platform](dependency-track.md#dependency-ingestion-platform)
admitted a particular third-party dependency artifact, having applied
the controls required at the claimed Dependency Track level.

-   Each ingestion event runs as an independent process on the platform.
    The `ingestionPlatform.id` identifies this platform, representing the
    transitive closure of all entities that are
    [trusted](principles.md#trust-platforms-verify-artifacts) to admit
    dependencies, apply controls, and emit attestations.

-   The input is the upstream identity of the dependency (`upstream`).
    The output is the admitted artifact on the platform (`subject`).
    Scan, integrity, and policy verdicts are bound to the output
    artifact's cryptographic digest and to the time the verdict was
    produced.

-   The Provenance MAY reference verified upstream Build provenance
    (`upstreamProvenance`) when the upstream produces it. A verifier of
    this Provenance inherits the upstream's Build Track guarantees by
    reference.

-   A release-level inventory such as an SBOM references the set of
    Dependency Ingestion Provenance attestations for the dependencies in
    that release. The Provenance is emitted per ingestion event and
    composed downstream by reference, not aggregated into a single
    per-release attestation.

## Schema

```jsonc
{
  // Standard attestation envelope; see <https://github.com/in-toto/attestation>.
  "_type": "https://in-toto.io/Statement/v1",
  "subject": [{
    "name": "<package-name@version>",
    "digest": { "<algorithm>": "<digest>" /* required */ }
  }],

  "predicateType": "https://slsa.dev/dependency/v1",
  "predicate": {
    "ingestor":             { /* Ingestor; required */ },
    "ingestionPlatform":    { /* Platform; required */ },
    "upstream":             { /* UpstreamRef; required */ },
    "ingestion":            { /* IngestionEvent; required */ },
    "resolvedFrom":         { /* ResolvedFromRef; required at L2+ for transitive deps */ },
    "scans":                [ /* Scan; optional - descriptive, attests to scans the platform chose to run */ ],
    "integrity":            { /* IntegrityVerdict; optional at L1, required `verified` at L2+ */ },
    "publisherSignature":   { /* PublisherSignature; optional at L1, required at L2+ (value may be `unavailable`) */ },
    "policyEvaluations":    [ /* PolicyEvaluation; required at L2+ for any admission policies the platform applies */ ],
    "upstreamProvenance":   { /* UpstreamProvenanceRef; required at L3+ (value may be `unavailable` / `not-attempted`) */ },
    "signingIsolation":     { /* SigningIsolation; required at L3+ */ },
    "ingestionIsolation":   { /* IngestionIsolation; required at L3+ */ }
  }
}
```

### `subject`

The cryptographic digest of the ingested dependency artifact. One subject
per attestation: a Dependency Ingestion Provenance describes one ingestion
event for one artifact.

| Field | Type | Description |
| --- | --- | --- |
| `subject[*].name` | string | OPTIONAL. Human-readable identifier (typically `<package-name>@<version>`). |
| `subject[*].digest` | object | REQUIRED. Cryptographic digest of the admitted artifact, keyed by algorithm. |

### `predicate.ingestor`

Identity of the organization that operates the Dependency Ingestion
Platform and consumes the dependency. REQUIRED at all levels.

| Field | Type | Description |
| --- | --- | --- |
| `id` | string | REQUIRED. URI identifying the ingestor (e.g., `https://example.com/`). |
| `name` | string | OPTIONAL. Human-readable name. |

### `predicate.ingestionPlatform`

Identity of the Dependency Ingestion Platform that produced this
attestation. REQUIRED at all levels.

| Field | Type | Description |
| --- | --- | --- |
| `id` | string | REQUIRED. URI identifying the platform. The platform implementer SHOULD define a security model for the platform that identifies the transitive closure of components covered by this identifier. |
| `version` | string | OPTIONAL. Implementer-defined platform version. |

### `predicate.upstream`

Upstream identity of the dependency that was admitted. REQUIRED at all
levels.

| Field | Type | Description |
| --- | --- | --- |
| `registry` | string | REQUIRED. URI of the upstream registry from which the artifact was originally retrieved. |
| `name` | string | REQUIRED. Package name in the upstream registry's namespace. |
| `version` | string | REQUIRED. Package version. |
| `digest` | object | OPTIONAL at L1; REQUIRED at L2+. Cryptographic digest of the upstream artifact as published. |

### `predicate.ingestion`

Per-event metadata. REQUIRED at all levels.

| Field | Type | Description |
| --- | --- | --- |
| `timestamp` | string | REQUIRED. RFC 3339 timestamp of the ingestion event. |
| `path` | string | REQUIRED. URI of the internal path used to admit the artifact (typically the platform-mirrored URL of the dependency). |

### `predicate.resolvedFrom`

For dependencies that were resolved transitively from another admitted
dependency, identifies the direct dependency that pulled this artifact
in. REQUIRED at L2+ for transitive dependencies. Absent or `null` for
top-level dependencies declared directly by the ingestor.

| Field | Type | Description |
| --- | --- | --- |
| `subject` | object | REQUIRED. Cryptographic digest of the direct (parent) dependency artifact whose resolution brought this artifact in. Matches the `subject[*].digest` of the parent's Dependency Ingestion Provenance. |
| `relationship` | string | OPTIONAL. Implementer-defined relationship label (e.g., `runtime-dependency`, `dev-dependency`, `build-dependency`). |

### `predicate.scans[]`

Array of scan verdicts. This field is OPTIONAL at all levels and
*descriptive* — the Dependency Track does not specify which scans a
platform must run. The platform records what it ran; verifiers apply
their own policy on top.

Common scan types implementers may attest to: `vulnerability`, `eol`,
`malware`, `license`, or any implementer-defined scan type.

| Field | Type | Description |
| --- | --- | --- |
| `type` | string | REQUIRED. The scan type (e.g., `vulnerability`, `eol`, `malware`, `license`). Implementer-defined types are allowed. |
| `scanner.id` | string | REQUIRED if `availability == "available"`. URI identifying the scanner. |
| `scanner.version` | string | OPTIONAL. Scanner version. |
| `dataSource` | string | REQUIRED. Identifier of the data source the scanner consulted (e.g., `OSV`, `NVD`, `endoflife.date`). MAY be a comma-separated list of sources consulted. |
| `timestamp` | string | REQUIRED. RFC 3339 timestamp of the scan or of the attempted check. |
| `verdict` | string | REQUIRED if `availability == "available"`. Scanner-defined verdict (e.g., `clean`, `vulnerable`, `eol`). |
| `availability` | string | OPTIONAL. MUST be set to `unavailable` when no data source covers the dep for the given scan type. |
| `details` | object | OPTIONAL. Scanner-specific details (e.g., CVE list for `vulnerability`). |

### `predicate.integrity`

Identity-verification verdict (integrity). OPTIONAL at L1; REQUIRED
at L2+ where the verdict MUST be `verified` for admitted artifacts.

| Field | Type | Description |
| --- | --- | --- |
| `method` | string | REQUIRED if `result == "verified"`. One of `hash`, `signature`. |
| `keyId` | string | REQUIRED if `method` is `signature`. URI identifying the verifying key. |
| `expected` | object | REQUIRED if `result == "verified"`. The expected hash or signature value (e.g., from a lockfile, an upstream signing manifest, or a curated allow-list). |
| `result` | string | REQUIRED. One of `verified`, `failed`, `unverified`. `unverified` MAY appear only at L1 and means the platform did not perform an integrity check. `failed` MUST NOT appear for an artifact admitted to the platform — failed verification implies refusal of admission. |

### `predicate.publisherSignature`

Identity-verification verdict (publisher signature). OPTIONAL at L1;
REQUIRED at L2+. At L2+, `result` MUST be `verified` when upstream
publishes a publisher signature, or `availability: unavailable`
otherwise.

Publisher signature verification confirms that the artifact was signed
by an identity associated with the publisher (npm publisher signing,
Maven Central GPG, Sigstore, RubyGems). It is distinct from per-fetch
integrity (which only confirms a known hash matches) and from upstream
provenance verification (which confirms how the artifact was built).

| Field | Type | Description |
| --- | --- | --- |
| `method` | string | REQUIRED if `result == "verified"`. Identifier of the signing scheme (e.g., `npm-provenance`, `gpg`, `sigstore`, `cosign`). |
| `keyId` | string | REQUIRED if `result == "verified"`. URI or identifier of the publisher's expected signing identity. |
| `result` | string | REQUIRED unless `availability == "unavailable"`. One of `verified`, `failed`, `unverified`. `unverified` MAY appear only at L1. `failed` MUST NOT appear for an artifact admitted to the platform. |
| `availability` | string | REQUIRED if no publisher signature was published by upstream. MUST be `unavailable`. Distinguishes "no publisher signature was published" from "verification was not attempted." |

### `predicate.policyEvaluations[]`

Array of policy-evaluation verdicts. This field is *descriptive* —
the Dependency Track does not specify which policies a platform must
apply. The integrity claim is that whatever policies are applied are
transparent in the Provenance. At L2+, for every admission policy the
platform applied to this dep, the platform MUST record a corresponding
entry here.

Example policy types implementers may attest to (not exhaustive, not
prescribed): deny-list against a malicious-packages feed, minimum
version-age quarantine, license allow-list, malware-scanner gate,
custom organizational policies.

| Field | Type | Description |
| --- | --- | --- |
| `policy.id` | string | REQUIRED. URI identifying the policy. |
| `policy.version` | string | REQUIRED. Policy version. |
| `timestamp` | string | REQUIRED. RFC 3339 timestamp of evaluation. |
| `result` | string | REQUIRED. One of `allow`, `deny`. Provenance with any `deny` MUST NOT be emitted for an artifact admitted to the platform — a `deny` verdict implies admission was refused. |
| `description` | string | OPTIONAL. Free-text description of the policy, for verifiers and auditors. |

### `predicate.upstreamProvenance`

The upstream-provenance verdict for this dep. REQUIRED at L3+.

The verdict identifies whether upstream-published provenance was found,
whether it was verified, and the result. Verifiers can use this to
chain trust to the upstream's source of truth, or to refuse Provenance
whose upstream-provenance verdict doesn't satisfy verifier policy.

| Field | Type | Description |
| --- | --- | --- |
| `predicateType` | string | REQUIRED if `verification.result` is `verified` or `failed`. URI of the upstream predicate (e.g., `https://slsa.dev/provenance/v1`). |
| `ref` | string | REQUIRED if `verification.result` is `verified` or `failed`. Reference to the upstream attestation (DSSE envelope URI or content-addressed digest). |
| `verification.result` | string | REQUIRED unless `availability == "unavailable"`. One of `verified`, `failed`, `not-attempted`. `not-attempted` means upstream publishes provenance but the platform did not verify. |
| `availability` | string | REQUIRED if upstream does NOT publish provenance. MUST be `unavailable`. Distinguishes "no upstream provenance was published" from "verification was not attempted." |

### `predicate.signingIsolation`

Records how the platform isolated the Provenance signing infrastructure
from code that runs during ingestion. REQUIRED at L3+.

This field is the attestation of the L3 anti-subversion claim that the
signing key used to sign this Provenance was not reachable by any
process that executed dep-supplied code. The motivating attack class is
Shai Hulud-style npm worms in which install scripts exfiltrate
credentials (including signing keys) from the ingestion environment.

| Field | Type | Description |
| --- | --- | --- |
| `method` | string | REQUIRED. One of `separate-signer-process` (signing runs as a process that did not execute dep code), `hardware-backed-key` (signing key is held in an HSM or KMS reachable only by the signing service), `post-ingestion-signing` (signing occurs in a job that runs after the ingestion job and does not have access to dep code or the ingestion environment's secrets), `other`. |
| `description` | string | REQUIRED. Free-text description of how the platform achieved isolation, suitable for an auditor. |
| `signerIdentity` | string | REQUIRED. URI of the signing service identity. MUST be distinct from any identity that executed dep-supplied code. |

### `predicate.ingestionIsolation`

Records how the platform isolated this dep's ingestion from the
ingestion of other deps. REQUIRED at L3+.

This field is the attestation of the L3 anti-subversion claim that no
other dep's ingestion could have contaminated this dep's ingestion,
and vice versa.

| Field | Type | Description |
| --- | --- | --- |
| `method` | string | REQUIRED. One of `no-dep-code-executed` (the platform fully blocked install hooks and did not execute dep code during ingestion; cross-dep tampering via dep code is not possible because dep code did not run), `ephemeral-per-dep-environment` (each dep's ingestion ran in an isolated environment that was destroyed after admission), `other`. |
| `description` | string | REQUIRED. Free-text description of how the platform achieved isolation. |
| `environmentId` | string | OPTIONAL. Implementer-defined identifier of the ingestion environment (e.g., container ID, sandbox session ID) when `method == "ephemeral-per-dep-environment"`. |

## Per-level required/optional matrix

| Field | L1 | L2 | L3 |
| --- | --- | --- | --- |
| `ingestor` | REQUIRED | REQUIRED | REQUIRED |
| `ingestionPlatform` | REQUIRED | REQUIRED | REQUIRED |
| `upstream.registry`, `upstream.name`, `upstream.version` | REQUIRED | REQUIRED | REQUIRED |
| `upstream.digest` | OPTIONAL | REQUIRED | REQUIRED |
| `ingestion.timestamp`, `ingestion.path` | REQUIRED | REQUIRED | REQUIRED |
| `resolvedFrom` (for transitive deps) | OPTIONAL | REQUIRED | REQUIRED |
| `scans[]` | OPTIONAL | OPTIONAL | OPTIONAL |
| `integrity` | OPTIONAL | REQUIRED (`verified`) | REQUIRED (`verified`) |
| `publisherSignature` | OPTIONAL | REQUIRED (`verified` or `unavailable`) | REQUIRED (`verified` or `unavailable`) |
| Signed envelope | OPTIONAL | REQUIRED | REQUIRED |
| Envelope signature recorded in a transparency log | OPTIONAL | OPTIONAL | REQUIRED |
| `policyEvaluations[]` (record any policies applied) | OPTIONAL | REQUIRED for any policy the platform applies | REQUIRED for any policy the platform applies |
| `upstreamProvenance` | OPTIONAL | OPTIONAL | REQUIRED |
| `signingIsolation` | OPTIONAL | OPTIONAL | REQUIRED |
| `ingestionIsolation` | OPTIONAL | OPTIONAL | REQUIRED |

At L1 the Provenance MAY be unsigned and self-asserted. At L2 the
Provenance MUST be signed by a key controlled by the Dependency
Ingestion Platform; verifiers authenticate the platform by verifying
this signature. At L3 the signature MUST also be recorded in a
transparency log so downstream verifiers can detect platform
signing-key compromise.

The Dependency Track does NOT prescribe specific scans
(`scans[]` entries) or specific admission policies
(`policyEvaluations[]` entries). The platform records what it did;
verifiers apply policy to require specific entries or values.

## Parsing rules

This predicate follows the in-toto attestation
[parsing rules](https://github.com/in-toto/attestation/blob/main/spec/v1/predicate.md).
Summary:

-   The `predicateType` URI represents the *major* version of this
    specification. Within a major version, additions are backwards
    compatible: new OPTIONAL fields MAY be added without changing the URI.
-   Breaking changes increment the major version and use a new URI (e.g.,
    `https://slsa.dev/dependency/v2`).
-   Producers MUST set `predicateType` to the exact URI value shown above,
    not a version-resolved URL.
-   Consumers MUST ignore unknown fields. Consumers MUST NOT reject an
    attestation solely because it contains fields the consumer does not
    recognize.

## Verification

A verifier of a Dependency Ingestion Provenance MUST, at the claimed
level:

1.  **Envelope.** At L2+, verify the DSSE envelope signature using a key
    trusted to identify the Dependency Ingestion Platform.
2.  **Schema.** Confirm the predicate conforms to the schema at the
    claimed level (per-level matrix above). Reject if REQUIRED fields are
    missing.
3.  **Ingestor + platform identity.** Confirm `ingestor.id` and
    `ingestionPlatform.id` match the verifier's expectations.
4.  **Subject digest.** Confirm the artifact the verifier is checking
    matches one of the digests in `subject[*].digest`.
5.  **Integrity (L2+).** Confirm `integrity.result == "verified"`.
6.  **Scan verdicts (per the verifier's policy).** Reject the artifact
    based on scan verdicts according to the verifier's downstream policy
    (e.g., refuse `verdict: vulnerable` of a given CVSS threshold).
7.  **Policy evaluations (L3+).** Confirm every entry in
    `policyEvaluations[]` has `result == "allow"`.
8.  **Source mirror (L3+).** OPTIONALLY fetch the source from
    `sourceMirror.uri` and verify against `sourceMirror.digest` if doing
    independent source-level audit.
9.  **Upstream provenance (L3+).** If `upstreamProvenance.availability` is
    `unavailable`, the verifier MAY still accept the artifact at Dep L3
    (the platform attests no upstream provenance exists). If
    `upstreamProvenance.ref` is present, the verifier MAY independently
    verify the upstream attestation against the verifier's expectations
    (this is the recommended path for end-to-end verification).

A verifier MAY trust the platform's `integrity.result`,
`policyEvaluations[].result`, and `upstreamProvenance.verification.result`
fields based on a trust relationship with the platform (per [Trust
platforms, verify artifacts](principles.md#trust-platforms-verify-artifacts)),
or MAY re-perform any of those checks independently.

## Examples

### Minimal L1

A minimal L1 attestation has the required identity fields and nothing
else. The platform attests to the existence of the ingested artifact;
verifiers apply policy on top. The Provenance MAY be unsigned at L1.

```json
{
  "_type": "https://in-toto.io/Statement/v1",
  "subject": [{
    "name": "lodash@4.17.21",
    "digest": { "sha256": "abc123..." }
  }],
  "predicateType": "https://slsa.dev/dependency/v1",
  "predicate": {
    "ingestor": { "id": "https://example.com/" },
    "ingestionPlatform": { "id": "https://artifactory.example.com/" },
    "upstream": {
      "registry": "https://registry.npmjs.org/",
      "name": "lodash",
      "version": "4.17.21"
    },
    "ingestion": {
      "timestamp": "2026-06-15T14:23:00Z",
      "path": "https://artifactory.example.com/npm/lodash/-/lodash-4.17.21.tgz"
    }
  }
}
```

A richer L1 attestation MAY include `integrity`, `publisherSignature`,
`scans[]`, and `policyEvaluations[]` even though the Dep Track does
not require them at L1. Voluntarily-recorded fields let verifiers apply
policy on top.

### L2 — adds signed envelope, integrity verdict, publisher signature

The above predicate wrapped in a DSSE envelope signed by the Dependency
Ingestion Platform's key, with `integrity` and `publisherSignature`
verdicts at `verified`. If this artifact was resolved transitively,
`resolvedFrom` would also be required. The platform optionally records
any admission policies it applied in `policyEvaluations[]`.

```json
{
  /* envelope + signature elided */
  "predicate": {
    /* ...as L1, plus: */
    "upstream": {
      /* ...as L1, plus: */
      "digest": { "sha256": "def456..." }
    },
    "integrity": {
      "method": "hash",
      "expected": { "sha256": "abc123..." },
      "result": "verified"
    },
    "publisherSignature": {
      "method": "npm-provenance",
      "keyId": "https://npmjs.com/~lodash-maintainer",
      "result": "verified"
    },
    "policyEvaluations": [
      /* present for any admission policies the platform applies;
         empty if no admission policies were applied */
    ]
  }
}
```

### L3 — adds upstream provenance verdict, signing and ingestion isolation, transparency-log

```json
{
  /* envelope + signature elided + signature recorded in transparency log */
  "predicate": {
    /* ...as L2, plus: */
    "upstreamProvenance": {
      "predicateType": "https://slsa.dev/provenance/v1",
      "ref": "https://attest.example.com/lodash/4.17.21/provenance",
      "verification": { "result": "verified" }
    },
    "signingIsolation": {
      "method": "post-ingestion-signing",
      "description": "Signing is performed by a separate CI job that does not execute dep code and is granted access to the signing key only via short-lived OIDC.",
      "signerIdentity": "https://platform.example.com/signers/dependency-provenance"
    },
    "ingestionIsolation": {
      "method": "no-dep-code-executed",
      "description": "Ingestion ran `npm ci --ignore-scripts`; no install hooks executed."
    }
  }
}
```

### L3 — upstream provenance unavailable

```json
{
  /* envelope + signature elided */
  "predicate": {
    /* ...as L3 above, but: */
    "upstreamProvenance": {
      "availability": "unavailable"
    }
  }
}
```

## Change history

-   **v1**: Initial version.

[in-toto attestation]: https://github.com/in-toto/attestation
