---
title: Build Environment track
description: This page gives an overview of the SLSA Build Environment track and its levels, describing their security objectives and general requirements.
---


## Track overview

The SLSA Build Environment track describes increasing levels of integrity and
trustworthiness of the <dfn>provenance</dfn> of a build's execution context.
In this track, provenance describes how the [hosted] build platform built the
base [build image], what build environment they deployed, and the hardware
platform they used.

| Track/Level   | Requirements | Focus |
| ------------- | ------------ | ----- |
| [Environment L0]  | (none)       | (n/a)    |
| [Environment L1]  | Signed build image provenance exists | Tampering during build image distribution |
| [Environment L2]  | Attested build environment deployment | Tampering via the build platform's control plane |
| [Environment L3]  | Hardware-authenticated build environment | Tampering via the compute platform's host interface |
| [Environment L4]  | Encrypted build environment | Tampering and data leaks by the build platform or compute platform during the build |

> [!IMPORTANT]
> The Environment track currently requires a [hosted] build platform.
> A future version of this track may generalize requirements to cover local
> build environments (e.g., developer laptop).

### Build environment model

<p align="center"><img src="images/build-env-model.svg" alt="Model Build Environment"></p>

The Build Environment track expands upon the [build model] by explicitily
separating the *build image* and *compute platform* from the abstract build environment
and build platform.

A typical build environment will go through the following lifecycle:

1.  *Build image creation*: A hosted build platform creates different build
    images through a separate build process. For the SLSA HABE Track, the
    hosted build platform outputs SLSA provenance describing this process.
2.  *Build environment deployment*: The hosted build platform calls into the
    *host interface* to deploy a new build environment from a given build image
    on the underlying compute platform.
    For the SLSA HABE Track, the build platform attests to the *measurement*
    of the environment's *boot process*.
3.  *Build dispatch*: When the tenant dispatches a new build, the hosted
    build platform assigns the build to a deployed build environment. For
    the SLSA HABE Track, the build platform attests to the binding between
    a build environment and *build ID*.
4.  *Build execution*: Finally, the *build executor* running within the
    environment executes the tenant's build definition.

| Primary Term | Description
| --- | ---
| Build ID | An immutable identifier assigned uniquely to a specific execution of a tenant's build. In practice, the build ID may be a cryptographic key or other unique and immutable identfier (e.g., a UUID) associated with the build execution.
| Build image | The template for a build runtime environment, such as a VM or container image. Individual components of a build image are provided by the hosted build platform, and include the bootable storage volume containing the build executor, a dedicated build platform client, and platform-provided pre-installed guest OS and packages.
| Build executor | The platform-provided program dedicated to executing the tenant’s build definition, i.e., running the build, within the build image. The build executor must be included in the build image's measurement.
| Build dispatch | The process of assigning a tenant's build to a pre-deployed build environment on a hosted build platform.
| Compute platform | The compute system and infrastructure, i.e., the host system (hypervisor and/or OS) and hardware, underlying a build platform. In practice, the compute platform and the build platform may be managed by the same or distinct organizations.
| Boot process | In the context of builds, the process of loading and executing the layers of firmware and software needed to start up a build environmenton the build platform.
| Measurement | The cryptographic hash of some system state in the build environment, including software binaries, configuration, or initialized run-time data. Software layers that are commonly measured include the bootloader, kernel, and kernel cmdline.

TODO: Disambiguate similar terms (e.g., image, build job, build runner)

## Environment levels

The lowest level only requires SLSA Build L2 (or higher) Provenance to exist
for the build image, while higher levels provide increasing auditability of
the build environment's properties and integrity of the generated provenance
attestations. The highest levels introduce further requirements for hardware-
assisted hardening aimed at reducing the trusted computing base of a build.

The primary purpose of the Environment track is to enable [auditing] that a
build was run in the expected compute environment. The build platform and
producers can check attestations generated by the build platform against the
expected properties for a given build environment. This enables any party to
detect several classes of supply chain threats originating in the build
environment [TODO: Link here].

