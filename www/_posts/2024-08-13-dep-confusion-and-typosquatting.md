---
title: "Defender's Perspective: Dependency Confusion and Typosquatting Attacks"
author: "Meder Kydyraliev (Google)"
is_guest_post: false
---

_Dependency confusion_ and _typosquatting_ attacks are very similar in their nature. They both exploit the weakness in the way many package managers identify packages using only their names. Successfully exploiting this weakness enables the attacker to run arbitrary code at install time or at application's run time. These attacks are scalable, portable, and extremely cost-effective to carry out—making them very appealing to malicious actors.

This blog post explores the attacks from the defender's perspective and highlights how SLSA can be used to help defend against them. It also describes some additional capabilities which might be required to mitigate this and other supply chain risks more robustly.

## What is Dependency Confusion?

The convenience of package registries has been recognized by developers and organizations worldwide as an effective way to manage and distribute internally developed software packages using existing tooling. One common approach involves running an internal, private instance of a package registry to distribute internal dependencies and configuring **_all_** build processes to first look for a package in the private registry and only if it is not found there going to the public instance of the package registry to fetch it[^1].

This works but is fragile. If someone in the organization attempts to build software that uses internal packages but doesn't correctly configure the build to use the private registry instance first then the package installer will attempt to fetch internal packages from the public registry instance. Under normal circumstances this will return an error, as the internal package name would not be present in the public instance.

### The Attack

