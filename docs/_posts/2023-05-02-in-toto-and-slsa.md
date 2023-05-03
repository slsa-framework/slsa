---
title: in-toto and SLSA
author: Aditya Sirish (NYU) and Tom Hennen (Google) representing the in-toto Community
is_guest_post: true
---

As an adopter of SLSA, you have likely encountered the
[in-toto project](https://in-toto.io/).
[in-toto attestations](https://github.com/in-toto/attestation) are part of
[SLSA’s recommended suite](/attestation-model#recommended-suite) for expressing
software supply chain claims. As in-toto maintainers, we’ve interacted with a
number of people who know of in-toto through SLSA but don’t fully understand the
project. For example, some were surprised to learn that "in-toto isn’t just a
format of attestations", and that the framework also defines verification
workflows that make use of attestations that are not SLSA Provenance. So, we
decided to author this post as a quick primer on in-toto, how SLSA uses in-toto,
and how other attestations can be used to complement SLSA.

## in-toto Primer

The in-toto Attestation Framework defines a fixed, lightweight "Statement" that
communicates some information about the execution of a software supply chain,
such as if the source was reviewed, or if it went through a SLSA conformant
build process. The information is communicated as a "Predicate" using a
context-specific schema identified by a "Predicate Type", and applies to one or
more software supply chain "Subjects". [SLSA Provenance](/provenance/v1) is one
such predicate type.

in-toto models the software supply chain as a series of "steps". Supply chain
owners, i.e. project owners or maintainers, define the set of actors authorized
to perform each step and rules that govern the artifacts used and produced by
the step. They can also include other arbitrary checks called "inspections" to
be performed during the verification workflow. These policies are recorded in a
piece of metadata called a supply chain "Layout", which is cryptographically
signed by the supply chain owners. As each step is performed, one or more
attestations are generated recording various aspects of the process, and during
verification, in-toto applies the policies in the layout against the set of
attestations produced during the execution of the supply chain.

## What SLSA gets from in-toto?

SLSA v1 is focused on the build aspects of the software supply chain. It defines
the Provenance predicate to record the build characteristics of the produced
artifacts. The specification describes how to verify Provenance as well as lays
out other requirements that are to be verified separately. The SLSA community
has also indicated a
[future source track](/blog/2023/04/the-breadth-and-depth-of-slsa) focused on
the security posture of how source is stored and developed prior to being fed
into a build process.

This is where _other_ in-toto predicate types can complement SLSA. in-toto
allows for defining use case specific predicates that contain contextual
information. Apart from SLSA Provenance, the framework currently
[lists definitions](https://github.com/in-toto/attestation/tree/main/spec/predicates)
for in-toto Links, results of runtime traces, Software Bill of Materials (SBOM)
specifications such as SPDX and CycloneDX, the Software Supply Chain Attribute
Integrity (SCAI) specification, and SLSA Verification Summary Attestations.
in-toto also has a process for members of the community to propose new predicate
types. Proposals are reviewed by the maintainers of the project who are supply
chain security stakeholders at Google, Verizon, Intel, Kusari, and TestifySec.
This ensures that predicate types are of high quality, useful to different
organizations and their specific use cases, and, most importantly, consistent so
that attestations are usable beyond organization boundaries.

With the
[upcoming enhancements to in-toto layouts](https://github.com/in-toto/ITE/pull/38),
supply chain owners can define granular policies for all of the different
predicates they generate during the execution of their software supply chain.
For example, they can embed SLSA Provenance specific checks alongside others
that verify best practices such as two party code reviews, successful test runs,
and so on were adhered to. Taken together, a
[bundle of in-toto attestations](https://github.com/in-toto/attestation/blob/main/spec/v1.0/bundle.md)
and a layout can be used to comprehensively verify a software supply chain’s
security posture.

## End-to-end attestations for your software supply chain

Let’s take a look at how other in-toto attestations can complement SLSA
Provenance. Here are a series of attestations (truncated where necessary) for
the execution of a supply chain. For the sake of this example, the attestations
are presented without their outer signing layer; in the real world, they'd all
be signed by the actors performing the corresponding operations.

### Check out the source code

First, the source repository is checked out and its Git commit is recorded using
an in-toto link.

```json
{
    "_type": "https://in-toto.io/Statement/v1",
    "subject": [{
        "name": "foo",
        "digest": {
            "gitCommit": "abcdef123456"
        }
    }],
    "predicateType": "https://in-toto.io/attestation/link/v0.3",
    "predicate": {
      "name": "checkout",
      "command": "git clone https://git.example.com/foo.git",
      "materials": {},
      "byproducts": {},
      "environment": {}
    }
}
```

### Is the code reviewed?

The attestation bundle includes a code review for the commit that was checked
out.

```json
{
    "_type": "https://in-toto.io/Statement/v1",
    "subject": [{
        "name": "foo",
        "digest": {
            "gitCommit": "abcdef123456"
        }
    }],
    "predicateType": "https://in-toto.io/attestation/human-review/v0.1",
    "predicate": {
        "result": "PASSED",
        "reviewLink": "https://cr.example.com/foo/abcdef123456",
        "timestamp": "2023-04-02T12:34:23Z"
    }
}
```

### Run tests

Prior to actually executing the build, the source's tests are run. This test run
and its results are recorded as a standalone attestation.

```json
{
    "_type": "https://in-toto.io/Statement/v1",
    "subject": [{
        "name": "foo",
        "digest": {
            "gitCommit": "abcdef123456"
        }
    }],
    "predicateType": "https://in-toto.io/attestation/test-result/v0.1",
    "predicate": {
        "result": "PASSED",
        "configuration": [{
            "name": "foo/test.yml",
            "digest": {
                "gitBlob": "123456abcd"
            }
        }],
        "url": "https://ci.example.com/23048",
        "passedTests": ["(test.yml, ubuntu-latest)", "(test.yml, windows-latest)"],
        "warnedTests": [],
        "failedTests": []
    }
}
```

### Build the final product

The build service performs the actual build itself and records SLSA Provenance
of the resulting artifact.

```json
{
    "_type": "https://in-toto.io/Statement/v1",
    "subject": [{
        "name": "bin/foo-v1.1",
        "digest": {
            "sha256": "ff332109abdd"
        }
    }],
    "predicateType": "https://slsa.dev/provenance/v1",
    "predicate": {
        "buildDefinition": {
            "buildType": "<buildType>",
            "externalParameters": {
                "repository": "https://git.example.com/foo.git",
                "ref": "refs/heads/main"
            },
            "resolvedDependencies": [{
                "name": "foo",
                "uri": "git+https://git.example.com/foo@refs/heads/main",
                "digest": {
                    "gitCommit": "abcdef123456"
                }
            }],
        },
        "runDetails": {
            "builder": {
                "id": "https://ci.example.com/",
            },
        }
    }
}
```

### Runtime trace results of the build

In addition to recording provenance, the bundle includes the results of a
runtime trace of the build process.

```json
{
    "_type": "https://in-toto.io/Statement/v1",
    "subject": [{
        "name": "bin/foo-v1.1",
        "digest": {
            "sha256": "ff332109abdd"
        }
    }],
    "predicateType": "https://in-toto.io/attestation/runtime-trace/v0.1",
    "predicate": {
        "monitor": {
            "type": "https://github.com/cilium/tetragon/v0.8.4",
            "tracePolicy": {
                "policies": [{
                    "name": "connect",
                    "config": ""
                }]
            }
        },
        "monitoredProcess": {
            "hostID": "https://ci.example.com",
            "type": "custom",
            "event": "https://ci.example.com/23055"
        },
        "monitorLog": {
            "process": [],
            "network": [],
            "fileAccess": [{
                "name": "foo/Makefile",
                "digest": {
                    "sha256": "1209abcd56"
                }
            }, ...]
        }
    }
}
```

### Build compiler configuration attributes

Finally, the bundle has a Software Supply Chain Attribute Integrity (SCAI)
attestation that records some attributes of the build tool. Specifically, the
attestation indicates the build step used GCC with stack protection enabled.

```json
{
    "_type": "https://in-toto.io/Statement/v1",
    "subject": [{
        "name": "bin/foo-v1.1",
        "digest": { "sha256": "ff332109abdd" }
    }],
    "predicateType": "https://in-toto.io/attestation/scai/attribute-report/v0.2",
    "predicate": {
        "attributes": [{
            "attribute": "WITH_STACK_PROTECTION",
            "conditions": { "flags": "-fstack-protector*" },
        }],
        "producer": {
            "uri": "file:///usr/bin/gcc",
            "name": "gcc9.3.0",
            "digest": {
                "sha256": "78ab6a8..."
            }
        }
    }
}
```

### Verification

This set of metadata can be submitted to in-toto's verification workflow using a
layout conforming to the new, under-development schema. Successful verification
would result in a Verification Summary Attestation.

```json
{
    "_type": "https://in-toto.io/Statement/v1",
    "subject": [{
        "name": "foo-v1.1",
        "digest": {
            "sha256": "ff332109abdd"
        }
    }],
    "predicateType": "https://slsa.dev/verification_summary/v1",
    "predicate": {
        "verifier": {
            "id": "https://example.com/publication_verifier"
        },
        "timeVerified": "2023-04-12T23:20:50.52Z",
        "resourceUri": "https://download.example.com/foo-v1.1",
        "policy": {
            "uri": "https://example.com/foo.layout",
            "digest": {"sha256": "dabc8907fa"}
        },
        "inputAttestations": [{
            "uri": "https://example.com/foo-v1.1.intoto.jsonl",
            "digest": {"sha256": "7843adcf34"}
        }],
        "verificationResult": "PASSED",
        "verifiedLevels": ["SLSA_LEVEL_3"],
        "slsaVersion": "1.0"
    }
}
```

## Get Involved

There are a number of exciting developments underway in in-toto such as the new
layouts, several new predicate specifications, and improvements to our tooling.
Come say hello at an
[in-toto community meeting](https://hackmd.io/@lukpueh/ry_e70Qqw) and on
[#in-toto](https://cloud-native.slack.com/archives/CM46K2VT2) on the
[CNCF Slack workspace](https://slack.cncf.io/).
