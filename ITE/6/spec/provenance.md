# Attestation type: Provenance v1

## Purpose

Describe how an artifact or set of artifacts was produced.

The primary focus is on automated builds that followed some "recipe".

## Schema

```jsonc
{
  "attestation_type": "https://in-toto.io/Provenance/v1",
  "subject": {
    "<URI-OR-PATH>": {
      "<DIGEST_TYPE>": "<DIGEST_VALUE>"
    }
  },
  "materials": {
    "<URI-OR-PATH>": {
      "<DIGEST_TYPE>": "<DIGEST_VALUE>"
    }
  },
  "builder": {
    "id": "<URI>"
  },
  "recipe": {
    "type": "<URI>",
    "material": "<URI-OR-PATH>",        // optional
    "entry_point": "<STRING>",          // optional
    "arguments": { /* object */ }       // optional
  },
  "reproducibility": {                  // optional
    /* object */
  },
  "metadata": {                         // optional
    "build_timestamp": "<TIMESTAMP>",   // optional
    "materials_complete": true/false    // optional
  }
}
```

### Standard attestation fields ([Attestation v1])

<a id="attestation_type"></a>
`attestation_type` _string ([TypeURI]), required_

> Always `"https://in-toto.io/Provenance/v1"`.

<a id="subject"></a>
`subject` _object ([ArtifactCollection]), required_

> The products of the build.

<a id="materials"></a>
`materials` _object ([ArtifactCollection]), optional_

> The collection of artifacts that influenced the build including sources,
> dependencies, build tools, base images, and so on.

### Type-specific fields

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
> for more than one builder. For example, a signle GitHubActions signer may
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
>   "material": "git+https://github.com/curl/curl@curl-7_72_0",
>   "entry_point": "build.yaml:maketgz",
>   "arguments": null
> }
> ```
>
> MAY be omitted if unknown or implicit from the builder.

<a id="recipe.type"></a>
`recipe.type` _string ([TypeURI]), required_

> URI indicating what type of recipe was performed. It determines the meaning
> of `recipe.entry_point`, `recipe.arguments`, `materials`, and
> `reproducibility`.

<a id="recipe.material"></a>
`recipe.material` _string, optional_

> Key in `materials` containing the recipe steps that are not implied by
> `recipe.type`. For example, if the recipe type were "make", then this would
> point to the source containing the Makefile, not the `make` program itself.
>
> Omit this field (or use null) if the recipe doesn't come from a material.
>
> TODO: What if there is more than one material?

<a id="recipe.entry_point"></a>
`recipe.entry_point` _string, optional_

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

<a id="reproducibility"></a>
`reproducibility` _object, optional_

> Other information that is needed to reproduce the build but that cannot be
> controlled by users. The schema is determined by `recipe.type`.

<a id="metadata"></a>
`metadata` _object, optional_

> Other properties of the build.

<a id="metadata.build_timestamp"></a>
`metadata.build_timestamp` _string ([Timestamp]), optional_

> The timestamp of when the build occurred.

<a id="metadata.materials_complete"></a>
`metadata.materials_complete` _boolean, optional_

> If true, `materials` is claimed to be complete, usually through some
> controls to prevent network access.

## Examples

See [provenance_curl_maketgz.yaml](../examples/provenance_curl_maketgz.yaml).

## Appendix: Review of CI/CD systems

See [ci_survey.md](../ci_survey.md) for a list of well-known CI/CD systems, to make
sure they all map cleanly into this schema.

[ArtifactCollection]: field_types.md#ArtifactCollection
[Attestation v1]: attestation.md
[Timestamp]: field_types.md#Timestamp
[TypeURI]: field_types.md#TypeURI
