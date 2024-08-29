---
title: Build Environment track
description: This page gives an overview of the SLSA Build Environment track and its levels, describing their security objectives and general requirements.
---

## Rationale

Today's hosted build platforms play a central role in an artifact's supply
chain. Whether it's a cloud-hosted service like GitHub Actions or an internal
enterprise CI/CD system, the build platform has a privileged level of access
to artifacts and sensitive operations during a build (e.g., access to
producer secrets, provenance signing).

This central and privileged role makes hosted build platforms an attractive
target for supply chain attackers. But even with strong economic and
reputational incentives to mitigate these risks, it's very challenging to
implement fully secure build platforms because they are made up of many
layers of interconnected components and subsystems.

The SLSA Build Environment track aims to address these issues by making it
possible to validate the integrity and trace the provenance of core build
platform components.

## Track overview

The SLSA Build Environment (BuildEnv) track describes increasing levels of
integrity and trustworthiness of the <dfn>provenance</dfn> of a build's
execution context. In this track, provenance describes how a [build image]
was created, how the [hosted] build platform deployed a build image in its
environment, and the compute platform they used.

| Track/Level   | Requirements | Focus
| ------------- | ------------ | -----
| [BuildEnv L0] | (none)       | (n/a)
| [BuildEnv L1] | Signed build image provenance exists | Tampering during build image distribution
| [BuildEnv L2] | Attested build environment deployment | Tampering via the build platform's control plane
| [BuildEnv L3] | Hardware-authenticated build environment | Tampering via the compute platform's host interface
| [BuildEnv L4] | Encrypted build environment | Tampering and data leaks by the build platform or compute platform during the build

> [!IMPORTANT]
> The Environment track currently requires a [hosted] build platform.
> A future version of this track may generalize requirements to cover local
> build environments (e.g., developer laptop).

### Build environment model

<p align="center"><img src="images/build-env-model.svg" alt="Model Build Environment"></p>

The Build Environment track expands upon the [build model] by explicitily
separating the *build image* and *compute platform* from the abstract build
environment and build platform.

A typical build environment will go through the following lifecycle:

1.  *Build image creation*: A build image producer creates different build
    images through dedicated build process. For the SLSA Environment track,
    the build image producer outputs provenance describing this process.
2.  *Build environment deployment*: The hosted build platform calls into the
    *host interface* to deploy a new build environment from a given build
    image on the underlying compute platform.
    For the SLSA Environment track, the hosted build platform attests to the
    *measurement* of the environment's *initial state* during its boot
    process.
3.  *Build dispatch*: When the tenant dispatches a new build, the hosted
    build platform assigns the build to a deployed build environment. For
    the SLSA Environment track, the build platform attests to the binding
    between a build environment and *build ID*.
4.  *Build execution*: Finally, the *build executor* running within the
    environment executes the tenant's build definition.

### Definitions

The Build Environment track specifies the following supply chain components
and roles:

| Primary Term | Description
| --- | ---
| Build ID | An immutable identifier assigned uniquely to a specific execution of a tenant's build. In practice, the build ID may be a cryptographic key or other unique and immutable identfier (e.g., a UUID) associated with the build execution.
| Build image | The template for a build environment, such as a VM or container image. Individual components of a build image include the bootable storage volume containing the build executor, a dedicated build platform client, and pre-installed guest OS and packages.
| Build image producer | The party that creates and distributes build images. In practice, the build image producer may be the hosted build platform or a third party in a BYO build image setting.
| Build executor | A platform-provided program dedicated to executing the tenant’s build definition, i.e., running the build, within the build environment. The build executor must be included in the build image's measurement.
| Build platform client | A platform-provided program that interfaces with the hosted build platform's control plane from within a running build environment. The build platform client must be included in the build image's measurement.
| Build dispatch | The process of assigning a tenant's build to a pre-deployed build environment on a hosted build platform.
| Compute platform | The compute system and infrastructure underlying a build platform, i.e., the host system (hypervisor and/or OS) and hardware. In practice, the compute platform and the build platform may be managed by the same or distinct organizations.
| Host interface | The component in the compute platform that the hosted build platform uses to request resources for deploying new build environments, i.e., the VMM/hypervisor or container orchestrator.
| Boot process | In the context of builds, the process of loading and executing the layers of firmware and/or software needed to start up a build environment on the build platform.
| Measurement | The cryptographic hash of some component or system state in the build environment, including software binaries, configuration, or initialized run-time data.
| Quote | Hardware-signed data that contains one or more hardware-generated measurements. Quotes may additionally include nonces for replay protection, firmware information, or other platform metadata.
| Reference value | A specific measurement used as the good known value for a given build environment component or state.

