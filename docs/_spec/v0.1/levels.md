---
title: Security levels
order: 2
version: 0.1
layout: specifications
description: Start here for the level breakdowns
---

SLSA’s levels prioritize measures to provide you and your users with appropriate, industry-recognized security guarantees. Each level builds on baseline guarantees that the source code you analyze and trust is the code that you're actually using, starting by prioritizing the security of packages you’re using, then focusing effort to securing the infrastructure in place to deliver that package.

Artifacts used in critical infrastructure or vital business operations may want to attain a higher level of security, whereas software that poses a low risk can stop when it’s appropriate. It can take years to achieve the ideal security state, so having intermediate milestones is important. That’s where SLSA levels come in, representing stages of gradual improvement.

The SLSA level is not transitive ([see our FAQs](../faq)). Each artifact’s SLSA level is independent from one another, allowing parallel progress and prioritization based on risk. The level describes the integrity protections of an artifact’s build process and top-level source, but nothing about the artifact’s dependencies. Dependencies have their own SLSA levels, and it’s possible for a SLSA Level 4 artifact to be built from SLSA Level 0 dependencies.

## Level 1: Basic security steps

**Level 1** means the supply chain is documented, there’s infrastructure to generate provenance data, and systems are prepared to comply with higher SLSA levels. Integrity across the build, source and dependencies involved are best effort. These checks are the basic first steps anyone can take to start mapping things out and focus their security efforts.

![level 1](/images/SLSA-Badge-full-level1.svg)

|                   | Description |
|-------------------|-------------|
| **Goals**         | <ul><li>Figure out the scope and risk of supply chain practices</li><li>Determine gaps in supply chain visibility</li><li>Provide a steel thread of information flow</li><li>Prepare systems for higher SLSA levels</li></ul> |
| **Requirements**  |  <ul><li>Automated build process</li><li>Supply chain is documented</li><li>Infrastructure to generate provenance data</li></ul>      |
| **Use cases**     |<ul><li><strong>Developer</strong> building and releasing locally</li><li><strong>Project</strong> releasing performed manually on maintainers’ machines</li><li><strong>Enterprise</strong> publishing applications through multiple distribution channels</li></ul> |

## Level 2: Protection for builders

**Level 2** shows more trustworthiness in the build, that there’s a build service instead of compiling locally, builders are source-aware, and signatures are used to prevent provenance being tampered with. Integrity in the build is now credible. It’s the logical place to establish more trust in a decoupled system. These requirements protect against threats like generating false or modified provenance to bypass policy checks.

![level 2](/images/SLSA-Badge-full-level2.svg)

|                   | Description |
|-------------------|-------------|
| **Goals**         | <ul><li>Establish builders as a trust boundary</li><li>Make builders source-aware</li><li>Prevent tampering</li></ul> |
| **Requirements**  |  <ul><li>Moving to a build service</li><li>Every change to the source is tracked in a version controlled system</li><li>Using cryptographic signatures verifiable by the consumer</li></ul>      |
| **Use cases**     |<ul><li><strong>Developer</strong> running open source builder instance on own infrastructure</li><li><strong>Project</strong> using a publically hosted CI</li><li><strong>Enterprise</strong> using their own internal CI</li></ul> |

## Level 3: Back to source

**Level 3** shows that a system’s builds are fully trustworthy, build definitions come from the source and a system has more hardened CI. Each build involved can be marked as fully trustworthy, and any builder compromise won’t undermine the rest of the system. Build integrity is now fully resilient, source integrity is credible but dependencies are best effort. This means mitigating against threats like compromised build environment of a subsequent build, compromised parallel builds, stealing cryptographic secrets, or building from a modified version of code changed after checkout.

![level 3](/images/SLSA-Badge-full-level3.svg)

|                   | Description |
|-------------------|-------------|
| **Goals**         | <ul><li>Isolate builds from one another within the builder</li><li>Insider with access to trigger builds can't influence build output</li></ul> |
| **Requirements**  |  <ul><li>Build definitions and configuration is defined in source control</li><li>Build service ensures the build steps ran in an ephemeral and isolated environment</li><li>Provenance can’t be falsified by the build service’s users</li><li>Provenance identifies entry point and all build parameters</li></ul>      |
| **Use cases**     |<ul><li><strong>Developer</strong> mirroring their code in a public repository and building on a public CI service</li><li><strong>Project</strong> using a publically hosted CI with isolated workers and records all build and release workflows in code</li><li><strong>Enterprise</strong> using a hardened internal CI system</li></ul> |

