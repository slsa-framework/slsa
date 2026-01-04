---
title: "Build Track: Basics"
description: This page introduces the SLSA build track part of the supply chain and the levels it uses to create software artifacts and the security requirements you want to achieve.
---

# {Build Track: Basics}

**About this page:** the *Build Track Basics* page introduces the SLSA build track part of the supply chain and the levels it uses to create software artifacts and the security requirements you want to achieve.

**Intended audience:** {everyone}.

**Topics covered:** Build track terminology, concept models, track levels

**Internet standards:** {insert standards that apply}

## Overview

{redo these into a new overview}
{see overview of SLSA track section for lingo defining what each track means, maybe link back to the original tracks.md info}
{more about what a level is}
{more about what a model is}t

- The SLSA build track is organized into a series of levels that provide increasing supply chain security guarantees. 
- This gives you confidence that software hasn’t been tampered with and can be securely traced back to its source.
- The amount of security you want to apply is called a level. The levels go from Level 0 (none) to Level 3 (most). 

## Build Terminology

These terms apply to SLSA Build track. See the general terminology [list](terms-generic.md) for terms used throughout the SLSA specification.

| Term | Definition |
| --- | --- |
| Admin | A privileged user with administrative access to the platform, potentially allowing them to tamper with builds or the control plane. |
| Build | Process that converts input sources and dependencies into output artifacts, defined by the tenant and executed within a single build environment on a platform. |
| Build caches | An intermediate artifact storage managed by the platform that maps intermediate artifacts to their explicit inputs. A build may share build caches with any subsequent build running on the platform. |
| <span id="build-environment">Build environment</span> | The independent execution context in which the build runs, initialized by the control plane. In the case of a distributed build, this is the collection of all such machines/containers/VMs that run steps.  |
| <span id="control-plane">Control plane</span> | Build platform component that orchestrates each independent build execution and produces provenance. The control plane is managed by an admin and trusted to be outside the tenant's control. |
| Dependencies | Artifacts fetched during initialization or execution of the build process, such as configuration files, source artifacts, or build tools. |
| Distribution platform | An entity responsible for mapping package names to immutable package artifacts. |
| Expectations | Defined by the producer's security personnel and stored in a database. |
| External parameters | The set of top-level, independent inputs to the build, specified by a tenant and used by the control plane to initialize the build. |
| Outputs | Collection of artifacts produced by the build. |
| Package | An identifiable unit of software intended for distribution, ambiguously meaning either an "artifact" or a "package name". Only use this term when the ambiguity is acceptable or desirable. |
| Package artifact | A file or other immutable object that is intended for distribution. |
| Package ecosystem | A set of rules and conventions governing how packages are distributed, including how clients resolve a package name into one or more specific artifacts. |
| Package manager client | Client-side tooling to interact with a package ecosystem. |
| Package name | <p>The primary identifier for a mutable collection of artifacts that all represent different versions of the same software. This is the primary identifier that consumers use to obtain the software.<p>A package name is specific to an ecosystem + registry, has a maintainer, is more general than a specific hash or version, and has a "correct" source location. A package ecosystem may group package names into some sort of hierarchy, such as the Group ID in Maven, though SLSA does not have a special term for this. |
| Package registry | A specific type of "distribution platform" used within a packaging ecosystem. Most ecosystems support multiple registries, usually a single global registry and multiple private registries. |
| <span id="platform">Platform</span> | System that allows tenants to run builds. Technically, it is the transitive closure of software and services that must be trusted to faithfully execute the build. It includes software, hardware, people, and organizations. |
| <span id="provenance">Provenance</span> | Attestation (metadata) describing how the outputs were produced, including identification of the platform and external parameters. |
| Provenance verification | Performed automatically on cluster nodes before execution by querying the expectations database. |
| Publish [a package] | Make an artifact available for use by registering it with the package registry. In technical terms, this means associating an artifact to a package name. This does not necessarily mean making the artifact fully public; an artifact may be published for only a subset of users, such as internal testing or a closed beta. |
| Steps | The set of actions that comprise a build, defined by the tenant. |
| Tenant | An untrusted user that builds an artifact on the platform. The tenant defines the build steps and external parameters. | 

