---
title: Dependency Track
description: This page describes the SLSA Dependeny track, which enablse a software producer to measure, control, and reduce risk introduced from third party dependencies.
---

# Basics

## Objective

Enable a software producer to measure, control, and reduce risk introduced from third party dependencies.

## Audience

The Dependency Track is primarily aimed at enterprises/organizations, with medium to large-sized organizations benefiting the most from adoption of the dependency track levels. Organizations include enterprises, but also large open source projects that want to manage third party dependency risk.

## Scope

The scope of the SLSA Dependency Track is to properly manage and securely consume build dependencies into the developer workflow to mitigate against supply chain threats targeting the open source ecosystem.

---

## Definitions

| Primary Term | Description
|---|---
| Build dependencies | Software artifacts fetched or otherwise made available to the build environment during the build of the artifact. This includes open and closed source binary dependencies.
| Package registry | An entity responsible for mapping package names to artifacts within a packaging ecosystem. Most ecosystems support multiple registries, usually a single global registry and multiple private registries.
| Artifact repository manager | A storage solution that manages your artifact lifecycle and supports different software package management systems while providing consistency to your CI/CD workflow
| Dependency security metadata feed | A metadata feed that provides security or risk information about each dependency to assist consumers in making judgements about the safety of their dependencies
| Package source files | A language-specific config file in a source code repo that identifies the package registry feeds or artifact repository manager feeds to consume dependencies from

---

## Onboarding

When onboarding your development environment to the SLSA Dependency Track, organizations are making claims about how dependencies are managed and consumed from that artifact version forward. This establishes continuity.

No claims are made for prior artifact versions.

## Levels

| Level | Requirements
| --- | ---
| Dependency L0 | (none)
| Dependency L1 | Inventory of dependencies exists
| Dependency L2 | Known vulnerabilities have been triaged
| Dependency L3 | Dependencies consumed from sources under producer's control
| Dependency L4 | Proactive defence against upstream attacks

---

## Level 0: No mitigations to dependency threats
  
**Summary**
L0 represents the lack of SLSA.

**Threats**
N/A

**Outcome**
N/A


## Level 1: Inventory of dependencies exists
   
**Summary**
Maintain an inventory of all build dependencies for a released artifact.

**Threat:**

Inability to respond to incidents or remediate vulnerabilities.

**Outcome:**

All third party build dependencies (including transitive) are identified.

-   A comprehensive picture of all third party dependencies enables understanding of the risk exposure
-   An inventory is a prerequisite to identify and manage known vulnerabilities
-   Implementing a centralized inventorycan enable efficient incident response and risk exposure measurement.


## Level 2: Known vulnerabilities have been triaged
   
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


## Level 3: Dependencies consumed from sources under producer's control
 
**Summary:**

All third-party build dependencies are consumed from sources under the producer’s control

**Threat:**

Availability risks of upstream sources being removed or taken down (e.g. left-pad incident). 

**Outcome:**

The build process consumes all third party build dependencies only from artifact producer-controlled sources, allowing for control of how dependencies enter the supply chain, reducing the attackable surface. 


## Level 4: Proactive defence against upstream attack
  
**Summary:**

Artifact producer is able to enforce a secure ingestion policy over third-party build dependencies in order to prevent the consumption of compromised upstream artifacts.

**Threat**

Malicious attacks on upstream sources such as package managers, compromised packages, and dependency confusion.

**Outcome**

Reduced likelihood of a released artifact including a malicious or compromised third-party dependency.

**Note:**

This capability builds on Level 3.
**Compliance options:**

-   Use of artifact management solutions to internally mirror third party dependencies in packaged form.
-   Source code vendoring, e.g. by mirroring a copy of the upstream code in a local VCS or using ecosystems tools like `go mod vendor` or `cargo vendor`.
-   Republishing third-party Docker base image under producer’s project.

**NOTES / Discussion:**

-   Build step must enforce use of systems under producer’s control.
-   Compliance with this level enables the ability to achieve Level 4 compliance.

