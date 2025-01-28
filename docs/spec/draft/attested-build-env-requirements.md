---
title: Hosting build environments
description: This page covers the detailed technical requirements for hosting build environments at each SLSA Build Environment level. The intended audience is build platform implementers, compute infrastructure providers and security engineers.
---

This section of the SLSA Build Environment track specification describes the
detailed conformance requirements for build platforms to achieve the SLSA
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

The following table summarizes the specific supply chain and security
requirements for each role to implement to achieve a desired BuildEnv level.

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
  <td><span id="attest-env-initial-state">**BI.3.1**: Attest to build environment initial state</span>
  <td> <td>✓<td>✓
<tr>
  <td><span id="attest-build-dispatch">**BI.3.2**: Attest to build dispatch</span>
  <td> <td>✓<td>✓
<tr>
  <td><span id="distribute-host-integrity-attesttations">**BI.3.3**: Distribute host integrity attestation</span>
  <td> <td> <td>✓
<tr>
  <td><span id="interface-trusted-hardware">**BI.3.4**: Interface with trusted hardware</span>
  <td> <td> <td>✓
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
  <td><span id="verify-env-initial-state">**BP.3.2**: Verify build environment initial state</span>
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

[Build Environment levels]: attested-build-env-levels.md
[build environment]: terminology.md#build-environment
[build platform]: terminology.md#platform
[compute platform]: terminology.md#compute-platform