TODO: Disambiguate similar terms (e.g., image, build job, build runner)

### Build environment threats

TODO

## BuildEnv levels

The primary purpose of the Build Environment (BuildEnv) track is to enable
[auditing] that a build was run in the expected execution context.

The lowest level only requires SLSA [Build L2] Provenance to
exist for the build image, while higher levels provide increasing
auditability of the build environment's properties and integrity of the
generated provenance attestations. The highest levels introduce further
requirements for hardware-assisted hardening aimed at reducing the trusted
computing base of a build.

Software producers and third-party auditors can check attestations generated
by the build image producer and build platform against the expected
properties for a given build environment. This enables any party to detect
[several classes] of supply chain threats originating in the build
environment.

As in the Build track, the exact implementation of this track is determined
by the build platform provider, whether they are a commercial CI/CD service,
or enterprise organization. While this track describes general minimum
requirements, this track does not dictate the following
implementation-specific details: the type of build environment, accepted
attestation formats, the type of technologies used to meet L3/4 requirements,
how attestations are distributed, how build environments are identified, and
what happens on failure.

<section id="environment-l0">

### BuildEnv L0: No guarantees

<dl class="as-table">
<dt>Summary<dd>

No requirements---L0 represents the lack of any sort of build environment
provenance.

<dt>Intended for<dd>

Development or test builds of software that are built and run on a local
machine, such as unit tests.

<dt>Requirements<dd>

n/a

<dt>Benefits<dd>

n/a

</dl>
</section>

<section id="buildenv-l1">

### BuildEnv L1: Signed build image provenance exists

<dl class="as-table">
<dt>Summary<dd>

The build image (i.e., VM or container image) used to instantiate the build
environment has SLSA provenance showing how the image was built.

<dt>Intended for<dd>

Build platforms and organizations wanting to ensure a baseline level of
integrity for build environments at the time of build image distrbution.

<dt>Requirements<dd>

-   Build Image Producer:
    -   MUST automatially generate SLSA [Build L2] or higher
    Provenance for created build images (i.e., VM or container images).
    -   MUST allow independent automatic verification of a build image's SLSA
    Provenance. If the build image artifact cannot be published, for example
    due to intellectual property concerns, an attestation asserting the
    expected hash value of the build image MUST be generated and distributed
    instead (e.g., using [SCAI] or a [Release Attestation]). If the full
    Provenance document cannot be disclosed, a [VSA] asserting the build
    image's SLSA Provenance MUST be distributed instead.

-   Build Platform:
    -   MUST meet SLSA [Build L2] requirements.
    -   Prior to deployment of a new build environment, the SLSA Provenance
    for the selected build image SHOULD be automatically verified.

<dt>Benefits<dd>

Provides evidence that a build image was built from the advertised
source and build process.

</dl>

</section>
<section id="buildenv-l2">

### BuildEnv L2: Attested build environment instantiation

<dl class="as-table">
<dt>Summary<dd>

The build environment is measured and authenticated prior to dispatching
any builds, attesting to the integrity of initial state of the environment
when it's deployed by the build platform.

<dt>Intended for<dd>

Organizations wanting to ensure that their build started from
a clean, known good state.

<dt>Requirements<dd>

