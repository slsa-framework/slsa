---
title: "Mini Shai-Hulud: Where SLSA's Boundaries Fall"
author: "Andrew McNamara (Red Hat)"
is_guest_post: false
ai_assisted: "Claude (Anthropic)"
excerpt: "The Mini Shai-Hulud npm supply chain attack chained GitHub Actions misconfiguration, cache poisoning, and OIDC token theft to publish malicious packages under legitimate identities. The compromised packages carried cryptographically valid SLSA build provenance attestations — but the build platform behind them did not meet SLSA Build L3 isolation requirements, and one that did would have blocked the primary attack vector. This post maps what SLSA's levels actually guarantee, where layering policy closes additional gaps, and what falls entirely outside the framework's scope."
---

On May 11, 2026, attackers compromised 84 npm package artifacts across 42 `@tanstack` packages, and the worm spread to 170+ packages across `@mistralai`, `@uipath`, and other namespaces. The "Mini Shai-Hulud" attack chained a GitHub Actions workflow misconfiguration, cache poisoning, and OIDC token extraction to publish malicious packages through legitimate CI/CD pipelines.

Several reports described these packages as carrying "valid SLSA Build Level 3 attestations." The attestations were cryptographically valid: the attacker extracted the legitimate OIDC token from runner memory and signed through Sigstore, producing attestations indistinguishable from the real thing. But the build platform that generated them did not meet SLSA Build L3 isolation requirements, and a platform that did would have prevented this specific attack vector. A signed artifact is not necessarily a trustworthy one. Some gaps SLSA cannot close on its own are addressable by layering policy on top; others require different controls entirely. This post maps where those boundaries fall.

## What happened

The attack exploited three weaknesses in sequence.[^1]

1.  **Pwn Request:** TanStack's `bundle-size.yml` workflow used the `pull_request_target` trigger, which runs fork-contributed code in the base repository's security context. The attacker opened a pull request from a fork and executed malicious code within the trusted repository.

2.  **Cache poisoning:** The malicious code poisoned the pnpm package store under the cache key that the legitimate `release.yml` workflow would later restore. GitHub Actions shares cache scope across trigger types, so the release workflow consumed the poisoned cache unknowingly.

3.  **OIDC token extraction:** When the release workflow ran with `id-token: write` permission, attacker-controlled code from the poisoned cache scraped the runner process memory, extracted the ambient OIDC token, and published directly to npm, bypassing the workflow's conditional publish logic entirely.

The result: 84 malicious packages published under the legitimate TanStack identity, carrying npm provenance attestations that pointed to the correct repository, workflow, and ref.

## Did valid SLSA provenance protect against these exploits?

No. Understanding why matters.

The compromised packages carried cryptographically valid attestations: the attacker used the legitimate OIDC token, extracted from runner memory mid-workflow, to authenticate to Sigstore's Fulcio CA and sign through npm's trusted publishing infrastructure. The resulting attestations accurately reported the builder (`github.com/actions/runner/github-hosted`), the repository (`TanStack/router`), and the workflow (`release.yml@refs/heads/main`). They were indistinguishable from attestations on legitimate packages.

