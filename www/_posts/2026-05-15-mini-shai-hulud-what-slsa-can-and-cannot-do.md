---
title: "What the Mini Shai-Hulud Campaign Teaches Us About SLSA"
author: "SLSA Contributors"
is_guest_post: false
---

On May 11, 2026, attackers compromised 84 npm package artifacts across 42 `@tanstack` packages — and the worm spread to 170+ packages across `@mistralai`, `@uipath`, and other namespaces. The "Mini Shai-Hulud" attack chained together a GitHub Actions workflow misconfiguration, cache poisoning, and OIDC token extraction to publish malicious packages through legitimate CI/CD pipelines.

Several reports described these packages as carrying "valid SLSA Build Level 3 attestations." They did not — a build platform that met those requirements would have blocked the cache poisoning that enabled this attack. A signed artifact is not a trustworthy one. Some gaps SLSA cannot close on its own are addressable by layering policy on top; others require different controls entirely. This post maps where those boundaries fall.

## What happened

The attack exploited three weaknesses in sequence.[^1]

1.  **Pwn Request:** TanStack's `bundle-size.yml` workflow used the `pull_request_target` trigger, which runs fork-contributed code in the base repository's security context. The attacker opened a pull request from a fork and executed malicious code within the trusted repository.

2.  **Cache poisoning:** The malicious code poisoned the pnpm package store under the cache key that the legitimate `release.yml` workflow would later restore. GitHub Actions shares cache scope across trigger types, so the release workflow consumed the poisoned cache unknowingly.

3.  **OIDC token extraction:** When the release workflow ran with `id-token: write` permission, attacker-controlled code from the poisoned cache scraped the runner process memory, extracted the ambient OIDC token, and published directly to npm — bypassing the workflow's conditional publish logic entirely.

The result: 84 malicious packages published under the legitimate TanStack identity, carrying npm provenance attestations that pointed to the correct repository, workflow, and ref.

## Were these packages actually SLSA Build Level 3?

No. Understanding why matters.