The attacker begins by performing reconnaissance to acquire names of internal packages. This can be done using a number of techniques, e.g., trawling through organization's open source repositories, inspecting shipped software or simply guessing the names. Once the attacker has the names of internal packages, they register these targeted packages with the public registry and release a new version with a malicious payload. At this point the attacker has to wait for one of the misconfigured builds to run and use the attacker's package — resulting in compromise. Effective use of this technique is described in detail in blog posts such as [Dependency Confusion: How I Hacked Into Apple, Microsoft and Dozens of Other Companies](https://medium.com/@alex.birsan/dependency-confusion-4a5d60fec610).

## What is Typosquatting?

The workflow for developers to add a new dependency to a software project commonly involves modification of a manifest file to list the new package by its name and version. The package name is usually manually typed in, copied/pasted from the web, or added by the IDE. Most of the input modes that involve humans are prone to transcription errors and typos, ranging from missing hyphens, lookalike characters, to transposed letters. Under normal circumstances the build would fail if a non-existent dependency is requested.

### The Attack

The attacker pre-registers (or "squats") a large number of package names with commonly seen typos in them—usually using popular package names as the starting point—and waits for victims to install their packages. The attack is opportunistic since, unlike dependency confusion, it doesn't target a specific organization. Notably, however, unlike dependency confusion, this attack has the potential to result in a more severe and hard to detect compromise. Public availability of packages that attackers target for squatting enables them to distribute original copies of the targeted packages and only deliver malicious payload at a later date by releasing an update. This attack vector can result in applications incorporating and using the attacker's package in production.

There are a number of potential vectors that attackers can use as the source of names to squat on to increase the chances of success, e.g. package names popular in other ecosystems, variants of the package name used by Linux distributions or OSS package names "hallucinated" by LLMs.

## Mitigations

The fragility of just using package names as the way to identify software packages is hopefully obvious by now. Let's first explore common recommendations([1](https://fossa.com/blog/dependency-confusion-understanding-preventing-attacks/), [2](https://www.activestate.com/blog/how-to-prevent-dependency-confusion/)). to mitigate _dependency confusion_ attacks and their limitations:

-   **Namespacing:** Some package registries support namespacing, sometimes called scoping or organization support. This feature enables organizations to claim a namespace in the public registry for their internal dependencies. This prevents attackers from registering internal names, as they are not authorized to publish to the organization's namespace. Confidentiality concerns would likely prevent large organizations, that are usually targeted by the dependency confusion attacks, from hosting internal dependencies in the public instance; claiming the namespace is, however, sufficient to prevent attackers from exploiting dependency confusion. Namespacing is not supported by all package registries, and moreover the solution is not very robust as trust is placed into another forgeable identifier outside of the organization's control.
-   **Registering internal names in the public registry:** a common practical workaround for registries that lack namespacing support is for organizations to do what the attackers do and claim internal package names in the public registry instance to prevent attackers from doing so. This recommendation doesn't address the root cause of dependency confusion attacks and requires ongoing coordination and synchronization of the names between public and private registries, which is fragile.
-   **Pinning or hash validation:** some client-side tooling supports pinning or locking of dependencies by hash. Both internal and external dependencies will be listed in the lockfile. Effectively preventing a dependency confusion attack using lockfiles requires all updates to the lock file to ensure that hashes for internal packages match the list of authorized hashes for that package. Not all ecosystems universally support pinning with lockfiles, and even those that do may lack the functionality to manage and distinguish between internal and external dependencies.

In case of _typosquatting_ attacks the mitigation is not very straightforward and for the most part requires intervention at the point when developers are adding a new dependency. Effective mitigation could involve presenting the developer with metadata about the package being added (e.g. number of dependents, downloads) and prompting them to verify and ensure that the package being installed is the one that developer intended. This unscalable approach is prone to human errors, which can happen for reasons ranging from time pressure and fatigue to the lack of security expertise and simple misreading of key parts of metadata.

### SLSA

Now let's look at how SLSA's **existing** controls can can be used to prevent each of the attacks.

#### Dependency Confusion

A much more robust way to address dependency confusion is to use SLSA. SLSA build provenance contains metadata about an artifact, which includes the URL of the source repository and identifies the build system that produced the artifact. This metadata enables secure binding of the package name and version to the canonical source repository and its build system, which is referred to as [expectations forming](/spec/v1.0/verifying-artifacts#forming-expectations) in SLSA.

Let's examine how SLSA build provenance prevents successful dependency confusion exploitation:

1.  Organization defines a policy for its internal packages by binding each package to the authorized builder and the expected canonical source repository.
2.  Organization's internal packages are built with a SLSA-compliant build system, which produces SLSA build provenance.
3.  SLSA build provenance is [distributed along with the artifact](/spec/v1.0/distributing-provenance), e.g. by the internal registry instance.
4.  Upon installation of the internal packages their build provenance is verified aginst the policy defined earlier. The verification ensures that the internal packages were built by the authorized build system using source code from the canonical source repository.

Attackers are unable to forge SLSA Level 2+ build provenance thus all dependency confusion attempts will be immediately detected due to a different canonical source repository or builder ID. Native support for SLSA build provenance and its verification in ecosystems like npm will enable this robust form of protection against dependency confusion attacks.

#### Typosquatting

Dealing with typosquatting attacks is trickier because at the time of the attack the developer is adding a new dependency, potentially interacting with it for the first time. Trust on first use (TOFU) is a common approach to bootstrapping trust and [forming expectations](/spec/v1.0/verifying-artifacts#forming-expectations), however, since it's impossible to know the developer's intent, all tooling can do is present them with the metadata about the package they are adding. Unfortunately that metadata could be for the attacker's impostor package.

Effective mitigation of typosquatting attacks requires ongoing integration of heuristics to proactively flag packages that appear like typosquatting attempts into all workflows that add new dependencies. Heuristics could range from evaluation over static data (e.g. package age) to ones requiring more time and resources (e.g. graph resolution or dynamic analysis). Managed ingestion, described below, is one very efficient and effective way to deploy such protections across larger enterprises.

### Managed Ingestion

Effective OSS supply chain security risk management hinges on an organization's ability to control what OSS can be used in an organization's products. This concept is not new, as it mirrors the approach taken in food supply chain management, where control over the ingredients included in food products is paramount. The concept is also reflected in [OpenSSF's s2c2f framework](https://github.com/ossf/s2c2f), which highlights control over ingestion in organizations as a crucial first step towards securing their software supply chains.

For a typical build process this means control over resolution of the OSS dependency graph and retrieval of the resolved dependencies from the Internet. Historically both processes lacked explicit control and transparency leading to a significant level of trust being placed in package managers and their associated registries.

Managed ingestion describes a dedicated deliberate process that happens separately from the build and involves an organization importing and assessing OSS packages before making them available to developers internally. While there is more than one way to implement managed ingestion, combining managed ingestion with existing artifact management solutions creates a very potent capability that provides organizations with control over the graph resolution and an opportunity for centralized supply chain risk management. Native support for different package ecosystems provided by most modern artifact management solutions ensures compatibility with most existing build and dependency management tools.

In this context, based on practical experience, managed ingestion needs to provide the following capabilities:

-   **Implementation of an ingestion delay** for new versions of OSS packages. A simple but very effective mitigation against a number of supply chain attacks.
-   **Mitigation of availability concerns** ensuring organizations are able to build and deploy even if upstream infrastructure is down.
-   **Mitigation of dependency confusion attacks** by flagging upstream packages whose names clash with internal package names or that fail SLSA build provenance verification.
-   **Mitigation of typosquatting** attacks by flagging upstream packages based on heuristics.
-   Opportunity to **deploy existing content scanning tools on OSS packages** to flag known indicators of maliciousness or unexpected changes (e.g. changes in capabilities reported by [CAPSLOCK](https://github.com/google/capslock)).

The process of using OSS packages via registries presents a lot of risks beyond typosquatting and dependency confusion—and requires the same level of attention and control as the build process itself. Managed ingestion is the fundamental capability required to successfully manage OSS supply chain risk. As part of the ongoing [SLSA dependencies track](https://github.com/slsa-framework/slsa/issues/961) effort we will work to formalize these concepts, including [those from s2c2f](https://github.com/slsa-framework/slsa/issues/1105), within the SLSA specification.

<!-- Footnotes themselves at the bottom. -->
## Notes

[^1]: Multi-registry behaviour is ecosystem and configuration specific, e.g. PyPI configured with the discouraged --extra-index-url flag would pick the highest version if a package is present in private and public instance. Overall the mechanics of the attack remain the same.
