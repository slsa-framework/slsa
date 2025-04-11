---
title: Hosting build environments
description: This page covers the detailed technical requirements for hosting build environments at each SLSA Build Environment level. The intended audience is build platform implementers, compute infrastructure providers and security engineers.
---

This section of the SLSA Build Environment track specification describes
detailed implementation guidance for build platforms to achieve the SLSA
[Build Environment levels].

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD",
"SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be
interpreted as described in [RFC 2119](https://www.rfc-editor.org/rfc/rfc2119).

## Overview

### Build Environment (BuildEnv) levels

In order to host a [build environment] with a specific BuildEnv level,
responsibility lies primarily with the [build image provider] and the
[build platform], although higher BuildEnv levels also add responsibilities for
the underlying [compute platform].

The BuildEnv track intends for the defined integrity requirements to expand
upon the scope of the [Build track]. Thus, the BuildEnv track is expected to
be implemented as a complement to the Build track.

The following table summarizes the specific supply chain and security
requirements for each role to implement a desired BuildEnv level.

<table class="no-alternate">
<tr>
  <th>Implementer
  <th>Requirement
  <th>Task
  <th>L1<th>L2<th>L3
<tr>
  <td rowspan=6><span id="build-image-producer">Build Image Producer (BI)</span>
  <td colspan=2><span id="distribute-image-provenance">**BI.1**: Distribute build image provenance</span>
  <td>✓<td>✓<td>✓
<tr>
  <td colspan=2><span id="distribute-image-ref-values">**BI.2**: Distribute reference values for build image components</span>
  <td> <td>✓<td>✓
<tr>
  <td rowspan=4><span id="enlightened-build-agent">**BI.3**: Implement enlightened build agent</span>
<tr>
  <td><span id="root-of-trust">**BI.3.1**: Interface with a root of trust</span>
  <td> <td>✓<td>✓
  <td><span id="attest-env-initial-state">**BI.3.2**: Attest to build environment initial state</span>
  <td> <td>✓<td>✓
<tr>
  <td><span id="attest-build-dispatch">**BI.3.3**: Attest to build dispatch</span>
  <td> <td>✓<td>✓
<tr>
  <td rowspan=5><span id="build-platform">Build Platform (BP)</span>
  <td colspan=2><span id="implement-slsa-build-track">**BP.1**: Implement the SLSA Build track</span>
  <td>✓<td>✓<td>✓
<tr>
  <td colspan=2><span id="choose-appropriate-compute-platform">**BP.2**: Choose an appropriate compute platform</span>
  <td> <td>✓<td>✓
<tr>
  <td rowspan=3><span id="verify-build-environment-integrity">**BP.3**: Verify build environment integrity</span>
  <td><span id="verify-image-provenance">**BP.3.1**: Verify build image provenance</span>
  <td>✓<td>✓<td>✓
<tr>
  <td><span id="verify-env-deployment">**BP.3.2**: Verify build environment deployment</span>
  <td> <td>✓<td>✓
<tr>
  <td><span id="verify-host-interface">**BP.3.3**: Verify host interface integrity</span>
  <td> <td> <td>✓
<tr>
  <td rowspan=5><span id="compute-platform">Compute Platform (CP)</span>
  <td rowspan=3><span id="enlightened-host-interface">**CP.1**: Run enlightened host interface</span>
  <td><span id="generate-guest-attestations">**CP.1.1**: Support guest system state attestation</span>
  <td> <td>✓<td>✓
<tr>
  <td><span id="guest-secure-boot">**CP.1.2**: Verify guest initialization integrity</span>
  <td> <td>✓<td>✓
<tr>
  <td><span id="expose-trusted-hardware">**CP.1.3**: Expose trusted hardware features</span>
  <td> <td> <td>✓
<tr>
  <td colspan=2><span id="trusted-hardware-feature">**CP.2**: Support integrated trusted hardware</span>
  <td> <td> <td>✓
<tr>
  <td colspan=2><span id="host-secure-boot">**CP.3**: Attest host interface integrity</span>
  <td> <td> <td>✓
</table>

### Scope

The requirements laid out in this guidance for BuildEnv track implementers
assume VM-based build environments. We plan to extend the scope of these
requirements to cover container-only environments in a future version of the
BuildEnv spec.

## Build Image Producer

The [build image producer] is an organization that releases a VM image (i.e.,
the [build image]) that is used as a basis for spawning an instance of a build
environment. Public cloud-based CI/CD services (e.g., GitHub Actions, GitLab
CI/CD) are major build image producers, offering various VM images for the most
common build environment configurations.

Enterprises hosting on-premise build platforms may produce their own build
images for internal software development teams or opt to use VM images produced
by a third-party. Similarly, software producers that require special-purpose
build environments, for example to support builds on specific hardware
architectures, may produce their own VM images and bring them to a hosted
build platform with bring-your-own build image policies.

### BI.1 Distribute build image provenance

The build image producer is responsible for generating and distributing
provenance describing how a particular build image was produced.

<table>
<tr><th>Level<th>Implementation Guidance

<tr><td>BuildEnv L1<td>

MUST follow SLSA Build L2 or higher [producer requirements] when producing VM
images to be used as build images.

<tr><td>BuildEnv L2<td>

MUST follow SLSA Build L3 or higher [producer requirements] when producing VM
images to be used as build images.

<tr><td>BuildEnv L3<td>

Same as L2.

</table>

The BuildEnv level specifies the minimum SLSA [Build track] level at which
the [producer requirements] MUST be followed by the build image producer. These
requirements include following a consistent build process, choosing a suitable
build platform, and  distributing the generated SLSA [Build Provenance] to allow
consumers to independently verify  provenance.

In scenarios where the build image artifact cannot be published directly, for
example due to build image producer intellectual property concerns, an
attestation asserting the expected hash value of the build image MUST be
generated (e.g., using [SCAI] or a [Release Attestation]) and distributed
alongside the image's corresponding SLSA Build Provenance.

If the full Build Provenance document cannot be disclosed, for instance to avoid
disclosing details about build platform internals, a [VSA] asserting the
produced build image's SLSA Build level MUST be distributed instead,
irrespective of whether the build image artifact itself is published.

### BI.2 Distribute reference values for build image components

The build image producer is responsible for generating and distributing
digitally signed known good values (i.e., [reference values]) for a number of
components in their produced build images.

<table>
<tr><th>Level<th>Implementation Guidance

<tr><td>BuildEnv L1<td>

none

<tr><td>BuildEnv L2<td>

MUST collect VM image component reference values:
-   bootloader
-   guest kernel
-   [build agent]
-   root filesystem

<tr><td>BuildEnv L3<td>

Same as L2.

</table>

For VM images, reference values for components such as a guest kernel or build =
agent MAY be collected during the VM's build by computing a [measurement] of
the particular component. Root filesystems specifically SHOULD be measured using
tools like [dm-verity] or [fs-verity] run at VM startup.

It is RECOMMENDED that authenticated reference values be captured in the VM
image's SLSA Build Provenance directly (as part of the `subject` field), or
using a dedicated [SCAI] attestation.
If a component is supplied by a third-party producer and the component's
authenticated reference value is made available, the build image producer SHOULD
use the available reference value, rather than generating its own.

Build image producers MAY collect and distribute reference values for additional
build image components for which the integrity of the initial state needs to be
checked (e.g., initramfs in Linux-based VMs).

### BI.3 Implement enlightened build agent

The [build agent] is a crucial component in a build environment, whose primary
role is to enable communication between the build platform's control plane and
the running build environment. As such, the build image producer is responsible
for implementing a [build agent] that supports specific features needed to
validate the integrity of a build environment.

#### BI.3.1 Interface with a root of trust

The enlightened build agent MUST be capable of automatically interfacing with a
root of trust component provided by the host [compute platform].

<table>
<tr><th>Level<th>Implementation Guidance

<tr><td>BuildEnv L1<td>

none

<tr><td>BuildEnv L2<td>

MUST be able to send requests and receive data from a software or virtualized
root of trust that supports the [quote] and [extend] operations, such as a vTPM
implemented by the hypervisor.

<tr><td>BuildEnv L3<td>

MUST be able to send requests and receive data from a *hardware* root of trust
that supports the [quote] and [extend] operations, such as a hardware TPM or
select confidential VM hardware in the compute platform.

</table>

#### BI.3.2 Attest to build environment initial state

The enlightened build agent MUST use the root of trust (per **BI.3.1**) to
attest to the integrity of the initial state of its build environment upon
completion of the VM's [boot process].

<table>
<tr><th>Level<th>Implementation Guidance

<tr><td>BuildEnv L1<td>

none

<tr><td>BuildEnv L2<td>

MUST request a signed [quote] from a software/virtualized root of trust for
the build environment's system state at boot time, and transmit this quote
to the build platform's control plane.

<tr><td>BuildEnv L3<td>

MUST request a signed [quote] from a *hardware* root of trust for the
environment's system state *and* the VMM's boot process, and transmit this
quote to the build platform's control plane.

</table>

#### BI.3.3 Attest to build dispatch

The enlightened build agent MUST use the root of trust (per **BI.3.1**) to
attest to the integrity of the process of dispatching a build to a build
environment. That is, the build dispatch occurs when a [software producer]
sends a request to the build platform to start a new build. As a result,
the build platform assigns the producer's request a unique [build ID] and
loads the associated build definition into a running build environment
instance. Establishing a cryptographic binding between the build ID and
the build environment allows verifiers to check that a build was not run in an
unexpected environment.

<table>
<tr><th>Level<th>Implementation Guidance

<tr><td>BuildEnv L1<td>

none

<tr><td>BuildEnv L2<td>

MUST extend the software/virtualized root of trust [measurement] with the
assigned [build ID] at build dispatch, request a new signed quote, and
transmit this quote to the build platform's control plane.

<tr><td>BuildEnv L3<td>

MUST extend the *hardware* root of trust [measurement] with the assigned
[build ID] at build dispatch, request a new signed quote, and transmit
this quote to the build platform's control plane.

</table>

Together with **BI.3.2**, **BI.3.3** establishes a chain of verifiable
integrity information that cryptographically binds the host system, VMM,
build environment and build ID.

## Build Platform

From the BuildEnv track's perspective, the [build platform] is a
system dedicated to orchestrating and deploying build environments
in which tenant-defined builds can be run. In practice, the build platform
may manage its own on-premise [compute platform], or it may rely on a
third-party compute infrastructure provider such as a public cloud service.

### BP.1 Implement the SLSA Build track

The build platform integrity requirements defined in the [Build track]
serve as an important foundation for enhancing the integrity of
build environments in a verifiable way.

<table>
<tr><th>Level<th>Implementation Guidance

<tr><td>BuildEnv L1<td>

MUST follow SLSA Build L2 or higher [build platform requirements].

<tr><td>BuildEnv L2<td>

MUST follow SLSA Build L3 or higher [build platform requirements].

<tr><td>BuildEnv L3<td>

Same as L2.

</table>

### BP.2 Choose an appropriate compute platform

### BP.3 Verify build environment integrity

#### BP.3.1 Verify build image provenance

#### BP.3.2 Verify build environment deployment

#### BP.3.3 Verify host interface integrity


## Compute Platform

[Build Environment levels]: build-env-levels.md
[Build Provenance]: provenance.md
[Build track]: requirements.md
[build environment]: terminology.md#build-environment
[build ID]: build-env-levels.md#build-id
[build image]: build-env-levels.md#build-image
[build image producer]: build-env-levels.md#build-image-producer
[build platform]: terminology.md#platform
[build platform requirements]: requirements.md#build-platform
[compute platform]: build-env-levels.md#compute-platform
[extend]: https://trustedcomputinggroup.org/wp-content/uploads/Trusted-Platform-Module-2.0-Library-Part-1-Version-184_pub.pdf
[measurement]: build-env-levels.md#measurement
[producer requirements]: requirements.md#producer
[quote]: build-env-levels.md#quote
[Release Attestation]: https://github.com/in-toto/attestation/blob/main/spec/predicates/release.md
[SCAI]: https://github.com/in-toto/attestation/blob/main/spec/predicates/scai.md
[Secure Boot]: https://wiki.debian.org/SecureBoot#What_is_UEFI_Secure_Boot.3F
[software producer]: terminology.md#producer
[TPM]: https://trustedcomputinggroup.org/resource/tpm-library-specification/
[VSA]: verification_summary.md
