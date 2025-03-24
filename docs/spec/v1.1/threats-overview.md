---
title: Supply chain threats
description: Attacks can occur at every link in a typical software supply chain, and these kinds of attacks are increasingly public, disruptive, and costly in today's environment. This page is an introduction to possible attacks throughout the supply chain and how SLSA could help.
---

Attacks can occur at every link in a typical software supply chain, and these
kinds of attacks are increasingly public, disruptive, and costly in today's
environment.

This page is an introduction to possible attacks throughout the supply chain and how
SLSA could help. For a more technical discussion, see [Threats & mitigations](threats.md).

## Summary

![Supply Chain Threats](images/supply-chain-threats.svg)

**Note that SLSA does not currently address all of the threats presented here.**
See [Threats & mitigations](threats.md) for what is currently addressed and
[Terminology](terminology.md) for an explanation of the supply chain model.

SLSA's primary focus is supply chain integrity, with a secondary focus on
availability. Integrity means protection against tampering or unauthorized
modification at any stage of the software lifecycle. Within SLSA, we divide
integrity into source integrity vs build integrity.

**Source integrity:** Ensure that all changes to the source code reflect the
intent of the software producer. Intent of an organization is difficult to
define, so SLSA is expected to approximate this as approval from two authorized
representatives.

**Build integrity:** Ensure that the package is built from the correct,
unmodified sources and dependencies according to the build recipe defined by the
software producer, and that artifacts are not modified as they pass between
development stages.

**Availability:** Ensure that the package can continue to be built and
maintained in the future, and that all code and change history is available for
investigations and incident response.

### Real-world examples

Many recent high-profile attacks were consequences of supply chain integrity vulnerabilities, and could have been prevented by SLSA's framework. For example:

<table>
<thead>
<tr>
<th>
<th>Integrity threat
<th>Known example
<th>How SLSA could help
<tbody>
<tr>
<td>A
<td>Submit unauthorized change (to source repo)
<td><a href="https://arstechnica.com/information-technology/2021/09/cryptocurrency-launchpad-hit-by-3-million-supply-chain-attack/">SushiSwap</a>: Contractor with repository access pushed a malicious commit redirecting cryptocurrency to themself.
<td>Two-person review could have caught the unauthorized change.
<tr>
<td>B
<td>Compromise source repo
<td><a href="https://news-web.php.net/php.internals/113838">PHP</a>: Attacker compromised PHP's self-hosted git server and injected two malicious commits.
<td>A better-protected source code platform would have been a much harder target for the attackers.
<tr>
<td>C
<td>Build from modified source (not matching source repo)
<td><a href="https://www.webmin.com/exploit.html">Webmin</a>: Attacker modified the build infrastructure to use source files not matching source control.
<td>A SLSA-compliant build server would have produced provenance identifying the actual sources used, allowing consumers to detect such tampering.
<tr>
<td>D
<td>Use compromised dependency (i.e. A-H, recursively)
<td><a href="https://web.archive.org/web/20210909051737/https://schneider.dev/blog/event-stream-vulnerability-explained/">event-stream</a>: Attacker controls an innocuous dependency and publishes a malicious binary version without a corresponding update to the source code.
<td>Applying SLSA recursively to all dependencies would prevent this particular vector, because the provenance would indicate that it either wasn't built from a proper builder or that the binary did not match the source.
<tr>
<td>E
<td>Compromise build process
<td><a href="https://www.crowdstrike.com/blog/sunspot-malware-technical-analysis/">SolarWinds</a>: Attacker compromised the build platform and installed an implant that injected malicious behavior during each build.
<td>Higher SLSA levels require <a href="requirements#build-requirements">stronger security controls for the build platform</a>, making it more difficult to compromise and gain persistence.
<tr>
<td>F
<td>Upload modified package (not matching build process)
<td><a href="https://about.codecov.io/apr-2021-post-mortem/">CodeCov</a>: Attacker used leaked credentials to upload a malicious artifact to a GCS bucket, from which users download directly.
<td>Provenance of the artifact in the GCS bucket would have shown that the artifact was not built in the expected manner from the expected source repo.
<tr>
<td>G
<td>Compromise package registry
<td><a href="https://theupdateframework.io/papers/attacks-on-package-managers-ccs2008.pdf">Attacks on Package Mirrors</a>: Researcher ran mirrors for several popular package registries, which could have been used to serve malicious packages.
<td>Similar to above (F), provenance of the malicious artifacts would have shown that they were not built as expected or from the expected source repo.
<tr>
<td>H
<td>Use compromised package
<td><a href="https://blog.sonatype.com/damaging-linux-mac-malware-bundled-within-browserify-npm-brandjack-attempt">Browserify typosquatting</a>: Attacker uploaded a malicious package with a similar name as the original.
<td>SLSA does not directly address this threat, but provenance linking back to source control can enable and enhance other solutions.
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
<td>D
<td>Dependency becomes unavailable
<td><a href="https://www.techradar.com/news/this-popular-code-library-is-causing-problems-for-hundreds-of-thousands-of-devs">Mimemagic</a>: Producer intentionally removes package or version of package from repository with no warning. Network errors or service outages may also make packages unavailable temporarily.
<td>SLSA does not directly address this threat.
</table>

A SLSA level helps give consumers confidence that software has not been tampered
with and can be securely traced back to source—something that is difficult, if
not impossible, to do with most software today.
