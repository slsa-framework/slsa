---
title: Terminology
order: 5
layout: specifications
description: Glossary and definitions
hero_text: A glossary of the technical terms found in SLSA documentation. The bulk of the SLSA documentation can get quite technical (especially when it becomes more granular and specific), so we’ve keep these terms accessible and easy to understand, so everyone can dive into SLSA’s moving parts.
---

## Glossary

> SLSA is in `alpha`. The definitions below are not yet finalized and subject to change.

### Artifact

An immutable blob of data. It primarily refers to software, but SLSA can be used for any artifact. They can be files, git commits, a file directory (serialized in some way), container images or firmware images.

### Assurance

The level of confidence that any software’s free from [vulnerabilities](#vulnerabilities).

### Attestation

A software attestation is a signed statement (metadata) about a software artifact or collection of software artifacts. This allows an artifact, package or program to authenticate itself, which can then help authorization decisions in an automated policy framework.

### Best effort

When referring to [integrity](#integrity), we use ‘best effort’ to signal a show of effort without substantial guarantees. It’s the least amount of assurance in either the source integrity, build integrity or the dependencies.

### Build

The process that transforms a set of input artifacts into a set of output artifacts. The inputs may be [sources](#sources), [dependencies](#dependency), or [ephemeral](#ephemeral-environment) build outputs. For example, a build could be .travis.yml (process) run by Travis CI (platform).

### CI/CD

Continuous integration, continuous delivery, continuous deployment. This is a means of frequently delivering software by automating part of the development process into a pipeline, such as automatic bug testing or automatic releases.

### Credible

When referring to [integrity](#integrity), we use ‘credible’ to describe the medium viable degree of [assurance](#assurance). There’s more integrity than something that’s ‘best effort’, but less than something that’s ‘resilient’.

### Cryptographic secrets

A piece of data (usually a key) known only to trusted persons in a secure communication system.

### Dependency

An artifact that is an input to a [build](#build) process but isn’t itself a [source](#source). In the model, it’s always a package. For example, a dependency could be an Alpine package (package) distributed on Alpine Linux (platform).

### Ephemeral environment

Short-lived, or temporary. This refers to an environment being created for a limited time to assist deployment and mirror production, then removed without consequence. They can be automated, on demand and shareable.

### Hardened

Referring to a higher level of security within a system, when the surface of [vulnerability](#vulnerabilities) has been reduced.

### Immutable reference

An identifier that’s guaranteed to always point to the same, immutable artifact. This must allow the consumer to locate the artifact and should include a cryptographic hash of the artifact’s contents to ensure integrity. For examples, a git url + branch/tag/ref + commit ID; cloud storage bucket ID + SHA-256 hash; Subversion url (no hash).

### Integrity

Integrity’s used to describe the relative degree of security within a system. We use it to refer specifically to the [source](#source) or [build](#build) environments, and applied to the level of security around the [dependencies](#dependency) involved.

### Package

An artifact that’s published for use by others. In the SLSA framework, a package is always the output of a build process, though that build process can be a no-op. For example, a package could be a Docker image (package) distributed on DockerHub (platform). ZIP files containing source code are packages rather than sources, because they’re built from some other source such as a git commit.

### Parallel builds

This is a means of introducing modularity to deployment, particularly for dependency management, where build scripts are executed in parallel for multiple processes for efficiency.

### Platform

Infrastructure or service that hosts the source, build, or distribution of software. For example, GitHub, Google Cloud Build, Travis CI, and Mozilla’s self-hosted Mercurial server.

### Provenance

Verifiable information about software artifacts that can describe where, when and how something was produced. Available provenance means that software can be traced back to its origins, and allow for authentication.

### Resilience

As a general term, resilience describes the relative level of confidence about the [integrity](#integrity) of the [source](#source), [build](#build) or [dependencies](#dependency) involved in a [software supply chain](#software-supply-chain). As a comparative term, we use ‘resilient’ to describe the highest degree of confidence in something’s [integrity](#integrity).

### Revision

An immutable, coherent state of a source. In Git for example, a revision is a commit in the history reachable from a specific branch in a specific repository. Different revisions within one repository may have different levels. For example, the most recent revision on a branch meets SLSA 4 but very old historical revisions before the cutoff do not.

### SBOM

Software Bill of Materials, the formalized list of components, libraries and modules needed to build any software and the supply chain relationships involved.

### Software supply chain

Everything involved from the development to deployment of software, from the author, the time it was created, to how it’s being used, [dependencies](#dependency) involved, how it’s been reviewed and known [vulnerabilities](#vulnerabilities).

### Source

Artifacts that were directly authored or reviewed by multiple people without modification. The source is the beginning of the supply chain, and we don’t trace the [provenance](#provenance) back any further.

### Strong authentication

Authentication that maps back to a specific person using an authentication mechanism which is resistant to account and credential compromise. For example, 2-factor authentication (2FA) where one factor is a hardware security key (e.g. YubiKey).

### Tampering

Deliberate, unauthorized and malicious changes, modifications and edits to code or software by exploiting [vulnerabilities](#vulnerabilities) at any point in the [software supply chain](#software-supply-chain).

### Transitive

Transitivity is a kind of direct relation between several objects, where a property of one is automatically assumed to be present in another by virtue of the relationship. SLSA is not transitive, so each artifact’s SLSA level is independent from the next (e.g. SLSA Level 4 does not require dependencies to also be SLSA Level 4).

### Trustworthy

Trustworthiness refers to the relative degree of confidence and compliance that a component is fit for use according to security parameters, that it’s available, reliable, [resilient](#resilience), secure against misuse or malicious intent, and adheres to security policy.

### Trusted persons

The set of people who are granted authority to maintain a software project.

### Trust boundary

This can be thought of as a moment or stage within the development and deployment process, where untrusted artifacts are checked, validated and authorized against security measures in order to progress.

### Trusted control plane

The orchestration layer that exposes the API and interfaces to define, deploy, and manage the lifecycle of software artifacts.

### Vulnerabilities

Any weakness or flaw in software or how it’s being used in a software supply chain. These can include security misconfigurations, injection flaws, insufficient protection of sensitive data, lack of proper validation, etc.
