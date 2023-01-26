---
title: Terminology
---
<div class="subtitle">

Before diving into the [SLSA Levels](levels.md), we need to establish a core set
of terminology and models to describe what we're protecting.

</div>

## TODO: Terms we still need to define

> **TODO:** Define these terms before the v1.0 release.

-   Ecosystem
-   Project
-   Attestation
-   Provenance

## Software supply chain

SLSA's framework addresses every step of the software supply chain - the
sequence of steps resulting in the creation of an artifact. We represent a
supply chain as a [directed acyclic graph] of sources, builds, dependencies, and
packages. One artifact's supply chain is a combination of its dependencies'
supply chains plus its own sources and builds.

[directed acyclic graph]: https://en.wikipedia.org/wiki/Directed_acyclic_graph

**TODO:** update supply chain model to include verification.

![Software Supply Chain Model](../../images/supply-chain-model.svg)

| Term | Description | Example |
| --- | --- | --- |
| Artifact | An immutable blob of data; primarily refers to software, but SLSA can be used for any artifact. | A file, a git commit, a directory of files (serialized in some way), a container image, a firmware image. |
| Source | Artifact that was directly authored or reviewed by persons, without modification. It is the beginning of the supply chain; we do not trace the provenance back any further. | Git commit (source) hosted on GitHub (platform). |
| [Build] | Process that transforms a set of input artifacts into a set of output artifacts. The inputs may be sources, dependencies, or ephemeral build outputs. | .travis.yml (process) run by Travis CI (platform). |
| Package | Artifact that is "published" for use by others. In the model, it is always the output of a build process, though that build process can be a no-op. | Docker image (package) distributed on DockerHub (platform). A ZIP file containing source code is a package, not a source, because it is built from some other source, such as a git commit. |
| Dependency | Artifact that is an input to a build process but that is not a source. In the model, it is always a package. | Alpine package (package) distributed on Alpine Linux (platform). |

[build]: #build-model

### Build model

We model a build as running on a multi-tenant platform, where each execution is
independent. A tenant defines the build, including the input source artifact and
the steps to execute. In response to an external trigger, the platform runs the
build by initializing the environment, fetching the source and possibly some
dependencies, and then starting execution inside the environment. The build then
performs arbitrary steps, possibly fetching additional dependencies, and outputs
one or more artifacts along with provenance metadata for those artifacts.

> **TODO:** move build model into spec versioned folder?
<p align="center"><img src="../../images/build-model.svg" alt="Model Build"></p>

| Term | Description
| --- | ---
| Platform | System that allows tenants to run build. Technically, it is the transitive closure of software and services that must be trusted to faithfully execute the build.
| Service | A platform that is hosted, not a developer's machine. (Term used in [requirements](requirements.md).)
| Build | Process that converts input sources and dependencies into output artifacts, defined by the tenant and executed within a single environment.
| Steps | The set of actions that comprise a build, defined by the tenant.
| Environment | Machine, container, VM, or similar in which the build runs, initialized by the platform. In the case of a distributed build, this is the collection of all such machines/containers/VMs that run steps.
| Trigger | External event or request causing the platform to run the build.
| Source | Top-level input artifact required by the build.
| Dependencies | Additional input artifacts required by the build.
| Outputs | Collection of artifacts produced by the build.
| Admin | Person with administrative access to the platform, potentially allowing them to tamper with the build process or access secret material.

<details><summary>Example: GitHub Actions</summary>

| Term         | Example
| ------------ | -------
| Platform     | [GitHub Actions] + runner + runner's dependent services
| Build        | Workflow or job (either would be OK)
| Steps        | [`steps`]
| Environment  | [`runs-on`]
| Trigger      | [workflow trigger]
| Source       | git commit defining the workflow
| Dependencies | any other artifacts fetched during execution
| Admin        | GitHub personnel

[GitHub Actions]: https://docs.github.com/en/actions
[`runs-on`]: https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#jobsjob_idruns-on
[`steps`]: https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#jobsjob_idsteps
[workflow trigger]: https://docs.github.com/en/actions/using-workflows/triggering-a-workflow

</details>

<details><summary>Example: Distributed Bazel Builds</summary>

Suppose a [Bazel] build runs on GitHub Actions using Bazel's [remote execution]
feature. Some steps (namely `bazel` itself) run on a GitHub Actions runner while
other steps (Bazel actions) run on a remote execution service.

In this case, the build's **environment** is the union of the GitHub Actions
runner environment plus the remote execution environment.

[Bazel]: https://bazel.build
[remote execution]: https://bazel.build/docs/remote-execution

</details>

<details><summary>Example: Local Builds</summary>

The model can still work for the case of a developer building on their local
workstation, though this does not meet SLSA 2+.

| Term         | Example
| ------------ | -------
| Platform     | developer's workstation
| Build        | whatever they ran
| Steps        | whatever they ran
| Environment  | developer's workstation
| Trigger      | commands that the developer ran
| Admin        | developer

</details>

[verification]: #verification-model

### Verification model

Verification in SLSA is performed in two ways. Firstly, the build system is
certified to ensure conformance with the requirements at the level claimed by
the build system. This certification should happen on a recurring cadence with
the outcomes published by the platform operator for their users to review and
make informed decisions about which builders to trust.

Secondly, artifacts are verified to ensure they meet the producer defined
expectations of where the package source code was retrieved from and on what
build system the package was built.

![Verification Model](verification-model.svg)

| Term         | Description |
|--------------|---- |
| Expectations | A set of constraints on the package's provenance metadata. The package producer sets expectations for a package, whether explicitly or implicitly. |
| Provenance verification | Artifacts are verified by the package ecosystem to ensure that the package's expectations are met before the package is used. |
| Build system certification | [Build systems are certified](verifying-systems.md) for their conformance to the SLSA requirements at the stated level. |

The examples below suggest some ways that expectations and verification may be
implemented for different, broadly defined, package ecosystems.

<details><summary>Example: Small software team</summary>

| Term | Example |
| ---- | ------- |
| Expectations | Defined by the producer's security personnel and stored in a database. |
| Provenance verification | Performed automatically on cluster nodes before execution by querying the expectations database. |
| Build system certification | The build system implementer follows secure design and development best practices, does annual penetration testing exercises, and self-certifies their conformance to SLSA requirements. |

</details>

<details><summary>Example: Open source language distribution</summary>

| Term | Example |
| ---- | ------- |
| Expectations | Defined separately for each package and stored in the package registry. |
| Provenance verification | The language distribution registry verifies newly uploaded packages meet expectations before publishing them. Further, the package manager client also verifies expectations prior to installing packages. |
| Build system certification | Performed by the language ecosystem packaging authority. |

</details>
