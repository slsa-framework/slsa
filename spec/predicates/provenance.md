# Predicate type: Provenance v1

Type URI: https://in-toto.io/Provenance/v1

## Purpose

Describe how an artifact or set of artifacts was produced.

The primary focus is on automated builds that followed some "recipe".

## Schema

```jsonc
{
  "subject": [{ ... }],
  "predicateType": "https://in-toto.io/Provenance/v1",
  "predicate": {                           // required
    "builder": {                           // required
      "id": "<URI>"                        // required
    },
    "recipe": {                            // optional
      "type": "<URI>",                     // required
      "definedInMaterial": /* integer */,  // optional
      "entryPoint": "<STRING>",            // optional
      "arguments": { /* object */ },       // optional
      "reproducibility": { /* object */ }  // optional
    },
    "metadata": {                          // optional
      "buildStartedOn": "<TIMESTAMP>",     // optional
      "buildFinishedOn": "<TIMESTAMP>",    // optional
      "materialsComplete": true/false      // optional
    },
    "materials": [
      {
        "uri": "<URI>",                    // optional
        "digest": { /* DigestSet */ },     // optional
        "mediaType": "<MEDIA_TYPE>",       // optional
        "tags": [ "<STRING>" ]             // optional
      }
    ]
  }
}
```

_(Note: This is a Predicate type that fits within the larger
[Attestation](../README.md) framework.)_

### Fields

<a id="builder"></a>
`builder` _object, required_

> Idenfifies the entity that executed the build steps. Example:
>
> ```json
> "builder": {
>   "id": "https://github.com/Attestations/GitHubHostedActions@v1"
> }
> ```
>
> This is distinct from the signer because one signer may generate attestations
> for more than one builder. For example, a single GitHubActions signer may
> produce attestations for both "github-hosted runner" and various "self-hosted
> runner" builders.
>
> Even though it may be implicit from the signer, it is required to aid
> readability and debugging.
>
> Verifiers MUST only accept specific builders from specific signers.

<a id="builder.id"></a>
`builder.id` _string ([TypeURI]), required_

> URI indicating the builder's identity.

<a id="recipe"></a>
`recipe` _object, optional_

> Describes the actions that the builder performed. Example:
>
> ```json
> "recipe": {
>   "type": "https://github.com/Attestations/GitHubActionsWorkflow@v1",
>   "definedInMaterial": 0,
>   "entryPoint": "build.yaml:maketgz"
> }
> ```
>
> MAY be omitted if unknown or implicit from the builder.

<a id="recipe.type"></a>
`recipe.type` _string ([TypeURI]), required_

> URI indicating what type of recipe was performed. It determines the meaning of
> `recipe.entryPoint`, `recipe.arguments`, `recipe.reproducibility`, and
> `materials`.

<a id="recipe.definedInMaterial"></a>
`recipe.definedInMaterial` _integer, optional_

> Index in `materials` containing the recipe steps that are not implied by
> `recipe.type`. For example, if the recipe type were "make", then this would
> point to the source containing the Makefile, not the `make` program itself.
>
> Omit this field (or use null) if the recipe doesn't come from a material.
>
> TODO: What if there is more than one material?

<a id="recipe.entryPoint"></a>
`recipe.entryPoint` _string, optional_

> String identifying the entry point. The meaning is defined by `recipe.type`.
> For example, if the recipe type were "make", then this would reference the
> directory in which to run `make` as well as which target to use.
>
> MAY be omitted if the recipe type specifies a default value.

<a id="recipe.arguments"></a>
`recipe.arguments` _object, optional_

> Collection of input arguments that influenced the build on top of
> `recipe.material` and `recipe.entry_point`. The schema is defined by
> `recipe.type`.
>
> Omit this field (or use null) to indicate "no arguments."

<a id="recipe.reproducibility"></a>
`recipe.reproducibility` _object, optional_

> Other information that is needed to reproduce the build but that cannot be
> controlled by users. The schema is determined by `recipe.type`.

<a id="metadata"></a>
`metadata` _object, optional_

> Other properties of the build.

<a id="metadata.buildStartedOn"></a>
`metadata.buildStartedOn` _string ([Timestamp]), optional_

> The timestamp of when the build started.

<a id="metadata.buildFinishedOn"></a>
`metadata.buildFinishedOn` _string ([Timestamp]), optional_

> The timestamp of when the build completed.

<a id="metadata.materialsComplete"></a>
`metadata.materialsComplete` _boolean, optional_

> If true, `materials` is claimed to be complete, usually through some controls
> to prevent network access.

<a id="materials"></a>
`materials` _array of objects, optional_

> The collection of artifacts that influenced the build including sources,
> dependencies, build tools, base images, and so on.

<a id="materials.uri"></a>
`materials[*].uri` _string ([ResourceURI]), optional_

> The method by which this artifact was referenced during the build.
>
> TODO: Should we differentiate between the "referenced" URI and the "resolved"
> URI, e.g. "latest" vs "3.4.1"?
>
> TODO: Should wrap in a `locator` object to allow for extensibility, in case we
> add other types of URIs or other non-URI locators?

