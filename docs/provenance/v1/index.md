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

> **TODO:** Get proper syntax highlighting for cue, and explain that this is a
> cue schema.

```javascript
{% include_relative provenance.cue %}
```

### Fields

_NOTE: This section describes the fields within `predicate`. For a description
of the other top-level fields, such as `subject`, see [Statement]._

> **TODO:** Automatically parse the proto and render it directly here, rather
> than a simple inclusion of the raw schema file.

```proto
{% include_relative provenance.proto %}
```

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