All of [BuildEnv L1], plus:

-   Build Image Producer:
    -   Build images MUST be created via a SLSA [Build L3] or higher build
    process.
    -   MUST add support in the build image to:
        -   Automatically check build image components against their
        reference values during build environment startup.
        In VM-based images, this can be achieved by enabling a [trusted boot]
        process. In container-based build images, a dedicated program MUST be
        used to perform these checks.[^1]
        -   Automatically generate and distribute a signed attestation that
        the initial state of a given build environment instance has been
        verified against the corresponding build image, incl. its SLSA
        Provenance (e.g., using [SCAI] or a [VSA]).
    -   MUST automatically generate and distribute signed reference values
    for the following build image components: bootloader or equivalent,
    guest kernel, build platform client, build executor, and root filesystem.
    Additional build image components whose initial state is to be checked
    MAY be also measured.

-   Build Platform Requirements:
    -   MUST meet SLSA [Build L3] requirements.
    -   Prior to deployment of a new build environment, the SLSA Provenance
    for the selected build image MUST be automatically verified. A signed
    attestation to the verification of the build image's SLSA Provenance
    MUST be automatically generated and distributed (e.g., via a [VSA]).
    -   Prior to dispatching a tenant's build to a deployed environment, its
    initial state attestation MUST be automatically verified. A signed
    attestation binding the tenant's build ID to the verified initial state
    of the selected build environment MUST be generated and distributed.

<dt>Benefits<dd>

Provides evidence that a build environment deployed by a hosted build
platform was instantiated from the expected build image and is at the
expected initial state, even in the face of a build platform-level
adversary.

</dl>

</section>
<section id="buildenv-l3">

### BuildEnv L3: Hardware-authenticated build environment

<dl class="as-table">
<dt>Summary<dd>

The initial state of the build environment is measured and autenticated by
trusted hardware, and the build ID is verifiably bound to the
deployed build environment, attesting to the integrity of the environment
when a tenant's build is first dispatched.

<dt>Intended for<dd>

Organizations wanting strong assurances that their build was dispatched in
a known good environment.

<dt>Requirements<dd>

All of [BuildEnv L2], plus:

**TODO:** These requirements need to be re-formulated.

-   Build Image Producer:
    -   MUST add support in the build image to:
        -   Use trusted hardware to check build image component reference
        values and integrity of the build environment startup.
        -   Automatically generate and distribute a signed attestation
        that a given build ID was dispatched in the corresponding build
        environment instance, incl. its initial state attestation (e.g.,
        using [SCAI] or a [VSA]).
        -   Use trusted hardware to sign all build image-generated
        attestations.

-   Build Platform Requirements: TODO

-   Compute Platform Requirements: TODO

<dt>Benefits<dd>

Provides hardware-authenticated evidence that a build running on a hosted
build platform was dispatched in the expected build environment, even in the
face of a compromised host interface (hypervisor/container orchestrator).

</dl>

</section>
<section id="buildenv-l4">

### BuildEnv L4: Encrypted build environment

TODO

</section>

<!-- Footnotes -->

[^1]: Since containers are executed as processes on the host platform they do not contain a traditional bootloader that starts up the execution context.

<!-- Link definitions -->

[Build L1]: levels.md#build-l1
[Build L2]: levels.md#build-l2
[Build L3]: levels.md#build-l3
[BuildEnv L0]: #buildenv-l0
[BuildEnv L1]: #buildenv-l1
[BuildEnv L2]: #buildenv-l2
[BuildEnv L3]: #buildenv-l3
[BuildEnv L4]: #buildenv-l4
[SCAI]: https://github.com/in-toto/attestation/blob/main/spec/predicates/scai.md
[VSA]: verification_summary.md
[build image]: #definitions
[build model]: terminology.md#build-model
[hosted]: requirements.md#isolation-strength
[several classes]: #build-environment-threats
[trusted boot]: https://csrc.nist.gov/glossary/term/trusted_boot