## Level 4: Across the chain

**Level 4** means the build environment is fully accounted for, dependencies are tracked in provenance and insider threats are ruled out. This means limiting access and input to the most critical people involved to prevent any tampering of the source, compromises and attacks, like project owners bypassing or disabling controls, platform administrators abusing privileges and pushing malicious versions of software, submitting bad code without review or evading code review requirements. Build and source integrity are fully resilient, and dependencies integrity is credible.

![level 4](/images/SLSA-Badge-full-level4.svg)

|                   | Description |
|-------------------|-------------|
| **Goals**         | <ul><li>Insider with commit access can't influence build output</li><li>Fully accounted for build environment</li><li>Ensure dependencies are tracked in provenance</li></ul> |
| **Requirements**  |  <ul><li>Every change in revision history has gone through two-person review</li><li>Build service is parameterless and hermetic</li><li>Provenance records all build dependencies available when running the build steps</li><li>Provenance includes reproducible information</li></ul>      |
| **Use cases**     |<ul><li><strong>Developer</strong> having a volunteer (maintainer) review all changes to the public mirror and makes all build dependencies content-addressed</li><li><strong>Project</strong> requiring all changes have at least one maintainer sign-off (or two community members for submissions from new contributors) and eliminates all network access during their build</li><li><strong>Enterprise</strong> requiring two-party review for all changes and vendors/pins all dependencies</li></ul> |

## Level requirements

The following table provides a summary of the [requirements](requirements.md) for each level.

| Requirement                          | SLSA 1 | SLSA 2 | SLSA 3 | SLSA 4 |
| ------------------------------------ | ------ | ------ | ------ | ------ |
| Source - [Version controlled]        |        | ✓      | ✓      | ✓      |
| Source - [Verified history]          |        |        | ✓      | ✓      |
| Source - [Retained indefinitely]     |        |        | 18 mo. | ✓      |
| Source - [Two-person reviewed]       |        |        |        | ✓      |
| Build - [Scripted build]             | ✓      | ✓      | ✓      | ✓      |
| Build - [Build service]              |        | ✓      | ✓      | ✓      |
| Build - [Build as code]              |        |        | ✓      | ✓      |
| Build - [Ephemeral environment]      |        |        | ✓      | ✓      |
| Build - [Isolated]                   |        |        | ✓      | ✓      |
| Build - [Parameterless]              |        |        |        | ✓      |
| Build - [Hermetic]                   |        |        |        | ✓      |
| Build - [Reproducible]               |        |        |        | ○      |
| Provenance - [Available]             | ✓      | ✓      | ✓      | ✓      |
| Provenance - [Authenticated]         |        | ✓      | ✓      | ✓      |
| Provenance - [Service generated]     |        | ✓      | ✓      | ✓      |
| Provenance - [Non-falsifiable]       |        |        | ✓      | ✓      |
| Provenance - [Dependencies complete] |        |        |        | ✓      |
| Common - [Security]                  |        |        |        | ✓      |
| Common - [Access]                    |        |        |        | ✓      |
| Common - [Superusers]                |        |        |        | ✓      |

<!-- markdownlint-disable MD036 -->
_○ = required unless there is a justification_

[access]: requirements.md#access
[authenticated]: requirements.md#authenticated
[available]: requirements.md#available
[build as code]: requirements.md#build-as-code
[build service]: requirements.md#build-service
[dependencies complete]: requirements.md#dependencies-complete
[ephemeral environment]: requirements.md#ephemeral-environment
[hermetic]: requirements.md#hermetic
[isolated]: requirements.md#isolated
[non-falsifiable]: requirements.md#non-falsifiable
[parameterless]: requirements.md#parameterless
[reproducible]: requirements.md#reproducible
[retained indefinitely]: requirements.md#retained-indefinitely
[scripted build]: requirements.md#scripted-build
[security]: requirements.md#security
[service generated]: requirements.md#service-generated
[superusers]: requirements.md#superusers
[two-person reviewed]: requirements.md#two-person-reviewed
[verified history]: requirements.md#verified-history
[version controlled]: requirements.md#version-controlled

## Supply chain threats

Attacks can occur at every link in a typical software supply chain, and these kinds of attacks are increasingly public, disruptive and costly in today’s environment. In developing SLSA, the requirements for each level are designed to specifically mitigate the risk of such known examples. For a much deeper technical analysis of the risks and how SLSA mitigates them, see [Threats and mitigations](threats.md).

![Supply Chain Threats]({{ site.baseurl }}/images/supply-chain-threats.svg)

