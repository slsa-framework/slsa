---
title: Threats and mitigations
prev_page:
    title: Requirements
    url: requirements
next_page:
    title: Frequently Asked Questions
    url: faq
---
<div class="subtitle">

Attacks can occur at every link in a typical software supply chain, and these
kinds of attacks are increasingly public, disruptive, and costly in today's
environment.

</div>

SLSA's [levels](levels.md) are designed to mitigate the risk of these attacks.
This page enumerates possible attacks throughout the supply chain and shows how
SLSA can help. For a background, see [Terminology](terminology.md).

## Summary

![Supply Chain Threats](../../images/supply-chain-threats.svg)

SLSA's primary focus is supply chain integrity, with a secondary focus on
availability. Integrity means protection against tampering or unauthorized
modification at any stage of the software lifecycle. Within SLSA, we divide
integrity into source integrity vs build integrity.

**Source integrity:** Ensure that all changes to the source code reflect the
intent of the software producer. Intent of an organization is difficult to
define, so SLSA approximates this as approval from two authorized
representatives.

**Build integrity:** Ensure that the package is built from the correct,
unmodified sources and dependencies according to the build recipe defined by the
software producer, and that artifacts are not modified as they pass between
development stages.

**Availability:** Ensure that the package can continue to be built and
maintained in the future, and that all code and change history is available for
investigations and incident response.

### Real-world examples

Many recent high-profile attacks were consequences of supply-chain integrity vulnerabilities, and could have been prevented by SLSA's framework. For example:

<table>
<thead>
<tr>
<th>
<th>Integrity threat
<th>Known example
<th>How SLSA can help
<tbody>
<tr>
<td>A
<td>Submit unauthorized change (to source repo)
<td><a href="https://lore.kernel.org/lkml/202105051005.49BFABCE@keescook/">Linux hypocrite commits</a>: Researcher attempted to intentionally introduce vulnerabilities into the Linux kernel via patches on the mailing list.
<td>Two-person review caught most, but not all, of the vulnerabilities.
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
<td>Compromise build process
<td><a href="https://www.crowdstrike.com/blog/sunspot-malware-technical-analysis/">SolarWinds</a>: Attacker compromised the build platform and installed an implant that injected malicious behavior during each build.
<td>Higher SLSA levels require <a href="requirements#build-requirements">stronger security controls for the build platform</a>, making it more difficult to compromise and gain persistence.
<tr>
<td>E
<td>Use compromised dependency (i.e. A-H, recursively)
<td><a href="https://web.archive.org/web/20210909051737/https://schneider.dev/blog/event-stream-vulnerability-explained/">event-stream</a>: Attacker added an innocuous dependency and then later updated the dependency to add malicious behavior. The update did not match the code submitted to GitHub (i.e. attack F).
<td>Applying SLSA recursively to all dependencies would have prevented this particular vector, because the provenance would have indicated that it either wasn't built from a proper builder or that the source did not come from GitHub.
<tr>
<td>F
<td>Upload modified package (not matching build process)
<td><a href="https://about.codecov.io/apr-2021-post-mortem/">CodeCov</a>: Attacker used leaked credentials to upload a malicious artifact to a GCS bucket, from which users download directly.
<td>Provenance of the artifact in the GCS bucket would have shown that the artifact was not built in the expected manner from the expected source repo.
<tr>
<td>G
<td>Compromise package repo
<td><a href="https://theupdateframework.io/papers/attacks-on-package-managers-ccs2008.pdf">Attacks on Package Mirrors</a>: Researcher ran mirrors for several popular package repositories, which could have been used to serve malicious packages.
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
<th>How SLSA can help
<tbody>
<tr>
<td>E
<td>Dependency becomes unavailable
<td><a href="https://www.techradar.com/news/this-popular-code-library-is-causing-problems-for-hundreds-of-thousands-of-devs">Mimemagic</a>: Maintainer intentionally removes package or version of package from repository with no warning. Network errors or service outages may also make packages unavailable temporarily.
<td>SLSA does not directly address this threat.
</table>

A SLSA level helps give consumers confidence that software has not been tampered
with and can be securely traced back to source—something that is difficult, if
not impossible, to do with most software today.

