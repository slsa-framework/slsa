---
title: Build Environment track
description: This page covers the SLSA Build Environment track and its levels, describing their security objectives and general requirements.
mermaid: true 
---

# {Build Environment Track: Basics}

**About this page:** this page covers *Build Environment Track: Basics* and its levels, describing their security objectives and general requirements.

**Intended audience:** {add appropriate audience}.

**Topics covered:** build track terminology, threats to build environments, build environment model, lifecycle, level specifics explaination and requirements for

**Internet standards:** [RFC 2119](https://www.rfc-editor.org/rfc/rfc2119), [CIS Critical Security Controls](https://www.cisecurity.org/controls/cis-controls-list)

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD",
"SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be
interpreted as described in [RFC 2119](https://www.rfc-editor.org/rfc/rfc2119).

**For more information, see:** {optional} 

## Overview

Today's hosted [build platforms] play a central role in an artifact's supply
chain. Whether it's a cloud-hosted service like GitHub Actions or an internal
enterprise CI/CD system, the build platform has a privileged level of access
to artifacts and sensitive operations during a build (e.g., access to
producer secrets, provenance signing).

This central and privileged role makes hosted build platforms an attractive
target for supply chain attackers. But even with strong economic and
reputational incentives to mitigate these risks, it's very challenging to
implement and operate fully secure build platforms because they are made up
of many layers of interconnected components and subsystems.

The SLSA Build Environment track aims to address these issues by making it
possible to validate the integrity and trace the provenance of core build
platform components.

## Build Environment Track Terminology

These terms apply to the Build Environment track. See the general terminology [list](terms-generic.md) for terms used throughout the SLSA specification.

| Term | Description |
| --- | --- |
| <span id="boot-process">Boot process</span> | In the context of builds, the process of loading and executing the layers of firmware and/or software needed to start up a build environment on the host compute platform. |
| <span id="build-agent">Build agent</span> | A build platform-provided program that interfaces with the build platform's control plane from within a running build environment. The build agent is also responsible for executing the tenant’s build definition, i.e., running the build. In practice, the build agent may be loaded into the build environment after instantiation, and may consist of multiple components. All build agent components must be measured along with the build image. |
| <span id="build-dispatch">Build dispatch</span> | The process of assigning a tenant's build to a pre-deployed build environment on a hosted build platform. |
| <span id="build-id">Build ID</span> | An immutable identifier assigned uniquely to a specific execution of a tenant's build. In practice, the build ID may be an identifier, such as a UUID, associated with the build execution. |
| <span id="build-image">Build image</span> | The template for a build environment, such as a VM or container image. Individual components of a build image include the root filesystem, pre-installed guest OS and packages, the build executor, and the build agent. |
| <span id="build-image-producer">Build image producer</span> | The party that creates and distributes build images. In practice, the build image producer may be the hosted build platform or a third party in a bring-your-own (BYO) build image setting. |
| Build platform assessment | [Build platforms are assessed](assessing-build-platforms.md) for their ability to meet SLSA requirements at the stated level. |
| <span id="compute-platform">Compute platform</span> | The compute system and infrastructure underlying a build platform, i.e., the host system (hypervisor and/or OS) and hardware. In practice, the compute platform and the build platform may be managed by the same or distinct organizations. |
| <span id="host-interface">Host interface</span> | The component in the compute platform that the hosted build platform uses to request resources for deploying new build environments, i.e., the VMM/hypervisor or container orchestrator. |
| <span id="measurement">Measurement</span> | The cryptographic hash of some component or system state in the build environment, including software binaries, configuration, or initialized run-time data. |
| <span id="quote">Quote</span> | (Virtual) hardware-signed data that contains one or more (virtual) hardware-generated measurements. Quotes may additionally include nonces for replay protection, firmware information, or other platform metadata. (Based on the definition in [section 9.5.3.1](https://trustedcomputinggroup.org/wp-content/uploads/TPM-2.0-1.83-Part-1-Architecture.pdf) of the TPM 2.0 spec) |
| <span id="reference-value">Reference value</span> | A specific measurement used as the good known value for a given build environment component or state. |

### Build environment track terms to avoid

| Term | Reason to avoid | 
| --- | --- |
| image| Disambiguate similar terms. |
| build job | Disambiguate similar terms. |
| build executor/runner | Disambiguate similar terms. |

## What the Build Environment Track does

{clean} The SLSA [Build track] defines requirements for the provenance that is produced for the build artifacts. Trustworthiness of the build process largely depends on the trustworthiness of the [build environment] the build runs in. The Build track assumes full trust into the [Build Platform], and provides no requirements to verify integrity of the build environment. BuildEnv track intends to close this gap.

### What it includes

 - Build environment is bootstrapped from a [build image], which is expected to be an artifact of a SLSA build pipeline.

 - Build platform verifies image security properties including provenance upon starting up the environment and makes evidence of the verification available to tenants or other auditors.

 - BuildEnv track assumes full trust in the software that comes with the build image or is installed at runtime.

 - Malicious software having privileged access within the build environment might be able to circumvent protections provided by the BuildEnv track.

 - Image providers should manage vulnerabilities in the image components to reduce the risks of such attacks, e.g. by using SLSA Dependency track and hardening images with mandatory access control (MAC) policies.

 - Control Plane may perform additional analysis of the image SBOM as it bootstraps the build environment.

Bootstrapping the build environment is a complex process, especially at higher SLSA levels.

## Build environment threats

### Threats and Build Levels

[Build L3] usually requires significant changes to existing build platforms to maintain ephemeral build environments.

It is not uncommon for the build platforms to rely on public cloud providers to manage the compute resources that power build environments.

#### Trusted Computing Base (TCB) issues

This in turn significantly expands the attack surface because added build platform dependencies become part of the [TCB].

Cloud providers are big companies with complex infrastructure that often provide limited abilities to scope the context of trust and continuously validate it over time when using their services.

The BuildEnv track addresses build TCB size concerns at [BuildEnv L2] and [BuildEnv L3] levels.

##### Trusted Computing Base Levels

[BuildEnv L1] level assumes full trust into the Build Platform including underlying [Compute Platform] (e.g., public cloud provider).

[BuildEnv L2] level adds capabilities for verifying the Compute Platform providing evidence that the build environment is bootstrapped from the expected image with the expected early boot components (e.g. UEFI firmware) provided by the Compute Platform.
In essence L2 provides evidence of the boot time integrity of a build environment.
L2 also addresses malicious access to the build environment using compromised Build Platform Admin credentials assuming that image has Compute Platform maintenance agents disabled in it, which are typically used for providing remote access to the virtual machine using Compute Platform APIs.
It is the responsibility of the Image provider to disable/uninstall those agents.
Control Plane should verify that maintenance agents are disabled in the image upon consuming it.  

[BuildEnv L3] level reduces the Compute Platform attack surface through the use of trusted execution environments (TEEs) addressing runtime infrastructure threats that could be coming from compromised Compute Platform admin credentials (that would allow direct access to the host interface) or malicious software within the Compute Platform.
The [SEV-SNP/TDX threat model] describes this level of trust reduction through the use of memory encryption, integrity protection, and remote attestation with cryptographic keys that are certified by the hardware manufacturer.
L3 provides evidence of continuous integrity of the build environment for the whole lifetime.
TEE technologies are not infallible, so physical human access to hardware and side channel attacks are still a risk that is accepted at L3.

### Build image lifetimes diagram

This diagram outlines the lifetime of a build image between its creation and use in bootstrapping a build environment.
A Build Image could be compromised at any stage of its lifetime.
Higher SLSA BuildEnv levels secure the build environment from larger classes of threats.

{mermaid diagram below}

<div class="mermaid">
flowchart LR
      BuildImage>Build Image] ---> |L1|BuildPlatform[[Build Platform]]
      BuildPlatform[[Build Platform]] ---> |L2|ComputeProvider[[Compute Provider]]
      ComputeProvider[[Compute Provider]] ---> |L3|BuildEnvironment[(Build Environment)]
</div>

### Build images and threat levels

[BuildEnv L1] protects from threats that happened during the build image *distribution*, i.e. in between image creation and consumption (e.g., pulling image from a shared registry) by the Build Platform.
This covers the case of unauthorized modifications to the image as it is distributed (potentially via untrusted channels).

[BuildEnv L2] delivers boot time integrity providing cryptographic evidence that the build environment has been bootstrapped to an expected state.
The Compute platform is fully trusted at this level as it provides a virtual TPM device that performs boot measurements.

[BuildEnv L3] extends boot time integrity into the run time all the way until the Build Environment is terminated.
L3 addresses threats coming from malicious actors (e.g., software agents or compromised admin credentials) in the Compute Platform host interface (see [SEV-SNP/TDX threat model] for the list of threats).
Vulnerabilities in the software that is legitimally included in the Build Image are out of scope.
Physical and side-channel attacks are out of scope too but may be considered in the additional future levels of this track.

Practically, achieving L3 requires the build running in a confidential VM using technologies like [AMD SEV-SNP] and [Intel TDX].
Compute Platform footprint in TCB is reduced but may not be eliminated completely if a confidential VM uses custom virtualization components running within it (e.g., [paravisor]).

NOTE: [Control Plane] is considered trusted at L2 and L3 because it *verifies* the remote attestation of the build environment.
Build platforms MAY provide capabilities that let tenants perform remote attestation using a third-party verifier.
However, for the Control Plane to be considered untrusted it should have no back-door access to the build environment (e.g. via SSH).
Besides, Control Plane provides input data to the build environment (i.e. build request message) and security risks associated with compromising inputs have to be considered as well.

For the example threats, refer to the [Build Threats] section.

## Build environment concept model

The Build Environment (BuildEnv) track expands upon the
[build model](threats-overview.md#build-model) by explicitly separating the
build image and compute platform from the
*abstract* build environment and build platform.

<p align="center"><img src="images/build-env-model.svg" alt="Build Environment Model"></p>

### Build environment lifecycle diagram

The above diagram shows how a typical build environment will go through the following lifecycle:

1.  *Build image creation*: A [build image producer](#build-image-producer)
    creates different [build images](#build-image) through a dedicated build
 process. For the SLSA BuildEnv track, the build image producer outputs
 [provenance](terminology#provenance) describing this process.
2.  *Build environment instantiation*: The [hosted build platform](terminology#platform)
    calls into the [host interface](#host-interface) to create a new instance
 of a build environment from a given build image. The
 [build agent](#build-agent) begins to wait for an incoming
 [build dispatch](#build-dispatch).
 For the SLSA BuildEnv track, the host interface in the compute platform
 attests to the integrity of the environment's initial state during its
 [boot process](#boot-process).
3.  *Build dispatch*: When the tenant dispatches a new build, the hosted
    build platform assigns the build to a created build environment.
    For the SLSA BuildEnv track, the build platform attests to the binding
 between a build environment and [build ID](#build-id).
4.  *Build execution*: Finally, the build agent within the environment executes
    the tenant's build definition.



## Build Environment Track Levels

The SLSA Build Environment (BuildEnv) track describes increasing levels of
integrity and trustworthiness of the provenance of a build's
execution context. In this track, provenance describes how a build image
was created, how the hosted build platform deployed a build image in its
environment, and the compute platform they used.

| Track/Level | Requirements | Focus | Trust Root
| ----------- | ------------ | ----- | ----------
| [BuildEnv L0] | (none) | (n/a) | (n/a)
| [BuildEnv L1] | Signed build image provenance exists | Tampering during build image distribution | Signed build image provenance
| [BuildEnv L2] | Attested build environment instantiation | Tampering via the build platform's control plane | The compute platform's host interface
| [BuildEnv L3] | Hardware-attested build environment | Tampering via the compute platform's host interface | The compute platform's hardware

> :warning:
> The Build Environment track L1+ currently requires a [hosted] build platform.
> A future version of this track may generalize requirements to cover bare-metal
> build environments.

> :grey_exclamation:
> We may consider the addition of an L4 to the Build Environment track, which
> covers hardware-attested runtime integrity checking during a build.

## Build Environment level specifics

The primary purpose of the Build Environment (BuildEnv) track is to enable
auditing that a build was run in the expected [execution context].

The lowest level only requires SLSA [Build L2] Provenance to
exist for the [build image], while higher levels provide increasing
auditability of the build environment's properties and integrity of the
generated provenance attestations. The highest levels introduce further
requirements for hardware-assisted hardening of the [compute platform]
aimed at reducing the trusted computing base of a build.

Software producers and third-party auditors can check attestations generated
by the [build image producer] and build platform against the expected
properties for a given build environment. This enables any party to detect
[several classes] of supply chain threats originating in the build
environment.

As in the Build track, the exact implementation of this track is determined
by the build platform implementer, whether they are a commercial CI/CD service
or enterprise organization. While this track describes general minimum
requirements, this track does not dictate the following
implementation-specific details: the type of build environment, accepted
attestation formats, the type of technologies used to meet L3 requirements,
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
environment has SLSA Build Provenance showing how the image was built.

<dt>Intended for<dd>

Build platforms and organizations wanting to ensure a baseline level of
integrity for build environments at the time of build image distribution.

<dt>Requirements<dd>

-   Build Image Producer:
    -   MUST automatically generate SLSA [Build L2] or higher
    Provenance for created build images (i.e., VM or container images).
    -   MUST allow independent automatic verification of a build image's [SLSA
    Build Provenance]. If the build image artifact cannot be published, for
    example due to intellectual property concerns, an attestation asserting the
    expected hash value of the build image MUST be generated and distributed
    instead (e.g., using [SCAI] or a [Release Attestation]). If the full Build
    Provenance document cannot be disclosed, a [VSA] asserting the build
    image's SLSA Provenance MUST be distributed instead.

-   Build Platform:
    -   MUST meet SLSA [Build L2] requirements.
    -   Prior to the instantiation of a new build environment, the SLSA
    Provenance for the selected build image MUST be automatically verified.
    A signed attestation to the result of the SLSA Provenance verification
    MUST be generated and distributed (e.g., via a [VSA]).

<dt>Benefits<dd>

Provides evidence that a build image was built from the advertised
source and build process.

</dl>

</section>
<section id="buildenv-l2">

### BuildEnv L2: Attested build environment instantiation

<dl class="as-table">
<dt>Summary<dd>

The build environment is measured and authenticated by the compute platform
upon instantiation, attesting to the integrity of the initial state
of the environment prior to executing a build.

<dt>Intended for<dd>

Organizations wanting to ensure that their build started from
a clean, known good state.

<dt>Requirements<dd>

All of [BuildEnv L1], plus:

-   Build Image Producer:
    -   Build images MUST be created via a SLSA [Build L3] or higher build
    process.
    -   MUST automatically generate and distribute signed [reference values]
    for the following build image components: bootloader or equivalent,
    guest kernel, [build agent], and root filesystem (e.g., via the image's
    SLSA Provenance, or [SCAI]).
    Additional build image components whose initial state is to be checked
    MAY be also measured.
    -   The build agent MUST be capable of:
        -   Upon completion of the [boot process]: Automatically interfacing
        with the host interface to obtain and transmit a signed quote for the
        build environment's system state.
        -   Upon build dispatch: Automatically generating and distributing
        a signed attestation that binds its boot process quote to the
        assigned build ID (e.g., using [SCAI]).

-   Build Platform Requirements:
    -   MUST meet SLSA [Build L3] requirements.
    -   Prior to dispatching a tenant's build to an instantiated environment,
    a signed [quote] MUST be automatically requested from the build agent,
    and the contained [measurements] verified against their boot process
    reference values. A signed attestation to the result of the verification
    MUST be generated and distributed (e.g., via a [VSA]).

-   Compute Platform Requirements:
    -   The [host interface] MUST be capable of generating signed quotes for
    the build environment's system state.
    In a VM-based environment, this MUST be achieved by enabling a feature
    like [vTPM], or equivalent, in the hypervisor.
    For container-based environments, the container orchestrator MAY need
    modifications to produce these attestations.
    -   The host interface MUST validate the measurements of the build image
    components against their signed references values during the build
    environment's boot process.
    In a VM-based environment, this MUST be achieved by enabling a process
    like [Secure Boot], or equivalent, in the hypervisor.
    For container-based environments, the container orchestrator MAY need
    modifications to perform these checks.[^1]
    -   Prior to instantiating a new build environment, the host interface
    MUST automatically verify the SLSA Provenance for the selected build
    image. A signed attestation to the verification of the build image's
    SLSA Provenance MUST be automatically generated and distributed (e.g.,
    via a [VSA]).

<dt>Benefits<dd>

Provides evidence that a build environment deployed by a hosted build
platform was instantiated from the expected build image and is at the
expected initial state, even in the face of a build platform-level
adversary.

</dl>

</section>
<section id="buildenv-l3">

### BuildEnv L3: Hardware-attested build environment

<dl class="as-table">
<dt>Summary<dd>

The initial state of the build's host environment is measured
and authenticated by trusted hardware, attesting to the integrity
of the build environment's underlying compute stack prior to executing
a build.

<dt>Intended for<dd>

Organizations wanting strong assurances that their build ran on a good
known host environment.

<dt>Requirements<dd>

All of [BuildEnv L2], plus:

-   Build Image Producer:
    -   Upon completion of the boot process: The build agent MUST be capable
    of automatically interfacing with the *trusted hardware* component to
    obtain a signed quote for the host interface's boot process and
    the environment's system state.
    -   Upon build dispatch: The generated dispatch attestation MUST include
    the host interface's boot process quote.

-   Build Platform Requirements:
    -   Prior to dispatching a tenant's build to an instantiated environment,
    the measurements in the *host interface's* boot process quote MUST be
    automatically verified against their reference values.
    A signed attestation to the result of the verification MUST be generated
    and distributed (e.g., via a [VSA]).

-   Compute Platform Requirements:
    -   MUST have trusted hardware capabilities, i.e., built-in physical
    hardware features for generating measurements and quotes for its system
    state. This SHOULD be achieved using a feature like [TPM],
    [confidential computing], or equivalent.
    -   MUST enable validation of the host interface's boot process against
    its reference values. This MUST be achieved by enabling a process
    like [Secure Boot], or equivalent, in the host platform.

<dt>Benefits<dd>

Provides hardware-authenticated evidence that a build ran in the expected
host environment, even in the face of a compromised host interface
(hypervisor/container orchestrator).

</dl>

</section>




## Considerations for Distributed Builds

TODO

<!-- Footnotes -->

[^1]: Since containers are executed as processes on the host platform they do not contain a traditional bootloader that starts up the execution context.

<!-- Link definitions -->

[Build track]: build-track-basics.md
[Build L1]: build-track-basics.md#build-l1
[Build L2]: build-track-basics.md#build-l2
[Build L3]: build-track-basics.md#build-l3
[BuildEnv L0]: #buildenv-l0
[BuildEnv L1]: #buildenv-l1
[BuildEnv L2]: #buildenv-l2
[BuildEnv L3]: #buildenv-l3
[Control plane]: terminology.md#control-plane
[Release Attestation]: https://github.com/in-toto/attestation/blob/main/spec/predicates/release.md
[SCAI]: https://github.com/in-toto/attestation/blob/main/spec/predicates/scai.md
[Secure Boot]: https://wiki.debian.org/SecureBoot#What_is_UEFI_Secure_Boot.3F
[SLSA Build Provenance]: provenance.md
[TPM]: https://trustedcomputinggroup.org/resource/tpm-library-specification/
[VSA]: verification_summary.md
[build image]: #build-image
[confidential computing]: https://confidentialcomputing.io/wp-content/uploads/sites/10/2023/03/Common-Terminology-for-Confidential-Computing.pdf
[execution context]: terminology.md#build-environment
[hosted]: build-requirements.md#isolation-strength
[boot process]: #boot-process
[build agent]: #build-agent
[build environment]: terminology.md#build-environment
[build image producer]: #build-image-producer
[build platform]: terminology.md#platform
[build platforms]: terminology.md#platform
[Build Threats]: threats.md#build-threats
[compute platform]: #compute-platform
[host interface]: #host-interface
[measurement]: #measurement
[paravisor]: https://openvmm.dev/
[provenance]: terminology.md#provenance
[quote]: #quote
[reference values]: #reference-value
[several classes]: #build-environment-threats
[vTPM]: https://trustedcomputinggroup.org/about/what-is-a-virtual-trusted-platform-module-vtpm/
[AMD SEV-SNP]: https://www.amd.com/en/developer/sev.html
[Intel TDX]: https://www.intel.com/content/www/us/en/developer/tools/trust-domain-extensions/overview.html
[TCB]: https://csrc.nist.gov/glossary/term/trusted_computing_base
[SEV-SNP/TDX threat model]: https://www.kernel.org/doc/Documentation/security/snp-tdx-threat-model.rst