The issue is not the attestations; it is the build platform behind them. The attestations are a record of what the build platform observed. When attacker-controlled code runs inside that platform, the observations are accurate but the build was compromised. SLSA Build L3 addresses this by requiring that the build platform guarantee [isolation](/spec/v1.2/build-requirements#isolated): no external influence can alter the build except through declared parameters. Specifically:

-   It MUST NOT be possible for one build to inject false entries into a build cache used by another build, also known as "cache poisoning."
-   It MUST NOT be possible for a build to access any secrets of the build platform, such as the provenance signing key.
-   It MUST NOT be possible for one build to persist or influence the build environment of a subsequent build.

The TanStack attack violated all three properties. A prior workflow run poisoned the cache; the build exposed the OIDC signing identity; and the attacker's code persisted through the shared cache. A build system meeting SLSA Build L3 requirements would have prevented the cache poisoning vector that enabled this attack.

npm's built-in provenance achieves [Build L2](/spec/v1.2/levels): the build runs on a hosted platform and provenance is authenticated. That is a real and meaningful guarantee. L2 provenance binds a package to its canonical source repository and build system, which is why it protects effectively against dependency confusion attacks where an attacker registers an impostor package but cannot produce provenance from the legitimate source. What L2 does not require is isolation. The build platform need not guarantee that builds cannot influence one another, or that signing credentials are inaccessible to the build steps. Those are L3 requirements, and the TanStack attack exploited exactly that gap. To protect against this class of attack, use a builder that enforces cache isolation between builds at the platform level and keeps the signing identity structurally inaccessible to the build process.

## What SLSA can help with

SLSA provenance lets consumers verify that a specific builder from a specific source repository produced a package. Consumers who enforce policies requiring an [expected builder](/spec/v1.2/verifying-artifacts#forming-expectations), rather than merely checking that *some* valid attestation exists, can detect anomalies like packages built through a non-standard pipeline.

SLSA's [threat model](/spec/v1.2/threats) also explicitly identifies [build cache poisoning](/spec/v1.2/threats#poison-the-build-cache) as a threat addressed at Build L3. The spec requires builds to isolate caches between runs, ideally keyed by the transitive closure of all inputs. Build platforms that meet this requirement would have blocked the primary vector in this attack.

The leveled approach gives teams a concrete path forward. L2 closes the dependency confusion problem: an attacker cannot forge provenance from a source repository they do not control. L3 closes the isolation problem: the build platform must guarantee that builds cannot influence one another and that signing credentials cannot be reached from within the build. A compromised build cannot reach the signing key or corrupt the builds that follow. Moving from L2 to L3 directly addresses the class of attack used here.

L3 isolation is a platform guarantee: did the platform faithfully transform the source code into a package? It does not ensure the source code or build configuration is well-intentioned. Verifying that the build did what was intended still requires examining the provenance properties: what source was built, which parameters were declared, which steps ran. Isolation makes those observations trustworthy; evaluating them is the consumer's responsibility.

The L2/L3 distinction comes down to who you trust. At L2, you trust each individual developer. The build platform signs provenance from its control plane, but the build environment is tenant-controlled, so a developer who can influence the pipeline can compromise the build. At L3, you trust the platform instead. The spec requires every provenance field to be "generated or verified by the build platform in a trusted control plane," making provenance "strongly resistant to forgery by tenants" as a structural property, not a social one. GitHub's current path to Build L3 illustrates the subtlety: developers must invoke a shared reusable workflow rather than author their own, which shifts trust from each individual developer to whoever controls that shared workflow. The attack surface narrows, but the trust root moves rather than disappears.

## What SLSA alone cannot address

SLSA provenance records evidence. It answers "what happened?" Policy and verification answer "was that good enough?" A build provenance attestation tells you which builder ran, from which source, with which parameters. It does not tell you whether what ran was the code the producer intended to run. Once attacker-controlled code runs inside a trusted workflow, SLSA's build-time guarantees are already behind them. The attacker hijacked the pipeline that legitimately produces provenance, rather than forging provenance from outside. No amount of policy on the resulting attestation recovers from that: the evidence is accurate, but the build was not what the producer intended.

Build platforms can accurately record what ran within their trust boundary, but they cannot vouch for whether what ran produced an uncompromised artifact. The boundary of observability is the boundary of the trust context. This constraint has been discussed in presentations from the community, including [Dirty Dancing: Untrustworthy SLSA Build Provenance](https://colocatedeventsna2025.sched.com/event/28D22/) and [From Mild to Wild: How Hot Can Your SLSA Be?](https://colocatedeventseu2026.sched.com/event/2DY1G/). The Mini Shai-Hulud attack is a concrete public example of that limitation.

SLSA also does not evaluate whether a workflow's trigger configuration is safe or whether its permissions are least-privileged. While SLSA Build L3 would have mitigated this attack, the `pull_request_target` misconfiguration that initiated this attack falls entirely outside SLSA's scope and is a well known vector for other attacks (e.g. publishing credential theft) beyond the build itself.

## What policy on top of SLSA can address

SLSA records evidence; policy decides what is acceptable.

SLSA v1.2's [Source Track](/spec/v1.2/source-requirements) addresses the risk of malicious code being approved and merged, whether by exploiting a weak review process, compromising a maintainer account, or submitting a convincing-looking PR. The Source Track records evidence about how a commit was created: whether branch protection was active, whether review requirements were met, and which identities were involved. A policy engine that requires source attestations alongside build provenance means an attacker who compromises the source repository still needs to satisfy source-level requirements, including review, attribution, and continuity, before the artifact is accepted downstream. Build provenance and source provenance are complementary; policy is what connects them.

Policy on expected builders and build parameters narrows the blast radius of a compromised pipeline, but not in the way this incident might suggest. In the TanStack incident, the attestations accurately named the expected builder, repository, and workflow. An "expected builder" check would have passed, because the pipeline was legitimate; it was the code running inside it that was not. What would have flagged an anomaly is checking the workflow run outcome after the fact: both runs that published malicious packages completed with `status: failure`, yet packages were published during them. Standard SLSA consumer tooling does not check workflow run status, but monitoring for publish events from failed workflow runs would have detected this within minutes. This is not a complete defense: an attacker who fully controls code inside a trusted builder on the expected ref can still produce conforming provenance. But operational monitoring raises the bar substantially above "a valid signature exists."

Well-formed provenance still leaves trust decisions unresolved: whether the source code contains known vulnerabilities, whether dependencies were themselves compromised. Additional attestation types fill those gaps. Vulnerability scan results, code review attestations, and SBOM attestations each address a dimension build provenance cannot cover. The OpenSSF [ORBIT working group](https://openssf.org/groups/orbit/) is working through these interoperability challenges. Comprehensive verification is expensive, though, and few organizations can re-verify every attestation in their dependency graph independently. Verification Summary Attestations (VSAs) make this tractable: a trusted verifier combines multiple attestation types, makes a determination, and publishes a single signed summary that consumers check instead of re-verifying every underlying claim.

Rebuilders take a different approach: independent parties build from the same source on their own isolated infrastructure and publish the results to their own repositories. Because they do not share the original pipeline's build environment, platform-specific compromises such as the cache poisoning in this attack do not propagate to them. A consumer pulling from a trusted rebuilder's repository rather than the original is therefore insulated from that pipeline's integrity failures. Where builds are reproducible, a rebuilder's successful reproduction is a strong complement to provenance: the original and rebuilt artifacts can be compared, and a poisoned build would produce a divergent output that a clean rebuild would not match.

## Defense in depth

The controls above extend SLSA's foundation through policy. What follows is a different layer: operational choices that determine whether the foundation is sound.

Start with builder choice. L2 builders generate provenance within the build's own trust context; L3 builders act as external observers, signing with keys the build cannot reach. Verify which level your builder actually achieves, and prefer builders where the signing identity is structurally inaccessible to the build process.

Workflow hygiene is a separate, necessary layer. Workflows that use `pull_request_target` to execute fork code grant untrusted contributors access to the repository's security context. Avoid this pattern or gate it carefully. Apply least-privilege permissions to every workflow, and pin action versions by digest so upstream compromises cannot silently change behavior. Treat shared caches as a cross-workflow trust boundary and scope them accordingly.[^2]

Monitoring fills what neither SLSA nor policy can anticipate. The malicious TanStack releases came from workflow runs that ended in failure: the workflow's own test step caught a problem, but the stolen OIDC token had already published the packages. An alert on publish events from failed workflow runs could have cut the exposure window by hours.

Two assumptions failed: that generating provenance is the same as meeting the isolation requirements provenance depends on, and that meeting those requirements is sufficient on its own. SLSA's levels, the policy layer above them, and the operational controls that make both meaningful are distinct things. The controls to close most of those gaps exist today.

[^1]: TanStack's [postmortem](https://tanstack.com/blog/npm-supply-chain-compromise-postmortem) and the [GitHub security advisory GHSA-g7cv-rxg3-hmpx](https://github.com/advisories/GHSA-g7cv-rxg3-hmpx) provide the primary account. Additional analysis is available from [Snyk](https://snyk.io/blog/tanstack-npm-packages-compromised/), [StepSecurity](https://www.stepsecurity.io/blog/mini-shai-hulud-is-back-a-self-spreading-supply-chain-attack-hits-the-npm-ecosystem), and [Socket](https://socket.dev/blog/tanstack-npm-packages-compromised-mini-shai-hulud-supply-chain-attack).

[^2]: TanStack's [hardening follow-up](https://tanstack.com/blog/incident-followup) documents the specific remediations applied after the incident, including removing `pull_request_target`, pinning all actions to commit SHAs, enforcing phishing-resistant 2FA, and adding automated workflow security scanning with `zizmor`.
