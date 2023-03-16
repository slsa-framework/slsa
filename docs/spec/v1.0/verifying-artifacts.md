---
prev_page:
  title: Verifying build systems
  url: verifying-artifacts
next_page:
  title: Threats & mitigations
  url: threats
---
# Verifying artifacts

SLSA uses provenance to indicate whether an artifact is authentic or not, but
provenance doesn't do anything unless somebody inspects it. SLSA calls that inspection
verification, and this page describes how to verify artifacts and their SLSA
provenance. The intended audience is system implementers, security engineers,
and software consumers.

## Overview

Artifact verification is a process that consists of several stages that involves
the artifact distribution system ("package ecosystem") and artifact consumer.

Package ecosystems verify an artifact's provenance against a set of expectations.
Those expectations are set by the package ecosystem, with optional input from the
artifact producer. Package ecosystems may choose to distribute only artifacts that
pass verification, or they may choose to require that consumers opt-in to
verification.

Consumers can trust their package ecosystem or some other third party to verify
artifacts, or they can verify artifacts against their own set of expectations.

## Package ecosystem

[Package ecosystem]: #package-ecosystem

> ⚠ **RFC:** Is there a better term that is more obvious to most readers?

A <dfn>package ecosystem</dfn> is a set of conventions and tooling for package
distribution. Every package has an ecosystem, whether it is formal or ad-hoc.
Some ecosystems are formal, such as language distribution (e.g.
[Python/PyPA](https://www.pypa.io)), operating system distribution (e.g.
[Debian/Apt](https://wiki.debian.org/DebianRepository/Format)), or artifact
distribution (e.g. [OCI](https://github.com/opencontainers/distribution-spec)).
Other ecosystems are informal, such as a convention used within a company. Even
ad-hoc distribution of software, such as through a link on a website, is
considered an "ecosystem". For more background, see
[Package Model](terminology.md#package-model).

The package ecosystem's maintainers are responsible for reliably redistributing
artifacts and provenance, making the producers' expectations available to consumers,
and providing tools to enable safe artifact consumption (e.g. whether an artifact
meets its producer's expectations).

### Setting Expectations

<dfn>Expectations</dfn> are known provenance values that indicate the corresponding
artifact is authentic. For example, a producer can define the allowed values for
[`buildType`](/provenance/v1#buildType) and
[`externalParameters`](/provenance/v1#externalParameters)
for a given package (assuming it uses the SLSA provenance format) in order to address
the [build integrity threats](threats#build-integrity-threats).
> **TODO:** link to more concrete guidance once it's available.

Expectations MUST be sufficient to detect
or prevent this adversary from injecting unofficial behavior into the package.
Example threats in this category include building from an unofficial fork or
abusing a build parameter to modify the build. Usually expectations identify
the canonical source repository (which is the main external parameter) and
any other security-relevant external parameters.

It is important to note that expectations are tied to a *package name*, whereas
provenance is tied to an *artifact*. Different versions of the same package name
may have different artifacts and therefore different provenance. Similarly, an
artifact may have different names in different package ecosystems but use the same
provenance file.

Package ecosystems
using the [RECOMMENDED suite](/attestation-model#recommended-suite) of attestation
formats SHOULD list the package name in the provenance attestation statement's
`subject` field, though the precise semantics for binding a package name to an
artifact are defined by the package ecosystem.

<table>
<tr><th>Requirement<th>Description<th>L1<th>L2<th>L3

<tr id="expectations-known">
<td>Expectations known
<td>

The package ecosystem MUST ensure that expectations are defined for the package before it is made available to package ecosystem users.

There are several approaches a package ecosystem could take to setting expectations, for example:

-   Requiring the producer to set expectations when registering a new package
    in the package ecosystem.
-   Using the values from the package's provenance during its initial
    publication (trust on first use).

<td>✓<td>✓<td>✓
<tr id="expectations-changes-auth">
<td>Changes authorized
<td>

The package ecosystem MUST ensure that any changes to expectations are
authorized by the package's producer. This is to prevent a malicious actor
from updating the expectations to allow building and publishing from a fork
under the malicious actor's control. Some ways this could be achieved include:

-   Requiring two authorized individuals from the package producer to approve
    the change.
-   Requiring consumers to approve changes, in a similar fashion to how SSH
    host fingerprint changes have to be approved by users.
-   Disallowing changes altogether, for example by binding the package name to
    the source repository.

<td><td>✓<td>✓
</table>

### Verifying expectations for artifacts

It is a critical responsibility of the package ecosystem to verify that the
provenance for a package matches the expectations defined for that package.
In our threat model, the adversary has the ability to invoke a build and to publish
to the registry but not to write to the source repository, nor do they have
insider access to any trusted systems.

A package version is considered to meet a given SLSA level if and only if the
package ecosystem has verified its provenance against the package's
expectations. If expectations are defined for a package but no provenance
exists for the artifact, this MUST result in verification failure.
Conversely, if multiple provenance attestations exist, the system SHOULD accept
any combination that satisfies expectations.

Verifying expectations could happen in multiple places within a package
ecosystem, for example by using one or more of the following approaches:

-   During package upload, the registry ensures that the package's provenance
    matches the known expectations for that package before accepting it into
    the registry.
-   During client-side installation/deployment of a package, the package
    ecosystem client ensures that the package's provenance matches the
    known expectations for that package before use.
-   Package ecosystem participants and/or the ecosystem operators perform
    continuous monitoring of packages to detect any changes to packages which
    do not match the known expectations. **TODO:** do we need to
    emphasize that the value of monitoring without enforcement is lower?

All package ecosystem verifiers will require a mapping from builder identity to
the SLSA level the builder is trusted to meet. How this map is defined,
distributed, and updated is package ecosystem specific.
> **TODO:** expand on this map model. Provide examples for ecosystems to follow,
perhaps in the use-cases, and link to certification.

Verification MUST include the following steps:

-   Ensuring that the builder identity is one of those in the map of trusted
    builder id's to SLSA level.
-   [Verification of the provenance](/provenance/v1#verification) metadata.
-   Ensuring that the values for `BuildType` and `ExternalParameters` in the
    provenance match the known expectations. The package ecosystem MAY allow
    an approved list of `ExternalParameters` to be ignored during verification.
    Any unrecognized `ExternalParameters` SHOULD cause verification to fail.

NOTE: The term *package ecosystem* MAY be interpreted loosely. For example, one
could implement a system which is external to the canonical package ecosystem
and perform SLSA verification for that package ecosystem's contents. This
combination can be considered a package ecosystem for the purposes of setting
and verifying expectations.

**TODO:** Update the requirements to provide guidelines for how to implement,
showing what the options are:

-   Create a more concrete guide on how to do expectations
-   Whether provenance is generated during the initial build and/or
    after-the-fact using reproducible builds
-   How provenance is distributed
-   What happens on failure: blocking, warning, and/or asynchronous notification

### Provenance Distribution

The package ecosystems MUST distribute provenance for the artifacts they distribute
if provided by the producer.

## Consumer

[Consumer]: #consumer

A package's <dfn>consumer</dfn> is the organization or individual that uses the
package.

There are no requirements for how artifact consumers interact with SLSA,
but they will benefit from verifying an artifact's provenance and the build
system used to produce the artifact. If a consumer is unwilling or unable to verify
artifacts, they may still gain some benefit by relying on third-party verification
(e.g. a monitoring service that publicizes artifacts that violate their expectations).

The consumer may have to opt-in to enable SLSA verification, depending on the
package ecosystem.

Consumers may either audit the build systems
themselves using the prompts in [verifying systems](verifying-systems.md) or
rely on the [SLSA certification program](certification.md) (coming soon).
