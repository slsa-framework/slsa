---
title: "SLSA End-to-End With AMPEL & Friends"
author: "Adolfo García Veytia (puerco)"
is_guest_post: true
---

This guest post walks through a practical, end-to-end SLSA implementation using
[🔴🟡🟢 AMPEL](https://github.com/carabiner-dev/ampel) — the Amazing Multipurpose
Policy Engine (and L) — along with other tools in the supply chain security
ecosystem. You’ll see how each step in a project’s build can be protected
through attested data, using VSA receipts to capture and verify each step
integrity along the way.

## Requirements

This example runs through the
[release workflow in the SLSA E2E demo repository](https://github.com/carabiner-dev/demo-slsa-e2e/blob/main/.github/workflows/release.yaml).
If you want to try running the verification steps yourself, download
[the latest AMPEL binary](https://github.com/carabiner-dev/ampel/releases/latest).
We also recommend downloading [bnd](https://github.com/carabiner-dev/bnd) to
inspect the generated attestations.

We'll walk through the steps in the workflow. When the workflow runs, all the verification
results are displayed on the run page on GitHub ([example](https://github.com/carabiner-dev/demo-slsa-e2e/actions/runs/18217437602)).
If you look at the execution output ([example](https://github.com/carabiner-dev/demo-slsa-e2e/actions/runs/18217437602/job/51869676510)),
you'll notice that those steps that involve AMPEL are marked with its traffic
lights (🔴🟡🟢), those that use `bnd` are marked with its pretzel icon (🥨).

## Meet the Fritoto Project

This walkthrough will analyze how the Fritoto project releases secure binaries.
Fritoto (a play on Friday + In-toto) is a utility that generates attestations
that inform if a software piece was built on a Friday. Why? Well… you don’t
deploy on Fridays, right? Fritoto’s attestations let you write policies to
prevent shipping software laced with Fridayness.

(Note that Fritoto is a joke project, but it is fully functional if you want to
attest those cursed EoW builds).

As a security tool, Fritoto has implemented a secure end-to-end build process,
starting with a hardened revision history and extending all the way to the
secure execution of its binaries.

Let’s inspect their hardened supply chain security architecture!

## It all starts at the source…

All security guardrails are worthless if attackers can inject malicious code into
the codebase. To ensure all changes going into the codebase are properly vetted,
the Fritoto team have secured their git repository with
[`sourcetool`](https://github.com/slsa-framework/source-tool), the SLSA Source
Track CLI.

The SLSA Source tools allowed the project to
[onboard its repository in minutes](https://github.com/slsa-framework/source-tool/blob/main/GETTING_STARTED.md),
hardening the revision history and setting up tools to continuously check that
repository security controls are properly set. Once the SLSA Source workflows are
in place, each commit receives its own SLSA Source attestations, confirming
that all changes have been merged while the security controls were in place.

By checking the SLSA Source attestations, Fritoto makes sure all builds are run
on a commit guaranteed to be part of a revision history were all changes were
properly vetted.

Before allowing any other steps of the release process run, Fritoto leverages
AMPEL to enforce a policy that verifies the build point’s source attestations:

```yaml
- name: 🔴🟡🟢 Verify Build Point Commit to be SLSA Source Level 3+
  uses: carabiner-dev/actions/ampel/verify@HEAD
  with:
    subject: "gitCommit:{% raw %}${{ github.sha }}{% endraw %}"
    policy: "git+https://github.com/carabiner-dev/policies#vsa/slsa-source-level3.json"
    collector: "note:https://github.com/{% raw %}${{ github.repository }}{% endraw %}@{% raw %}${{ github.sha }}{% endraw %}"
    signer: "sigstore::https://token.actions.githubusercontent.com::https://github.com/slsa-framework/source-actions/.github/workflows/compute_slsa_source.yml@refs/heads/main"
    attest: false

- name: 🥨 Export source attestations
  id: export-source-attestations
  run: |
    bnd read note:{% raw %}${{ github.repository }}{% endraw %}@{% raw %}${{ github.sha }}{% endraw %} --jsonl >> .attestations/attestations.bundle.jsonl
    echo "" >> .attestations/attestations.bundle.jsonl

```

In this fragment of the
[release workflow](https://github.com/carabiner-dev/demo-slsa-e2e/blob/main/.github/workflows/release.yaml),
AMPEL pulls the commit’s VSA (Verification Summary Attestation) from the git
commit notes and verifies that the repository had Source Level 3 protections in place,
ensuring no rogue commits altered the code base.

Second, using bnd, we extract the attestations and add them to a jsonl (linear JSON)
bundle where we'll collect all the build process' security metadata.

## No Trust, No Go

Now that the source is trusted, the Fritoto release process checks its builder.
It uses [Chainguard’s Go image](https://images.chainguard.dev/directory/image/go/overview)
to build binaries for the supported platforms. This image ships with some
attestations already built in, making it is easy to verify with AMPEL. We will
leverage its SLSA Build provenance attestation to make sure the image and the
Go compiler within come from
[Chainguard’s SLSA3 build system](https://edu.chainguard.dev/compliance/slsa/slsa-chainguard/).

To verify it, AMPEL pulls the provenance attestations attached to the image using
its `coci` (Cosign/OCI) collector driver. Then it runs them through the project's
builder PolicySet. AMPEL will also generate a VSA capturing the results of the
verification which we’ll also save for later in our jsonl file.

```yaml
- name: 🔴🟡🟢 Verify Builder Image  
  uses: carabiner-dev/actions/ampel/verify@HEAD  
  with:  
    # The verification subjest: The image digest  
    subject: "{% raw %}${{ steps.digests.outputs.builder }}{% endraw %}"
    # Use the modified policy set
    policy: "git+https://github.com/{% raw %}${{ github.repository }}{% endraw %}#policies/fritoto-verify-builder.hjson"
    # Collect builder attestations attached to the image  
    collector: "coci:cgr.dev/chainguard/go"  
    # We don't specify the signer here as it's baked in the policy code, but
    # we could do it:
    # signer: "sigstore::https://token.actions.githubusercontent.com::https://github.com/slsa-framework/source-actions/.github/workflows/compute_slsa_source.ml@refs/heads/main"
    attest: false  
```  

[Check the source](https://github.com/carabiner-dev/demo-slsa-e2e/blob/cb5a32d292d1222e8d55a5d0d0585e2da0efe7a1/.github/workflows/release.yaml#L98-L109).

### The Build Image PolicySet

A PolicySet is a group of policies that AMPEL applies together. Fritoto’s
[build image PolicySet](https://github.com/carabiner-dev/demo-slsa-e2e/blob/main/policies/fritoto-verify-builder.hjson)
performs the [verifications suggested in the SLSA spec](/spec/v1.0/verifying-artifacts) by reusing three
policies from AMPEL’s community repository:

```json
   "policies": [
        {
            "id": "slsa-builder-id",
            "source": {
                "location": { "uri": "git+https://github.com/carabiner-dev/policies#slsa/slsa-builder-id.json" }
            },
            "meta": { "controls": [ { "framework": "SLSA", "class": "BUILD", "id": "LEVEL_3" } ] }  
        },
        {
            "id": "slsa-build-type",
            "source": {
                "location": { "uri": "git+https://github.com/carabiner-dev/policies#slsa/slsa-build-type.json" }
            },  
            "meta": { "controls": [ { "framework": "SLSA", "class": "BUILD", "id": "LEVEL_3" } ] }
        },
        {
            "id": "slsa-build-point",
            "source": {
                "location": { "uri": "git+https://github.com/carabiner-dev/policies#slsa/slsa-build-point.json" }
            },
            "meta": {  
                "controls": [ { "framework": "SLSA", "class": "BUILD", "id": "LEVEL_3" } ],
                "enforce": "OFF"
            }
        }
    ]
```

The policies are referenced remotely but if you look at each policy, you’ll see
that they
[verify the build type](https://github.com/carabiner-dev/policies/blob/main/slsa/slsa-build-type.json),
[look for the expected builder ID](https://github.com/carabiner-dev/policies/blob/main/slsa/slsa-builder-id.json), and
[verify the build point](https://github.com/carabiner-dev/policies/blob/main/slsa/slsa-build-point.json) (although this one is not enforced in the policy set for now,
as the build point is missing from the image attestation).

The policy set defines the contextual data required by each policy. Also, you’ll
notice that the signer identities are verified and "baked" into the policyset code:

```json
  "identities": [
      {  
          "sigstore": {  
              "issuer": "https://token.actions.githubusercontent.com",  
              "identity": "https://github.com/chainguard-images/images/.github/workflows/release.yaml@refs/heads/main"  
          }  
      }  
  ]
```

By codifying the signer identities and contextual values in the policy, you can
make them immutable when you sign the policy.

<!-- markdownlint-disable MD026 -->
## Moaar Data!

As part of their build process, the Fritoto builder creates additional attestations
to ensure the build is safe to ship to its users and increase the transparency
of the released assets. All of these additional attestations will describe data
about the build commit, they will be collected and checked before releasing the
binaries.

The following additional attestations are produced before the build:

### SBOM

First, to keep track of all dependencies, the build process builds an SPDX
Software Build of Materials. The release workflow uses Carabiner's
[unpack](https://github.com/carabiner-dev/unpack) utility as it generates an
attested SBOM natively but you can use any SBOM generator such as Syft or Trivy
and then tie the SBOM to the commit in an attestation with `bnd predicate`.

### Checking for Vulnerabilities (and dealing with them)

Next, the build process generates an attestation of an OSV vulnerability scan.
It is wrapped and signed as an attestation.

But alas! OSV scanner found that the project is susceptible to CVE-2020-8911 and
CVE-2020-8912 (BTW, we've [injected these vulns](https://github.com/carabiner-dev/demo-slsa-e2e/blob/cb5a32d292d1222e8d55a5d0d0585e2da0efe7a1/go.mod#L5-L6)
on purpose for this demo 😇). Later in the release process, AMPEL will gate on
any detected vulnerabilities before shipping the binaries, so we need to address
them or the policy will fail. How? Well, we __VEX__!

VEX, the
[Vulnerability Exploitability Exchange](https://www.cisa.gov/resources-tools/resources/minimum-requirements-vulnerability-exploitability-exchange-vex) lets software
authors and other stakeholders communicate if a software piece is affected by a
vulnerability.

As these CVEs are [known not to be exploitable in Fritoto](https://github.com/carabiner-dev/demo-slsa-e2e/blob/cb5a32d292d1222e8d55a5d0d0585e2da0efe7a1/main.go#L16-L21),
the release engineers issue two OpenVEX attestations assessing the project as
[`not_affected`](https://github.com/openvex/spec/blob/main/OPENVEX-SPEC.md#status-labels)
by them. They do this using [vexctl](https://github.com/openvex/vexctl) the
OpenVEX CLI that manages VEX documents, and then signing them into attestations
using bnd. In the demo, the VEX documents are generated on the fly and will be
published in the attestations bundle.

### Show me Those Tests!

Next up, Fritoto leverages [beaker](https://github.com/carabiner-dev/beaker),
an experimental tool from Carabiner Systems that runs your project’s tests and
generates a standard
[test-results](https://github.com/in-toto/attestation/blob/main/spec/predicates/test-result.md)
attestation from the tests run. Since it is just a standard statement, the same
policy works with a tests-result attestation from any other tool.

Again, this statement will describe the test run at the specific build point,
that is, it will have the commit’s sha as its subject.

## Let's Build that Castle

It is time to run the build. But before doing so, we need to verify that the
conditions snapshotted in all the attested data check out with out expectations.
AMPEL will gate the build by
[applying a preflight PolicySet](https://github.com/carabiner-dev/demo-slsa-e2e/blob/main/policies/fritoto-gate-build.hjson)
to all the collected attestations, stopping the workflow if anything goes wrong.

```yaml
  # Gate the build enforcing the preflight policy
  - name: 🔴🟡🟢 Run Release Pre-flight Verification
    uses: carabiner-dev/actions/ampel/verify@HEAD
    with:  
      subject: "sha1:{% raw %}${{ github.sha }}{% endraw %}"
      policy: "git+https://github.com/{% raw %}${{ github.repository }}{% endraw %}#policies/fritoto-gate-build.hjson"
      collector: "jsonl:.attestations/attestations.bundle.jsonl"
      attest: false
```

In this case, AMPEL collects the attestations with its jsonl collector from the
file that the release process has been assembling on each step. You'll notice
that the policy set is referenced remotely; this ensures that the policy code
cannot be changed during the build process. Note that while AMPEL policies and
policy sets can be signed, we are using them unsigned in the demo to see their
code more easily.

We won't go into the policy details, but you can check the policy set code and
see that it reuses three community polices that:

1)  [Check the SBOM was generated](https://github.com/carabiner-dev/policies/blob/main/sbom/sbom-exists.json),
2)  [Verify that all unit tests passed](https://github.com/carabiner-dev/policies/blob/main/test-results/tests-pass.json),
and
3)  [Ensure no exploitable vulnerabilities are present](https://github.com/carabiner-dev/policies/blob/main/openvex/no-exploitable-vulns-osv.json).

As we mentioned before, the OSV scan returned two CVEs, but thanks to the OpenVEX
attestations, the release is allowed to run because the
[non-exploitable vulnerabilities policy](https://github.com/carabiner-dev/policies/blob/main/openvex/no-exploitable-vulns-osv.json)
leverages the
[VEX transformer](https://github.com/carabiner-dev/policies/blob/0816f604293d448e7ce0800d82134c15bf9bb3dc/openvex/no-exploitable-vulns-osv.json#L7-L9)
in AMPEL. This transformer reads attested VEX statements and suppresses any
non-exploitable vulnerabilities according to the signed VEX data.

Next, the workflow runs the build using the verified image. After running the
build script, we’ll have the binaries of the Fritoto attester for various
platforms ready to ship.

## Generating SLSA Build Provenance

After the build is done, the workflow will assemble the binaries’ SLSA Build
provenance attestation using the
[Kubernetes Tejolote attester](https://github.com/kubernetes-sigs/tejolote).
Tejolote queries the build system and extracts data about the jobs that produced
the artifacts, their build environment, and their configuration:

```yaml
  - name: 🌶️ Generate SLSA Provenance Attestation  
    id: tejolote
    run: |  
      # Generate the provenance attestation with the Tejolote attester  
      tejolote attest github://{% raw %}${{github.repository}}{% endraw %}/"{% raw %}${GITHUB_RUN_ID}{% endraw %}" \
        --artifacts file:$(pwd)/bin/ \
        --output .attestations/provenance.json --slsa="1.0" \
        --vcs-url=cgr.dev/chainguard/go@{% raw %}${{ steps.digests.outputs.builder }}{% endraw %}

      # Sign the provenance attestation  
      bnd statement .attestations/provenance.json >> .attestations/attestations.bundle.jsonl  
      echo "" >> .attestations/attestations.bundle.jsonl

```

This step adds the provenance attestation to the same jsonl bundle with the
rest of the attestations which we will publish along with the artifacts.

Note that for demonstration purposes, the build process is running Tejolote in
the same job, which is not ideal (or SLSA 3 compliant). Tejolote is designed to
run outside of the workflow; it observes the build system running and attests
when the build is done. But for the demo, it will do for now.

## Final Check Before Release

Finally, Fritoto performs a SLSA Build and Source verification on the built
binaries to ensure everything securely ties together. To spare downstream
consumers from doing the same heavy checks, the project will issue separate
VSAs, one for each binary, which can be later used to check that every
verification up to this point actually took place and the results passed as
expected (see End User Verification).

Here, the workflow runs `ampel verify` on each binary, applying the
[`fritoto-gate-publish.hjson`](https://github.com/carabiner-dev/demo-slsa-e2e/policies/fritoto-gate-publish.hjson),
and attests the results in individual VSAs:

```yaml
  - name: 🔴🟡🟢 Verify All Artifacts and Generate VSAs  
    id: artifact-vsas  
    run: |  
            echo "$HOME/.carabiner/bin" >> $GITHUB_PATH  
            ls -l bin/  
            for binfile in $(ls bin/\*);   
              do ampel verify "$binfile" \
                --policy "git+https://github.com/{% raw %}${{ github.repository }}{% endraw %}#policies/fritoto-gate-publish.hjson" \
                --collector jsonl:.attestations/attestations.bundle.jsonl \
                --attest-results --attest-format=vsa --results-path=vsa.tmp.json \
                --format=html >> $GITHUB_STEP_SUMMARY;

              bnd statement vsa.tmp.json >> .attestations/attestations.bundle.jsonl;  
              echo "" >> .attestations/attestations.bundle.jsonl;  
              rm -f vsa.tmp.json;  
            done  
```

### The Pre-Release PolicySet

The `fritoto-gate-publish` policy set performs the following checks:

1)  All the SLSA Build verifications of the binaries themselves as recommended on the spec.
2)  Verifies the dependency VSAs produced from the previous verifications, namely:
    -   That the build image is `SLSA_BUILD_LEVEL3`
    -   That the git commit used as build point is `SLSA_SOURCE_3`

By verifying the VSAs, we don’t have to do all the checks for the image and
source again!

### A Multitude of Subjects

Verifying this step is special as we will mix attestations that describe
different components of the build process: the built binaries (from the build
provenance), the git commit (the source VSAs), and the builder image (from the
VSAs generated by AMPEL when it verified the container). Now, the new VSAs we
are about to produce will have each fritoto binary as their subject... how do
we check all those subjectes from a single policy set? The answer: Chain them!

#### Chaining Subjects

To support this scenario, AMPEL supports the notion of _chained subjects_. The
chain connects an initial subject (the Fritoto binary) to another resource,
such as the build image or the source commit.

To connect the binary in the policy to the image and its build point commit, the
Fritoto team wrote _selectors_ that act as carabiners clipping the binary to both
by extracting data from the build provenance attestation. Here is an example,
shortened for illustration (this is the HJSON variant with comments):

```js
  chain: [
    {
        predicate: {
            type: "https://slsa.dev/provenance/v1",
            // The selector chains the attestation. It looks in the
            // resolvedDependencies dection of the build provenance
            // for the buildPointRepo context value defined above.
            selector: '''
                predicates[0].data.buildDefinition.resolvedDependencies.map(
                  dep, dep.uri.startsWith(context.buildPointRepo + '@'), dep
                )[0]
            '''
        }
    }
  ]
```  

This selector code extracts the URI from the `resolvedDependencies` field in the
build provenance when it matches the repository name. AMPEL then synthesizes a
new in-toto subject from the extracted data and re-fetches the new subject's
attestations, evaluating the policy on the commit instead of the binary.

### Attesting the Verification

After running the prerelease policy, AMPEL generates a SLSA VSA for each binary,
attesting to everything we’ve seen so far. Here is an example:

```json
{
  "predicateType": "https://slsa.dev/verification_summary/v1",
  "predicate": {
    "dependencyLevels": {
      "SLSA_BUILD_LEVEL_3": "1",
      "SLSA_SOURCE_3": "1"
    },
    "inputAttestations": [
      {
        "digest": {
          "sha256": "2f0f9f9a37f20449875d851b74cfaaaeaccb954a71c8d1ce78fba7bcbfb7990f",
          "sha512": "f045158113f9cc8cd298c3903d5eb94aef5113c09f00e69d01e045aae71d015a9d6d535591d92571048c952807ed9f9cc4a3b9f877efc46fc76ad076c83b61e0"
        },
        "uri": "jsonl:.attestations/attestations.bundle.jsonl#12"
      },
      {
        "digest": {
          "sha256": "6e437c982c3eb448f08feee2549829923f7b61da2d485fbe34571436c27b1ef7",
          "sha512": "de594ea3853663abf58d804ee4d5eca056a7eb193a5694abce4f8d1c15025f073a39319bf45f14a5d0bff1b24188917e6a5a58d774a8c820b25a1639dd2b70bb"
        },
        "uri": "jsonl:.attestations/attestations.bundle.jsonl#6"
      },
      {
        "digest": {
          "sha256": "ebf2acb09c2febca789fd30ab4badbdb73d574caa7a747387cc47d68e10204e7",
          "sha512": "fff6203a5b0a183c0ca0bd7793a6b8de7450d557f57ccb663ac9f136b0de3fc8acdb7cc4f52e8932b774924e0fc331410a314a12f6d4af874013a3c4dd958873"
        },
        "uri": "jsonl:.attestations/attestations.bundle.jsonl#1"
      },
      {
        "digest": {
          "sha256": "d78b94aec61b5d8e1fcf1f4b3a486748d52d1de45072530f95908d5798e26c9a",
          "sha512": "7003ca97a7519986d80737596a6da22dbefc4101e3082c67f647566f5a87670ebd7ecfb1cf6bf7c38d934122f0e57ef35a4d9dd93e29cc802e5fe76492db05c9"
        },
        "uri": "jsonl:.attestations/attestations.bundle.jsonl#3"
      }
    ],
    "policy": {
      "digest": {
        "sha256": "175812c1dd152826cdd604aa14a35674c2f5073ef7a822cf8a2dde02026c03bd",
        "sha512": "195fcb1023068374c404bf679ce7697e80b45e7a8736d58bb64e89fea5d9f5afa8cfcbc4411a83acd6c18131e7198f717e045d7649388599700008272c12e342"
      }
    },
    "resourceUri": "https://github.com/carabiner-dev/demo-slsa-e2e/releases/download/v0.1.8/fritoto-linux-amd64",
    "slsaVersion": "1.1",
    "timeVerified": "2025-10-10T01:14:42.461212072Z",
    "verificationResult": "PASSED",
    "verifiedLevels": [
      "SLSA_BUILD_LEVEL_2"
    ],
    "verifier": {
      "id": "https://carabiner.dev/ampel@v1"
    }
  },
  "_type": "",
  "type": "https://in-toto.io/Statement/v1",
  "subject": [
    {
      "name": "fritoto-linux-amd64",
      "uri": "bin/fritoto-linux-amd64",
      "digest": {
        "sha256": "3e6d22582191fb4b22632907f3b24a22629325e32b6cd4fe9692a63938819983",
        "sha512": "3f06fb85ff6aef9d2a86590ab83a8b9c14dacc85e29e4d273993b01426a752fc2fe0ead6c22dcaac1ed31ec50e9cbadea63b4e2daf3c58cfc63df398e343dc5e"
      }
    }
  ]
}
```

Notice in the VSA the subject is the darwin/arm64 binary and how its
`SLSA_BUILD_LEVEL_2` level is recorded, but also the verified levels of its
dependencies. The important parts in this document are:

-   The verifier ([https://carabiner.dev/ampel@v1](https://carabiner.dev/ampel@v1)) that tells you what tool performed the verification
-   The subject (the fritoto-linux-amd64 binary)
-   The verification result (`PASSED`)
-   The verified levels of the binary (`SLSA_BUILD_LEVEL_2`)
-   The verified SLSA levels of the dependencies (`dependencyLevels`):
    -   One `SLSA_BUILD_LEVEL_3` (the go container image)
    -   One `SLSA_SOURCE_3` (the build point commit, protected with the SLSA source tools)

This VSA can be used to communicate to users all the verifications performed on
the binaries, they can act as guarantees that the released assets were built in
a secure environment.

## End User Verification

Now that the Fritoto project has produced VSAs for all its binaries, the project
users should be able to use them! Especially since Fritoto is a “security”
(wink wink) tool that runs in CI. So how can a user verify the executables?

To verify the Fritoto binaries, users only need the
[latest release of AMPEL](https://github.com/carabiner-dev/ampel/releases/latest)
installed. AMPEL can check the binary directly or verify its hash (as published
on the project's
[release page](https://github.com/carabiner-dev/demo-slsa-e2e/releases/latest)).
The Fritoto team has published a
[policy to verify the project's binaries](https://github.com/carabiner-dev/demo-slsa-e2e/blob/main/policies/check-artifacts.json).
You don’t need to download the policy or the attestations; AMPEL can fetch them
for you when it needs them using the releases collector driver:

```bash
# Download the binary from GitHub:
curl -LO https://github.com/carabiner-dev/demo-slsa-e2e/releases/download/v0.1.8/fritoto-linux-amd64

# Verify it using the fritoto-check-artifacts policy which uses the VSA.
ampel verify fritoto-linux-amd64 \
      --policy "git+https://github.com/carabiner-dev/demo-slsa-e2e#policies/fritoto-check-artifacts.json" \
      --collector release:carabiner-dev/demo-slsa-e2e@v0.1.8
```

The results in the terminal show the checks performed on the VSA with their
respective verification results:

```bash
+--------------------------------------------------------------------------------------------------------------------+
| ⬤⬤⬤AMPEL: Evaluation Results                                                                                       |
+-------------------------+-------------------------+--------+-------------------------------------------------------+
| PolicySet               | fritoto-check-artifacts | Date   | 2025-10-09 19:25:06.805181588 -0600 CST               |
+-------------------------+-------------------------+--------+-------------------------------------------------------+
| Status: ● PASS          | Subject                 | - sha256:884aa2480316522ff74cebf2eb2ca16d...                   |
+-------------------------+-------------------------+--------+-------------------------------------------------------+
| Policy                  | Controls                | Status | Details                                               |
+-------------------------+-------------------------+--------+-------------------------------------------------------+
| slsa-build-deps-level-3 | BUILD-LEVEL_3           | ● PASS | All verified dependencies are SLSA_BUILD_LEVEL_3+     |
| vsa-verify-verifier     | -                       | ● PASS | Attestation was issued by trusted verifier            |
| vsa-verify-resourceuri  | -                       | ● PASS | VSA verification of expected resource URI             |
| slsa-build-level-2      | BUILD-LEVEL_2           | ● PASS | VSA attesting a SLSA_BUILD_2+ compliance verification |
+-------------------------+-------------------------+--------+-------------------------------------------------------+

```

### Checking the Attestation Bundle

The Fritoto project releases a lot of security metadata along with its binaries. The attestations bundle contains 17
statements, if you want to see what is in there, you can use
[bnd, the attestations multitool](https://github.com/carabiner-dev/bnd):

```bash  
bnd read release:carabiner-dev/demo-slsa-e2e@v0.1.8
```

```bash
🔎  Query Results:
-----------------

Attestation #0
✉️  Envelope Media Type: application/vnd.dev.sigstore.bundle.v0.3+json
🔏 Signer identity: sigstore::https://token.actions.githubusercontent.com::https://github.com/slsa-framework/source-actions/.github/workflows/compute_slsa_source.yml@refs/heads/main
📃 Attestation Details:
   Predicate Type: https://github.com/slsa-framework/slsa-source-poc/source-provenance/v1-draft
   Attestation Subjects:
   - gitCommit: cb5a32d292d1222e8d55a5d0d0585e2da0efe7a1


Attestation #1
...
```

This command displays details of the release attestations: who signed them, their
subjects, and their type. Using bnd you can extract the attestations or view the
predicates or unpack them to single files.

Exploring the secure data should give you an idea of the kinds of policies that
can be written, and since all the tools used here are open source, you can use
them in your projects too! If you write something cool, consider contributing it to
[AMPEL’s community policies](https://github.com/carabiner-dev/policies)
for others to reuse!

## Conclusion

This case study went through the basic steps of a secure build leveraging the SLSA
model:

1.  We checked the source code attestations  
2.  We checked the builder attestations  
3.  We performed checks on our project and attested the results.  
4.  We checked the results of 1-3 before triggering the build and produced a VSA of the verification.
5.  We verified the resulting binaries before releasing them and produced VSAs to capture the verification results.  
6.  We published all the signed security metadata in a bundle along with the binaries.
7.  Finally, showed how end users can check the binaries using the verification summaries. If they wish, they can also perform the complete verification themselves, as all the data and policies are open and available.

The
[example project repository](https://github.com/carabiner-dev/demo-slsa-e2e)
is open source, feel free to suggest improvements or fix any bugs,
just not the CVEs,please ;)

## Resources

This is a list of the tools used in the demo, most of them have GitHub actions
you can use, check the
[Fritoto release workflow](https://github.com/carabiner-dev/demo-slsa-e2e/blob/main/.github/workflows/release.yaml)
for examples.

Fritoto, the SLSA e2e demo:<br>
[https://github.com/carabiner-dev/demo-slsa-e2e](https://github.com/carabiner-dev/demo-slsa-e2e)

🔴🟡🟢 AMPEL, The Amazing Multipurpose Policy Engine (and L)<br>
[https://github.com/carabiner-dev/ampel](https://github.com/carabiner-dev/ampel)

🥨 bnd, the attestation multitool<br>
https://github.com/carabiner-dev/bnd

sourcetool, SLSA Source's CLI to secure your git history<br>
https://github.com/slsa-framework/source-tool

Tejolote, The kubernetes SLSA Build Attestter<br>
https://github.com/kubernetes-sigs/tejolote

OSV Scanner, Vulnerability scanner leveraging OSV data<br>
https://github.com/google/osv-scanner

Vexctl, OpenVEX’s tool to manage vex documents<br>
[https://github.com/openvex/vexctl](https://github.com/openvex/vexctl)

Beaker, Test run attester<br>
[https://github.com/carabiner-dev/beaker](https://github.com/carabiner-dev/beaker)

Unpack, experimental dependency extractor<br>
https://github.com/carabiner-dev/unpack