The compromised packages carried [npm provenance](https://docs.npmjs.com/generating-provenance-statements), which runs provenance generation within the caller's own workflow. SLSA Build L3 requires that the build platform guarantee [isolation](/spec/v1.2/build-requirements#isolated) — that no external influence can alter the build except through declared parameters. Specifically, SLSA Build L3 requires:

-   It MUST NOT be possible for one build to inject false entries into a build cache used by another build, also known as "cache poisoning."
-   It MUST NOT be possible for a build to access secrets of the build platform, such as provenance signing keys.
-   It MUST NOT be possible for one build to persist or influence the build environment of a subsequent build.

The TanStack attack violated all three properties. A prior workflow run poisoned the cache, the build exposed the OIDC signing identity, and the attacker's code persisted through the shared cache. A build system meeting SLSA Build L3 requirements would have prevented the cache poisoning vector that enabled this attack.

npm's built-in provenance achieves [Build L2](/spec/v1.2/levels): the build runs on a hosted platform and provenance is authenticated. That is a real and meaningful guarantee — L2 provenance binds a package to its canonical source repository and build system, which is why it protects effectively against dependency confusion attacks where an attacker registers an impostor package but cannot produce provenance from the legitimate source. What L2 does not require is isolation. The build platform need not guarantee that builds cannot influence one another, or that signing credentials are inaccessible to the build steps. Those are L3 requirements, and the TanStack attack exploited exactly that gap. To protect against this class of attack, use a builder that enforces cache isolation between builds at the platform level and keeps the signing identity structurally inaccessible to the build process.

## What SLSA can help with

SLSA provenance lets consumers verify that a specific builder from a specific source repository produced a package. Consumers who enforce policies requiring an [expected builder](/spec/v1.2/verifying-artifacts#forming-expectations) — rather than checking merely that *some* valid attestation exists — can detect anomalies like packages built through a non-standard pipeline.

SLSA's [threat model](/spec/v1.2/threats) also explicitly identifies [build cache poisoning](/spec/v1.2/threats#poison-the-build-cache) as a threat addressed at Build L3. The spec requires that builds isolate caches between runs, ideally keyed by the transitive closure of all inputs. Build platforms that meet this requirement would have blocked the primary vector in this attack.

The leveled approach gives teams a concrete path forward. L2 closes the dependency confusion problem — an attacker cannot forge provenance from a source repository they do not control. L3 closes the isolation problem — the build platform must guarantee that builds cannot influence one another and that signing credentials cannot be reached from within the build. Moving from L2 to L3 directly addresses the class of attack used here.

## What SLSA alone cannot address

SLSA provenance records evidence — it answers "what happened?" Policy and verification answer "was that good enough?" An attestation tells you which builder ran, from which source, with which parameters. It does not tell you whether what ran was the code the producer intended to run. Once attacker-controlled code runs inside a trusted workflow, SLSA's build-time guarantees are already behind them. The attacker here hijacked the pipeline that legitimately produces provenance, rather than forging provenance from outside. No amount of policy on the resulting attestation recovers from that: the evidence is accurate, but what happened was not what the producer intended.

Build platforms can accurately record what ran within their trust boundary, but cannot vouch for whether what ran produced an uncompromised artifact — the boundary of observability is the boundary of the trust context. This constraint has been discussed in the community, including in [Dirty Dancing: Untrustworthy SLSA Build Provenance](https://colocatedeventsna2025.sched.com/event/28D22/) and [From Mild to Wild: How Hot Can Your SLSA Be?](https://colocatedeventseu2026.sched.com/event/2DY1G/). The Mini Shai-Hulud attack is a concrete public example of that limitation.

SLSA also does not evaluate whether a workflow's trigger configuration is safe, whether its permissions are least-privileged, or whether its caching strategy creates cross-workflow trust boundaries. The `pull_request_target` misconfiguration that initiated this attack falls outside SLSA's scope entirely: it is a workflow authoring error, not a build platform integrity failure.

## What policy on top of SLSA can address

SLSA records evidence; policy decides what is acceptable. Several gaps that SLSA leaves narrow when a policy layer is added.

SLSA v1.2's [Source Track](/spec/v1.2/source-requirements) addresses the risk of malicious code being approved and merged — whether by exploiting a weak review process, compromising a maintainer account, or submitting a convincing-looking PR. The Source Track records evidence about how a commit was created: whether branch protection was active, whether review requirements were met, and which identities were involved. A policy engine that requires source attestations alongside build provenance means an attacker who compromises the source repository still needs to satisfy source-level requirements — review, attribution, and continuity — before the artifact is accepted downstream. Build provenance and source provenance are complementary; policy is what connects them.

Policy on expected builders and build parameters also narrows the blast radius of a compromised pipeline. In the TanStack incident, the attacker published directly to npm using a stolen OIDC token — outside the workflow's normal publish step, during a run that ended in failure. A consumer policy requiring provenance from a specific expected builder, or requiring that the build completed successfully, would have flagged that anomaly. This is not a complete defense — an attacker who fully controls code inside a trusted builder on the expected ref can still produce conforming provenance — but it raises the bar substantially above "a valid signature exists."

Well-formed provenance still leaves trust decisions unresolved: whether the source code contains known vulnerabilities, whether dependencies were themselves compromised. Additional attestation types fill those gaps — vulnerability scan results, code review attestations, and SBOM attestations each address a dimension build provenance cannot cover. The [OpenSSF Security Toolbelt](https://openssf.org/) aims to compose these signals. Comprehensive verification is expensive, though, and few organizations can re-verify every attestation in their dependency graph independently. Verification Summary Attestations (VSAs) make this tractable: a trusted verifier combines multiple attestation types, makes a determination, and publishes a single signed summary that consumers check instead of re-verifying every underlying claim.

Rebuilders take a different approach. Independent parties build from the same source and compare outputs — if they match, the result is trustworthy without requiring trust in any single build environment. Where reproducible builds are achievable, this is a strong complement to provenance.

## Defense in depth

The controls above extend SLSA's foundation through policy. What follows is a different layer: operational choices that determine whether the foundation is sound.

Start with builder choice. L2 builders generate provenance within the build's own trust context; L3 builders act as external observers, signing with keys the build cannot reach. Verify which level your builder actually achieves, and prefer builders where the signing identity is structurally inaccessible to the build process.

Workflow hygiene is a separate, necessary layer. Workflows that use `pull_request_target` to execute fork code grant untrusted contributors access to the repository's security context — avoid this pattern or gate it carefully. Apply least-privilege permissions to every workflow, and pin action versions by digest so upstream compromises cannot silently change behavior. Treat shared caches as a cross-workflow trust boundary and scope them accordingly.[^2]

Monitoring fills what neither SLSA nor policy can anticipate. The malicious TanStack releases came from workflow runs that ended in failure — the workflow's own test step caught a problem, but the stolen OIDC token had already published the packages. An alert on publish events from failed workflow runs could have cut the exposure window by hours.

What failed was the assumption that generating provenance is the same as meeting the isolation requirements provenance depends on — and separately, that meeting those requirements is sufficient on its own. SLSA's levels, the policy layer above them, and the operational controls that make both meaningful are distinct things. The controls to close most of those gaps exist today.

[^1]: TanStack's [postmortem](https://tanstack.com/blog/npm-supply-chain-compromise-postmortem) and the [GitHub security advisory GHSA-g7cv-rxg3-hmpx](https://github.com/advisories/GHSA-g7cv-rxg3-hmpx) provide the primary account. Additional analysis is available from [Snyk](https://snyk.io/blog/tanstack-npm-packages-compromised/), [StepSecurity](https://www.stepsecurity.io/blog/mini-shai-hulud-is-back-a-self-spreading-supply-chain-attack-hits-the-npm-ecosystem), and [Socket](https://socket.dev/blog/tanstack-npm-packages-compromised-mini-shai-hulud-supply-chain-attack).

[^2]: TanStack's [hardening follow-up](https://tanstack.com/blog/incident-followup) documents the specific remediations applied after the incident, including removing `pull_request_target`, pinning all actions to commit SHAs, enforcing phishing-resistant 2FA, and adding automated workflow security scanning with `zizmor`.
