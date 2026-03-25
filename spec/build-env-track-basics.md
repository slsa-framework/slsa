---
title: Build Environment track
description: This page gives an overview of the SLSA Build Environment track and its levels, describing their security objectives and general requirements.
mermaid: true
---

## Rationale

Today's hosted [build platforms] play a central role in an artifact's supply
chain. Whether it's a public cloud-hosted service like GitHub Actions or an
internal enterprise CI/CD system, the build platform has a privileged level of
access to artifacts and sensitive operations during a build (e.g., access to
producer secrets, provenance signing).

This central and privileged role makes hosted build platforms an attractive
target for supply chain attackers. But even with strong economic and
reputational incentives to mitigate these risks, it's very challenging to
implement and operate fully secure build platforms because they are made up
of many layers of interconnected components and subsystems.

The SLSA Build Environment track aims to address these issues by making it
possible to validate the integrity and trace the [provenance] of core build
platform components.

## Track overview

The SLSA Build Environment (BuildEnv) track describes increasing levels of
integrity and trustworthiness of the provenance of a build's
execution context. In this track, provenance describes how a build image
was created, how the hosted build platform deployed a build image in its
environment, and the compute platform they used.

| Track/Level | Requirements | Focus | Trust Root
| ----------- | ------------ | ----- | ----------
| [BuildEnv L0] | (none) | (n/a) | (n/a)
| [BuildEnv L1] | Signed build image provenance exists | Tampering during build image distribution | Signed build image provenance
| [BuildEnv L2] | Attested build environment instantiation | Tampering during build environment boot process | The compute platform's host interface
| [BuildEnv L3] | Hardware-attested build environment | Tampering with compute platform software | The compute platform's hardware

> :warning:
> The Build Environment track L1+ currently requires a [hosted] build platform.
> A future version of this track may generalize requirements to cover bare-metal
> build environments.

> :grey_exclamation:
> We may consider the addition of an L4 to the Build Environment track, which
> covers hardware-attested runtime integrity checking during a build.

### Build environment model

<p align="center"><img src="images/build-env-model.svg" alt="Build Environment Model"></p>

