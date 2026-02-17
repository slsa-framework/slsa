## Mapping to real-world ecosystems

Most real-world ecosystems fit the package model above but use different terms.
The table below attempts to document how various ecosystems map to the SLSA
Package model. There are likely mistakes and omissions; corrections and
additions are welcome!

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

Notes:

-   [Go](https://go.dev) (golang) uses a significantly different distribution model than other ecosystems.
    In Go, the package name is a source repository URL. While clients can fetch
    directly from that URL---in which case there is no "package" or
    "registry"---they usually fetch a zip file from a *module proxy*. The module
    proxy acts as both a builder (by constructing the package artifact from
    source) and a registry (by mapping package name to package artifact). People
    trust the module proxy because builds are independently reproducible, and a
    *checksum database* guarantees that all clients receive the same artifact
    for a given URL.

### Real-world supply chain examples

Many recent high-profile attacks were consequences of supply chain integrity vulnerabilities, and could have been prevented by SLSA's framework. For example:

<table>
<thead>
<tr>
<th>
<th>Threats from
<th>Known example
<th>How SLSA could help
<tbody>
<tr>
<td>A
<td>Producer
<td><a href="https://en.wikipedia.org/wiki/SpySheriff">SpySheriff</a>: Software producer purports to offer anti-spyware software, but that software is actually malicious.
<td>SLSA does not directly address this threat but could make it easier to discover malicious behavior in open source software, by forcing it into the publicly available source code.
For closed source software SLSA does not provide any solutions for malicious producers.
<tr>
<td>B
<td>Authoring & reviewing
<td><a href="https://arstechnica.com/information-technology/2021/09/cryptocurrency-launchpad-hit-by-3-million-supply-chain-attack/">SushiSwap</a>: Contractor with repository access pushed a malicious commit redirecting cryptocurrency to themself.
<td>Two-person review could have caught the unauthorized change.
<tr>
<td>C
<td>Source code management
<td><a href="https://news-web.php.net/php.internals/113838">PHP</a>: Attacker compromised PHP's self-hosted git server and injected two malicious commits.
<td>A better-protected source code system would have been a much harder target for the attackers.
<tr>
<td>D
<td>External build parameters
<td><a href="https://www.reddit.com/r/HobbyDrama/comments/jouwq7/open_source_development_the_great_suspender_saga/">The Great Suspender</a>: Attacker published software that was not built from the purported sources.
<td>A SLSA-compliant build server would have produced provenance identifying the actual sources used, allowing consumers to detect such tampering.
<tr>
<td>E
<td>Build process
<td><a href="https://www.crowdstrike.com/blog/sunspot-malware-technical-analysis/">SolarWinds</a>: Attacker compromised the build platform and installed an implant that injected malicious behavior during each build.
<td>Higher SLSA Build levels have <a href="requirements#build-platform">stronger security requirements for the build platform</a>, making it more difficult for an attacker to forge the SLSA provenance and gain persistence.
<tr>
<td>F
<td>Artifact publication
<td><a href="https://about.codecov.io/apr-2021-post-mortem/">CodeCov</a>: Attacker used leaked credentials to upload a malicious artifact to a GCS bucket, from which users download directly.
<td>Provenance of the artifact in the GCS bucket would have shown that the artifact was not built in the expected manner from the expected source repo.
<tr>
<td>G
<td>Distribution channel
<td><a href="https://theupdateframework.io/papers/attacks-on-package-managers-ccs2008.pdf">Attacks on Package Mirrors</a>: Researcher ran mirrors for several popular package registries, which could have been used to serve malicious packages.
<td>Similar to above (F), provenance of the malicious artifacts would have shown that they were not built as expected or from the expected source repo.
<tr>
<td>H
<td>Package selection
<td><a href="https://blog.sonatype.com/damaging-linux-mac-malware-bundled-within-browserify-npm-brandjack-attempt">Browserify typosquatting</a>: Attacker uploaded a malicious package with a similar name as the original.
<td>SLSA does not directly address this threat, but provenance linking back to source control can enable and enhance other solutions.
<tr>
<td>I
<td>Usage
<td><a href="https://www.horizon3.ai/attack-research/disclosures/cve-2023-27524-insecure-default-configuration-in-apache-superset-leads-to-remote-code-execution/">Default credentials</a>: Attacker could leverage default credentials to access sensitive data.
<td>SLSA does not address this threat.
<tr>
<td>N/A
<td>Dependency threats (i.e. A-H, recursively)
<td><a href="https://web.archive.org/web/20210909051737/https://schneider.dev/blog/event-stream-vulnerability-explained/">event-stream</a>: Attacker controls an innocuous dependency and publishes a malicious binary version without a corresponding update to the source code.
<td>Applying SLSA recursively to all dependencies would prevent this particular vector, because the provenance would indicate that it either wasn't built from a proper builder or that the binary did not match the source.
</table>

<table>
<thead>
<tr>
<th>
<th>Availability threat
<th>Known example
<th>How SLSA could help
<tbody>
<tr>
<td>N/A
<td>Dependency becomes unavailable
<td><a href="https://www.techradar.com/news/this-popular-code-library-is-causing-problems-for-hundreds-of-thousands-of-devs">Mimemagic</a>: Producer intentionally removes package or version of package from repository with no warning. Network errors or service outages may also make packages unavailable temporarily.
<td>SLSA does not directly address this threat.
</table>

A SLSA level helps give consumers confidence that software has not been tampered
with and can be securely traced back to source—something that is difficult, if
not impossible, to do with most software today.

 