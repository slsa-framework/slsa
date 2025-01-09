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
  <th>Degree
  <th>L1<th>L2<th>L3
<tr>
  <td rowspan=4><span id="build-image-producer">Build Image Producer (BI)</span>
  <td colspan=2><span id="distribute-image-provenance">**BI.1**: Distribute build image provenance</span>
  <td>✓<td>✓<td>✓
<tr>
  <td colspan=2><span id="distribute-image-ref-values">**BI.2**: Distribute reference values for build image components</span>
  <td> <td>✓<td>✓
<tr>
  <td rowspan=2><span id="enlightened-build-agent">**BI.3**: Implement enlightened build agent</span>
  <td><span id="build-env-boot-quote">**BI.3.1**: Provide build environment boot process quote</a>
  <td> <td>✓<td>✓
  <tr>
  <td><span id="distribute-build-id-quote">**BI.3.2**: Attest to build dispatch</a>
  <td> <td>✓<td>✓
</table>

[Build Environment levels]: attested-build-env-levels.md
[build environment]: terminology.md#build-environment
[build platform]: terminology.md#platform
[compute platform]: terminology.md#compute-platform