**Benefits:**
All of Dependency L2, plus:

-   Enables developers to continue to build even if upstream resources are unavailable
-   Establishes a standardized consumption method to control how dependencies are consumed, thereby reducing your attackable surface

**Threats mitigated at this level:**

-   Availability risks of upstream sources being removed or taken down (e.g. left-pad incident).

---

## Level 4: Proactive defence against prevailing supply chain threats

**Outcome:**  
Software producer enforces the following minimum secure ingestion policy over third-party build dependencies in order to prevent the consumption of compromised upstream artifacts:

-   All versions of build dependencies must be at least 72 hours old, with exemption for versions that address known vulnerabilities.
-   All private producer-owned build dependencies are acquired from internal sources.
-   Build dependencies must not contain any known malicious packages, or unwanted functionality (e.g. bitcoin miners).

**Intended for:**
Consumers of third party dependencies, including open source, and third party binaries wanting to mitigate against the most prevalent supply chain threats targeting the open source ecosystem.

**Compliance options:**

-   Managed ingestion of artifacts into producer’s systems is one place to enforce the above requirements, e.g.:
    -   By only ingesting packages that were released 72 hours ago.
    -   By checking all packages and versions against known malicious packages databases (e.g. OpenSSF Malicious Packages).
-   Many artifact management solutions support virtual repositories that enable mitigation of dependency confusion.
-   Leverage dependency security metadata feeds to inform policy decisions on dependencies you consume.

**NOTES / Discussion:**

-   This capability builds on Level 3.

**Benefits:**
All of Dependency L3, plus:

-   Policy enforcement systems are integrated into the standardized consumption method to check dependencies for issues before the dependency is downloaded.
-   Reduces risk of initial compromise from supply chain threats, preventing costs incurred from responding to an incident.

**Threats mitigated at this level:**

-   A malicious actor compromises a known good dependency to add malicious functionality in a newly published version of that dependency (e.g. ESLint incident)
-   A dependency adds a new transitive dependency that is malicious (e.g. Event-Stream incident)
-   Typosquatting
-   Dependency Confusion
-   Intentional vulnerabilities/backdoors/protestware added to a code base (e.g. Colors v1.4.1 incident, node-ipc incident)

---

## Requirements

| Requirement | Description | L1 | L2 | L3 | L4
| --- | --- | --- | --- | --- | ---
| Maintain a complete inventory of all dependencies used in development | An organization producing artifacts MUST implement tooling that inventories dependencies for every version they release | ✓ | ✓ | ✓ | ✓
| Scan dependencies for known vulnerabilities | An organization MUST proactively identify 3rd party dependency in their build that have known vulnerabilities |  | ✓ | ✓ | ✓
| Triage all vulnerable dependencies before release | An organization MUST triage all known vulnerabilities and either remediate the vulnerability, or not remediate in the given release. For example, an organization may make the decision for unremediated vulnerabilities to be recorded in a VEX attestation due to not being exploitable in the manner the dependency was integrated into their artifact |  | ✓ | ✓ | ✓
| The build process consumes all third party build dependencies only from producer-controlled sources | An organization MUST consume dependencies through producer-controlled sources, such as an artifact repository manager for packaged dependencies (e.g. NuGet, npm, pypi, maven, crates, rubygems), and vendored source code mirrored from upstream open source repos into repos under producer's control (e.g. C/C++, golang) |  |  | ✓ | ✓
| Build dependencies meet minimum security requirements | An organization MUST consume dependencies that have been determined to have acceptable risk.  For example, an organization may implement a malware scanning solution to determine if a dependency is safe, or implement a quantine period before consumption of newest versions are allowed, or leverage a dependency security metadata feed to inform policy decisions.   |  |  |  | ✓

---

## Future Considerations

-   Ability to apply private patches in response to zero-day vulnerabilities
-   All dependencies are verifiably built by a trusted builder
-   Ability to detect and address dependencies that are End of Life (EOL)