## Threats in detail

> **IMPORTANT:** This is a work in progress.

What follows is a comprehensive technical analysis of supply chain threats and
their corresponding mitigations in SLSA. The goals are to:

-   Explain the reasons for each of the SLSA [requirements](requirements.md).
-   Increase confidence that the SLSA requirements are sufficient to achieve the
    desired [level](levels.md) of integrity protection.
-   Help implementers better understand what they are protecting against so that
    they can better design and implement controls.

<article class="threats">

## Source integrity threats

A source integrity threat is a potential for an adversary to introduce a change
to the source code that does not reflect the intent of the software producer.
This includes the threat of an authorized developer introducing an unauthorized
change—in other words, an insider threat.

### (A) Submit unauthorized change

An adversary introduces a change through the official source control management
interface without any special administrator privileges.

#### (A1) Submit change without review

<details><summary>Directly submit without review <span>(SLSA 4)</span></summary>

*Threat:* Submit bad code to the source repository without another person
reviewing.

*Mitigation:* Source repository requires two-person approval for all changes.
<sup>[[Two-person reviewed] @ SLSA 4]</sup>

*Example:* Adversary directly pushes a change to a GitHub repo's `main` branch.
Solution: Configure GitHub's "branch protection" feature to require pull request
reviews on the `main` branch.

</details>
<details><summary>Review own change through a sock puppet account <span>(SLSA 4)</span></summary>

*Threat:* Propose a change using one account and then approve it using another
account.

*Mitigation:* Source repository requires approval from two different, trusted
persons. If the proposer is trusted, only one approval is needed; otherwise two
approvals are needed. The software producer maps accounts to trusted persons.
<sup>[[Two-person reviewed] → Different persons @ SLSA 4]</sup>

*Example:* Adversary creates a pull request using a secondary account and then
approves and merges the pull request using their primary account. Solution:
Configure branch protection to require two approvals and ensure that all
repository contributors and owners map to unique persons.

</details>
<details><summary>Use a robot account to submit change <span>(SLSA 4)</span></summary>

*Threat:* Exploit a robot account that has the ability to submit changes without
two-person review.

*Mitigation:* All changes require two-person review, even changes authored by
robots. <sup>[[Two-person reviewed] @ SLSA 4]</sup>

*Example:* A file within the source repository is automatically generated by a
robot, which is allowed to submit without review. Adversary compromises the
robot and submits a malicious change without review. Solution: Require human
review for these changes.

