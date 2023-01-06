---
title: "Build Type: GitHub Actions Workflow"
layout: standard
hero_text: |
    A [SLSA Provenance](../../provenance/v1) `buildType` that describes the
    execution of a GitHub Actions workflow.
---

## Description

This `buildType` describes the execution of a top-level [GitHub Actions]
workflow (as a whole).

Note: This type is not meant to describe execution of subsets of the top-level
workflow, such as an action, a job, or a reusable workflow.

[GitHub Actions]: https://docs.github.com/en/actions

## Build Definition

### External parameters

All external parameters are REQUIRED.

<table>
<tr><th>Parameter<th>Type<th>Description

<tr id="inputs"><td><code>inputs_*</code><td>string<td>

The [inputs context], with each `inputs.<name>` renamed to `inputs_<name>`.
Every non-empty input value MUST be recorded. Empty values SHOULD be omitted.

Note: Only `workflow_dispatch` events and reusable workflows have inputs.

<tr id="source"><td><code>source</code><td>artifact<td>

The git repository containing the top-level workflow YAML file.

This can be computed from the [github context] using
`"git+" + github.server_url + "/" + github.repository + "@" + github.ref`.

<tr id="workflow_path"><td><code>workflow_path</code><td>string<td>

The path to the workflow YAML file within `source`.

Note: this cannot be computed directly from the [github context]: the
`github.workflow` context field only provides the *name* of the workflow, not
the path. See [getEntryPoint] for one possible implementation.

[getEntryPoint]: https://github.com/slsa-framework/slsa-github-generator/blob/ae7e58c315b65aa92b9440d5ce25d795845b3b2a/slsa/buildtype.go#L94-L135

</table>

[github context]: https://docs.github.com/en/actions/learn-github-actions/contexts#github-context
[inputs context]: https://docs.github.com/en/actions/learn-github-actions/contexts#inputs-context

### System parameters

> TODO: None of these are really "parameters", per se, but rather metadata
> about the build. Perhaps they should go in `runDetails` instead? The problem
> is that we don't have an appropriate field for it currently.

All system parameters are OPTIONAL. Each corresponds to the [github context]
value of the same name, with `github.<name>` renamed to `github_<name>`. The
list only includes parameters that are likely to have an effect on the build and
that are not already captured elsewhere.

| Parameter            | Type     | Description |
| -------------------- | -------- | ----------- |
| `github_actor`       | string   | The username of the user that triggered the initial workflow run. |
| `github_event_name`  | string   | The name of the event that triggered the workflow run. |

> TODO: What about `actor_id`, `repository_id`, and `repository_owner_id`? Those
> are not part of the context so they're harder to describe, and the repository
> ones should arguably go on the `source` paramater rather than be here.
>
> Also `base_ref` and `head_ref` are similar in that they are annotations about
> `source` rather than a proper parameter.

### Resolved dependencies

The resolved dependencies MAY contain any artifacts known to be input to the
workflow, such as the specific versions of the virtual environments used.

## Run details

### Metadata

The `invocationId` SHOULD be set to `github.server_url + "/actions/runs/" +
github.run_id + "/attempts/" + github.run_attempt`.

## Example

```json
{% include_relative example.json %}
```

Note: The `builder.id` in the example assumes that the build runs under
[slsa-github-generator](https://github.com/slsa-framework/slsa-github-generator).
If GitHub itself generated the provenance, the `id` would be different.

## Version history

### v0.1

Initial version
