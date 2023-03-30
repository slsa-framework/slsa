---
title: Verifying build systems
description: The provenance consumer is responsible for deciding whether they trust a builder to produce SLSA Build L3 provenance. However, assessing Build L3 capabilities requires information about a builder's construction and operating procedures that the consumer cannot glean from the provenance itself. To aid with such assessments, we provide a common threat model and builder model for reasoning about builders' security. We also provide a questionnaire that organizations can use to describe their builders to consumers along with sample answers that do and do not satisfy the SLSA Build L3 requirements.
---

The provenance consumer is responsible for deciding whether they trust a builder
to produce SLSA Build L3 provenance. However, assessing Build L3 capabilities
requires information about a builder's construction and operating procedures
that the consumer cannot glean from the provenance itself. To aid with such
assessments, we provide a common threat model and builder model for reasoning
about builders' security. We also provide a questionnaire that organizations can
use to describe their builders to consumers along with sample answers that do
and do not satisfy the SLSA Build L3 requirements.

## Build Model

Auditors MUST consider at least these five elements of the
[build model](terminology.md#build-model) when assessing build systems for SLSA
conformance: external parameters, platform, environments, caches, and outputs.

![image](/images/build-model.svg)

The following sections detail these elements of the build model and give prompts
for assessing a build system's ability to produce SLSA Build L3 provenance.

### External Parameters

External parameters are the external interface to the builder and include all
inputs to the build process. Examples include the source to be built, the build
definition/script to be executed, user-provided instructions to the platform
for how to create the build environment (e.g. which operating system to use),
and any additional user-provided strings.

#### Prompts for Assessing External Parameters

-   How does the platform process user-provided external parameters? Examples:
    sanitizing, parsing, not at all
-   Which external parameters are processed by the platform and which are
    processed by the environment?
-   What sort of external parameters does the platform accept for environment
    configuration?
-   How do you ensure that all external parameters are represented in the
    provenance?
-   How will you ensure that future design changes will not add additional
    external parameters without representing them in the provenance?

### Platform

The platform is the build system component that orchestrates each independent
build execution. It is responsible for setting up each build and cleaning up
afterwards. At SLSA Build L2+ the platform generates and signs provenance for
each build performed on the build service. The platform is operated by one or
more administrators, who have privileges to modify the platform.

#### Prompts for Assessing Platforms

-   Administration
    -   What are the ways an employee can use privileged access to influence a
        build or provenance generation? Examples: physical access, terminal
        access, access to cryptographic secrets
    -   What controls are in place to detect or prevent the employee from
        abusing such access? Examples: two-person approvals, audit logging,
        workload identities
    -   Roughly how many employees have such access?
    -   How are privileged accounts protected? Examples: two-factor
        authentication, client device security policies
    -   What plans do you have for recovering from security incidents and system
        outages? Are they tested? How frequently?

-   Provenance generation
    -   How does the platform observe the build to ensure the provenance's
        accuracy?
    -   Are there situations in which the platform will not generate provenance
        for a completed build? What are they?

-   Development practices
    -   How do you track the platform's software and configuration? Example:
        version control
    -   How do you build confidence in the platform's software supply chain?
        Example: SLSA L3+ provenance, build from source
    -   How do you secure communications between builder components? Example: TLS
        with certificate transparency.
    -   Are you able to perform forensic analysis on compromised environments?
        How? Example: retain base images indefinitely

-   Creating environments
    -   How does the platform share data with environments? Example: mounting a
        shared file system partition
    -   How does the platform protect its integrity from environments? Example:
        not mount its own file system partitions on environments
    -   How does the platform prevent environments from accessing its
        cryptographic secrets? Examples: dedicated secret storage, not mounting

-   Managing cryptographic secrets
    -   How do you store the platform's cryptographic secrets?
    -   Which parts of the organization have access to the platform's
        cryptographic secrets?
    -   What controls are in place to detect or prevent employees abusing such
        access? Examples: two-person approvals, audit logging
    -   How are secrets protected in memory? Examples: secrets are stored in
        hardware security modules and backed up in secure cold storage
    -   How frequently are cryptographic secrets rotated? Describe the rotation
        process.
    -   What is your plan for remediating cryptographic secret compromise? How
        frequently is this plan tested?

### Environment

The build environment is the independent execution environment where the build
takes place. Each environment must be isolated from the platform and from all
other environments, including environments running builds from the same build
user or project. Build users are free to modify the environment inside the
environment arbitrarily. Build environments must have a means to fetch input
artifacts (source, dependencies, etc).

#### Prompts for Assessing Environments

-   Isolation technologies
    -   How are environments isolated from the platform and each other? Examples:
        VMs, containers, sandboxed processes
    -   How have you hardened your environments against malicious tenants?
        Examples: configuration hardening, limiting attack surface
    -   How frequently do you update your isolation software?
    -   What is your process for responding to vulnerability disclosures? What
        about vulnerabilities in your dependencies?
    -   What prevents a malicious build from gaining persistence and influencing
        subsequent builds?

-   Creation and destruction
    -   What tools and environment are available in environments on creation? How
        were the elements of this environment chosen? Examples: A minimal Linux
        distribution with its package manager, OSX with HomeBrew
    -   How long could a compromised environment remain active in the build
        system?

-   Network access
    -   Are environments able to call out to remote execution? If so, how do you
        prevent them from tampering with the platform or other environments over
        the network?
    -   Are environments able to open services on the network? If so, how do you
        prevent remote interference through these services?

### Cache

Builders may have zero or more caches to store frequently used dependencies.
Build environments may have either read-only or read-write access to caches.

#### Prompts for Assessing Caches

-   What sorts of caches are available to build environments?
-   How are those caches populated?
-   How are cache contents validated before use?

### Output Storage

Output Storage holds built artifacts and their provenance. Storage may either be
shared between build projects or allocated separately per-project.

#### Prompts for Assessing Output Storage

-   How do you prevent builds from reading or overwriting files that belong to
    another build? Example: authorization on storage
-   What processing, if any, does the platform do on output artifacts?

## Builder Evaluation

Organizations can either self-attest to their answers or seek certification from
a third-party auditor. Evidence for self-attestation should be published on
the internet. Evidence submitted for third-party certification need not be
published.