<a id="materials.digest"></a>
`materials[*].digest` _object ([DigestSet]), optional_

> Collection of cryptographic digests for the contents of this artifact.

<a id="materials.mediaType"></a>
`materials[*].mediaType` _string (Media Type), optional_

> The [Media Type](https://www.iana.org/assignments/media-types/) for this
> artifact, if known.

<a id="materials.tags"></a>
`materials[*].tags` _array (of strings), optional_

> Unordered set of labels whose meaning is dependent on `recipe.type`. SHOULD be
> sorted lexicographically.
>
> TODO: Recommend specific conventions, e.g. `source` and `dev-dependency`.

## Examples

This section shows how `builder` and `recipe` would be populated for various
common scenarios. Other fields are omitted because they do not vary
significantly between systems.

### GitHub Actions

WARNING: This is only for demonstration purposes. The GitHub Actions team has
not yet reviewed or approved this design, and it is not yet implemented. Details
are subject to change!

GitHub-Hosted runner:

```json
"builder": {
  "id": "https://github.com/Attestations/GitHubHostedActions@v1"
}
```

Self-hosted runner: Not yet supported. We need to figure out a URI scheme that
represents what system hosted the runner, or perhaps add additional properties
in `builder`.

GitHub Actions Workflow:

```jsonc
"recipe": {
  // Build steps were defined in a GitHub Actions Workflow file ...
  "type": "https://github.com/Attestations/GitHubActionsWorkflow@v1",
  // ... in the git repo described by `materials[0]` ...
  "definedInMaterial": 0,
  // ... at the path .github/workflows/build.yaml, using the job "build".
  "entryPoint": "build.yaml:build",
  // The only possible user-defined parameters that can affect the build are the
  // "inputs" to a workflow_dispatch event. This is unset/null for all other
  // events.
  "arguments": {
    "inputs": { ... }
  },
  // TODO: Additional parameters needed to make the workflow reproducible.
  "reproducibility": null
}
```

### Google Cloud Build

WARNING: This is only for demonstration purposes. The Google Cloud Build team
has not yet reviewed or approved this design, and it is not yet implemented.
Details are subject to change!

Google-hosted worker:

```json
"builder": {
  "id": "https://cloudbuild.googleapis.com/GoogleHostedWorker@v1"
}
```

Custom worker: Not yet supported. We need to figure out a URI scheme that
represents what system hosted the worker, or perhaps add additional properties
in `builder`.

Cloud Build config-as-code
([BuildTrigger](https://cloud.google.com/build/docs/api/reference/rest/v1/projects.triggers)
with `filename`):

```jsonc
"recipe": {
  // Build steps were defined in a cloudbuild.yaml file ...
  "type": "https://cloudbuild.googleapis.com/CloudBuildYaml@v1",
  // ... in the git repo described by `materials[0]` ...
  "definedInMaterial": 0,
  // ... at the path path/to/cloudbuild.yaml.
  "entryPoint": "path/to/cloudbuild.yaml",
  // The only possible user-defined parameters that can affect a BuildTrigger
  // are the subtitutions in the BuildTrigger.
  "arguments": {
    "substitutions": {...}
  },
  // TODO: Additional parameters needed to make the build reproducible.
  "reproducibility": null
}
```

Cloud Build with steps defined in a trigger or over RPC:

```jsonc
"recipe": {
  // Build steps were provided as an argument. No `definedInMaterial` or
  // `entryPoint`.
  "type": "https://cloudbuild.googleapis.com/CloudBuildSteps@v1",
  "arguments": {
    // The steps that were performed. (Format TBD.)
    "steps": [...],
    // The substitutions in the build trigger.
    "substitutions": {...}
    // TODO: Any other arguments?
  },
  // TODO: Additional parameters needed to make the build reproducible.
  "reproducibility": null
}
```

### Manually run commands

WARNING: This is just a proof-of-concept. It is not yet standardized.

```jsonc
"builder": {
  "id": "mailto:person@example.com"
},
"recipe": {
  // There was no entry point, and the commands were run in an ad-hoc fashion.
  // There is no `definedInMaterial` or `entryPoint`.
  "type": "https://example.com/ManuallyRunCommands@v1",
  "arguments": {
    // The list of commands that were executed.
    "commands": [
      "tar xvf foo-1.2.3.tar.gz",
      "cd foo-1.2.3",
      "./configure --enable-some-feature",
      "make foo.zip"
    ],
    // Indicates how to parse the strings in `commands`.
    "shell": "bash"
  },
  // If desired, this can be used to describe the state of the system. It would
  // contain arbitrary key/value pairs intended for human consumption.
  "reproducibility": null
}
```

## Appendix: Review of CI/CD systems

See [ci_survey.md](../../ci_survey.md) for a list of well-known CI/CD systems, to
make sure they all map cleanly into this schema.

[DigestSet]: ../field_types.md#DigestSet
[ResourceURI]: ../field_types.md#ResourceURI
[Timestamp]: ../field_types.md#Timestamp
[TypeURI]: ../field_types.md#TypeURI