Many recent high-profile attacks were consequences of supply-chain integrity vulnerabilities, and could have been prevented by SLSA's framework. For example:

|     | Threat                                                                | Known example                                                                                                                                                                                  | How SLSA can help                                                                                                                                                                                                                     |
| --- | --------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| A   | Submit bad code to the source repository                              | [Linux hypocrite commits]: Researcher attempted to intentionally introduce vulnerabilities into the Linux kernel via patches on the mailing list.                                              | Two-person review caught most, but not all, of the vulnerabilities.                                                                                                                                                                   |
| B   | Compromise source control platform                                    | [PHP]: Attacker compromised PHP's self-hosted git server and injected two malicious commits.                                                                                                   | A better-protected source code platform would have been a much harder target for the attackers.                                                                                                                                       |
| C   | Build with official process but from code not matching source control | [Webmin]: Attacker modified the build infrastructure to use source files not matching source control.                                                                                          | A SLSA-compliant build server would have produced provenance identifying the actual sources used, allowing consumers to detect such tampering.                                                                                        |
| D   | Compromise build platform                                             | [SolarWinds]: Attacker compromised the build platform and installed an implant that injected malicious behavior during each build.                                                             | Higher SLSA levels require [stronger security controls for the build platform](requirements.md#build-requirements), making it more difficult to compromise and gain persistence.                                                      |
| E   | Use bad dependency (i.e. A-H, recursively)                            | [event-stream]: Attacker added an innocuous dependency and then later updated the dependency to add malicious behavior. The update did not match the code submitted to GitHub (i.e. attack F). | Applying SLSA recursively to all dependencies would have prevented this particular vector, because the provenance would have indicated that it either wasn't built from a proper builder or that the source did not come from GitHub. |
| F   | Upload an artifact that was not built by the CI/CD system             | [CodeCov]: Attacker used leaked credentials to upload a malicious artifact to a GCS bucket, from which users download directly.                                                                | Provenance of the artifact in the GCS bucket would have shown that the artifact was not built in the expected manner from the expected source repo.                                                                                   |
| G   | Compromise package repository                                         | [Attacks on Package Mirrors]: Researcher ran mirrors for several popular package repositories, which could have been used to serve malicious packages.                                         | Similar to above (F), provenance of the malicious artifacts would have shown that they were not built as expected or from the expected source repo.                                                                                   |
| H   | Trick consumer into using bad package                                 | [Browserify typosquatting]: Attacker uploaded a malicious package with a similar name as the original.                                                                                         | SLSA does not directly address this threat, but provenance linking back to source control can enable and enhance other solutions.                                                                                                     |

[linux hypocrite commits]: https://lore.kernel.org/lkml/202105051005.49BFABCE@keescook/
[php]: https://news-web.php.net/php.internals/113838
[webmin]: https://www.webmin.com/exploit.html
[solarwinds]: https://www.crowdstrike.com/blog/sunspot-malware-technical-analysis/
[event-stream]: https://schneider.dev/blog/event-stream-vulnerability-explained/
[codecov]: https://about.codecov.io/apr-2021-post-mortem/
[attacks on package mirrors]: https://theupdateframework.io/papers/attacks-on-package-managers-ccs2008.pdf
[browserify typosquatting]: https://blog.sonatype.com/damaging-linux-mac-malware-bundled-within-browserify-npm-brandjack-attempt

A SLSA level helps give consumers confidence that software has not been tampered with
and can be securely traced back to source—something that is difficult, if not
impossible, to do with most software today.

## Limitations

SLSA can help reduce supply chain threats in a software artifact, but there are limitations.

-   There are a significant number of dependencies in the supply chain for many artifacts. The full graph of dependencies could be intractably large.
-   In practice, a team working on security will need to identify and focus on the important components in a supply chain. This can be performed manually, but the effort could be significant.
-   An artifact’s SLSA level is not transitive ([see our FAQs](../faq.md)) and dependencies have their own SLSA ratings. This means that it is possible for a SLSA 4 artifact to be built from SLSA 0 dependencies. So, while the main artifact has strong security, risks may still exist elsewhere. The aggregate of these risks will help software consumers understand how and where to use the SLSA 4 artifact.
-   While automation of these tasks will help, it isn’t practical for every software consumer to fully vet the entire graph of every artifact. To close this gap, auditors and accreditation bodies could verify and assert that something meets the SLSA requirements. This could be particularly valuable for closed source software.

As part of our roadmap, we’ll explore how to identify important components, how to determine aggregate risk throughout a supply chain, and the role of accreditation.
