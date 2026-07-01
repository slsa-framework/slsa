---
title: Dependency Track
description: SLSA Dependency Track requirements for ingesting third-party build dependencies. Imports the attestable subset of OpenSSF S2C2F. Defines the Dependency Ingestion Provenance predicate.
---

# Basics

## Objective

Enable an organization that ingests third-party software dependencies to
measure, control, and reduce the supply chain risk those dependencies
introduce. Define a per-ingestion attestation, Dependency Ingestion
Provenance, that downstream parties can verify.

## Why this track exists

[Applying SLSA recursively](verifying-artifacts.md#step-3-optional-check-dependencies-recursively)
to every dependency would address most consumption risks if each upstream
producer published SLSA Build and Source attestations. Most upstream OSS
does not yet do so, and recursive verification is not achievable across
most of the open source ecosystem.

The Dependency Track provides controls that fill that gap. These controls
fall into two groups in this track's L1-L3 scope:

-   Controls applied at the boundary that limit which upstream artifacts
    can reach the build at all (the ingestion chokepoint, deny-list,
    constraints on install-time behavior, structural enforcement).
-   Controls that produce the ingestor's own attestations about each
    consumed dependency when upstream attestations are unavailable
    (inventory, scans, integrity verification, source mirror, upstream
    provenance verification when available).

A third group of controls produces the ingestor's own producer-side
attestations over consumed dependencies via rebuild. That work is
deferred to a future cross-cutting axis. See
[Future Considerations](#future-considerations).

## Audience

The Dependency Track is for any organization that ingests third-party
software dependencies. This includes software producers in their role as
consumers of upstream OSS, and pure consumers (e.g., enterprises that
consume OSS internally but do not ship downstream software). Medium and
large organizations benefit most.

## Scope

The scope is third-party build dependencies: software artifacts fetched or
otherwise made available to the build environment during the build of a
released artifact. Runtime dependencies, base images, and developer
tooling are out of scope for this revision and listed under
[Future Considerations](#future-considerations).

The track imports the attestable subset of the OpenSSF
[Secure Supply Chain Consumption Framework
(S2C2F)](https://github.com/ossf/s2c2f). S2C2F requirements that describe
organizational practice rather than per-artifact evidence (incident
response plans, manual update capability, registry-approval policy) are
out of scope. See the [S2C2F mapping appendix](#s2c2f-mapping-appendix)
for the full mapping, including which requirements are referred to the
OpenSSF Security Baseline.

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT",
"SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this
document are to be interpreted as described in
[RFC 2119](https://www.rfc-editor.org/rfc/rfc2119).

---

## Dependency Ingestion Provenance

Dependency Ingestion Provenance is the per-ingestion attestation defined
by this track. A Dependency Ingestion Platform emits one attestation per
ingested artifact describing how that artifact entered the ingestor's
environment.

-   Predicate type URI: `https://slsa.dev/dependency/v1`
-   Envelope: in-toto Statement v1, see
    [Attestation model](attestation-model.md).
-   Subject: the cryptographic digest of the ingested dependency artifact.
-   Granularity: one attestation per ingested artifact. A release-level
    inventory such as an SBOM references the set of attestations for the
    dependencies it contains.

A producer that publishes both [SLSA Build Provenance](provenance.md) and
Dependency Ingestion Provenance SHOULD reference the latter from the
former's `resolvedDependencies` field, by subject digest. A verifier
walking from a built artifact's Build Provenance reaches its Dependency
Ingestion Provenance attestations directly, without depending on an
out-of-band SBOM.

The schema, parsing rules, and verification procedure are documented in
[Dependency Provenance](dependency-provenance.md).

---

## Definitions

| Primary Term | Description |
| --- | --- |
| Build dependency | Software artifact fetched or otherwise made available to the build environment during the build of the artifact. Includes open- and closed-source binary dependencies. |
| Ingestor | The organization that operates the Dependency Ingestion Platform and consumes third-party build dependencies. May or may not also be a SLSA Producer of downstream artifacts. |
| Dependency Ingestion Platform | Infrastructure that admits third-party build dependencies into the ingestor's environment and emits Dependency Ingestion Provenance per ingestion event. Typically composed of an artifact repository manager, scanner suite, and integrity verifier. |
| Dependency Ingestion Provenance | Per-(artifact, ingestion event) attestation describing how the dependency entered the ingestor's environment. Predicate type `https://slsa.dev/dependency/v1`. |
| Package registry | An entity that maps package names to artifacts within a packaging ecosystem. Most ecosystems support multiple registries (a global one plus private ones). |
| Artifact repository manager | A storage solution that manages artifact lifecycle across package management systems while providing consistency to a CI/CD workflow. Typically the binary chokepoint of a Dependency Ingestion Platform. |
| Package source files | A language-specific config file in a source code repository that identifies the package registry feeds or artifact repository manager feeds to consume dependencies from. |
| Source mirror | An internally hosted copy of an upstream dependency's source code (not just its packaged artifact), maintained to enable source-level scanning and continued availability when upstream sources are unavailable. |

---

## Levels

| Track/Level | Mnemonic | Requirements |
| --- | --- | --- |
| Dep L0 | (none) | (n/a) |
| Dep L1 | Inventoried | The platform emits a Dependency Ingestion Provenance for each ingested dep, naming the dep and recording scan verdicts for vulnerabilities and end-of-life status. |
| Dep L2 | Controlled | The platform is the only path through which deps are ingested, including transitive deps. Per-fetch integrity is verified. Upstream publisher signatures are verified when available. Install-time code execution and network access are constrained. The Provenance is signed by the platform. |
| Dep L3 | Screened | Ingestion bypass is blocked. Each dep is screened against a deny-list and a malware feed, and is subject to a minimum version-age policy. Upstream provenance is verified when available. The platform's Provenance signature is recorded in a transparency log. |

### Why the levels are structured this way

Build's levels strengthen the integrity of one attestation against a
build tenant adversary. The Dependency Track's adversary is the
dependency itself and whoever published it; the ingestor does not run
adversarial code on the platform. The levels here describe what claims
the platform makes about each ingested dep, and how tightly the
ingestion path is controlled.

The structure follows three principles from
[SLSA's principles doc](principles.md):

1.  *Simple levels with clear outcomes.* Each level has a single-word
    mnemonic and a clear set of requirements. The mnemonics grade up:
    each level adds a new class of claim about each ingested dep.

2.  *Trust platforms, verify artifacts.* Requirements are split between
    the [Ingestor](#ingestor) and the
    [Dependency Ingestion Platform](#dependency-ingestion-platform).
    Verifiers verify the Provenance, not the platform's deployed
    configuration.

3.  *Prefer attestations over inferences.* Each requirement specifies
    what the Dependency Ingestion Provenance must contain or guarantee,
    not what configuration state to observe.

A future cross-cutting axis would introduce a stronger "Verified" tier
where the ingestor produces their own producer-side attestations over
consumed deps, typically by rebuilding each dep under the ingestor's own
SLSA Build platform. That work is a different kind of claim from what
this track describes and is reserved for that future axis. See
[Future Considerations](#future-considerations).

---

<section id="dep-l0">

## Dep L0: No guarantees

<dl class="as-table">
<dt>Summary<dd>

No requirements. L0 represents the absence of SLSA Dependency Track
claims.

<dt>Intended for<dd>

Organizations that have not yet adopted the Dependency Track.

<dt>Requirements<dd>

n/a

<dt>Benefits<dd>

n/a

</dl>
</section>
<section id="dep-l1">

## Dep L1: Inventoried

<dl class="as-table">
<dt>Summary<dd>

For each ingested dependency, a Dependency Ingestion Provenance exists
that identifies the dependency. Identity-verification verdicts, scan
verdicts, and policy-evaluation results MAY be recorded in the
Provenance; values MAY be `unverified` / `unavailable` /
`not-evaluated`. Trivial to bypass or forge.

<dt>Intended for<dd>

Organizations that want baseline visibility into their third-party
dependency footprint, without yet investing in a hardened ingestion
path. A starting point for downstream verifiers to apply policy on
top.

<dt>Requirements<dd>

-   Ingestor:
    -   [Choose an appropriate Dependency Ingestion Platform](#dep-choose-platform).
    -   [Distribute Dependency Ingestion Provenance](#dep-distribute-provenance)
        for every ingested dependency that contributes to a release.
-   Dependency Ingestion Platform:
    -   [Maintain an automated inventory](#dep-automated-inventory) by
        emitting a Dependency Ingestion Provenance for each ingested
        dependency.

<dt>Benefits<dd>

-   Consumed dependencies are knowable from per-dep attestations bound
    to a release.
-   Provides a baseline that downstream parties can verify before
    higher levels are achieved.
-   Voluntarily-recorded verdicts (integrity, publisher signature, scan
    results, policy evaluations) become consumable evidence that
    downstream verifiers can require via policy, even when this track
    does not require the platform to populate them at L1.

<dt>Notes<dd>

-   The Provenance MAY be unsigned and self-asserted at L1. Nothing
    prevents a dep from being brought in outside the platform; nothing
    binds the recorded fields to the bytes actually consumed; nothing
    requires identity verification. L2 grounds the Provenance in a
    controlled flow with verified identity.
-   This track does not prescribe what scans or policy evaluations to
    run at L1. A producer that runs scans MAY record the verdicts;
    verifiers MAY require specific recorded evidence as a matter of
    their own policy.

</dl>
</section>
<section id="dep-l2">

## Dep L2: Controlled

<dl class="as-table">
<dt>Summary<dd>

Dep L2 makes the Provenance authentic and the ingestion path
configured. The Dependency Ingestion Platform is the configured path
through which dependencies enter the ingestor's environment, including
transitive dependencies resolved by the package manager. The platform
performs identity verification (per-fetch integrity MUST be `verified`,
and publisher signature MUST be `verified` when upstream publishes
one). For any admission policies the platform applies, the Provenance
records them transparently. The platform signs the Dependency
Ingestion Provenance.

Forging the Provenance now requires forging the platform's signature.

<dt>Intended for<dd>

Organizations that have adopted L1 and want the recorded Provenance to
be grounded in a controlled flow with verified identity, signed by the
platform.

<dt>Requirements<dd>

All of [Dep L1], plus:

-   Ingestor:
    -   [Configure the build to resolve through the platform](#dep-package-source-config).
-   Dependency Ingestion Platform:
    -   [Operate as the ingestion chokepoint](#dep-internal-binary-repo).
    -   [Admit transitive dependencies through the platform](#dep-transitive-resolution).
    -   [Verify per-fetch integrity](#dep-validate-integrity) — verdict MUST be `verified`.
    -   [Verify upstream publisher signature when available](#dep-publisher-signature) — verdict MUST be `verified` when upstream publishes a signature; `unavailable` otherwise.
    -   [Record any admission policies applied](#dep-policy-attestation).
    -   Sign the Dependency Ingestion Provenance. See
        [Dependency Provenance](dependency-provenance.md).

<dt>Benefits<dd>

All of [Dep L1], plus:

-   Identity-verification verdicts bind the inventory to bytes that
    actually match upstream's claim.
-   Transitive resolution comes through the same chokepoint: a
    malicious transitive dep cannot be pulled in from outside the
    platform by an otherwise-benign direct dep.
-   Publisher-account takeover is detected at ingestion when upstream
    publishes a signature.
-   Whatever admission policies the platform applies are transparent
    in the Provenance, so verifiers can apply their own policy on top.
-   Forging the Provenance requires forging the platform's signature.

<dt>Notes<dd>

-   This track does not prescribe which admission policies the
    platform must apply. A platform that applies no admission policies
    records an empty `policyEvaluations[]`; verifiers can refuse that
    as a matter of their own policy.
-   A determined developer or build can still bypass the configured
    path. L3 closes that gap with structural enforcement.

</dl>
</section>
<section id="dep-l3">

## Dep L3: Screened

<dl class="as-table">
<dt>Summary<dd>

Dep L3 closes the threats L2 leaves open:
(a) bypass is structurally blocked, not just detectable; (b) the
upstream-provenance reference for each dep is recorded (verified when
available, `unavailable` otherwise) so the chain of trust ties to
upstream's source of truth; and (c) a hostile dep cannot subvert the
Provenance about itself or about other deps in the same ingestion
run, because the signing infrastructure is unreachable from dep code
and each dep's ingestion is isolated. The Shai Hulud npm attacks made
this last threat class concrete: malicious dependencies whose install
scripts steal credentials from the ingestion environment.

<dt>Intended for<dd>

Most software releases that consume third-party dependencies. Dep L3
typically requires significant investment in the ingestion platform.

<dt>Requirements<dd>

All of [Dep L2], plus:

-   Dependency Ingestion Platform:
    -   [Block non-platform paths](#dep-enforce-curated-feed).
    -   [Record the upstream-provenance verdict in every Provenance](#dep-verify-provenance) — verdict MAY be `verified`, `failed`, `not-attempted`, or `unavailable`.
    -   [Isolate signing infrastructure from dep code](#dep-signing-isolation).
    -   [Isolate the ingestion of each dep from others](#dep-ingestion-isolation).
    -   Record the platform's Dependency Ingestion Provenance signatures
        in a transparency log. See
        [Dependency Provenance](dependency-provenance.md).

<dt>Benefits<dd>

All of [Dep L2], plus:

-   Ingestion bypass is blocked, not just detectable. The Provenance
    describes every consumed dependency.
-   The upstream-provenance reference is recorded for every dep; when
    upstream produces SLSA Build Provenance, a verifier inherits
    upstream's Build-side guarantees by reference.
-   A malicious dep cannot steal the platform's Provenance signing key
    via an install hook (Shai Hulud-style) because the key is not
    reachable from any process that executed dep code.
-   A malicious dep cannot affect the ingestion of another dep, because
    each dep's ingestion is isolated from the others.
-   Recording platform signatures in a transparency log lets downstream
    verifiers detect platform signing-key compromise.

<dt>Notes<dd>

-   This track does not prescribe which admission policies the
    platform applies. Verifiers that require specific policies
    (deny-list against a malicious-packages feed, a minimum
    version-age, a malware scan, etc.) MAY refuse Provenance whose
    recorded `policyEvaluations[]` doesn't include the expected
    entries.
-   A "Verified" tier where the ingestor produces their own
    producer-side attestations over consumed deps (typically via
    rebuild) is reserved for a future cross-cutting axis. See
    [Future Considerations](#future-considerations).

</dl>
</section>

---

## Requirements

Each requirement below specifies either an action the ingestor MUST take or
a property the Dependency Ingestion Provenance MUST guarantee. RFC 2119
keywords apply as marked.

### Overview

<table class="no-alternate">
<tr>
  <th>Implementer
  <th>Requirement
  <th>L1<th>L2<th>L3
<tr>
  <td rowspan=3><a href="#ingestor">Ingestor</a>
  <td><a href="#dep-choose-platform">Choose an appropriate Dependency Ingestion Platform</a>
  <td>✓<td>✓<td>✓
<tr>
  <td><a href="#dep-distribute-provenance">Distribute Dependency Ingestion Provenance</a>
  <td>✓<td>✓<td>✓
<tr>
  <td><a href="#dep-package-source-config">Configure build to resolve through the platform</a>
  <td> <td>✓<td>✓
<tr>
  <td rowspan=10><a href="#dependency-ingestion-platform">Dependency Ingestion Platform</a>
  <td><a href="#dep-automated-inventory">Inventory</a>
  <td>✓<td>✓<td>✓
<tr>
  <td><a href="#dep-internal-binary-repo">Operate as ingestion chokepoint</a>
  <td> <td>✓<td>✓
<tr>
  <td><a href="#dep-transitive-resolution">Admit transitive dependencies through the platform</a>
  <td> <td>✓<td>✓
<tr>
  <td><a href="#dep-validate-integrity">Identity-verification verdict (integrity)</a>
  <td>OPTIONAL<td>✓<td>✓
<tr>
  <td><a href="#dep-publisher-signature">Identity-verification verdict (publisher signature)</a>
  <td>OPTIONAL<td>✓<td>✓
<tr>
  <td><a href="#dep-policy-attestation">Record any admission policies applied</a>
  <td> <td>✓<td>✓
<tr>
  <td><a href="#dep-enforce-curated-feed">Block non-platform paths</a>
  <td> <td> <td>✓
<tr>
  <td><a href="#dep-verify-provenance">Upstream provenance verdict recorded</a>
  <td> <td> <td>✓
<tr>
  <td><a href="#dep-signing-isolation">Signing infrastructure isolation</a>
  <td> <td> <td>✓
<tr>
  <td><a href="#dep-ingestion-isolation">Cross-dep ingestion isolation</a>
  <td> <td> <td>✓
</table>

### Security Best Practices

While the exact definition of what constitutes a secure Dependency Ingestion
Platform is beyond the scope of this specification, all implementations
MUST use industry security best practices to be conformant. This includes,
but is not limited to, using proper access controls, securing
communications, implementing proper management of cryptographic secrets,
doing frequent updates, and promptly fixing known vulnerabilities.

## Ingestor

[Ingestor]: #ingestor

An <dfn>ingestor</dfn> is the organization that operates a Dependency
Ingestion Platform and consumes third-party build dependencies. The
ingestor MAY also be a [Producer](terminology.md#roles) of downstream
software, or MAY be a pure consumer (an enterprise that consumes OSS
internally without releasing downstream artifacts).

### Choose an appropriate Dependency Ingestion Platform

[dep-choose-platform]: #dep-choose-platform
<a id="dep-choose-platform"></a>

The ingestor MUST select a Dependency Ingestion Platform capable of
reaching their desired SLSA Dependency Level.

For example, an ingestor targeting Dep L3 MUST choose a platform capable
of emitting Dependency Ingestion Provenance with policy-evaluation,
source-mirror, and upstream-provenance fields populated and signed.

### Distribute Dependency Ingestion Provenance

[dep-distribute-provenance]: #dep-distribute-provenance
<a id="dep-distribute-provenance"></a>

The ingestor MUST distribute (or, for ingestors that do not release
downstream software, hold) the Dependency Ingestion Provenance attestations
emitted by the platform for every third-party dependency consumed by a
released artifact. The ingestor MAY delegate distribution to the platform.

### Configure build to resolve through the platform

[dep-package-source-config]: #dep-package-source-config
<a id="dep-package-source-config"></a>

The ingestor MUST configure their build's package source files (lockfiles,
package-source mappings, equivalent ecosystem-specific configuration) so
that the build resolves third-party dependencies only through the chosen
Dependency Ingestion Platform, with versions pinned and integrity hashes
recorded.

> Examples: package-source-mapping in NuGet; `.npmrc` registry pinning
combined with `package-lock.json` integrity hashes;
`pip --require-hashes` with a `requirements.txt` lockfile; `go.sum`;
`Cargo.lock`.

Maps to S2C2F [ENF-1](#s2c2f-mapping-appendix).

## Dependency Ingestion Platform

[Dependency Ingestion Platform]: #dependency-ingestion-platform

A <dfn>Dependency Ingestion Platform</dfn> is the infrastructure that
admits third-party build dependencies into the ingestor's environment
and emits Dependency Ingestion Provenance. A platform is typically
composed of an artifact repository manager, a scanner suite, and an
integrity verifier. The defining property is that it emits the
Provenance, not any particular product combination.

The platform's responsibilities increase with the level. At L1 it emits
an inventory Provenance per ingested dep. At L2 it operates as the
ingestion chokepoint, performs identity-verification with `verified`
results, and signs the Provenance. At L3 it structurally enforces the
chokepoint and is hardened so that a hostile dep cannot subvert the
Provenance about itself or about other deps.

### L1 requirements: Inventoried

[L1 requirements]: #l1-requirements-inventoried

At L1, the platform MUST emit, for every third-party build dependency
it admits, a Dependency Ingestion Provenance attestation that
identifies the dependency. Identity-verification verdicts, scan
verdicts, and policy-evaluation results MAY be recorded in the
Provenance; values MAY be `unverified` / `unavailable` /
`not-evaluated` when the platform did not perform a given check. The
Provenance MAY be unsigned and self-asserted at L1.

<table>
<tr><th>Requirement<th>Description<th>L1<th>L2<th>L3

<tr id="dep-automated-inventory"><td>Inventory (Automated) <a href="#dep-automated-inventory">🔗</a><td>

The platform MUST emit a Dependency Ingestion Provenance attestation for
every third-party build dependency it admits, identifying the dependency by
name, version, and cryptographic digest. Together the set of attestations
associated with a release MUST be sufficient to enumerate every direct and
transitive third-party dependency contributing to that release.

> For example: each admitted package version triggers emission of a
`https://slsa.dev/dependency/v1` attestation bound to the package's digest;
a release-level SBOM references the set of attestations for the dependencies
the release contains.

Maps to S2C2F [INV-1](#s2c2f-mapping-appendix).

<td>✓<td>✓<td>✓

</table>

### L2 requirements: Controlled

[L2 requirements]: #l2-requirements-controlled

At L2 the platform operates as the configured ingestion path including
for transitive dependencies. The platform performs identity-verification
with `verified` results (per-fetch integrity, and publisher signature
when upstream publishes one), records any admission policies it
applies, and signs every Dependency Ingestion Provenance it emits.

<table>
<tr><th>Requirement<th>Description<th>L1<th>L2<th>L3

<tr id="dep-internal-binary-repo"><td>Operate as ingestion chokepoint <a href="#dep-internal-binary-repo">🔗</a><td>

The Dependency Ingestion Platform MUST be configured as the ingestion
path through which third-party build dependencies enter the ingestor's
environment, and MUST record the platform's identity in every
Dependency Ingestion Provenance it emits. The platform sources upstream
artifacts under its own controlled path; consumers fetch from the
platform, not from upstream registries directly.

At L2 the chokepoint is configured. Structural enforcement that makes
the chokepoint the only physically reachable path is required at L3
(see [Block non-platform paths](#dep-enforce-curated-feed)).

> Implementations vary by scale. A solo project: `.npmrc` pinned to a
single registry, with all fetches captured in CI logs. A
multi-team organization: a package proxy mirroring upstream registries
under one URL namespace, applying per-fetch controls. A pre-vetted
dependency bundle: all admissions happen once at curation time and
the bundle is the only source consumers read from. A sandboxed
ingestion runner: per-dep ephemeral container fetches and characterizes
each dep. The platform is defined by what it does (admit deps through a
controlled path and emit Provenance), not by what kind of product it is.

Maps to S2C2F [ING-2](#s2c2f-mapping-appendix).

<td> <td>✓<td>✓

<tr id="dep-transitive-resolution"><td>Admit transitive dependencies through the platform <a href="#dep-transitive-resolution">🔗</a><td>

When a package manager resolves transitive dependencies of an admitted
artifact (deps declared in the artifact's manifest and fetched at install
or build time), the Dependency Ingestion Platform MUST admit each
transitive dependency through the same controls applied to direct
dependencies. The Dependency Ingestion Provenance for a transitive
dependency MUST record, in `resolvedFrom`, the subject digest of the
direct dependency that pulled it in.

This closes a category of attack where a direct dependency goes through
the platform but its transitive dependencies are fetched from arbitrary
upstream sources, defeating the chokepoint.

> For example: when a Maven build resolves a dependency tree, every
artifact in the tree (not just the top-level POM) is admitted by the
platform. When `npm install foo` brings in `bar`, the platform admits
`bar` through the chokepoint and emits a Dependency Ingestion Provenance
for it.

This requirement has no S2C2F ID. It makes explicit the transitive scope
of S2C2F's ING-2 and ENF-1.

<td> <td>✓<td>✓

<tr id="dep-validate-integrity"><td>Identity-verification verdict (integrity) <a href="#dep-validate-integrity">🔗</a><td>

The Dependency Ingestion Provenance MAY record a per-fetch integrity
verdict at L1; at L2+ this verdict MUST be present and MUST be
`verified`. The verdict records the method (`hash`, `signature`), the
key identity (where applicable), and the result.

At L1 the platform MAY emit an `unverified` verdict if no integrity
check was performed. At L2+ the platform MUST verify the integrity of
every consumed third-party build dependency at the time of ingestion,
MUST reject artifacts whose verification fails, and MUST record the
`verified` verdict in each Provenance.

> For example: `--require-hashes` mode in pip; lockfile-pinned
integrity hashes in npm; verifying upstream signatures with Sigstore
`cosign verify` or ecosystem-native signing.

Maps to S2C2F [AUD-3](#s2c2f-mapping-appendix).

<td>OPTIONAL<td>✓<td>✓

<tr id="dep-publisher-signature"><td>Identity-verification verdict (publisher signature) <a href="#dep-publisher-signature">🔗</a><td>

The Dependency Ingestion Provenance MAY record a publisher-signature
verdict at L1; at L2+ this verdict MUST be present. When the upstream
of a consumed dependency publishes a publisher signature, the platform
MUST verify that signature against the publisher's expected identity
at L2+ and MUST record the `verified` verdict. When no publisher
signature is published by the upstream, the Provenance MUST record
`publisherSignature.availability` as `unavailable`.

Publisher signature verification is distinct from per-fetch integrity
(which only confirms the artifact matches a known hash) and from
upstream provenance verification (which confirms how the artifact was
built). It detects publisher-account takeover and impersonation.

> For example: verifying an npm package's publisher signature against
the publisher's signing key registered with npm; verifying a Maven
Central artifact's GPG signature against the publisher's published
key; verifying a Sigstore signing identity for a package signed via
keyless workflows.

This requirement has no S2C2F ID. S2C2F's AUD-3 covers integrity
broadly; this requirement separates publisher identity from artifact
integrity.

<td>OPTIONAL<td>✓<td>✓

<tr id="dep-policy-attestation"><td>Record any admission policies applied <a href="#dep-policy-attestation">🔗</a><td>

For every dependency-admission policy the Dependency Ingestion Platform
applies (deny-list, version-age, license filter, malware-scanner gate,
or any other policy the operator chooses to run), the Dependency
Ingestion Provenance MUST record the policy's identity, version,
evaluation timestamp, and verdict, all bound to the artifact's
cryptographic digest. The Provenance MUST NOT be emitted with a `deny`
verdict for an artifact that was admitted (a `deny` verdict implies
admission was refused).

This requirement does NOT prescribe which policies a platform must
apply. The Dependency Track does not specify whether to use a
deny-list, what the version-age cutoff should be, which malware
scanner to consult, or which custom organizational policies to apply.
Those are operator and verifier choices. The integrity claim is that
*whatever policies are applied are transparent in the Provenance*. A
verifier can then refuse Provenance whose recorded policy set does not
satisfy the verifier's policy.

This is structurally similar to how Build Provenance's
`externalParameters` field works: the Build Track does not say which
parameters a build must accept, but it does require that all such
parameters be captured in the Provenance.

> For example: a platform that integrates the OpenSSF Malicious
Packages feed records a deny-list policy evaluation per dep. A
platform that enforces a 7-day version-age quarantine records a
version-age policy evaluation per dep with the configured duration and
the upstream publication date. A platform that runs a malware scanner
and refuses on positive verdict records a scanner-policy evaluation.
A platform that applies a license allow-list records that. A platform
that applies no admission policies records an empty
`policyEvaluations[]` array — verifiers can refuse that absence as a
matter of their own policy.

This requirement has no direct S2C2F ID. It generalizes the
attestable core of S2C2F's ING-3 and similar control prescriptions
without requiring any specific policy.

<td> <td>✓<td>✓

</table>

### L3 requirements: Screened

[L3 requirements]: #l3-requirements-screened

At L3 the platform blocks non-platform ingestion paths structurally,
records the upstream-provenance verdict in every Provenance, isolates
the Provenance signing infrastructure from any code that runs during
ingestion, isolates the ingestion of each dep from others, and
publishes its Provenance signatures to a transparency log.

<table>
<tr><th>Requirement<th>Description<th>L1<th>L2<th>L3

<tr id="dep-enforce-curated-feed"><td>Structural enforcement <a href="#dep-enforce-curated-feed">🔗</a><td>

The Dependency Ingestion Platform MUST block consumption of third-party
build dependencies from any feed other than the platform. Build
environments and developer environments MUST NOT be able to resolve
dependencies outside the platform. Network policy or equivalent access
controls MUST prevent it, not just detect it after the fact.

> For example: build environments with no outbound network access except
to the platform; firewall rules that deny direct access to public
registries from developer or CI machines.

Maps to S2C2F [ENF-2](#s2c2f-mapping-appendix).

<td> <td> <td>✓

<tr id="dep-verify-provenance"><td>Upstream-provenance verdict recorded <a href="#dep-verify-provenance">🔗</a><td>

The Dependency Ingestion Provenance MUST record an upstream-provenance
verdict at L3. The verdict identifies whether upstream-published
provenance was found, whether it was verified, and the result. Valid
values are `verified`, `failed`, `not-attempted`, or `unavailable`.

When the upstream of a consumed dependency produces verifiable
provenance (for example, SLSA Build Provenance), the platform MUST
attempt verification against the ingestor's expectations and MUST
record either `verified` or `failed`. When upstream does not produce
provenance, the Provenance MUST record `unavailable`. When the
platform chose not to verify available upstream provenance, the
Provenance MUST record `not-attempted` so verifiers can distinguish
"no upstream provenance was published" from "verification was not
attempted."

This requirement does not prescribe what to do with the verdict —
verifiers MAY refuse Provenance with `not-attempted`, `failed`, or
`unavailable` as a matter of their own policy.

> For example: verifying a SLSA Build [Provenance](provenance.md)
attestation against an expected source repository and builder
identity; verifying a [Verification Summary
Attestation](verification_summary.md) issued by a trusted verifier;
recording `unavailable` for a dep whose upstream publishes no
provenance.

S2C2F AUD-1 maps to "SLSA: Distribute provenance" in S2C2F v1.1. This
requirement is where the Dependency Track consumes the output of the
Build Track when upstream produces it.

Maps to S2C2F [AUD-1](#s2c2f-mapping-appendix).

<td> <td> <td>✓

<tr id="dep-signing-isolation"><td>Signing infrastructure isolation <a href="#dep-signing-isolation">🔗</a><td>

The signing key used to sign Dependency Ingestion Provenance MUST NOT
be reachable by any process that executes dependency-supplied code
during ingestion. This includes install hooks, sandboxed installer
initialization, scanners that execute dep code, and any other component
where the dep's bytes are executed. Signing MUST happen in a control
plane that did not execute dep code. The Dependency Ingestion Provenance
MUST record, in `signingIsolation`, the method the platform used to
achieve this isolation.

This requirement addresses a class of attack that the Shai Hulud npm
worms made concrete: malicious dependencies whose install scripts
exfiltrate credentials (npm tokens, GitHub tokens, AWS keys) from the
ingestion environment. Without signing-infrastructure isolation, the
platform's Provenance signing key sits in that environment and a
malicious dep can steal it and forge Provenance about itself or about
future deps. This is the direct parallel to
[Build L3 signing-key isolation](build-requirements.md#provenance-unforgeable).

> For example: a CI workflow that does dep ingestion and scanning in
one job, then signs the resulting Provenance from a separate job whose
runner has access to the signing key but did not execute any dep code.
A package proxy where admission, scanning, and signing run in distinct
processes with separate credentials, and the signing process never
holds dep-supplied bytes in executable form. Hardware-backed signing
keys (HSM, KMS) reachable only by the signing process.

> Note for CI-based implementers: typical CI architectures already
satisfy this requirement structurally. A workflow that runs
`npm ci --ignore-scripts` in one job and then signs the emitted
Provenance from a separate job using Sigstore keyless via OIDC has the
signing identity isolated from any process that touched dep bytes by
construction. In that case, the L3 work is recording
`signingIsolation` in the attestation, not building new infrastructure.
The structural requirement is the same; the attestation makes the
property verifiable downstream.

This requirement has no S2C2F ID. S2C2F's REB-* axis approaches the
same threat class by having the ingestor rebuild the dep entirely under
their own SLSA Build platform; this requirement addresses the
platform-side isolation instead.

<td> <td> <td>✓

<tr id="dep-ingestion-isolation"><td>Cross-dep ingestion isolation <a href="#dep-ingestion-isolation">🔗</a><td>

The ingestion of any one dependency MUST NOT be able to influence the
ingestion of any other dependency, nor the Provenance about any other
dependency. The platform MUST record, in `ingestionIsolation`, the
method by which the property is achieved.

This is an outcome property. The Dependency Track does not prescribe
how the platform achieves it; the requirement is the property and the
attestation of it. Two methods are recognized by the schema as ways to
satisfy the outcome and may be recorded in `ingestionIsolation.method`:

-   `no-dep-code-executed`: no dependency-supplied code ran during
    ingestion (install hooks fully blocked, source distributions that
    build at install time refused or pre-built elsewhere, and scanners
    do not execute dep code). If no dep code ran, no cross-dep
    tampering via dep code is possible.
-   `ephemeral-per-dep-environment`: each dependency's ingestion runs
    in an ephemeral environment that is destroyed after admission;
    caches, network state, and filesystem state from one dep's
    ingestion do not persist into the next.

Implementers MAY satisfy the outcome by other means and record those
under `ingestionIsolation.method: other` with a description; verifiers
MAY refuse `other` without a description they accept.

This is the direct parallel to
[Build L3 ephemeral build environment](build-requirements.md#isolated)
and addresses the threat of a dep's install hook (if dep code ran at
all) tampering with the ingestion environment for subsequent deps —
poisoning a shared cache, modifying proxy policy state, planting a
payload retrieved by the next dep, or stealing credentials used to
ingest the next dep.

> For example: a CI workflow that runs `npm ci --ignore-scripts` to
admit all deps without executing any of their code
(`no-dep-code-executed`). A package proxy that admits each dep in a
per-dep container that is destroyed after admission
(`ephemeral-per-dep-environment`).

> Note for CI-based implementers: typical CI architectures already
satisfy this outcome structurally as `no-dep-code-executed`. The L3
work is recording `ingestionIsolation` in the attestation; the
underlying property comes free with the architecture. Centralized
proxy implementations that *do* run dep code (for example, scanners
that exercise install hooks in a sandbox) need to take the
`ephemeral-per-dep-environment` path instead.

This requirement has no S2C2F ID.

<td> <td> <td>✓

</table>

---

## S2C2F mapping appendix

The OpenSSF [Secure Supply Chain Consumption Framework
(S2C2F) v1.1](https://github.com/ossf/s2c2f) (CSL-1.0) is a
consumer-side OSS framework that this track draws from. The
Dependency Track is integrity-focused and imports only the S2C2F
requirements that are integrity-relevant (about evidence existence,
authenticity, controlled flow, and platform hardening). S2C2F
requirements that prescribe specific best-practice operational
controls (specific scans, specific admission policies, organizational
practices) are out of scope — they are appropriately addressed by the
OpenSSF Security Baseline or by verifier policy on top of the
Provenance, not by the Dep Track.

Six S2C2F requirements are imported. Eight S2C2F requirements that
prescribe operational practice are intentionally out of scope (see
[Out of scope for this track](#out-of-scope-for-this-track)). Five
requirements in this track have no S2C2F ID and address integrity
threats S2C2F does not enumerate (see
[Filling S2C2F gaps](#filling-s2c2f-gaps)). Five additional S2C2F
requirements (REB-1..4, AUD-4) describe rebuild-based attestations
and are deferred to a future cross-cutting axis. The remaining
S2C2F requirements describe organizational practice and are referred
to the OpenSSF Security Baseline.

### Imported (integrity-relevant, L1–L3)

This track is deliberately integrity-focused. It imports a small set
of S2C2F requirements that are integrity-relevant — about evidence
existence, evidence authenticity, controlled flow, and platform
hardening — rather than best-practice prescriptions.

| S2C2F ID | Practice | S2C2F level | SLSA Dep level | Requirement |
| --- | --- | --- | --- | --- |
| INV-1 | Inventory | L1 | L1 | [Inventory](#dep-automated-inventory) |
| ING-2 | Ingest | L1 | **L2** | [Operate as ingestion chokepoint](#dep-internal-binary-repo) |
| AUD-3 | Audit | L2 | L2 | [Identity-verification verdict (integrity)](#dep-validate-integrity) |
| ENF-1 | Enforce | L2 | L2 | [Configure build to resolve through the platform](#dep-package-source-config) |
| ENF-2 | Enforce | L3 | L3 | [Block non-platform paths](#dep-enforce-curated-feed) |
| AUD-1 | Audit | L3 | L3 | [Upstream-provenance verdict recorded](#dep-verify-provenance) |

ING-2 moves from S2C2F L1 to Dep L2. S2C2F placed the chokepoint as
foundational practice. In this track the chokepoint is what grounds
the L1 inventory in a controlled flow with signed Provenance, which is
the L2 claim.

### Filling S2C2F gaps (integrity-relevant additions)

These requirements have no S2C2F ID. They address integrity threats
S2C2F does not enumerate as attestable claims.

| Requirement | Dep level | Why it's needed |
| --- | --- | --- |
| [Admit transitive dependencies through the platform](#dep-transitive-resolution) | L2 | The chokepoint's integrity claim extends to transitive resolution. Without this, an L2 ingestor could chokepoint the direct dep and let its transitive dependencies be pulled from arbitrary upstream sources, defeating the chokepoint. |
| [Identity-verification verdict (publisher signature)](#dep-publisher-signature) | L2 | Per-fetch integrity (matches a known hash) and upstream provenance verification (matches the upstream's claimed build process) are distinct from publisher signature verification (signed by the publisher's identity). Publisher signature is the strongest control against publisher-account takeover. |
| [Record any admission policies applied](#dep-policy-attestation) | L2 | The integrity claim that *whatever policies the platform applies are transparent in the Provenance*. The track does not prescribe which policies to apply; it requires that those applied be recorded so verifiers can apply policy on top. |
| [Signing infrastructure isolation](#dep-signing-isolation) | L3 | Addresses Shai Hulud-style npm-worm attacks where install scripts exfiltrate credentials (including signing keys) from the ingestion environment. Without this, a malicious dep can forge Provenance about itself or future deps. Direct parallel to Build L3 signing-key isolation. |
| [Cross-dep ingestion isolation](#dep-ingestion-isolation) | L3 | Outcome property: a dep's ingestion cannot affect another dep's ingestion or the Provenance about it. Direct parallel to Build L3 ephemeral build environment. |

### Out of scope for this track (best-practice prescriptions)

The Dep Track is integrity-focused and does not prescribe specific
operational best practices. The following S2C2F requirements are
*out of scope* — they prescribe specific scans, controls, or
organizational practices rather than integrity properties of the
Provenance. The OpenSSF Security Baseline is the appropriate home for
these. A verifier targeting Dep L_n MAY independently require that
the Provenance record any of these as a matter of verifier policy
(e.g., "Provenance must record a vulnerability scan verdict").

| S2C2F ID | Reason |
| --- | --- |
| SCA-1 (Vulnerability scan) | Prescribes which scan tooling to run. The Dep Track allows producers to record scan verdicts (`scans[].type == "vulnerability"`) but does not require the scan be performed. |
| SCA-2 (License attribution) | Compliance concern, not integrity. License metadata is well-served by SBOMs. |
| SCA-3 (EOL detection) | Prescribes EOL scanning. Producers MAY record EOL verdicts in the Provenance; verifier policy decides if required. |
| SCA-4 (Malware scan) | Prescribes malware scanning. Producers MAY record malware verdicts; verifier policy decides if required. |
| ING-3 (Deny-list) | Prescribes a specific admission-policy mechanism (deny-list). The Dep Track's [policy-attestation requirement](#dep-policy-attestation) captures the integrity-relevant generalization: any admission policy the platform applies is recorded. Specific deny-list choice is left to operator and verifier policy. |
| UPD-2 (Automated update tooling) | Organizational practice. Routed to the OpenSSF Security Baseline. |
| ING-4 (Source mirror) | Source mirroring is most valuable when paired with rebuild, which is reserved for the future "Verified" cross-cutting axis. |
| AUD-2 (Bypass detection) | Detect-only signal subsumed at L3 by [structural enforcement](#dep-enforce-curated-feed). |

### Deferred to a future cross-cutting axis

These S2C2F requirements describe the ingestor producing their own
producer-side attestations over consumed deps via rebuild. That work is
a different kind of claim from what the Dep Track describes. A future
cross-cutting "Verified" axis is the intended home. See
[Future Considerations](#future-considerations).

| S2C2F ID | Practice | S2C2F level | Description |
| --- | --- | --- | --- |
| REB-1 | Rebuild | L4 | Rebuild OSS in a trusted build environment or validate reproducible builds. |
| REB-2 | Rebuild | L4 | Sign rebuilt OSS. |
| REB-3 | Rebuild | L4 | Generate SBOMs for rebuilt OSS. |
| REB-4 | Rebuild | L4 | Sign produced SBOMs. |
| AUD-4 | Audit | L4 | Validate SBOMs of consumed OSS. |

### Excluded (referred to OpenSSF Security Baseline)

| S2C2F ID | Practice | S2C2F level | Reason for exclusion | Referred to |
| --- | --- | --- | --- | --- |
| ING-1 | Ingest | L1 | The list of trusted public registries is a policy choice. The enforcement that fetches came from one is captured by the [chokepoint](#dep-internal-binary-repo) at L2 and [structural enforcement](#dep-enforce-curated-feed) at L3. | OpenSSF Security Baseline (registry-approval policy) |
| INV-2 | Inventory | L2 | "Have an OSS Incident Response Plan" is organizational. No per-artifact evidence. | OpenSSF Security Baseline (incident response) |
| UPD-1 | Update | L1 | "Update vulnerable OSS manually" is a capability assertion, not an artifact property. | OpenSSF Security Baseline (vulnerability management) |
| UPD-3 | Update | L2 | "Display OSS vulnerabilities in developer contribution flow" requires two-person review, which is covered by the [SLSA Source Track](source-requirements.md). The PR-check half is redundant with Source Track requirements. | SLSA Source Track + OpenSSF Security Baseline |
| SCA-5 | Scan | L3 | "Perform proactive security analysis of OSS" describes an upstream code audit practice. A signed audit report bound to a commit or artifact digest could be attestable in a future iteration, once a predicate type is defined. | OpenSSF Security Baseline (security review practice) |
| FIX-1 | Fix-It-And-Upstream | L4 | "Capability to privately patch and upstream a fix" is a capability assertion. The resulting rebuild evidence is covered by the deferred REB-1..4. | OpenSSF Security Baseline (vulnerability response capability) |

The original S2C2F specification text is published under the
[Community Specification License 1.0](https://github.com/CommunitySpecification/1.0).
Text in the requirements above is paraphrased, not transcribed verbatim;
attribution to S2C2F v1.1 is via the rows in this appendix.

---

## Future Considerations

-   Cross-cutting "Verified" axis for ingested dependencies. The Dep
    Track's L1 to L3 covers what the platform observes and records about
    each ingested dep. A further step is for the ingestor to produce
    their own producer-side attestations over consumed deps, typically by
    rebuilding the dep on the ingestor's own SLSA Build platform, signing
    the rebuilt artifact, and emitting and signing an SBOM. S2C2F's
    REB-1..4 and AUD-4 describe this work. It is a different kind of
    claim from anything in L1 to L3 (the ingestor produces ground truth
    rather than recording external trust signals) and is reserved for a
    cross-cutting axis where any SLSA track can make the same claim about
    its inputs. The term "Verified" is reserved for that axis. Ingestors
    that plan to participate in the Verified axis SHOULD also maintain
    an internal source mirror (S2C2F ING-4) as a prerequisite for
    rebuild.
-   License attribution. License metadata per dep is not in scope for
    this track. SBOMs that reference the Dependency Ingestion Provenance
    attestations are the natural carrier.
-   Broader scope: extend beyond build dependencies to runtime
    dependencies, base images, and developer tooling.
-   Attestable proactive security analysis (S2C2F SCA-5 evidence half).
    Define a predicate type for upstream audit reports bound to a commit
    SHA or artifact digest.
-   Verified rebuilder networks. Allow a Dep Track claim to reference
    independent rebuilders.
-   End-of-life escalation paths. Define a response path when an EOL
    determination surfaces at L1.

[Dep L0]: #dep-l0
[Dep L1]: #dep-l1
[Dep L2]: #dep-l2
[Dep L3]: #dep-l3
