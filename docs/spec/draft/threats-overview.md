---
title: Supply chain threats 
description: Attacks can occur at every link in a typical software supply chain, and these kinds of attacks are increasingly public, disruptive, and costly in today's environment. This page is an introduction to possible attacks throughout the supply chain and how SLSA could help. 
---

SLSA defines *software manufacturing models* that fight supply chain *attacks*. These threats can occur at any link in a software supply chain and are becoming increasingly public, disruptive, and costly in today's environment.

This page introduces two key SLSA software models: [framework system models](threats-overview.md#SLSA-framework-system-models) and [supply chain threat model](threats-overview.md#supply-chain-threat-model). It also shows how they can help mitigate possible attacks throughout the supply chain. For a more technical discussion of SLSA's threat methodology, see [Threats & mitigation solutions](threats.md).  

<!-- Filename will change to "Threats & mitigation solutions" -->

# SLSA software model concepts 

## SLSA framework system models

SLSA uses the following software manufacturing *models* that are based on real-world supply chain systems to define their framework criteria.

1. [Build model](threats-overview#Build-model) - defines the production of software artifacts
2. [Distribution model](threats-overview#distribution-model) - generates artifact provenence
3. [Verification model](threats-overview#verification-model) - authenticates artifact provenence

### Build model

When SLSA's build model defines the production process of software artifacts, the build runs on a multi-tenant *build platform*, where each execution is independent. 

The diagram below shows the build model workflow.

<p align="center"><img src="images/build-model.svg" alt="Model Build"></p>

#### Workflow steps

1.  A tenant invokes the build by specifying *external parameters* through an
    *interface*, either directly or via a trigger. Typically, at least one of
    these external parameters is a reference to a *dependency*. External
    parameters are literal values while dependencies are artifacts.
2.  The build platform's *control plane* interprets these external parameters,
    fetches an initial set of dependencies, initializes a *build environment*,
    and then starts the execution within that environment.
3.  The build then performs arbitrary steps (which might include fetching
    additional dependencies) and produces one or more *output* artifacts.
    Because the steps within the build environment are under the tenant's control, 
    the build platform isolates build environments from each other in accordance with the SLSA Build Level.
4.  Finally, for SLSA Build L2+, the control plane outputs *provenance* information,
    describing the whole process.

**Note:** there is no formal definition of "source" in the build model, just external
parameters and dependencies. Most build platforms have an explicit "source"
artifact to fetch, which is often a Git repository. The
reference to the artifact is an external parameter, but the artifact itself is
a dependency.

For examples of how this model applies to real-world build platforms, see [Provenence](provenance.md). 

<!-- Is this link correct? Or is it real-world-examples.md -->

### Distribution model

SLSA's distribution model generates artifact provenence to guarantee the integrity of the distribution of software <dfn>packages</dfn>, once they are manufactured. These packages are created according to the rules and conventions of standard <dfn>package ecosystems</dfn>.
Examples of formal ecosystems include [Python/PyPA](https://www.pypa.io),
[Debian/Apt](https://wiki.debian.org/DebianRepository/Format), and
[OCI](https://github.com/opencontainers/distribution-spec), while examples of
informal ecosystems include links to files on a website or distribution of
first-party software within a company.

As an example, a consumer locates software within an ecosystem by asking a
<dfn>distribution platform</dfn>, such as a package registry, to resolve a
mutable <dfn>package name</dfn> into an immutable <dfn>package artifact</dfn>.
[^label] To <dfn>publish</dfn> a package artifact, the software producer asks
the registry to update a mapping to resolve to the new artifact. The registry
represents the entity or entities with the power to alter what artifacts are
accepted by consumers for a given package name. For example, if consumers only
accept packages signed by a particular public key, then the access to the
public key serves as the registry.

The package name is the primary security boundary within a package ecosystem.
Different package names represent separate pieces of
software, such as different owners, behaviors, security properties, and so on.
As a result, *the package name is the primary unit being protected in SLSA*.
It is the primary identifier to which consumers attach expectations.

[^label]: This resolution might include a version number, label, or some other
    selector in addition to the package name, but that is not important to SLSA.
    
### Verification model

SLSA verifies artifact provenence in two ways:

- **Build platform certification** ensures conformance to the level requirements specified by
the build platform. This certification should happen on a recurring cadence, with
the outcomes published by the platform operator for their users to review and
make informed decisions about which builders to trust.
- **Artifact verification** ensures that artifacts meet the producer-defined
expectations of where the package source code was retrieved and on what
build platform the package was built.

The diagram below shows how SLSA verifies artifact provenence.

![Verification Model](images/verification-model.svg)

#### Diagram terminology

| Term | Description
| ---- | ----
| Expectations | A set of constraints on the package's provenance metadata. The package producer sets expectations for a package, either explicitly or implicitly.
| Provenance verification | Artifacts are verified by the package ecosystem to ensure that the package's expectations are met before the package is used.
| Build platform assessment | [Build platforms are assessed](assessing-build-platforms.md) for their ability to meet SLSA requirements at the stated level.

The examples below suggest ways that expectations and verification can be
implemented for different and broadly-defined package ecosystems.

<details><summary>Example: Small software team</summary>

| Term | Example
| ---- | -------
| Expectations | Defined by the producer's security personnel and stored in a database.
| Provenance verification | Performed automatically on cluster nodes before execution by querying the expectations database.
| Build platform assessment | The build platform implementer follows secure design and development best practices, does annual penetration testing exercises, and self-certifies their adherence to SLSA requirements.

</details>

<details><summary>Example: Open source language distribution</summary>

| Term | Example
| ---- | -------
| Expectations | Defined separately for each package and stored in the package registry.
| Provenance verification | The language distribution registry verifies newly uploaded packages meet expectations before publishing them. Further, the package manager client also verifies expectations prior to installing packages.
| Build platform assessment | Performed by the language ecosystem packaging authority.

</details>

## Supply chain threat model

SLSA's framework addresses every step of the software supply chain and the
sequence of steps results in the creation of an artifact. The SLSA specification represents a
supply chain as a [directed acyclic graph](https://en.wikipedia.org/wiki/Directed_acyclic_graph) of sources, builds, dependencies, and
packages. One artifact's supply chain is a combination of its dependencies'
supply chains plus its own sources and builds.

SLSA's primary focus is supply chain integrity, with a secondary focus on
*availability*. Integrity means protection against tampering or unauthorized
modification at any stage of the software lifecycle. Within SLSA, we divide
integrity into *source* integrity vs *build* integrity.

**Source integrity** ensures that the source revision represents the intent of the producer, all expected processes were followed, and that the revision was not modified after being accepted.

**Build integrity** ensures that the package is built from the correct
unmodified sources and dependencies, according to the build recipe defined by the
software producer, and artifacts are not modified as they pass between
development stages.

**Availability** ensures that the package can continue to be built and
maintained in the future, and that all code and change history is available for
investigations and incident response.

The diagram below shows a supply chain sequence and the attack vectors for different types of threats.

![Supply Chain Threats](images/supply-chain-threats.svg)

**Note:** SLSA does not currently address all of the threats presented here. See the section on [Threats & mitigation solutions](threats.md) for more detailed information.