The Build Environment (BuildEnv) track expands upon the
[build model](terminology#build-model) by explicitly separating the
[build image](terminology#build-image) and [compute platform](#compute-platform) from the
abstract [build environment](#build-environment) and [build platform](terminology#platform).
Specifically, the BuildEnv track defines the following roles, components, and concepts:

| Primary Term | Description
| --- | ---
| <span id="build-id">Build ID</span> | An immutable identifier assigned uniquely to a specific execution of a tenant's build. In practice, the build ID may be an identifier, such as a UUID, associated with the build execution.
| <span id="build-image">Build image</span> | The template for a build environment, such as a VM or container image. Individual components of a build image include the root filesystem, pre-installed guest OS and packages, the build executor, and the build agent.
| <span id="build-image-producer">Build image producer</span> | The party that creates and distributes build images. In practice, the build image producer may be the hosted build platform or a third party in a bring-your-own (BYO) build image setting.
| <span id="build-agent">Build agent</span> | A build platform-provided program that interfaces with the build platform's control plane from within a running build environment. The build agent is also responsible for executing the tenant’s build definition, i.e., running the build. In practice, the build agent may be loaded into the build environment after instantiation, and may consist of multiple components. All build agent components must be measured along with the build image.
| <span id="build-dispatch">Build dispatch</span> | The process of assigning a tenant's build to a pre-deployed build environment on a hosted build platform.
| <span id="build-request">Build request</span> | The process of a tenant sending a request to a hosted build platform to execute the build definition. In practice, the build request may be sent automatically after events like a new pull reuquests, or triggered manually by the tenant.
| <span id="compute-platform">Compute platform</span> | The compute system and infrastructure underlying a build platform, i.e., the host system (hypervisor and/or OS) and hardware. In practice, the compute platform and the build platform may be managed by the same or distinct organizations.
| <span id="host-interface">Host interface</span> | The component in the compute platform that the hosted build platform uses to request resources for deploying new build environments, i.e., the VMM/hypervisor or container orchestrator.
| <span id="boot-process">Boot process</span> | In the context of builds, the process of loading and executing the layers of firmware and/or software needed to start up a build environment on the host compute platform.
| <span id="measurement">Measurement</span> | The cryptographic hash of some component or system state in the build environment, including software binaries, configuration, or initialized run-time data.
| <span id="quote">Quote</span> | (Virtual) hardware-signed data that contains one or more (virtual) hardware-generated measurements. Quotes may additionally include nonces for replay protection, firmware information, or other platform metadata. (Based on the definition in [section 9.5.3.1](https://trustedcomputinggroup.org/wp-content/uploads/TPM-2.0-1.83-Part-1-Architecture.pdf) of the TPM 2.0 spec)
| <span id="reference-value">Reference value</span> | A specific measurement used as the good known value for a given build environment component or state.

**TODO:** Disambiguate similar terms (e.g., image, build job, build executor/runner)

#### Build environment lifecycle

<!--
This diagram outlines the lifetime of a build image between its creation and
use in bootstrapping a build environment.

<div class="mermaid">
flowchart LR
      BuildImage>Build Image] ---> |L1|BuildPlatform[[Build Platform]]
      BuildPlatform[[Build Platform]] ---> |L2|ComputeProvider[[Compute Provider]]
      ComputeProvider[[Compute Provider]] ---> |L3|BuildEnvironment[(Build Environment)]
</div>
-->

A typical build environment will go through the following lifecycle:

1.  *Build image creation*: A [build image producer](#build-image-producer)
    creates different [build images](#build-image) through a dedicated build
    process. For the SLSA BuildEnv track, the build image producer outputs
    [provenance](terminology#provenance) describing this process.
2.  *Build image distribution*: A build image producer distributes the build
    image and makes it available for usage on
    [hosted build platforms](terminology#platform).
3.  *Build environment instantiation*: A hosted build platform calls into the
    [host interface](#host-interface) to create a new instance of a build
    environment from a given build image. The [build agent](#build-agent) waits
    for an incoming [build dispatch](#build-dispatch).
    For the SLSA BuildEnv track, the host interface in the compute platform
    attests to the integrity of the environment's initial state during its
    [boot process](#boot-process).
3.  *Build dispatch*: When the tenant [requests a new build](#build-request),
    the hosted build platform assigns the build to an instantiated build
    environment.
    For the SLSA BuildEnv track, the build platform attests to the binding
    between a build environment and [build ID](#build-id).
4.  *Build execution*: Finally, the build agent within the environment executes
    the tenant's build definition.

### Build environment threats

A [build image] could be compromised at any stage of its lifetime. The SLSA
BuildEnv levels incrementally address several classes of threats to the build
environment.

For example threats, refer to the [Build Threats] section.

### Build image distribution threats

An attacker may make unauthorized modifications to the build image during build
distribution, i.e., in between image creation and consumption (e.g., pulling
the image from a shared registry) by the build platform. This tampering
may occur on the registry or as the build image is transmitted (potentially via
untrusted channels).

[BuildEnv L1] addresses threats that can happen during build image distribution
by requiring that build images be created following the SLSA Build track.
[BuildEnv L1] also assumes full trust in the build platform including the
underlying [compute platform] (e.g., public cloud provider).

### Build environment instantiation threats

An attacker may tamper with the bootstrapping process of the build environment
to instantiate a build environment with compromised boot components (e.g., UEFI
firmware). If the attacker manages to compromise build platform admin
credentials, these can be used to gain malicious access to the build environment
via installed compute platform maintenance software. While such software is
typically used for providing remote admin access to the virtual machine (VM)
using compute platform APIs, it can also be used to modify boot components in
the VM.

[BuildEnv L2] addresses these threats by requiring evidence provided by the
compute platform's host interface that the build environment is instantiated
from the expected image with the expected early boot components. In essence, L2
provides evidence of the boot time integrity of a build environment.

The compute platform is fully trusted at [BuildEnv L2] as the level relies on
the host interface to perform a build environment's boot-time measurements. It
remains the responsibility of the build image producer to disable/uninstall any
admin interfaces that could be misused by an attacker.

### Compute platform threats

Attackers may seek to compromise a build platform's runtime infrastructure, and
thereby any builds it executes, or circumvent any VM boot-time integrity checks,
through vulnerable/malicious software within the compute platform or its host
nterface. These threats may also arise from compromised compute platform admin
credentials that would allow direct access to compute platform software.

See the [AMD SEV-SNP/Intel TDX threat model] for a more detailed list of compute
platform level threats.

[BuildEnv L3] reduces the compute platform attack surface through the use of
hardware-based attestation, commonly provided by trusted execution environments
(TEEs). The [AMD SEV-SNP/Intel TDX threat model] describes how this level of
trust reduction can be achieved through the use of VM memory encryption and
integrity checking, as well as remote attestation with cryptographic keys that
are certified by the compute platform's hardware manufacturer.

[BuildEnv L3] therefore extends a build environment's boot time integrity to
to its execution. That is, L3 requires *hardware-attested* evidence that the
build environment was instantiated from the expected build image and is running
within a legitimate hardware environment supporting the above integrity
properties.

#### Trusted components and track scope

The BuildEnv track assumes full trust in the following components. Risks that
are out of scope may be considered in a future version of the BuildEnv or
other SLSA track.

The [control plane] is trusted even at L2 and L3 because it *verifies* the
provenance attestations of the build environment.

-  Reducing trust in the control plane is out of scope, and would require
   measures like removing back-door access to the build environment (e.g., via
   SSH).
-  The control plane provides input data to the build environment (i.e., build
   request message). Mitiating security risks associated with compromised
   inputs are also out of scope.

The software that ships with the build image or is installed at runtime is
trusted at all levels, but may be optionally verified for enhanced integrity
checking at higher levels of the BuildEnv track.

-  Vulnerabilities in the software that is legitimally included in the build
   image are out of scope.
-  Addressing attempts to circumvent the integrity protections provided by the
   BuildEnv track by malicious software with privileged access within the build
   environment is also out of scope.
-  Build image producers should manage vulnerabilities in the image components
   to reduce the risks of such attacks, e.g. by using the SLSA Dependency track
   and hardening images with mandatory access control (MAC) policies.
-  The control plane may perform additional analysis of build image supply
   chain information like SBOM as part of build environment bootstrapping.

Physical and side-channel attacks on the build or compute platform, including
any trusted execution hardware, are out of scope.

<!--

#### Parking lot

The SLSA [Build track] defines requirements for the provenance that is produced for the build artifacts.
Trustworthiness of the build process largely depends on the trustworthiness of the [build environment] the build runs in.
The Build track assumes full trust into the [Build Platform], and provides no requirements to verify integrity of the build environment.
BuildEnv track intends to close this gap.

Build environment is bootstrapped from a [build image], which is expected to be an artifact of a SLSA build pipeline.
Build platform verifies image security properties including provenance upon starting up the environment and makes evidence of the verification available to tenants or other auditors.

Bootstrapping the build environment is a complex process, especially at higher SLSA levels.
[Build L3] usually requires significant changes to existing build platforms to maintain ephemeral build environments.

Cloud providers are big companies with complex infrastructure that often provide limited abilities to scope the context of trust and continuously validate it over time when using their services.

Practically, achieving L3 requires the build running in a confidential VM using technologies like [AMD SEV-SNP] and [Intel TDX].
Compute Platform footprint in TCB is reduced but may not be eliminated completely if a confidential VM uses custom virtualization components running within it (e.g., [paravisor]).

-  Build platforms MAY provide capabilities that let tenants perform remote attestation using a third-party verifier.

-->

## BuildEnv levels

The primary purpose of the Build Environment (BuildEnv) track is to enable
auditing that a build was run in the expected [execution context].
It is not uncommon for the build platforms to rely on public cloud providers to
manage the compute resources that power build environments. This in turn
significantly expands the attack surface because added compute platform
dependencies become part of the trusted computing base ([TCB]).

The lowest level only requires SLSA [Build L2] Provenance to
exist for the [build image], while higher levels incrementally reduce the TCB
size of the build environment, and provide increased integrity checking of the
build environment.

Hence, the highest levels of the BuildEnv track introduce further requirements
for hardware-based hardening of the [compute platform] aimed at reducing the
TCB of a build environment.

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

The initial state of the host interface is measured
and authenticated by trusted hardware, attesting to the integrity
properties of the build environment's underlying compute stack.

<dt>Intended for<dd>

Organizations wanting strong assurances that their build ran on
a good known, high-integrity execution environment, without needing to
place full trust in the compute platform.

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
    [trsuted execution environment], or equivalent.
    -   MUST enable validation of the host interface's boot process against
    its reference values. This MUST be achieved by enabling a process
    like [Secure Boot], or equivalent, in the host platform.

<dt>Benefits<dd>

Provides hardware-authenticated evidence that a build ran in the expected
high-integrity environment, even in the face of a compromised host interface
(hypervisor/container orchestrator).

</dl>

</section>

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
