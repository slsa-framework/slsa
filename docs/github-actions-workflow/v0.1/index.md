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

Note: This type is **not** meant to describe execution of subsets of the
top-level workflow, such as an action, a job, or a reusable workflow.

[GitHub Actions]: https://docs.github.com/en/actions

## Build Definition

### External parameters

All external parameters are REQUIRED unless empty.

<table>
<tr><th>Parameter<th>Type<th>Description

<tr id="inputs"><td><code>inputs</code><td>object<td>

The [inputs][inputs context] to the top-level workflow. Every non-empty input
value MUST be recorded. Empty values SHOULD be omitted. Only relevant for
`workflow_dispatch` events. MAY be omitted if empty.

<tr id="source"><td><code>source</code><td>string<td>

The git repository containing the top-level workflow YAML file.

This can be computed from the [github context] using
`"git+" + github.server_url + "/" + github.repository + "@" + github.ref`.

<tr id="vars"><td><code>vars</code><td>object<td>

The [vars context]. MAY be omitted if empty.

<tr id="workflowPath"><td><code>workflowPath</code><td>string<td>

The path to the workflow YAML file within `source`.

Note: this cannot be computed directly from the [github context]: the
`github.workflow` context field only provides the *name* of the workflow, not
the path. See [getEntryPoint] for one possible implementation.

[getEntryPoint]: https://github.com/slsa-framework/slsa-github-generator/blob/ae7e58c315b65aa92b9440d5ce25d795845b3b2a/slsa/buildtype.go#L94-L135

</table>

[github context]: https://docs.github.com/en/actions/learn-github-actions/contexts#github-context
[inputs context]: https://docs.github.com/en/actions/learn-github-actions/contexts#inputs-context
[vars context]: https://docs.github.com/en/actions/learn-github-actions/contexts#vars-context

### System parameters

All system parameters are OPTIONAL.

| Parameter | Type     | Description |
| --------- | -------- | ----------- |
| `github`  | object   | A subset of the [github context] as described below. Only includes parameters that are likely to have an effect on the build and that are not already captured elsewhere. |

The `github` object SHOULD contains the following elements:

| GitHub Context Parameter | Type   | Description |
| ------------------------ | ------ | ----------- |
| `github.actor`           | string |The username of the user that triggered the initial workflow run. |
| `github.event_name`      | string |The name of the event that triggered the workflow run. |

> TODO: What about `actor_id`, `repository_id`, and `repository_owner_id`? Those
> are not part of the context so they're harder to describe, and the repository
> ones should arguably go on the `source` paramater rather than be here.
>
> Also `base_ref` and `head_ref` are similar in that they are annotations about
> `source` rather than a proper parameter.

> TODO: None of these are really "parameters", per se, but rather metadata
> about the build. Perhaps they should go in `runDetails` instead? The problem
> is that we don't have an appropriate field for it currently.

### Resolved dependencies

The `resolvedDependencies` SHOULD contain an entry providing the git commit ID
of `source`, with the `uri` matching `externalParameters.source`. See [Example].

The resolved dependencies MAY contain any artifacts known to be input to the
workflow, such as the specific versions of the virtual environments used.

## Run details

### Metadata

The `invocationId` SHOULD be set to `github.server_url + "/actions/runs/" +
github.run_id + "/attempts/" + github.run_attempt`.

## Example

[Example]: #example

```json
{% include_relative example.json %}
```

Note: The `builder.id` in the example assumes that the build runs under
[slsa-github-generator](https://github.com/slsa-framework/slsa-github-generator).
If GitHub itself generated the provenance, the `id` would be different.

## Version history

### v0.1

Initial version