### Build track terms to avoid

These terms can be ambiguous and should be avoided.

| Term | Reason to avoid | 
| --- | --- |
| Build recipe | Could mean external parameters, but may include concrete steps of how to perform a build. To avoid implementation details, we don't define this term, but always use "external parameters" which is the interface to a build platform. Similar terms are build configuration source and build definition. |
| Builder | Usually means build platform, but might be used for build environment, the user who invoked the build, or a build tool from dependencies. To avoid confusion, we always use "build platform". The only exception is in the provenance, where builder is used as a more concise field name. |

## Build track concept models

The SLSA build track uses the following software manufacturing *models* that are based on real-world supply chain systems to define their framework criteria.

### Build production process model

When SLSA's build model defines the production process of software artifacts, the build runs on a multi-tenant *build platform*, where each execution is independent. 

The diagram below shows the build model workflow.

<p align="center"><img src="images/build-model.svg" alt="Model Build"></p>

#### Build workflow steps

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

For examples of how this model applies to real-world build platforms, see [provenance](provenance.md). 

### Distribution of the artifact provenance model

SLSA's distribution model generates artifact provenance to guarantee the integrity of the distribution of software <dfn>packages</dfn>, once they are manufactured. These packages are created according to the rules and conventions of standard <dfn>package ecosystems</dfn>.
Examples of formal ecosystems include [Python/PyPA](https://www.pypa.io),
[Debian/Apt](https://wiki.debian.org/DebianRepository/Format), and
[OCI](https://github.com/opencontainers/distribution-spec), while examples of
informal ecosystems include links to files on a website or distribution of
first-party software within a company.

As an example, a consumer locates software within an ecosystem by asking a
<dfn>distribution platform</dfn>, such as a package registry, to resolve a
mutable <dfn>package name</dfn> into an immutable <dfn>package artifact</dfn>.

To <dfn>publish</dfn> a package artifact, the software producer asks
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

**Note:** This resolution might include a version number, label, or some other
    selector in addition to the package name, but that is not important to SLSA.
    
### Verification of the artifact provenance model

SLSA verifies artifact provenance in two ways:

- **Build platform certification** ensures conformance to the level requirements specified by
the build platform. This certification should happen on a recurring cadence, with
the outcomes published by the platform operator for their users to review and
make informed decisions about which builders to trust.
- **Artifact verification** ensures that artifacts meet the producer-defined
expectations of where the package source code was retrieved and on what
build platform the package was built.

The diagram below shows how SLSA verifies artifact provenance.

![Verification Model](images/verification-model.svg)

#### Verification diagram terminology

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

## Build Track Levels

Provenance describes how the artifact was created. Levels define the type of provenance. Each type gives you a different kind of security, with the zero being the lowest level and 3 providing the most security. 

| Track/Level | Requirements | Focus
| ----------- | ------------ | -----
| [Build L0] | (none) | (n/a)
| [Build L1] | Provenance showing how the package was built | Mistakes, documentation
| [Build L2] | Signed provenance, generated by a hosted build platform | Tampering after the build
| [Build L3] | Hardened build platform | Tampering during the build

<!-- For comparison: a future Build L4's focus might be reproducibility or
hermeticity or completeness of provenance -->

> Note: The [previous version] of the specification used a single unnamed track,
> SLSA 1–4. For version 1.0, the Source aspects were removed to focus on the
> Build track. In 1.2 the [Source Track](tracks#source-track) reintroduces
> coverage of source code.

<section id="build-l0">

### Build L0: No guarantees

<dl class="as-table">
<dt>Summary<dd>

No requirements---L0 represents the lack of SLSA.

<dt>Intended for<dd>

Development or test builds of software that are built and run on the same
machine, such as unit tests.

<dt>Requirements<dd>

n/a

<dt>Benefits<dd>

n/a

</dl>
</section>
<section id="build-l1">

### Build L1: Provenance exists

<dl class="as-table">
<dt>Summary<dd>

Package has provenance showing how it was built. Can be used to prevent mistakes
but is trivial to bypass or forge.

<dt>Intended for<dd>

Projects and organizations wanting to easily and quickly gain some benefits of
SLSA---other than tamper protection---without changing their build workflows.

<dt>Requirements<dd>

-   Software Producer:
    -   Follow a consistent build process so that others can form
        expectations about what a "correct" build looks like.
    -   Run builds on a build platform that meets Build L1 requirements.
    -   Distribute provenance to consumers, preferably using a convention
        determined by the package ecosystem.
-   Build platform:
    -   Automatically generate [provenance] describing how the artifact was
        built, including: what entity built the package, what build process
        they used, and what the top-level input to the build were.

<dt>Benefits<dd>

-   Makes it easier for both producers and consumers to debug, patch, rebuild,
    and/or analyze the software by knowing its precise source version and build
    process.

-   With [verification], prevents mistakes during the release process, such as
    building from a commit that is not present in the upstream repo.

-   Aids organizations in creating an inventory of software and build platforms
    used across a variety of teams.

<dt>Notes<dd>

-   Provenance may be incomplete and/or unsigned at L1. Higher levels require
    more complete and trustworthy provenance.

</dl>

</section>
<section id="build-l2">

### Build L2: Hosted build platform

<dl class="as-table">
<dt>Summary<dd>

Forging the provenance or evading verification requires an explicit "attack",
though this may be easy to perform. Deters unsophisticated adversaries or those
who face legal or financial risk.

In practice, this means that builds run on a hosted platform that generates and
signs[^sign] the provenance.

<dt>Intended for<dd>

Projects and organizations wanting to gain moderate security benefits of SLSA by
switching to a hosted build platform, while waiting for changes to the build
platform itself required by [Build L3].

<dt>Requirements<dd>

All of [Build L1], plus:

-   Software producer:
    -   Run builds on a [hosted] build platform that meets Build L2
        requirements.
-   Build platform:
    -   Generate and sign[^sign] the provenance itself. This may be done
        during the original build, an after-the-fact reproducible build, or
        some equivalent system that ensures the trustworthiness of the
        provenance.
-   Consumer:
    -   Validate the authenticity of the provenance.

<dt>Benefits<dd>

All of [Build L1], plus:

-   Prevents tampering after the build through digital signatures[^sign].

-   Deters adversaries who face legal or financial risk by evading security
    controls, such as employees who face risk of getting fired.

-   Reduces attack surface by limiting builds to specific build platforms that
    can be audited and hardened.

-   Allows large-scale migration of teams to supported build platforms early
    while further hardening work ([Build L3]) is done in parallel.

</dl>
</section>
<section id="build-l3">

[^sign]: Alternate means of verifying the authenticity of the provenance are
    also acceptable.

### Build L3: Hardened builds

<dl class="as-table">
<dt>Summary<dd>

Forging the provenance or evading verification requires exploiting a
vulnerability that is beyond the capabilities of most adversaries.

In practice, this means that builds run on a hardened build platform that offers
strong tamper protection.

<dt>Intended for<dd>

Most software releases. Build L3 usually requires significant changes to
existing build platforms.

<dt>Requirements<dd>

All of [Build L2], plus:

-   Software producer:
    -   Run builds on a hosted build platform that meets Build L3
        requirements.
-   Build platform:
    -   Implement strong controls to:
        -   prevent runs from influencing one another, even within the same
            project.
        -   prevent secret material used to sign the provenance from being
            accessible to the user-defined build steps.

<dt>Benefits<dd>

All of [Build L2], plus:

-   Prevents tampering during the build---by insider threats, compromised
    credentials, or other tenants.

-   Greatly reduces the impact of compromised package upload credentials by
    requiring the attacker to perform a difficult exploit of the build process.

-   Provides strong confidence that the package was built from the official
    source and build process.

</dl>
</section>

<!-- Link definitions -->

[build l0]: #build-l0
[build l1]: #build-l1
[build l2]: #build-l2
[build l3]: #build-l3
[future versions]: future-directions.md
[hosted]: build-requirements.md#isolation-strength
[previous version]: ../v0.1/levels.md
[provenance]: terminology.md
[verification]: verifying-artifacts.md
