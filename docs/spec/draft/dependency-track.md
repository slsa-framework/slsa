---
title: Dependency Track
description: This page describes the SLSA Dependency track, which enables a software producer to measure, control, and reduce risk introduced from third party dependencies.
---

# {Dependency Track: Consuming Dependencies}

**About this page:** the Build Track Basics page describes the SLSA Dependency track, which enables a software producer to measure, control, and reduce risk introduced from third party dependencies.

**Intended audience:** {TBD}.

**Topics covered:** terminology, dependency track level summary, dependency track requirements

**Internet standards:** [RFC 2119](https://www.rfc-editor.org/rfc/rfc2119), [CIS Critical Security Controls](https://www.cisecurity.org/controls/cis-controls-list)

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD",
"SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be
interpreted as described in [RFC 2119](https://www.rfc-editor.org/rfc/rfc2119).

**For more information, see:** [General SLSA terminology](terminology.md), [Build track specific terminology](build-track-basics.md#terminology).

## Overview



This page describes the SLSA Dependency track, which enables a software producer to measure, control, and reduce risk introduced from third party dependencies.

## Overview

The Dependency track is designed to enable a software producer to measure, control, and reduce risk introduced from third party dependencies. It is primarily aimed at enterprises/organizations, with medium to large-sized organizations benefiting the most from adoption of the dependency track levels. Organizations include enterprises, but also large open source projects that want to manage third party dependency risk.

The scope of the SLSA Dependency Track is to properly manage and securely consume build dependencies into the developer workflow to mitigate against supply chain threats targeting the open source ecosystem.

## Terminology

{Introduction?}

| Term | Description |
| --- | --- |
| Artifact repository manager | A storage solution that manages your artifact lifecycle and supports different software package management systems while providing consistency to your CI/CD workflow. |
| Build dependencies | Software artifacts fetched or otherwise made available to the build environment during the build of the artifact. This includes open and closed source binary dependencies. |
| Dependency security metadata feed | A metadata feed that provides security or risk information about each dependency to assist consumers in making judgements about the safety of their dependencies. |
| Package registry | An entity responsible for mapping package names to artifacts within a packaging ecosystem. Most ecosystems support multiple registries, usually a single global registry and multiple private registries. |
| Package source files | A language-specific config file in a source code repo that identifies the package registry feeds or artifact repository manager feeds to consume dependencies from. |

---

## Dependency Track Level Summary

| Level | Requirements
| --- | ---
| Dependency L0 | (none)
| Dependency L1 | Inventory of dependencies exists
| Dependency L2 | Known vulnerabilities have been triaged
| Dependency L3 | Dependencies consumed from sources under producer's control
| Dependency L4 | Proactive defence against upstream attacks

### Dependency Track Level Specifics

#### Level 0: No mitigations to dependency threats
  
**Summary:**

L0 represents the lack of any SLSA dependency track claims.

**Threats:**

N/A

**Outcome:**

N/A

#### Level 1: Inventory of dependencies exists

**Summary:**

An inventory of all build dependencies within the artifact exists.

**Threat:**

Inability to respond to incidents or remediate vulnerabilities.

**Outcome:**

All third party build dependencies (including transitive) are identified.

-   A comprehensive picture of all third party dependencies enables understanding of the risk exposure.
-   An inventory is a prerequisite to identify and manage known vulnerabilities.
-   Implementing a centralized inventory can enable efficient incident response and risk exposure measurement.

#### Level 2: Known vulnerabilities have been triaged

**Summary:**

All known vulnerabilities in the artifact have been triaged.

**Threat:**

Introducing vulnerable dependencies into artifact.

**Outcome:**

Artifacts are released with no unknown 'known' vulnerabilities. Outcomes of the triage could result in the decision to:

-   Remediate vulnerabilities, prior to release
-   Proceed with the release and remediate vulnerabilities in the next release, following normal release cycle
-   Proceed with the release and remediate vulnerabilities by expediting the next patch release.

**Note:**

-   Does NOT mean the artifact is free of vulnerabilities, but at the time of release all known vulnerabilities are triaged.
-   Race condition: new vulnerability can, theoretically, be published on the same day as the release.

#### Level 3: Dependencies consumed from locations under producer's control

**Summary:**

All third-party build dependencies are consumed from locations under the producer’s control.

**Threat:**

Availability risks of upstream sources being removed or taken down (e.g. left-pad incident).

**Outcome:**

The build process consumes all third party build dependencies only from artifact producer-controlled locations, allowing for control of how dependencies enter the supply chain, reducing the attackable surface.  This also enables developers to continue to build even if upstream resources are unavailable.

**Note:**

Compliance with this level enables the ability to achieve Level 4 compliance.

#### Level 4: Proactive defence against upstream attack
  
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

**Note:**

This capability builds on Level 3.

## Dependency Track Requirements

| Requirement | Description | Example | L1 | L2 | L3 | L4
| --- | --- | --- | --- | --- | --- | ---
| Inventory of dependencies exists | An organization producing artifacts MUST implement tooling that inventories dependencies for every version they release | Build-time SBOM generated by the build tool, capturing direct and transitive dependencies for the artifact being released. For language ecosystem dependencies, dependency pinning can serve as a starting point for many ecosystems as it provides identification for all transitive dependencies (e.g. `package-lock.json`, `pip –require-hashes`, `go.sum`, Gradle lock). Software Composition Analysis (SCA) tools can serve as another starting point to produce an SBOM, capturing an artifact’s dependencies Metadata associated with vendored source code, identifying the dependency (e.g. by specifying CPE or ecosystem, name and version or a package URL) | ✓ | ✓ | ✓ | ✓
| Scan dependencies for known vulnerabilities | An organization MUST proactively identify 3rd party dependency in their build that have known vulnerabilities | Leverage SBOMs or SCA tools to scan for CVEs in public vulnerability databases - e.g, NVD. | | ✓ | ✓ | ✓
| Triage all vulnerable dependencies before release | An organization MUST triage all known vulnerabilities and either remediate the vulnerability, or not remediate in the given release. For example, an organization may make the decision for unremediated vulnerabilities to be recorded in a VEX attestation due to not being exploitable in the manner the dependency was integrated into their artifact | Third party build dependencies of the artifact being released as represented by an SBOM, lockfile, metadata files or other means are scanned for known vulnerabilities. Reported vulnerabilities are triaged and either remediated or not remediated in the given release. Triage decisions for unremediated vulnerabilities can be recorded in a VEX attestation for internal policy enforcement (i.e. VEX is not required to be published to comply with this level).Regular updates outside of the artifact release cycle driven by new dependency releases or discovery of new known vulnerabilities using freely available tools like Dependabot/Renovatebot/OSV-Scanner can simplify the compliance process. | | ✓ | ✓ | ✓
| The build process consumes all third party build dependencies only from producer-controlled locations | An organization MUST consume dependencies through an artifact producer-controlled location, instead of directly from upstream. | Use of artifact management solutions to internally mirror third party dependencies in packaged form. Source code vendoring, e.g. by mirroring a copy of the upstream code in a local VCS or using ecosystems tools like `go mod vendor` or `cargo vendor`. Republishing third-party Docker base image under producer’s project. | | | ✓ | ✓
| Enforce secure ingestion policy | An organization MUST consume dependencies that have been determined to have acceptable risk. For example, an organization may implement a malware scanning solution to determine if a dependency is safe, or implement a quantine period before consumption of newest versions are allowed, or leverage a dependency security metadata feed to inform policy decisions. | -   Managed ingestion of artifacts into producer’s systems is one place to enforce the above requirements, e.g.: By only ingesting packages that were released 72 hours ago, by checking all packages and versions against known malicious packages databases (e.g. OpenSSF Malicious Packages). Many artifact management solutions support virtual repositories that enable mitigation of dependency confusion. Leverage dependency security metadata feeds to inform policy decisions on dependencies you consume. | | | | ✓

---

## Future Considerations

-   Ability to apply private patches in response to zero-day vulnerabilities
-   All dependencies are verifiably built by a trusted builder
-   Ability to detect and address dependencies that are End of Life (EOL)
