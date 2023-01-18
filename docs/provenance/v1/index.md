---
title: Provenance
layout: standard
hero_text: To trace software back to the source and define the moving parts in a complex supply chain, provenance needs to be there from the very beginning. It’s the verifiable information about software artifacts describing where, when and how something was produced. For higher SLSA levels and more resilient integrity guarantees, provenance requirements are stricter and need a deeper, more technical understanding of the predicate.
---
<!-- Note: We only include the major version in the URL, e.g. "v1" instead of
"v1.0", because minor versions are guaranteed to be backwards compatible. We
still include the minor version number in the selector (_data/versions.yml) so
that readers can easily find the current minor version number. -->

## Purpose

Describe how an artifact or set of artifacts was produced so that:

-   Consumers of the provenance can verify that the artifact was built according
    to expectations.
-   Others can rebuild the artifact, if desired.

This predicate is the recommended way to satisfy the SLSA [provenance
requirements].

## Prerequisite

Understanding of SLSA [Software Attestations](/attestation-model)
and the larger [in-toto attestation] framework.

## Model

Provenance is an attestation that the `builder` produced the `subject` software
artifacts through execution of the `buildDefinition`.

![Build Model](model.svg)

The model is as follows:

-   Each build runs as an independent process on a multi-tenant platform. The
    `builder` is the identity of this platform, representing the transitive
    closure of all entities that must be
    [trusted](../spec/v1.0/principles.md#trust-systems-verify-artifacts) to
    faithfully run the build and record the provenance. (Note: The same model
    can be used for platform-less or single-tenant build systems.)

-   The build process is defined by a parameterized template, identified by
    `buildType`. Often a build platform only supports a single build type. For
    example, the GitHub Actions platform only supports executing a GitHub
    Actions workflow file.

-   All top-level, independent inputs are captured by the parameters to the
    template. There are two types of parameters:

    -   `externalParameters`: the external interface to the build. In SLSA,
        these values are untrusted; they MUST be included in the provenance and
        MUST be verified downstream.

    -   `systemParameters`: set internally by the platform. In SLSA, these
        values are trusted because the platform is trusted; they are OPTIONAL
        and need not be verified downstream. They MAY be included to enable
        reproducible builds, debugging, or incident response.

    Some (but not all) parameters are references to artifacts. For example, the
    external parameters for a GitHub Actions workflow includes the source
    repository (artifact reference) and the path to the workflow file (string
    value).

-   All other artifacts fetched during initialization or execution of the build
    process are considered dependencies. The `resolvedDependencies` captures
    these dependencies, if known.

-   During execution, the build process MAY communicate with the build
    platform's control plane and/or build caches. This communication is not
    captured in the provenance but is subject to [SLSA
    Requirements](../spec/v1.0/requirements.md).

-   Finally, the build process outputs one or more artifacts, identified by
    `subject`.

For concrete examples, see [index of build types](#index-of-build-types).

> **TODO:** Align with the [Build model](../spec/v1.0/terminology.md).

## Parsing rules

This predicate follows the in-toto attestation [parsing rules]. Summary:

-   Consumers MUST ignore unrecognized fields.
-   The `predicateType` URI includes the major version number and will always
    change whenever there is a backwards incompatible change.
-   Minor version changes are always backwards compatible and "monotonic." Such
    changes do not update the `predicateType`.
-   Producers MAY add extension fields using field names that are URIs.
-   Optional fields MAY be unset or null, and should be treated equivalently.
    Both are equivalent to empty for _object_ or _array_ values.

## Schema

_NOTE: This section describes the fields within `predicate`. For a description
of the other top-level fields, such as `subject`, see [Statement]._

<!-- TODO: Get proper syntax highlighting for cue, and explain that this is a
cue schema. -->

```javascript
{% include_relative provenance.cue %}
```

<details>
<summary>Protocol buffer schema</summary>

Link: [provenance.proto](provenance.proto)

```proto
{% include_relative provenance.proto %}
```

</details>

### Provenance

[Provenance]: #provenance

REQUIRED FIELDS: `buildDefinition`, `runDetails`

<a id="buildDefinition"></a>
`buildDefinition` _object ([BuildDefinition])_

> The input to the build.
>
> The accuracy and completeness of this information is implied by
> `runDetails.builder.id`.

<a id="runDetails"></a>
`runDetails` _object ([RunDetails])_

> Details specific to this particular execution of the build.

### BuildDefinition

[BuildDefinition]: #builddefinition

REQUIRED FIELDS: `buildType`, `externalParameters`

<a id="buildType"></a>
`buildDefinition.buildType` _string ([TypeURI])_

> [TypeURI] indicating how to unambiguously interpret this message and
> initiate the build.
>
> This SHOULD resolve to a human-readable specification that includes:
>
> -   Overall description.
> -   List of all parameters, including: name, description, external vs system,
>     type (artifact vs scalar vs...), required vs optional.
> -   Explicit, unambiguous instructions for how to initiate the build given
>     this message.
> -   Complete example provenance file.

<a id="externalParameters"></a>
`buildDefinition.externalParameters` _map (string→[ParameterValue])_

> The set of top-level external inputs to the build. This SHOULD contain all
> the information necessary and sufficient to initialize the build and begin
> execution. "Top-level" means that it is not derived from another input.
>
> The key is a name whose interpretation depends on `buildType`. The key MUST be
> unique across `externalParameters` and `systemParameters`. The following
> conventional names are RECOMMENDED when appropriate:
>
> name     | description
> -------- | -----------
> `source` | The primary input to the build.
> `config` | The build configuration, if different from `source`.
>
> The build system SHOULD be designed to minimize the amount of information
> necessary here, in order to reduce fragility and ease verification.
> Consumers SHOULD have an expectation of what "good" looks like; the more
> information that they must check, the harder that task becomes.
>
> Guidelines:
>
> -   Maximize the amount of information that is implicit from the meaning of
>     `buildType`. In particular, any value that is boilerplate and the same
>     for every build SHOULD be implicit.
>
> -   Reduce parameters by moving configuration to input artifacts whenever
>     possible. For example, instead of passing in compiler flags via a
>     parameter, require them to live next to the source code or build
>     configuration.
>
> -   If possible, architect the build system to use this definition as its
>     sole top-level input, in order to guarantee that the information is
>     sufficient to run the build.
>
> -   In some cases, the build configuration is evaluated client-side and
>     sent over the wire, such that the build system cannot determine its
>     origin. In those cases, the build system SHOULD serialize the
>     configuration in a deterministic way and record the `digest` without a
>     `uri`. This allows one to consider the client-side evaluation as a
>     separate "build" with its own provenance, such that the verifier can
>     chain the two provenance attestations together to determine the origin
>     of the configuration.
>
> TODO: Describe how complete this must be at each SLSA level.
>
> TODO: Some requirement that the builder verifies the URI and that the
> verifier checks it against expectations?

<a id="systemParameters"></a>
`buildDefinition.systemParameters` _map (string→[ParameterValue])_

> Parameters of the build environment that were provided by the `builder` and
> not under external control. The primary intention of this field is for
> debugging, incident response, and vulnerability management. The values here
> MAY be necessary for reproducing the build.

<a id="resolvedDependencies"></a>
`buildDefinition.resolvedDependencies` _array ([ArtifactReference])_

> Resolved dependencies needed at build time. For example, if the build
> script fetches and executes "example.com/foo.sh", which in turn fetches
> "example.com/bar.tar.gz", then both "foo.sh" and "bar.tar.gz" should be
> listed here.
>
> Any artifacts listed under `externalParameters` or `systemParameters`
> SHOULD NOT be repeated here.
>
> TODO: Explain what the purpose of this field is. Why do we need it? \
> TODO: Explain how to determine what goes here. \
> TODO: Explain that it's OK for it to be incomplete. \
> TODO: If the dep is already pinned, does it need to be listed here? \
> TODO: Should this be a map instead of an array? Then each MUST be named
> explicitly, which would be less ambiguous but more difficult. \
> TODO: Clarify when something should go here vs builderDependencies. The
> choice is not obvious. More examples might help.

### ParameterValue

[ParameterValue]: #parametervalue

**Exactly one** of the fields MUST be set.

<a id="artifact"></a>
`artifact` _object ([ArtifactReference])_

> A reference to an artifact.

<a id="value"></a>
`value` _string_

> A scalar value. For simplicity, only string values are supported.

### ArtifactReference

[ArtifactReference]: #artifactreference

Either `uri` or `digest` is REQUIRED.

<a id="uri"></a>
`uri` _string (URI)_

> [URI] describing where this artifact came from. When possible, this SHOULD
> be a universal and stable identifier, such as a source location or Package
> URL ([purl]).
>
> Example: `pkg:pypi/pyyaml@6.0`

<a id="digest"></a>
`digest` _string ([DigestSet])_

> [DigestSet] of cryptographic digests for the contents of this artifact.
>
> TODO: Decide on hex vs base64 in #533 then document it here.

<a id="localName"></a>
`localName` _string (URI), OPTIONAL_

> The name for this artifact local to the build.
>
> Example: `PyYAML-6.0.tar.gz`

<a id="downloadLocation"></a>
`downloadLocation` _string (URI), OPTIONAL_

> [URI] identifying the location that this artifact was downloaded from, if
> different and not derivable from `uri`.
>
> Example: `https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz`

<a id="mediaType"></a>
`mediaType` _string ([MediaType]), OPTIONAL_

> Media Type (aka MIME type) of this artifact.

### RunDetails

[RunDetails]: #rundetails

> TODO: The following fields are the same as v0.2:
>
> REQUIRED at SLSA Build L1 unless the `id` is implicit from the attestation
> envelope (e.g. public key).
  Builder builder = 1;

> TODO: description
> OPTIONAL.
  BuildMetadata metadata = 2;

> Additional artifacts generated during the build that should not be
> considered the "output" of the build but that may be needed during
> debugging or incident response.
>
> Possible use cases:
>
> -   Logs generated during the build.
> -   Fully evaluated build configuration.
>
> In most cases, this SHOULD NOT contain all intermediate files generated
> during the build. Instead, this should only contain files that are likely
> to be useful later and that cannot be easily reproduced.
>
> TODO: Do we need some recommendation for how to distinguish between
> byproducts? For example, should we recommend using `localName`?
>
> OPTIONAL.
  repeated ArtifactReference byproducts = 3;

### Builder

[Builder]: #builder

> [URI] ... (same as v0.2)
> TODO: In most cases this is implicit from the envelope layer (e.g. the
> public key or x.509 certificate), which is just one more thing to mess up.
> Can we rescope this to avoid the duplication and thus the security concern?
> For example, if the envelope identifies the build system, this might
> identify the tenant project?
>
> REQUIRED at SLSA Build L1 unless it is implicit from the attestation
> envelope (e.g. public key).
  string id = 1;

> TODO: Do we want to add this field? (#319)
> TODO: Should we merge this with builderDependencies into a combined
> "builderParameters"? Then arbitrary information can be stored.
>
> OPTIONAL.
  map<string, string> version = 2;

> Dependencies used by the orchestrator that are not run within the workload
> and that should not affect the build, but may affect the provenance
> generation or security guarantees.
> TODO: Flesh out this model more.
>
> OPTIONAL.
  repeated ArtifactReference builder_dependencies = 3;

## Index of build types

The following is an partial index of build type definitions. Each contains a
complete example predicate.

-   [GitHub Actions Workflow](../../github-actions-workflow/v0.1/)

## Migrating from 0.2

To migrate from [version 0.2][0.2] (`old`), use the following pseudocode. The
meaning of each field is unchanged unless otherwise noted.

```javascript
{
    "buildDefinition": {
        // The `buildType` MUST be updated for v1.0 to describe how to
        // interpret `inputArtifacts`.
        "buildType": /* updated version of */ old.buildType,
        "externalParameters": old.invocation.parameters + {
            // It is RECOMMENDED to rename "entryPoint" to something more
            // descriptive.
            "entryPoint": old.invocation.configSource.entryPoint,
            // OPTION 1:
            // If the old `configSource` was the sole top-level input,
            // (i.e. containing the source or a pointer to the source):
            "source": {
                "artifact": {
                    "uri": old.invocation.configSource.uri,
                    "digest": old.invocation.configSource.digest,
                },
            },
            // OPTION 2:
            // If the old `configSource` contained just build configuration
            // and a separate top-level input contained the source:
            "source": {
                "artifact": old.materials[indexOfSource],
            },
            "config": {
                "artifact": {
                    "uri": old.invocation.configSource.uri,
                    "digest": old.invocation.configSource.digest,
                },
            },
        },
        "systemParameters": {
            "artifacts": null, // not in v0.2
            "values": old.invocation.environment,
        },
        "resolvedDependencies": old.materials,
    },
    "runDetails": {
        "builder": {
            "id": old.builder.id,
            "version": null,  // not in v0.2
            "builderDependencies": null,  // not in v0.2
        },
        "metadata": {
            "invocationId": old.metadata.buildInvocationId,
            "startedOn": old.metadata.buildStartedOn,
            "finishedOn": old.metadata.buildFinishedOn,
        },
        "byproducts": null,  // not in v0.2
    },
}
```

The following fields from v0.2 are no longer present in v1.0:

-   `entryPoint`: Use `externalParameters[<name>]` instead.
-   `buildConfig`: No longer inlined into the provenance. Instead, either:
    -   If the configuration is a top-level input, record its digest in
        `externalParameters["config"]`.
    -   Else if there is a known use case for knowing the exact resolved
        build configuration, record its digest in `byproducts`. An example use
        case might be someone who wishes to parse the configuration to look for
        bad patterns, such as `curl | bash`.
    -   Else omit it.
-   `metadata.completeness`: Now implicit from `builder.id`.
-   `metadata.reproducible`: Now implicit from `builder.id`.

## Change history

### v1.0 (DRAFT)

Major refactor to reduce misinterpretation, including a minor change in model.

-   Significantly expanded all documentation.
-   Altered the model slightly to better align with real-world build systems,
    align with reproducible builds, and make verification easier.
-   Grouped fields into `buildDefinition` vs `runDetails`.
-   Renamed `parameters` and `environment` to `externalParameters` and
    `systemParameters`, respectively. Both can now reference artifacts or string
    values.
-   Split and merged `configSource` into `externalParameters`.
-   Split and merged `materials` into `resolvedDependencies`,
    `externalParameters`, `systemParameters`, and `builderDependencies`.
-   Added `localName`, `downloadLocation`, and `mediaType` to artifact
    references.
-   Removed `buildConfig`; can be replaced with
    `externalParameters.artifacts["config"]`, `byproducts`, or simply omitted.
-   Removed `completeness` and `reproducible`; now implied by `builder.id`.
-   Added `builder.version`.
-   Added `byproducts`.

### v0.2

Refactored to aid clarity and added `buildConfig`. The model is unchanged.

-   Replaced `definedInMaterial` and `entryPoint` with `configSource`.
-   Renamed `recipe` to `invocation`.
-   Moved `invocation.type` to top-level `buildType`.
-   Renamed `arguments` to `parameters`.
-   Added `buildConfig`, which can be used as an alternative to `configSource`
    to validate the configuration.

### rename: slsa.dev/provenance

Renamed to "slsa.dev/provenance".

### v0.1.1

-   Added `metadata.buildInvocationId`.

### v0.1

Initial version, named "in-toto.io/Provenance"

[0.1]: v0.1.md
[0.2]: v0.2.md
[DigestSet]: https://github.com/in-toto/attestation/blob/main/spec/field_types.md#DigestSet
[ResourceURI]: https://github.com/in-toto/attestation/blob/main/spec/field_types.md#ResourceURI
[Statement]: https://github.com/in-toto/attestation/blob/main/spec/README.md#statement
[Timestamp]: https://github.com/in-toto/attestation/blob/main/spec/field_types.md#Timestamp
[TypeURI]: https://github.com/in-toto/attestation/blob/main/spec/field_types.md#TypeURI
[in-toto attestation]: https://github.com/in-toto/attestation
[parsing rules]: https://github.com/in-toto/attestation/blob/main/spec/README.md#parsing-rules
