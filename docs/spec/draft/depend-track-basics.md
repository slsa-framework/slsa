---
title: Dependency Track
description: This page shows how the SLSA Dependency track enables a software producer to measure, control, and reduce risk introduced from third party dependencies.
---

# {Dependency Track: Consuming Dependencies}

**About this page:** the *Dependency Track: Consuming Dependencies* page shows how this track enables a software producer to measure, control, and reduce risk introduced from third party dependencies.

**Intended audience:** {add appropriate audience}

**Topics covered:** dependency track terminology, track level summary

**Internet standards:** [RFC 2119](https://www.rfc-editor.org/rfc/rfc2119), {other standards as required}

>The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD",
"SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be
interpreted as described in [RFC 2119](https://www.rfc-editor.org/rfc/rfc2119).

**For more information, see:** {optional}

## Overview

The Dependency track is primarily aimed at enterprises/organizations, with medium to large-sized organizations benefiting the most from adoption of the dependency track levels. Organizations include enterprises, but also large open source projects that want to manage third party dependency risk.

The scope of the SLSA Dependency Track is to properly manage and securely consume build dependencies into the developer workflow to mitigate against supply chain threats targeting the open source ecosystem.

## Dependency Track Terminology

These terms apply to the Dependency track. See the general terminology [list](terms-generic.md) for terms used throughout the SLSA specification.

| Term | Description |
| --- | --- |
| Artifact repository manager | A storage solution that manages your artifact lifecycle and supports different software package management systems while providing consistency to your CI/CD workflow. |
| Build dependencies | Software artifacts fetched or otherwise made available to the build environment during the build of the artifact. This includes open and closed source binary dependencies. |
| Dependency security metadata feed | A metadata feed that provides security or risk information about each dependency to assist consumers in making judgements about the safety of their dependencies. |
| Package registry | An entity responsible for mapping package names to artifacts within a packaging ecosystem. Most ecosystems support multiple registries, usually a single global registry and multiple private registries. |
| Package source files | A language-specific config file in a source code repo that identifies the package registry feeds or artifact repository manager feeds to consume dependencies from. |

## Dependency Track Level Summary

| Level | Requirements
| --- | ---
| Dependency L0 | (none)
| Dependency L1 | Inventory of dependencies exists
| Dependency L2 | Known vulnerabilities have been triaged
| Dependency L3 | Dependencies consumed from sources under producer's control
| Dependency L4 | Proactive defence against upstream attacks

## Dependency Track Level Specifics

### Level 0: No mitigations to dependency threats
  
**Summary:**

L0 represents the lack of any SLSA dependency track claims.

**Threats:**

N/A

**Outcome:**

N/A

### Level 1: Inventory of dependencies exists

**Summary:**

An inventory of all build dependencies within the artifact exists.

**Threat:**

Inability to respond to incidents or remediate vulnerabilities.

**Outcome:**

All third party build dependencies (including transitive) are identified.

-   A comprehensive picture of all third party dependencies enables understanding of the risk exposure.
-   An inventory is a prerequisite to identify and manage known vulnerabilities.
-   Implementing a centralized inventory can enable efficient incident response and risk exposure measurement.

### Level 2: Known vulnerabilities have been triaged

**Summary:**

All known vulnerabilities in the artifact have been triaged.

**Threat:**

Introducing vulnerable dependencies into artifact.

**Outcome:**

Artifacts are released with no unknown 'known' vulnerabilities. Outcomes of the triage could result in the decision to:

-   Remediate vulnerabilities, prior to release
-   Proceed with the release and remediate vulnerabilities in the next release, following normal release cycle
-   Proceed with the release and remediate vulnerabilities by expediting the next patch release.

**Note:** This does NOT mean the artifact is free of vulnerabilities, but at the time of release all known vulnerabilities are triaged. Also covers race conditions: new vulnerability can, theoretically, be published on the same day as the release.

### Level 3: Dependencies consumed from locations under producer's control

**Summary:**

All third-party build dependencies are consumed from locations under the producer’s control.

**Threat:**

Availability risks of upstream sources being removed or taken down (e.g. left-pad incident).

**Outcome:**

The build process consumes all third party build dependencies only from artifact producer-controlled locations, allowing for control of how dependencies enter the supply chain, reducing the attackable surface.  This also enables developers to continue to build even if upstream resources are unavailable.

**Note:** Compliance with this level enables the ability to achieve Level 4 compliance.

### Level 4: Proactive defence against upstream attack
  
**Summary:**

Artifact producer is able to enforce a secure ingestion policy over third-party build dependencies in order to prevent the consumption of compromised upstream artifacts.

**Threat:**

Malicious attacks on upstream sources such as package managers, compromised packages, and dependency confusion. Attacks include:

-   A dependency adds a new transitive dependency that is malicious (e.g. Event-Stream incident)
-   Typosquatting
-   Dependency Confusion
-   Intentional vulnerabilities/backdoors/protestware added to a code base (e.g. Colors v1.4.1 incident, node-ipc incident)

**Outcome:**

Reduced likelihood of a released artifact including a malicious or compromised third-party dependency.

**Note:** This capability builds upon Level 3.