> TODO([#196](https://github.com/slsa-framework/slsa/issues/196)) This solution
> may not be practical. Should there be an exception for locked down robot
> accounts?

</details>
<details><summary>Abuse review exceptions<span>(SLSA 4)</span></summary>

*Threat:* Exploit a review exception to submit a bad change without review.

*Mitigation:* All changes require two-person review without exception.
<sup>[[Two-person reviewed] @ SLSA 4]</sup>

*Example:* Source repository requires two-person review on all changes except
for "documentation changes," defined as only touching files ending with `.md` or
`.html`. Adversary submits a malicious executable named `evil.md` without review
using this exception, and then builds a malicious package containing this
executable. This would pass the policy because the source repository is correct,
and the source repository does require two-person review. Solution: Do not allow
such exceptions.

> TODO This solution may not be practical in all circumstances. Are there any
> valid exceptions? If so, how do we ensure they cannot be exploited?

</details>

#### (A2) Evade code review requirements

<details><summary>Modify code after review <span>(not required)</span></summary>

*Threat:* Modify the code after it has been reviewed but before submission.

*Mitigation:* Source control platform invalidates approvals whenever the
proposed change is modified. <sup>[NOT REQUIRED FOR SLSA]</sup>

*Example:* Source repository requires two-person review on all changes.
Adversary sends a "good" pull request to a peer, who approves it. Adversary then
modifies it to contain "bad" code before submitting. Solution: Configure branch
protection to dismiss stale approvals when new changes are pushed.

> Note: This is not currently a SLSA requirement because the productivity hit is
> considered too great to outweigh the security benefit. The cost of code review
> is already too high for most projects, given current code review tooling, so
> making code review even costlier would not further our goals. However, this
> should be considered for future SLSA revisions once the state-of-the-art for
> code review has improved and the cost can be minimized.

</details>
<details><summary>Submit a change that is unreviewable <span>(SLSA 4)</span></summary>

*Threat:* Send a change that is meaningless for a human to review that looks
benign but is actually malicious.

*Mitigation:* Code review system ensures that all reviews are informed and
meaningful. <sup>[[Two-person reviewed] → Informed review @ SLSA 4]</sup>

*Example:* A proposed change updates a file, but the reviewer is only presented
with a diff of the cryptographic hash, not of the file contents. Thus, the
reviewer does not have enough context to provide a meaningful review. Solution:
the code review system should present the reviewer with a content diff or some
other information to make an informed decision.

</details>
<details><summary>Copy a reviewed change to another context <span>(SLSA 4)</span></summary>

*Threat:* Get a change reviewed in one context and then transfer it to a
different context.

*Mitigation:* Approvals are context-specific. <sup>[[Two-person reviewed] ->
Context-specific approvals @ SLSA 4]</sup>

*Example:* MyPackage's source repository requires two-person review. Adversary
forks the repo, submits a change in the fork with review from a colluding
colleague (who is not trusted by MyPackage), then merges the change back into
the upstream repo. Solution: The merge should still require review, even though
the fork was reviewed.

</details>
<details><summary>Compromise another account <span>(SLSA 3)</span></summary>

*Threat:* Compromise one or more trusted accounts and use those to submit and
review own changes.

*Mitigation:* Source control platform verifies two-factor authentication, which
increases the difficulty of compromising accounts. <sup>[[Verified history] →
strong authentication @ SLSA 3]</sup>

*Example:* Trusted person uses a weak password on GitHub. Adversary guesses the
weak password, logs in, and pushes changes to a GitHub repo. Solution: Configure
GitHub organization to requires 2FA for all trusted persons. This would increase
the difficulty of using the compromised password to log in to GitHub.

</details>
<details><summary>Hide bad change behind good one <span>(SLSA 4)</span></summary>

*Threat:* Request review for a series of two commits, X and Y, where X is bad
and Y is good. Reviewer thinks they are approving only the final Y state whereas
they are also implicitly approving X.

*Mitigation:* Only the version that is actually reviewed is the one that is
approved. Any intermediate revisions don't count as being reviewed.
<sup>[[Two-person reviewed] @ SLSA 4]</sup>

*Example:* Adversary sends a pull request containing malicious commit X and
benign commit Y that undoes X. In the pull request UI, reviewer only reviews and
approves "changes from all commits", which is a delta from HEAD to Y; they don't
see X. Adversary then builds from the malicious revision X. Solution: Policy
does not accept this because the version X is not considered reviewed.

> TODO This is implicit but not clearly spelled out in the requirements. We
> should consider clarifying if there is confusion or incorrect implementations.

</details>

#### (A3) Code review bypasses that are out of scope of SLSA

<details><summary>Software producer intentionally submits bad code <span>(out of scope)</span></summary>

*Threat:* Software producer intentionally submits "bad" code, following all
proper processes.

*Mitigation:* **Outside the scope of SLSA.** Trust of the software producer is
an important but separate property from integrity.

*Example:* A popular extension author sells the rights to a new owner, who then
modifies the code to secretly mine bitcoin at the users' expense. SLSA does not
protect against this, though if the extension were open source, regular auditing
may discourage this from happening.

</details>
<details><summary>Collude with another trusted person <span>(out of scope)</span></summary>

*Threat:* Two trusted persons collude to author and approve a bad change.

*Mitigation:* **Outside the scope of SLSA.** We use "two trusted persons" as a
proxy for "intent of the software producer".

</details>
<details><summary>Trick reviewer into approving bad code <span>(out of scope)</span></summary>

*Threat:* Construct a change that looks benign but is actually malicious, a.k.a.
"bugdoor."

*Mitigation:* **Outside the scope of SLSA.**

</details>
<details><summary>Reviewer blindly approves changes <span>(out of scope)</span></summary>

*Threat:* Reviewer approves changes without actually reviewing, a.k.a. "rubber
stamping."

*Mitigation:* **Outside the scope of SLSA.**

</details>

### (B) Compromise source repo

An adversary introduces a change to the source control repository through an
administrative interface, or through a compromise of the underlying
infrastructure.

<details><summary>Project owner bypasses or disables controls <span>(SLSA 4)</span></summary>

*Threat:* Trusted person with "admin" privileges in a repository submits "bad"
code bypassing existing controls.

*Mitigation:* All persons are subject to same controls, whether or not they have
administrator privileges. Disabling the controls requires two-person review (and
maybe notifies other trusted persons?) <sup>[[Two-person reviewed] @ SLSA
4]</sup>

*Example 1:* GitHub project owner pushes a change without review, even though
GitHub branch protection is enabled. Solution: Enable the "Include
Administrators" option for the branch protection.

*Example 2:* GitHub project owner disables "Include Administrators", pushes a
change without review, then re-enables "Include Administrators". This currently
has no solution on GitHub.

> TODO This is implicit but not clearly spelled out in the requirements. We
> should consider clarifying since most if not all existing platforms do not
> properly address this threat.

</details>
<details><summary>Platform admin abuses privileges <span>(SLSA 4)</span></summary>

*Threat:* Platform administrator abuses their privileges to bypass controls or
to push a malicious version of the software.

*Mitigation:* TBD <sup>[[Common requirements] @ SLSA 4]</sup>

*Example 1:* GitHostingService employee uses an internal tool to push changes to
the MyPackage source repo.

*Example 2:* GitHostingService employee uses an internal tool to push a
malicious version of the server to serve malicious versions of MyPackage sources
to a specific CI/CD client but the regular version to everyone else, in order to
hide tracks.

*Example 3:* GitHostingService employee uses an internal tool to push a
malicious version of the server that includes a backdoor allowing specific users
to bypass branch protections. Adversary then uses this backdoor to submit a
change to MyPackage without review.

</details>
<details><summary>Exploit vulnerability in SCM <span>(out of scope)</span></summary>

*Threat:* Exploit a vulnerability in the implementation of the source code
management system to bypass controls.

*Mitigation:* **Outside the scope of SLSA.**

</details>

## Build integrity threats

A build integrity threat is a potential for an adversary to introduce behavior
to a package that is not reflected in the source code, or to build from a
source, dependency, and/or process that is not intended by the software
producer.

### (C) Build from modified source

An adversary builds from a version of the source code that does not match the
official source control repository.

<details><summary>Build from unofficial fork of code <span>(TBD)</span></summary>

*Threat:* Build using the expected CI/CD process but from an unofficial fork of
the code that may contain unauthorized changes.

*Mitigation:* Policy requires the provenance's source location to match an
expected value.

*Example:* MyPackage is supposed to be built from GitHub repo `good/my-package`.
Instead, it is built from `evilfork/my-package`. Solution: Policy rejects
because the source location does not match.

</details>
<details><summary>Build from unofficial branch or tag <span>(TBD)</span></summary>

*Threat:* Build using the expected CI/CD process and source location, but
checking out an "experimental" branch or similar that may contain code not
intended for release.

*Mitigation:* Policy requires that the provenance's source branch/tag matches an
expected value, or that the source revision is reachable from an expected
branch.

*Example:* MyPackage's releases are tagged from the `main` branch, which has
branch protections. Adversary builds from the unprotected `experimental` branch
containing unofficial changes. Solution: Policy rejects because the source
revision is not reachable from `main`.

</details>
<details><summary>Build from unofficial build steps <span>(TBD)</span></summary>

*Threat:* Build the package using the proper CI/CD platform but with unofficial
build steps.

*Mitigation:* Policy requires that the provenance's build configuration source
matches an expected value.

*Example:* MyPackage is expected to be built by Google Cloud Build using the
build steps defined in the source's `cloudbuild.yaml` file. Adversary builds
with Google Cloud Build, but using custom build steps provided over RPC.
Solution: Policy rejects because the build steps did not come from the expected
source.

</details>
<details><summary>Build from unofficial entry point <span>(TBD)</span></summary>

*Threat:* Build using the expected CI/CD process, source location, and
branch/tag, but using a target or entry point that is not intended for release.

*Mitigation:* Policy requires that the provenance's build entry point matches an
expected value.

*Example:* MyPackage is supposed to be built from the `release` workflow.
Adversary builds from the `debug` workflow. Solution: Policy rejects because the
entry point does not match.

</details>
<details><summary>Build from modified version of code modified after checkout <span>(SLSA 3)</span></summary>

*Threat:* Build from a version of the code that includes modifications after
checkout.

*Mitigation:* Build service pulls directly from the source repository and
accurately records the source location in provenance. <sup>[[Identifies source
code] @ SLSA 3]</sup>

*Example:* Adversary fetches from MyPackage's source repo, makes a local commit,
then requests a build from that local commit. Builder records the fact that it
did not pull from the official source repo. Solution: Policy rejects because the
source repo is not as expected.

</details>

### (D) Compromise build process

An adversary introduces an unauthorized change to a build output through
tampering of the build process; or introduces false information into the
provenance.

<details><summary>Use build parameter to inject behavior <span>(SLSA 4)</span></summary>

*Threat:* Build using the expected CI/CD process, source location, branch/tag,
and entry point, but adding a build parameter that injects bad behavior into the
output.

*Mitigation:* Policy only allows known-safe parameters. At SLSA 4, no parameters
are allowed. <sup>[[Parameterless] @ SLSA 4]</sup>

*Example:* MyPackage's GitHub Actions Workflow uses `github.event.inputs` to
allow users to specify custom compiler flags per invocation. Adversary sets a
compiler flag that overrides a macro to inject malicious behavior into the
output binary. Solution: Policy rejects because it does not allow any `inputs`.

</details>
<details><summary>Compromise build environment of subsequent build <span>(SLSA 3)</span></summary>

*Threat:* Perform a "bad" build that persists a change in the build environment,
then run a subsequent "good" build using that environment.

*Mitigation:* Builder ensures that each build environment is ephemeral, with no
way to persist changes between subsequent builds. <sup>[[Ephemeral environment]
@ SLSA 3]</sup>

*Example:* Build service uses the same machine for subsequent builds. Adversary
first runs a build that replaces the `make` binary with a malicious version,
then runs a subsequent build that otherwise would pass the policy. Solution:
Builder changes architecture to start each build with a clean machine image.

</details>
<details><summary>Compromise parallel build <span>(SLSA 3)</span></summary>

*Threat:* Perform a "bad" build that alters the behavior of another "good" build
running in parallel.

*Mitigation:* Builds are isolated from one another, with no way for one to
affect the other. <sup>[[Isolated] @ SLSA 3]</sup>

*Example:* Build service runs all builds for project MyPackage on the same
machine as the same Linux user. Adversary starts a "bad" build that listens for
the "good" build and swaps out source files, then starts a "good" build that
would otherwise pass the policy. Solution: Builder changes architecture to
isolate each build in a separate VM or similar.

</details>
<details><summary>Steal cryptographic secrets <span>(SLSA 3)</span></summary>

*Threat:* Use or exfiltrate the provenance signing key or some other
cryptographic secret that should only be available to the build service.

*Mitigation:* Builds are isolated from the trusted build service control plane,
and only the control plane has access to cryptographic secrets. <sup>[[Isolated]
@ SLSA 3]</sup>

*Example:* Provence is signed on the build worker, which the adversary has
control over. Adversary uses a malicious process that generates false provenance
and signs it using the provenance signing key. Solution: Builder generates and
signs provenance in the trusted control plane; the worker has no access to the
key.

</details>
<details><summary>Set values of the provenance <span>(SLSA 2)</span></summary>

*Threat:* Generate false provenance and get the trusted control plane to sign
it.

*Mitigation:* Trusted control plane generates all information that goes in the
provenance, except (optionally) the output artifact hash.
<sup>[[Service generated] @ SLSA 2]</sup>

*Example:* Provenance is generated on the build worker, which the adversary has
control over. Adversary uses a malicious process to get the build service to
claim that it was built from source repo `good/my-package` when it was really
built from `evil/my-package`. Solution: Builder generates and signs the
provenance in the trusted control plane; the worker reports the output artifacts
but otherwise has no influence over the provenance.

</details>
<details><summary>Poison the build cache <span>(TBD)</span></summary>

*Threat:* Add a "bad" artifact to a build cache that is later picked up by a
"good" build process.

*Mitigation:* **TBD**

*Example:* Build system uses a build cache across builds, keyed by the hash of
the source file. Adversary runs a malicious build that creates a "poisoned"
cache entry with a falsified key, meaning that the value wasn't really produced
from that source. A subsequent build then picks up that poisoned cache entry.

</details>
<details><summary>Project owner <span>(TBD)</span></summary>

**TODO:** similar to Source (do the same threats apply here?)

</details>
<details><summary>Platform admin <span>(TBD)</span></summary>

**TODO:** similar to Source

</details>

### (E) Use compromised dependency

> **TODO:** What exactly is this about? Is it about compromising the build
> process through a bad build tool, and/or is it about compromising the output
> package through a bad library? Does it involve all upstream threats to the
> dependency, or is it just about this particular use of the package (e.g.
> tampering on input, or choosing a bad dependency)?

<!-- separate TODO -->

> **TODO:** Fill this out to give more examples of threats from compromised
> dependencies.

### (F) Upload modified package

An adversary uploads a package not built from the proper build process.

<details><summary>Build with untrusted CI/CD <span>(TBD)</span></summary>

*Threat:* Build using an unofficial CI/CD pipeline that does not build in the
correct way.

*Mitigation:* Policy requires provenance showing that the builder matched an
expected value.

*Example:* MyPackage is expected to be built on Google Cloud Build, which is
trusted up to SLSA 4. Adversary builds on SomeOtherBuildService, which is only
trusted up to SLSA 2, and then exploits SomeOtherBuildService to inject bad
behavior. Solution: Policy rejects because builder is not as expected.

</details>
<details><summary>Upload package without provenance <span>(SLSA 1)</span></summary>

*Threat:* Upload a package without provenance.

*Mitigation:* Policy requires provenance showing that the package came from the
expected CI/CD pipeline.

*Example:* Adversary uploads a malicious version of MyPackage to the package
repository without provenance. Solution: Policy rejects because provenance is
missing.

</details>
<details><summary>Tamper with artifact after CI/CD <span>(SLSA 1)</span></summary>

*Threat:* Take a good version of the package, modify it in some way, then
re-upload it using the original provenance.

*Mitigation:* Policy requires provenance with a `subject` matching the hash of
the package.

*Example:* Adversary performs a proper build, modifies the artifact, then
uploads the modified version of the package to the repository along with the
provenance. Solution: Policy rejects because the hash of the artifact does not
match the `subject` found within the provenance.

</details>
<details><summary>Tamper with provenance <span>(SLSA 2)</span></summary>

*Threat:* Perform a build that would not otherwise pass the policy, then modify
the provenance to make the policy checks pass.

*Mitigation:* Policy only accepts provenance that was cryptographically signed
by the public key corresponding to an acceptable builder.

*Example:* MyPackage is expected to be built by GitHub Actions from the
`good/my-package` repo. Adversary builds with GitHub Actions from the
`evil/my-package` repo and then modifies the provenance so that the source looks
like it came from `good/my-package`. Solution: Policy rejects because the
cryptographic signature is no longer valid.

</details>

### (G) Compromise package repo

An adversary modifies the package on the package repository using an
administrative interface or through a compromise of the infrastructure.

**TODO:** fill this out

### (H) Use compromised package

An adversary modifies the package after it has left the package repository, or
tricks the user into using an unintended package.

<details><summary>Typosquatting <span>(out of scope)</span></summary>

*Threat:* Register a package name that is similar looking to a popular package
and get users to use your malicious package instead of the benign one.

*Mitigation:* **Mostly outside the scope of SLSA.** That said, the requirement
to make the source available can be a mild deterrent, can aid investigation or
ad-hoc analysis, and can complement source-based typosquatting solutions.
<sup>[[Verified history] and [Retained indefinitely] @ SLSA 3]</sup>

</details>

## Availability threats

An availabiliy threat is a potential for an adversary to deny someone from
reading a source and its associated change history, or from building a package.

<details><summary>(A)(B) Delete the code <span>(SLSA 3)</span></summary>

*Threat:* Perform a build from a particular source revision and then delete that
revision or cause it to get garbage collected, preventing anyone from inspecting
the code.

*Mitigation:* Some system retains the revision and its version control history,
making it available for inspection indefinitely. Users cannot delete the
revision except as part of a transparent legal or privacy process.
<sup>[[Retained indefinitely] @ SLSA 3-4]</sup>

*Example:* Adversary submits bad code to the MyPackage GitHub repo, builds from
that revision, then does a force push to erase that revision from history (or
requests GitHub to delete the repo.) This would make the revision unavailable
for inspection. Solution: Policy prevents this by requiring a positive
attestation showing that some system, such as GitHub, ensures retention and
availability.

</details>
<details><summary>(E) A dependency becomes temporarily or permenantly unavailable to the build process <span>(out of scope)</span></summary>

*Threat:* Unable to perform a build with the intended dependencies.

*Mitigation:* **Outside the scope of SLSA.** That said, some solutions to support Hermetic and Reproducable builds may also reduce the impact of this threat.
<sup>[[Hermetic] [Reproducible] @ SLSA 4]</sup>

</details>

## Other threats

Threats that can compromise the ability to prevent or detect the supply chain
security threats above but that do not fall cleanly into any one category.

<details><summary>Tamper with policy <span>(TBD)</span></summary>

*Threat:* Modify the policy to accept something that would not otherwise be
accepted.

*Mitigation:* Policies themselves must meet SLSA 4, including two-party review.

*Example:* Policy for MyPackage only allows source repo `good/my-package`.
Adversary modifies the policy to also accept `evil/my-package`, then builds from
that repo and uploads a bad version of the package. Solution: Policy changes
require two-party review.

</details>
<details><summary>Forge change metadata <span>(SLSA 3)</span></summary>

*Threat:* Forge the change metadata to alter attribution, timestamp, or
discoverability of a change.

*Mitigation:* Source control platform strongly authenticates actor identity,
timestamp, and parent revisions. <sup>[[Verified history] @ SLSA 3]</sup>

*Example:* Adversary submits a git commit with a falsified author and timestamp,
and then rewrites history with a non-fast-forward update to make it appear to
have been made long ago. Solution: Consumer detects this by seeing that such
changes are not strongly authenticated and thus not trustworthy.

</details>
<details><summary>Exploit cryptographic hash collisions <span>(TBD)</span></summary>

*Threat:* Exploit a cryptographic hash collision weakness to bypass one of the
other controls.

*Mitigation:* Require cryptographically secure hash functions for code review
and provenance, such as SHA-256.

*Examples:* Construct a "good" file and a "bad" file with the same SHA-1 hash.
Get the "good" file reviewed and then submit the "bad" file, or get the "good"
file reviewed and submitted and then build from the "bad" file. Solution: Only
accept cryptographic hashes with strong collision resistance.

</details>

</article>

<!-- Links -->

[Access]: requirements.md#access
[Authenticated]: requirements.md#authenticated
[Available]: requirements.md#available
[Build as code]: requirements.md#build-as-code
[Build service]: requirements.md#build-service
[Common requirements]: requirements.md#common-requirements
[Dependencies complete]: requirements.md#dependencies-complete
[Ephemeral environment]: requirements.md#ephemeral-environment
[Hermetic]: requirements.md#hermetic
[Identifies source code]: requirements.md#identifies-source-code
[Isolated]: requirements.md#isolated
[Non-falsifiable]: requirements.md#non-falsifiable
[Parameterless]: requirements.md#parameterless
[Reproducible]: requirements.md#reproducible
[Retained indefinitely]: requirements.md#retained-indefinitely
[Scripted build]: requirements.md#scripted-build
[Security]: requirements.md#security
[Service generated]: requirements.md#service-generated
[Superusers]: requirements.md#superusers
[Two-person reviewed]: requirements.md#two-person-reviewed
[Verified history]: requirements.md#verified-history
[Version controlled]: requirements.md#version-controlled
