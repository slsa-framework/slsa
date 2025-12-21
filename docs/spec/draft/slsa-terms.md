---
title: SLSA terminology
description: The following terminology is used in the SLSA specification.
---

## SLSA specification terminology

The following terms and descriptions will be used throughout the SLSA specification to provide consistency and clarify meanings. Examples will be provided when relevant. Terms that only apply to specific tracks will be noted. 
| Term | Description | Example | Track |
| ---  | ---         | ---   | ---     |
| Admin | A privileged user with administrative access to the platform, potentially allowing them to tamper with builds or the control plane. | | |
| Artifact | An immutable blob of data; primarily refers to software, but SLSA can be used for any artifact. | A file, a git commit, a directory of files (serialized in some way), a container image, a firmware image. | Build |
| Attestation | An authenticated statement (metadata) about a software artifact or collection of software artifacts. | A signed [SLSA Provenance] file. | Build |
| Build | Process that transforms a set of input artifacts into a set of output artifacts. The inputs may be sources, dependencies, or ephemeral build outputs. | .travis.yml (process) run by Travis CI (platform). | Build |
| Build caches | An intermediate artifact storage managed by the platform that maps intermediate artifacts to their explicit inputs. A build may share build caches with any subsequent build running on the platform. | | |
| Build environment| The independent execution context in which the build runs, initialized by the control plane. In the case of a distributed build, this is the collection of all such machines/containers/VMs that run steps. | | |
| Consumer (Role) | A party who uses software provided by a producer. The consumer may verify provenance for software they consume or delegate that responsibility to a separate verifier. | A developer who uses open source software distributions. A business that uses a point of sale system. | Build |
| Control plane | Build platform component that orchestrates each independent build execution and produces provenance. The control plane is managed by an admin and trusted to be outside the tenant's control. | | |
| Dependency | Artifact that is an input to a build process but that is not a source. In the model, it is always a package. | Alpine package (package) distributed on Alpine Linux (platform). | Build |
| Dependencies | Artifacts fetched during initialization or execution of the build process, such as configuration files, source artifacts, or build tools. | | |
| Distribution | The channel through which artifacts are "published" for use by others. | A registry like DockerHub or npm. Artifacts may also be distributed via physical media (e.g., a USB drive). | Build |
| Distribution platform | An entity responsible for mapping package names to immutable package artifacts. | | |
| External parameters | The set of top-level, independent inputs to the build, specified by a tenant and used by the control plane to initialize the build. | | |
| Infrastructure provider (Role) | A party who provides software or services to other roles. | A package registry's maintainers. A build platform's maintainers. | Build |
| Outputs | Collection of artifacts produced by the build. | | |
| Package | Artifact that is distributed. In the model, it is always the output of a build process, though that build process can be a no-op. | Docker image (package) distributed on DockerHub (distribution). A ZIP file containing source code is a package, not a source, because it is built from some other source, such as a git commit. | Build |
| Package artifact | A file or other immutable object that is intended for distribution. | | |
| Package ecosystem | A set of rules and conventions governing how packages are distributed, including how clients resolve a package name into one or more specific artifacts. | | |
| Package manager client | Client-side tooling to interact with a package ecosystem. | | |
| Package name | <p>The primary identifier for a mutable collection of artifacts that all represent different versions of the same software. This is the primary identifier that consumers use to obtain the software.<p>A package name is specific to an ecosystem + registry, has a maintainer, is more general than a specific hash or version, and has a "correct" source location. A package ecosystem may group package names into some sort of hierarchy, such as the Group ID in Maven, though SLSA does not have a special term for this. | | |
| Package registry | A specific type of "distribution platform" used within a packaging ecosystem. Most ecosystems support multiple registries, usually a single global registry and multiple private registries. | | |
| Platform | System that allows tenants to run builds. Technically, it is the transitive closure of software and services that must be trusted to faithfully execute the build. It includes software, hardware, people, and organizations. |  |  |
| Producer (Role) | A party who creates software and provides it to others. Producers are often also consumers. | An open source project's maintainers. A software vendor. | Build |
| Provenance | Attestation (metadata) describing how the outputs were produced, including identification of the platform and external parameters. | | |
| Publish (a package) | Make an artifact available for use by registering it with the package registry. In technical terms, this means associating an artifact to a package name. This does not necessarily mean making the artifact fully public; an artifact may be published for only a subset of users, such as internal testing or a closed beta. | | |
| Source | Artifact that was directly authored or reviewed by persons, without modification. It is the beginning of the supply chain; we do not trace the provenance back any further. | Git commit (source) hosted on GitHub (platform). | Build |
| Steps | The set of actions that comprise a build, defined by the tenant. | | |
| Tenant | An untrusted user that builds an artifact on the platform. The tenant defines the build steps and external parameters. | | |
| Verifier (Role) | A party who inspect an artifact's provenance to determine the artifact's authenticity. | A business's software ingestion system. A programming language ecosystem's package registry. | Build |

## Terms to avoid

These terms can be ambiguous and should be avoided.

| Term | Reason to avoid | 
| ---  | ---         | 
| Package repository |Could mean either package registry or package name, depending on the ecosystem. To avoid confusion, we always use "repository" exclusively to mean "source repository", where there is no ambiguity. |
| Package manager (without "client") | Could mean either package ecosystem, package registry, or client-side tooling. |
| Avoid using terms such as "developer," "maintainer," "producer," "author," and "publisher" interchangeably. | Whenever possible, default to "producer," in line with the model of producer -> consumer -> infrastructure provider. "Maintainer" is reserved for sections specifying the act of continuing to maintain a project after its creation, or when used in a less technical context where it is unlikely to cause confusion. "Author" is reserved for the act of making source code commits or reviews. "Individual" is used when the context's focus is specifying a single person (i.e., "an individual's workstation" or "compromised individual"). |
| Avoid using terms such as "platform," "system," and "service" interchangeably. |  Whenever possible, default to "platform." Instead of using "service," a reference to a "hosted platform" should be used. A reference to some specific software or tools internal to a platform can be made with "platform component" unless there is a more appropriate definition to use directly like "control plane." External self-described services and systems can continue to be called by these terms. |