As in the Build track, the exact implementation of this track is determined
by the build platform provider, whether they are a commercial CI/CD service,
or enterprise organization. While this track describes
general [TODO: minimum requirements], this track does not dictate the
following implementation-specific details: the type of build environment
environment, accepted attestation formats, the type of technologies used to
meet L3/4 requirements, what SLSA [Build] level the *built artifacts* meet,
how attestations are distributed, how build environments are identified, and
what happens on failure.

<section id="environment-l0">

### Environment L0: No guarantees

<dl class="as-table">
<dt>Summary<dd>

No requirements---L0 represents the lack of any sort of build environment provenance.

<dt>Intended for<dd>

Development or test builds of software that are built and run on the same
machine, such as unit tests.

<dt>Requirements<dd>

n/a

<dt>Benefits<dd>

n/a

</dl>
</section>

<section id="environment-l1">

### Environment L1: Signed build image provenance exists

<dl class="as-table">
<dt>Summary<dd>

The build image (i.e., VM or container image) used to instantiate the build
environment has SLSA provenance showing how the image was built.

<dt>Intended for<dd>

Build platforms and organizations wanting to ensure a baseline level of
integrity for build environments at the time of build image generation.

<dt>Software Producer Requirements<dd>

-   MUST run builds using a build image that was built by a hosted build
    platform that meets Environment L1 requirements.

-   SHOULD verify the build image's SLSA Build provenance for the selected
    build image, and distribute evidence of the verification to consumers
    (e.g., using a [VSA])

<dt>Build Platform Requirements<dd>

-   MUST automatially generate and distribute SLSA [Build L1] or higher
    Provenance for its supplied build images (i.e., VM or container images).

-   The initial state of the build environment's root storage volume
    MUST be integrity measured and signed.

-   MUST execute builds on infrastructure that meets SLSA [Build L2].

<dt>Benefits<dd>

-   Provides evidence that a build image provided by a hosted build platform
    was built from the advertised source and build process.

</dl>

</section>
<section id="environment-l2">

### Environment L2: Attested build environment instantiation

<dl class="as-table">
<dt>Summary<dd>

The deployed build environment is integrity measured and authenticated
prior to giving access to the tenant, attesting to the initial state of the
environment.

<dt>Intended for<dd>

Organizations wanting to ensure that a specific build is running
in the expected build environment.

All of [Environment L1], plus:

<dt>Software Producer Requirements<dd>

-   MUST run builds in a build environment on a hosted build platform that
    meets Environment L2 requirements.

-   SHOULD verify the build image's Build SLSA provenance for the selected
    build image, and distribute evidence of the verification to consumers
    (e.g., using a [VSA])

<dt>Build Platform Requirements<dd>

-   MUST automatially generate and distribute SLSA [Build L2] or higher
    Provenance for its supplied build images (i.e., VM or container images).

-   The boot process of each build environment MUST be cryptographically measured
    and signed.

-   MUST distribute the boot and root storage attestations to allow for
    independent verification.

-   MUST uniquely bind a build image to a build environment instance.

-   MUST uniquely and immutably bind an instance of a build to its build
    environment.

-   MUST execute builds in an environment that meets SLSA [Build L3].

<dt>Benefits<dd>

-   Provides evidence that a build environment deployed by a hosted build
    platform was initialized from the expected build image.

</dl>

</section>
<section id="environment-l3">

### Environment L3: Hardware-authenticated build environment
TODO

</section>
<section id="environment-l4">

### Environment L4: Encrypted build environment

TODO

</section>

<!-- Link definitions -->

[Build L1]: levels.md#build-l1
[Build L2]: levels.md#build-l2
[Build L3]: levels.md#build-l3
[Environment L0]: #environment-l0
[Environment L1]: #environment-l1
[Environment L2]: #environment-l2
[Environment L3]: #environment-l3
[Environment L4]: #environment-l4
[VSA]: verification_summary.md
[future versions]: future-directions.md
[hosted]: requirements.md#isolation-strength
