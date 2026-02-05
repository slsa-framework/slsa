---
title: SLSA generic terminology
description: The following generic terminology is used in the SLSA specification. 
---

# {General Terminology} 

The following terms and descriptions will be used throughout the SLSA specification. Examples are provided when relevant. 

| Term | Description | Example |
| ---  | ---         | ---   |
| Artifact | An immutable blob of data; primarily refers to software, but SLSA can be used for any artifact. | A file, a git commit, a directory of files (serialized in some way), a container image, a firmware image. |
| Attestation | An authenticated statement (metadata) about a software artifact or collection of software artifacts. | A signed [SLSA Provenance] file. | 
| Build | Process that transforms a set of input artifacts into a set of output artifacts. The inputs may be sources, dependencies, or ephemeral build outputs. | .travis.yml (process) run by Travis CI (platform). | 
| Build environment| The independent execution context in which the build runs, initialized by the control plane. In the case of a distributed build, this is the collection of all such machines/containers/VMs that run steps. | | 
| Consumer | A party who uses software provided by a producer. The consumer may verify provenance for software they consume or delegate that responsibility to a separate verifier. | A developer who uses open source software distributions. A business that uses a point of sale system. | 
| Dependency | Artifact that is an input to a build process but that is not a source. In the model, it is always a package. | Alpine package (package) distributed on Alpine Linux (platform). | 
| Distribution | The channel through which artifacts are "published" for use by others. | A registry like DockerHub or npm. Artifacts may also be distributed via physical media (e.g., a USB drive). | 
| Outputs | Collection of artifacts produced by the build. | |
| Package | Artifact that is distributed. In the model, it is always the output of a build process, though that build process can be a no-op. | Docker image (package) distributed on DockerHub (distribution). A ZIP file containing source code is a package, not a source, because it is built from some other source, such as a git commit. | 
| Platform | System that allows tenants to run builds. Technically, it is the transitive closure of software and services that must be trusted to faithfully execute the build. It includes software, hardware, people, and organizations. |  |  
| Producer | A party who creates software and provides it to others. Producers are often also consumers. | An open source project's maintainers. A software vendor. | 
| Provenance | Attestation (metadata) describing how the outputs were produced, including identification of the platform and external parameters. | | 
| Publish | Make an artifact available for use by registering it with the package registry. In technical terms, this means associating an artifact to a package name. This does not necessarily mean making the artifact fully public; an artifact may be published for only a subset of users, such as internal testing or a closed beta. | | 
| Source | Artifact that was directly authored or reviewed by persons, without modification. It is the beginning of the supply chain; we do not trace the provenance back any further. | Git commit (source) hosted on GitHub (platform). | 
| Source Control System | A platform or combination of services(self-hosted or SaaS) that hosts a Source Repository and provides a trusted foundation for managing source revisions by enforcing policies for authentication, authorization, and change management, such as mandatory code reviews or passing status checks. | |
| Steps | The set of actions that comprise a build, defined by the tenant. | | 
| Tenant | An untrusted user that builds an artifact on the platform. The tenant defines the build steps and external parameters. | | 
| Verification system | A set of instructions that a person follows to inspect an artifact's provenance to determine the artifact's authenticity. | A business's software ingestion system. A programming language ecosystem's package registry. | 

## Track-specific terminology

Many terms are specific to a track and are defined in their own tracks. The table below contains links to the terminology for each track.

| Track-specific terminology | Link | 
| ---  | ---         | 
| Build Track | [Build terminology](build-track-basics.md#build-track-terminology) |
| Build Environment Track | [Build Environment terminology](build-env-track-basics.md#build-environment-terminology) |
| Dependency Track | [Dependency terminology](depend-track-basics.md#dependency-track-terminology) |
| Source Track | [Source terminology](source-track-basics.md#source-track-terminology) |

## Terms to avoid

These terms can be ambiguous and should be avoided.

| Term | Reason to avoid | 
| ---  | ---         | 
| Package repository |Could mean either package registry or package name, depending on the ecosystem. To avoid confusion, we always use "repository" exclusively to mean "source repository", where there is no ambiguity. |
| Package manager (without "client") | Could mean either package ecosystem, package registry, or client-side tooling. |
| Avoid using terms such as "developer," "maintainer," "producer," "author," and "publisher" interchangeably. | Whenever possible, default to "producer," in line with the model of producer -> consumer -> infrastructure provider. "Maintainer" is reserved for sections specifying the act of continuing to maintain a project after its creation, or when used in a less technical context where it is unlikely to cause confusion. "Author" is reserved for the act of making source code commits or reviews. "Individual" is used when the context's focus is specifying a single person (i.e., "an individual's workstation" or "compromised individual"). |
| Avoid using terms such as "platform," "system," and "service" interchangeably. |  Whenever possible, default to "platform." Instead of using "service," a reference to a "hosted platform" should be used. A reference to some specific software or tools internal to a platform can be made with "platform component" unless there is a more appropriate definition to use directly like "control plane." External self-described services and systems can continue to be called by these terms. |



