---
title: "General Availability of SLSA 3 Go native builder for GitHub Actions"
author: "Laurent Simon, Asra Ali, Ian Lewis, Mark Lodato, Jose Palafox, Joshua Lock"
is_guest_post: true
---

A couple months ago, Google and GitHub demonstrated how to generate non-forgeable SLSA 3 provenance for packages/binaries created via GitHub Actions ([1](https://security.googleblog.com/2022/04/improving-software-supply-chain.html), [2](https://github.blog/2022-04-07-slsa-3-compliance-with-github-actions/)). Since then, we've been working hard to turn the reference example into a production-ready system for everyone to use. Today, we're announcing the v1 release of the [trusted builders](https://github.com/slsa-framework/slsa-github-generator) that can be used in GitHub Actions and [verification tools](https://github.com/slsa-framework/slsa-verifier).

As a reminder, [SLSA provenance](https://slsa.dev/provenance/v0.2) extends the principle of artifact signing. Where a signature endorses the final binary, provenance details exactly where and how the artifact was built. Generating SLSA 3 provenance ensures users can trust and verify an artifact's build integrity. By making this information available, you can help your users protect against attacks that tamper with the build process, such as changing the source material or uploading a modified binary that sidelined the authorized build recipe. 

The following is a walk through of how to use this builder for Go applications and examples of how you can use the generated information. 

## Process

### Step 1: Use our builder to build your releases. 

All it takes is to install it via the GitHub dashboard: 

<!-- TODO: Add images -->

The workflow will look like the following:

```
uses: slsa-framework/slsa-github-generator/.github/workflows/builder_go_slsa3.yml 
```

You can find an end-to-end example as used by [Scorecard](https://github.com/ossf/scorecard): [workflow](https://github.com/ossf/scorecard/blob/main/.github/workflows/slsa-goreleaser.yml) and [configuration file](https://github.com/ossf/scorecard/blob/main/.slsa-goreleaser.yml).


### Step 2: Verification for your users

The verification tool validates the signed provenance and exposes arguments to verify metadata for most common use cases, including verification of the source repository used to build the binary.

To install the verification CLI tool, run:

```
go install github.com/slsa-framework/slsa-verifier@v1.0.0
```

As an example, you can use the CLI tool to verify the latest Scorecard release. Download the Scorecard binary and its SLSA provenance here[TODO:link]

```
$ slsa-verifier \
     --artifact-path ./binary-linux-amd64 \
     --provenance ./binary-linux-amd64.intoto.jsonl \
     # The expected source repository.
     --source github.com/ossf/scorecard \
     # The expected branch used to generate the artifact.
     --branch "main" \
     # The expected release tag of the artifact
     --tag v15.0.20 
...
Verified signature against tlog entry index 2604927 at URL: https://rekor.sigstore.dev/api/v1/log/entries/e5591c5f4c5f24918a226a542ffcee3ebd3011b105dc0e078937fd4abcf0bbc6
Signing certificate information:
 {
	"caller": "asraa/slsa-on-github-test",
	"commit": "2d475d74a93e375bff3420f30930334a8c88b7e2",
	"job_workflow_ref": "/slsa-framework/slsa-github-generator/.github/workflows/builder_go_slsa3.yml@refs/tags/v1.0.0",
	"trigger": "workflow_dispatch",
	"issuer": "https://token.actions.githubusercontent.com"
}
PASSED: Verified SLSA provenance
```

Check the [format specification](https://github.com/slsa-framework/slsa-github-generator/blob/main/PROVENANCE_FORMAT.md) for more information about the information inside the generated SLSA provenance.


## Use cases

Validating non-forgeable SLSA provenance can help to both protect against interesting classes of attacks that were seen recently and also help to prevent misuse by exposing information which organizations can use to evaluate policies.


### Detect rollback attacks

A rollback attack is an attack where an attacker replaces a recent artifact (say, v2.0.3) with an older version (say, v2.0.2). If the older version v2.0.2 has known vulnerabilities, an attacker can continue exploiting it. Provenance allows consumers to verify the version of the artifact’s source. As illustrated in the verification command above, the verifier takes a `--tag` flag for this use case.


### Detect invalid source (due to expired and invalid domains)

In two recent attacks [[1](https://twitter.com/firefart/status/1532091679741825024), [2](https://sockpuppets.medium.com/how-i-hacked-ctx-and-phpass-modules-656638c6ec5e)], researchers managed to take over package managers' accounts by acquiring expired domain names linked to the account.The attackers were able to use the domains to publish new packages. The SLSA provenance verification takes as input an expected `--source github.com/source/repo`. The slsa-verifier checks this value against the provenance and verifies that the package creation was initiated via a workflow in the repository. As such, provenance verification for the package would have failed because the attacker does not have access to build the artifact from the original repository.


### Detect recycled GitHub accounts

Another attack presented in [[2](https://sockpuppets.medium.com/how-i-hacked-ctx-and-phpass-modules-656638c6ec5e)] is one where the GitHub username of a Rust crate package maintainer is invalid or no longer exists. The attacker can create this username on GitHub and push a new crate version. SLSA provenance can still help: the provenance contains the `actor_id` who initiated the artifact build, which is unique even when a username is recycled:

```
$ cat provenance.intoto | jq -r '.predicate.invocation.environment.github_actor_id'
64505099
```

When using the SLSA verifier tool, users can pass the flag `--print-provenance` to print out the validated provenance. Using this information in a policy or tool that detects change in `actor_id` could have mitigated this risk for existing consumers of a package.


### Detect recreated GitHub repository

Another attack described in [[2](https://sockpuppets.medium.com/how-i-hacked-ctx-and-phpass-modules-656638c6ec5e)] is one where the original GitHub repository is closed, and the attacker manages to recreate it. The SLSA provenance contains both the `repository_id` and the `repository_owner_id` which remain unique even when username and/or repository names are recycled:

```
$ cat provenance.intoto | jq -r '.predicate.invocation.environment.github_repository_owner_id'
80431187
$ cat provenance.intoto | jq -r '.predicate.invocation.environment.github_repository_id'
486325809
```

Validating fields of the SLSA provenance would have mitigated this risk for existing consumers of a package, as they would have detected a change in `github_repository_id` or `github_repository_owner_id`.


### Validate the process used to build the binary

Some organizations may only want to authorize a predefined set of workflows to create production-ready release artifacts, for example `github.com/source/repo/github/workflows/release.yml`. They may also host other workflows on their repository intended for CI or developer usage. Users may want to validate and create a policy that the artifacts they are consuming were generated from the authorized workflows. The SLSA provenance in our builders exposes metadata that determines the workflow, or entrypoint, of the build:


```
$ cat provenance.intoto | jq -r '.predicate.invocation.configSource.entryPoint'
.github/workflows/e2e.go.tag.branch1.config-ldflags-assets.slsa3.yml
```

### Check how an artifact was built 

As a user, you may want to validate certain options of the binary you are consuming. For example, was the released binary intended for production or development usage? Was the build sanitized or hardened with security options like PIE? Or, if a repository hosts multiple projects, you may want to validate which project corresponds to your artifact. To check these, the SLSA provenance includes build steps that list the exact commands used to generate the artifact: 


```
$ cat provenance.intoto | jq -r '.predicate.buildConfig.steps'
[
  {
    "command": [
      "/opt/hostedtoolcache/go/1.18.2/x64/bin/go",
      "mod",
      "vendor"
    ],
    "env": null,
    "workingDir": "/home/runner/work/example-package/example-package"
  },
  {
    "command": [
      "/opt/hostedtoolcache/go/1.18.2/x64/bin/go",
      "build",
      "-mod=vendor",
      "-trimpath",
      "-tags=netgo",
      "-ldflags=-X main.gitVersion=v1.2.3 -X main.gitCommit=abcdef -X main.gitBranch=branch1",
      "-o",
      "binary-linux-amd64"
    ],
    "env": [
      "GOOS=linux",
      "GOARCH=amd64",
      "GO111MODULE=on",
      "CGO_ENABLED=0"
    ],
    "workingDir": "/home/runner/work/example-package/example-package"
  }
]
```

## Conclusion

We believe all the necessary building blocks are ready to make SLSA a reality *today*.This v1 release of the builder meets SLSA level 3 build and provenance requirements for Golang projects. We are currently working on meeting SLSA level 4 requirements and additionally supporting SBOM generation. In the future, integrating with package managers with Sigstore support would help make SLSA available to even more users. If you are interested in working toward this goal, we would love to help provide consultancy, knowledge, or funds to enable native package manager SLSA provenance.

If you’re a Go package developer, try our builder and provide feedback on how we can improve it. Be one of the first adopters of this exciting technology, and encourage your users to verify your artifacts. This is really important to provide transparency and security for the software supply-chain.

We have more announcements coming in the next few weeks, including using generic builders for SLSA 2 to help users incrementally transition towards SLSA. We are also planning to announce support for other ecosystems including container builds, and add tooling to make policy validation easier. Stay tuned!
