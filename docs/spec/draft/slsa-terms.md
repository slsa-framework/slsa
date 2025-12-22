---
title: SLSA terminology
description: The following terminology is used in the SLSA specification. 
---

## SLSA specification terminology

The following terms and descriptions will be used throughout the SLSA specification. Examples are provided when relevant. Terms that only apply to specific tracks are be noted. 
| Term | Description | Example | Track |
| ---  | ---         | ---   | ---     |
| Admin | A privileged user with administrative access to the platform, potentially allowing them to tamper with builds or the control plane. | | |
| Artifact | An immutable blob of data; primarily refers to software, but SLSA can be used for any artifact. | A file, a git commit, a directory of files (serialized in some way), a container image, a firmware image. | Build |
| Artifact repository manager | A storage solution that manages your artifact lifecycle and supports different software package management systems while providing consistency to your CI/CD workflow. | | Dependency |
| Attestation | An authenticated statement (metadata) about a software artifact or collection of software artifacts. | A signed [SLSA Provenance] file. | Build |
| <span id="boot-process">Boot process</span> | In the context of builds, the process of loading and executing the layers of firmware and/or software needed to start up a build environment on the host compute platform. |  | Build Environment |
| Build | Process that transforms a set of input artifacts into a set of output artifacts. The inputs may be sources, dependencies, or ephemeral build outputs. | .travis.yml (process) run by Travis CI (platform). | Build |
| <span id="build-agent">Build agent</span> | A build platform-provided program that interfaces with the build platform's control plane from within a running build environment. The build agent is also responsible for executing the tenant’s build definition, i.e., running the build. In practice, the build agent may be loaded into the build environment after instantiation, and may consist of multiple components. All build agent components must be measured along with the build image. | | Build Environment |
| Build caches | An intermediate artifact storage managed by the platform that maps intermediate artifacts to their explicit inputs. A build may share build caches with any subsequent build running on the platform. | | |
| Build dependencies | Software artifacts fetched or otherwise made available to the build environment during the build of the artifact. This includes open and closed source binary dependencies. | | Dependency |
| <span id="build-dispatch">Build dispatch</span> | The process of assigning a tenant's build to a pre-deployed build environment on a hosted build platform. | | Build Environment |
| Build environment| The independent execution context in which the build runs, initialized by the control plane. In the case of a distributed build, this is the collection of all such machines/containers/VMs that run steps. | | |
| <span id="build-id">Build ID</span> | An immutable identifier assigned uniquely to a specific execution of a tenant's build. In practice, the build ID may be an identifier, such as a UUID, associated with the build execution. | | Build Environment |
| <span id="build-image">Build image</span> | The template for a build environment, such as a VM or container image. Individual components of a build image include the root filesystem, pre-installed guest OS and packages, the build executor, and the build agent. | | Build Environment |
| <span id="build-image-producer">Build image producer</span> | The party that creates and distributes build images. In practice, the build image producer may be the hosted build platform or a third party in a bring-your-own (BYO) build image setting. | | Build Environment |
| <span id="compute-platform">Compute platform</span> | The compute system and infrastructure underlying a build platform, i.e., the host system (hypervisor and/or OS) and hardware. In practice, the compute platform and the build platform may be managed by the same or distinct organizations. | | Build Environment |
| Consumer (Role) | A party who uses software provided by a producer. The consumer may verify provenance for software they consume or delegate that responsibility to a separate verifier. | A developer who uses open source software distributions. A business that uses a point of sale system. | Build |
| Control plane | Build platform component that orchestrates each independent build execution and produces provenance. The control plane is managed by an admin and trusted to be outside the tenant's control. | | |
| Dependency | Artifact that is an input to a build process but that is not a source. In the model, it is always a package. | Alpine package (package) distributed on Alpine Linux (platform). | Build |
| Dependency security metadata feed | A metadata feed that provides security or risk information about each dependency to assist consumers in making judgements about the safety of their dependencies. | | Dependency |
| Dependencies | Artifacts fetched during initialization or execution of the build process, such as configuration files, source artifacts, or build tools. | | |
| Distribution | The channel through which artifacts are "published" for use by others. | A registry like DockerHub or npm. Artifacts may also be distributed via physical media (e.g., a USB drive). | Build |
| Distribution platform | An entity responsible for mapping package names to immutable package artifacts. | | |
| External parameters | The set of top-level, independent inputs to the build, specified by a tenant and used by the control plane to initialize the build. | | |
| <span id="host-interface">Host interface</span> | The component in the compute platform that the hosted build platform uses to request resources for deploying new build environments, i.e., the VMM/hypervisor or container orchestrator. | | Build Environment |
| Infrastructure provider (Role) | A party who provides software or services to other roles. | A package registry's maintainers. A build platform's maintainers. | Build |
| Named Reference | A user-friendly name for a specific source revision, such as `main` or `v1.2.3`. | | Source |
| Outputs | Collection of artifacts produced by the build. | | |
| <span id="measurement">Measurement</span> | The cryptographic hash of some component or system state in the build environment, including software binaries, configuration, or initialized run-time data. | | Build Environment |
| Package | Artifact that is distributed. In the model, it is always the output of a build process, though that build process can be a no-op. | Docker image (package) distributed on DockerHub (distribution). A ZIP file containing source code is a package, not a source, because it is built from some other source, such as a git commit. | Build |
| Package artifact | A file or other immutable object that is intended for distribution. | | |
| Package ecosystem | A set of rules and conventions governing how packages are distributed, including how clients resolve a package name into one or more specific artifacts. | | |
| Package manager client | Client-side tooling to interact with a package ecosystem. | | |
| Package name | <p>The primary identifier for a mutable collection of artifacts that all represent different versions of the same software. This is the primary identifier that consumers use to obtain the software.<p>A package name is specific to an ecosystem + registry, has a maintainer, is more general than a specific hash or version, and has a "correct" source location. A package ecosystem may group package names into some sort of hierarchy, such as the Group ID in Maven, though SLSA does not have a special term for this. | | |
| Package registry | A specific type of "distribution platform" used within a packaging ecosystem. Most ecosystems support multiple registries, usually a single global registry and multiple private registries. | | Dependency |
| Package source files | A language-specific config file in a source code repo that identifies the package registry feeds or artifact repository manager feeds to consume dependencies from. | | Dependency |
| Platform | System that allows tenants to run builds. Technically, it is the transitive closure of software and services that must be trusted to faithfully execute the build. It includes software, hardware, people, and organizations. |  |  |
| Producer (Role) | A party who creates software and provides it to others. Producers are often also consumers. | An open source project's maintainers. A software vendor. | Build |
| Provenance | Attestation (metadata) describing how the outputs were produced, including identification of the platform and external parameters. | | |
| Publish (a package) | Make an artifact available for use by registering it with the package registry. In technical terms, this means associating an artifact to a package name. This does not necessarily mean making the artifact fully public; an artifact may be published for only a subset of users, such as internal testing or a closed beta. | | |
| <span id="quote">Quote</span> | (Virtual) hardware-signed data that contains one or more (virtual) hardware-generated measurements. Quotes may additionally include nonces for replay protection, firmware information, or other platform metadata. (Based on the definition in [section 9.5.3.1](https://trustedcomputinggroup.org/wp-content/uploads/TPM-2.0-1.83-Part-1-Architecture.pdf) of the TPM 2.0 spec) | | Build Environment |
| <span id="reference-value">Reference value</span> | A specific measurement used as the good known value for a given build environment component or state. | | Build Environment |
| Source | Artifact that was directly authored or reviewed by persons, without modification. It is the beginning of the supply chain; we do not trace the provenance back any further. | Git commit (source) hosted on GitHub (platform). | Build |
| Source Branch | A Named Reference that moves to track the Change History of a cohesive line of development within a Source Repository. E.g. `main`, `develop`, `feature-x` | | Source |
| Source Change | A modification to the state of the Source Repository, such as creation of a new Source Revision based on a previous Source Revision, or creation, deletion, or modification of a Named Reference. | | Source |
| Source Change History | A record of the history of Source Revisions that preceded a specific revision. | | Source |
| Source Repository (Repo) | A self-contained unit that holds the content and revision history for a set of files, along with related metadata like Branches and Tags. | | Source |
| Source Revision | A specific, logically immutable snapshot of the repository's tracked files. It is uniquely identified by a revision identifier, such as a cryptographic hash like a Git commit SHA or a path-qualified sequential number like `25@trunk/` in SVN. A Source Revision includes both the content (the files) and its associated version control metadata, such as the author, timestamp, and parent revision(s). Note: Path qualification is needed for version control systems that represent Branches and Tags using paths, such as Subversion and Perforce. | | Source |
| Source <span id="tag">Tag</span> | A Named Reference that is intended to be immutable. Once created, it is not moved to point to a different revision. E.g. `v1.2.3`, `release-20250722` | | Source |
| Source Administrator | A human who can perform privileged operations on one or more projects. Privileged actions include, but are not limited to, modifying the change history and modifying project- or organization-wide security policies. | | Source |
| Source Control System | A platform or combination of services(self-hosted or SaaS) that hosts a Source Repository and provides a trusted foundation for managing source revisions by enforcing policies for authentication, authorization, and change management, such as mandatory code reviews or passing status checks. | | Source |
| Source Organization | A set of people who collectively create Source Revisions within a Source Repository. Examples of organizations include open-source projects, a company, or a team within a company. The organization defines the goals of a Source Repository and the methods used to produce new Source Revisions. | | Source |
| Source Proposed Change | A proposal to make a Change in a Source Repository. | | Source |
| Source Provenance | Information about how a Source Revision came to exist, where it was hosted, when it was generated, what process was used, who the contributors were, and which parent revisions preceded it. | | Source |
| Source Trusted person | A human who is authorized by the organization to propose and approve changes to the source. | | Source |
| Source Trusted robot | Automation authorized by the organization to act in explicitly defined contexts. The robot’s identity and codebase cannot be unilaterally influenced. | | Source |
| Source Untrusted person | A human who has limited access to the project. They MAY be able to read the source. They MAY be able to propose or review changes to the source. They MAY NOT approve changes to the source or perform any privileged actions on the project. | | Source |
| Steps | The set of actions that comprise a build, defined by the tenant. | | |
| Tenant | An untrusted user that builds an artifact on the platform. The tenant defines the build steps and external parameters. | | |
| Verifier (Role) | A party who inspect an artifact's provenance to determine the artifact's authenticity. | A business's software ingestion system. A programming language ecosystem's package registry. | Build |

> **NOTE:** The 'branch' and 'tag' source features within version control systems may
not always align with the 'Branch' and 'Tag' definitions provided in this
specification. For example, in git and other version control systems, the UX may
allow 'tags' to be moved. Patterns like `latest` and `nightly` tags rely on this.
For the purposes of this specification these would be classified as 'Named References' and not as 'Tags'.


## Terms to avoid

These terms can be ambiguous and should be avoided.

| Term | Reason to avoid | 
| ---  | ---         | 
| Package repository |Could mean either package registry or package name, depending on the ecosystem. To avoid confusion, we always use "repository" exclusively to mean "source repository", where there is no ambiguity. |
| Package manager (without "client") | Could mean either package ecosystem, package registry, or client-side tooling. |
| Avoid using terms such as "developer," "maintainer," "producer," "author," and "publisher" interchangeably. | Whenever possible, default to "producer," in line with the model of producer -> consumer -> infrastructure provider. "Maintainer" is reserved for sections specifying the act of continuing to maintain a project after its creation, or when used in a less technical context where it is unlikely to cause confusion. "Author" is reserved for the act of making source code commits or reviews. "Individual" is used when the context's focus is specifying a single person (i.e., "an individual's workstation" or "compromised individual"). |
| Avoid using terms such as "platform," "system," and "service" interchangeably. |  Whenever possible, default to "platform." Instead of using "service," a reference to a "hosted platform" should be used. A reference to some specific software or tools internal to a platform can be made with "platform component" unless there is a more appropriate definition to use directly like "control plane." External self-described services and systems can continue to be called by these terms. |



