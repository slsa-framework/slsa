---
title: Supply chain threat overview
description: Attacks can occur at every link in a typical software supply chain, and these kinds of attacks are increasingly public, disruptive, and costly in today's environment. This page is an introduction to possible attacks throughout the supply chain and how SLSA could help.
---

# {The Supply Chain Problem}

## Introduction to Supply Chain Attacks

Attacks can occur at every link in a typical software supply chain, and these
kinds of attacks are increasingly public, disruptive, and costly in today's
environment. This page outlines possible attacks throughout the supply chain and how
SLSA can help. 

Threats can be mitigated because SLSA's primary focus is supply chain integrity. Integrity means protection against tampering or unauthorized
modification at any stage of the software lifecycle. Within SLSA, we divide
integrity into source integrity vs build integrity: 

- **Source integrity:** Ensures that the source revision represents the intent of the producer, that all expected processes were followed and that the revision was not modified after being accepted.

- **Build integrity:** Ensures that the package is built from the correct,
unmodified sources and dependencies according to the build recipe defined by the
software producer, and that artifacts are not modified as they pass between
development stages.

SLSA can provide additional mitigation because its secondary focus is on availablity:

- **Availability:** Ensures that the package can continue to be built and
maintained in the future, and that all code and change history is available for
investigations and incident response.

SLSA helps give consumers confidence that software has not been tampered
with and can be securely traced back to source - something that is difficult, if
not impossible, to do with most software today.

## Supply chain threat model

![Supply Chain Threats](images/supply-chain-threats.svg)

This supply chain threat model diagram shows where threats can occur in the supply chain sequence of events. The letters (A) through (I) represent different threats and are explained in the real-world example table [below](real-world-examples). For more technical details on supply chain threats, see [Threats & mitigations](threats.md).

**Note:** SLSA does not currently address all of the threats presented in the diagram.

## Real-world examples of Supply Chain threats

Many recent high-profile attacks were consequences of supply chain integrity vulnerabilities, and could have been prevented by SLSA's framework. 

The table below outlines a set of real world supply chain threat problems and explains how SLSA can mitigate them. Each threat in this table has a label of (A) through (I). These labels coincide with the red triangle threat locations in the diagram above. See the [Threats & Mitigations](threats.md) page for in-depth details on threat problems and SLSA solutions.

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


