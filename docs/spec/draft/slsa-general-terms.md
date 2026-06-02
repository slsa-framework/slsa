---
title: SLSA general terminology
description: The following general terminology is used in the SLSA specification. 
---

## SLSA specification general terminology

The following terms and descriptions will be used throughout the SLSA specification. This table includes basic terminology and not track-specifc language. Links for terms that only apply to individual tracks are supplied after this table. There is also a list of ambiguous terms to avoid using and a comparison map that shows how SLSA terms relate to real-world ecosystem terminology.

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

### Track-specific terminology

Many SLSA terms are specific to an individual track and are defined in these tracks. The table below contains links to the terminology for each track.

| Track-specific terminology | Link | 
| ---  | ---         | 
| Build Track | [Build terminology](build-track-basics.md#build-track-terminology) |
| Build Environment Track | [Build Environment terminology](build-env-track-basics.md#build-environment-terminology) |
| Dependency Track | [Dependency terminology](depend-track-basics.md#dependency-track-terminology) |
| Source Track | [Source terminology](source-track-basics.md#source-track-terminology) |

### Terms to avoid

These terms can be ambiguous and shouldn't be used.

| Term | Reason to avoid | 
| ---  | ---         | 
| Package repository |Could mean either package registry or package name, depending on the ecosystem. To avoid confusion, we always use "repository" exclusively to mean "source repository", where there is no ambiguity. |
| Package manager (without "client") | Could mean either package ecosystem, package registry, or client-side tooling. |
| Avoid using terms such as "developer," "maintainer," "producer," "author," and "publisher" interchangeably. | Whenever possible, default to "producer," in line with the model of producer -> consumer -> infrastructure provider. "Maintainer" is reserved for sections specifying the act of continuing to maintain a project after its creation, or when used in a less technical context where it is unlikely to cause confusion. "Author" is reserved for the act of making source code commits or reviews. "Individual" is used when the context's focus is specifying a single person (i.e., "an individual's workstation" or "compromised individual"). |
| Avoid using terms such as "platform," "system," and "service" interchangeably. |  Whenever possible, default to "platform." Instead of using "service," a reference to a "hosted platform" should be used. A reference to some specific software or tools internal to a platform can be made with "platform component" unless there is a more appropriate definition to use directly like "control plane." External self-described services and systems can continue to be called by these terms. |

### Mapping SLSA terminology to real-world ecosystems terms

Most real-world software ecosystems use different terms than SLSA. 
The table below documents how various ecosystems map to SLSA
terminology. 

<!-- Please keep this list sorted alphabetically within each section. -->

<table>
  <tr>
    <th>Package ecosystem
    <th>Package registry
    <th>Package name
    <th>Package artifact
  <tr>
    <td colspan=4><em>Languages</em>
  <tr>
    <td><a href="https://doc.rust-lang.org/cargo/appendix/glossary.html">Cargo</a> (Rust)
    <td><a href="https://doc.rust-lang.org/cargo/appendix/glossary.html#registry">Registry</a>
    <td><a href="https://doc.rust-lang.org/cargo/appendix/glossary.html#crate">Crate name</a>
    <td><a href="https://doc.rust-lang.org/cargo/appendix/glossary.html#artifact">Artifact</a>
  <tr>
    <td><a href="https://www.cpan.org">CPAN</a> (Perl)
    <td><a href="https://pause.perl.org/pause/query?ACTION=pause_04about">PAUSE</a>
    <td><a href="https://neilb.org/2015/09/05/cpan-glossary.html#distribution">Distribution</a>
    <td><a href="https://neilb.org/2015/09/05/cpan-glossary.html#release">Release</a> (or <a href="https://neilb.org/2015/09/05/cpan-glossary.html#distribution">Distribution</a>)
  <tr>
    <td><a href="https://go.dev/ref/mod">Go</a>
    <td><a href="https://go.dev/ref/mod#glos-module-proxy">Module proxy</a>
    <td><a href="https://go.dev/ref/mod#glos-module-path">Module path</a>
    <td><a href="https://go.dev/ref/mod#glos-module">Module</a>
  <tr>
    <td><a href="https://maven.apache.org/glossary">Maven</a> (Java)
    <td>Repository
    <td>Group ID + Artifact ID
    <td>Artifact
  <tr>
    <td><a href="https://www.npmjs.com/">npm</a> (JavaScript)
    <td><a href="https://docs.npmjs.com/about-the-public-npm-registry">Registry</a>
    <td><a href="https://docs.npmjs.com/package-name-guidelines">Package Name</a>
    <td><a href="https://docs.npmjs.com/about-packages-and-modules">Package</a>
  <tr>
    <td><a href="https://docs.microsoft.com/en-us/nuget/nuget-org/overview-nuget-org">NuGet</a> (C#)
    <td>Host
    <td>Project
    <td>Package
  <tr>
    <td><a href="https://packaging.python.org/en/latest/specifications/binary-distribution-format/#file-name-convention">PyPA</a> (Python)
    <td><a href="https://packaging.python.org/en/latest/glossary/#term-Package-Index">Index</a>
    <td><a href="https://packaging.python.org/en/latest/glossary/#term-Project">Project Name</a>
    <td><a href="https://packaging.python.org/en/latest/glossary/#term-Distribution-Package">Distribution</a>
  <tr>
    <td colspan=4><em>Operating systems</em>
  <tr>
    <td><a href="https://wiki.debian.org/Teams/Dpkg">Dpkg </a> (e.g. Debian)
    <td><em>?</em>
    <td>Package name
    <td>Package
  <tr>
    <td><a href="https://docs.flatpak.org/en/latest/introduction.html#terminology">Flatpak</a>
    <td>Repository
    <td>Application
    <td>Bundle
  <tr>
    <td><a href="https://docs.brew.sh/Manpage">Homebrew</a> (e.g. Mac)
    <td>Repository (Tap)
    <td>Package name (Formula)
    <td>Binary package (Bottle)
  <tr>
    <td><a href="https://wiki.archlinux.org/title/Pacman">Pacman</a> (e.g. Arch)
    <td>Repository
    <td>Package name
    <td>Package
  <tr>
    <td><a href="https://rpm.org">RPM</a> (e.g. Red Hat)
    <td>Repository
    <td>Package name
    <td>Package
  <tr>
    <td><a href="https://nixos.org/manual/nix">Nix</a> (e.g. <a href="https://nixos.org/">NixOS</a>)
    <td>Repository (e.g. <a href="https://github.com/NixOS/nixpkgs">Nixpkgs</a>) or <a href="https://nixos.org/manual/nix/stable/glossary.html#gloss-binary-cache">binary cache</a>
    <td><a href="https://nixos.org/manual/nix/stable/language/derivations.html">Derivation name</a>
    <td><a href="https://nixos.org/manual/nix/stable/language/derivations.html">Derivation</a> or <a href="https://nixos.org/manual/nix/stable/glossary.html#gloss-store-object">store object</a>
  <tr>
    <td colspan=4><em>Storage systems</em>
  <tr>
    <td><a href="https://cloud.google.com/storage/docs/key-terms">GCS</a>
    <td><em>n/a</em>
    <td>Object name
    <td>Object
  <tr>
    <td><a href="https://github.com/opencontainers/distribution-spec/blob/main/spec.md#definitions">OCI</a>/Docker
    <td>Registry
    <td>Repository
    <td>Object
  <tr>
    <td colspan=4><em>Meta</em>
  <tr>
    <td><a href="https://deps.dev/glossary">deps.dev</a>: <a href="https://deps.dev/glossary#system">System</a>
    <td><a href="https://deps.dev/glossary#packaging-authority">Packaging authority</a>
    <td><a href="https://deps.dev/glossary#package">Package</a>
    <td><em>n/a</em>
  <tr>
    <td><a href="https://github.com/package-url/purl-spec/blob/master/PURL-SPECIFICATION.rst">purl</a>: type
    <td>Namespace
    <td>Name
    <td><em>n/a</em>
</table>

**Notes:** Go uses a significantly different distribution model than other ecosystems.
    In Go, the package name is a source repository URL. While clients can fetch
    directly from that URL, in which case there is no "package" or
    "registry", they usually fetch a zip file from a *module proxy*. The module
    proxy acts as both a builder (by constructing the package artifact from
    source) and a registry (by mapping package name to package artifact). People
    trust the module proxy because builds are independently reproducible, and a
    *checksum database* guarantees that all clients receive the same artifact
    for a given URL.
    
    





