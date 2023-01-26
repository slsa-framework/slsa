---
title: "Build Type: GitHub Actions Workflow"
layout: standard
hero_text: |
    A [SLSA Provenance](../../provenance/v1) `buildType` that describes the
    execution of a GitHub Actions workflow.
---

## Description

This `buildType` describes the execution of a top-level [GitHub Actions]
workflow that builds a software artifact.

Only the following [event types] are supported:

| Supported event type  | Event description |
| --------------------- | ----------------- |
| [`create`]            | Creation of a git tag or branch. |
| [`push`]              | Creation or update of a git tag or branch. |
| [`workflow_dispatch`] | Manual trigger of a workflow. |

[`create`]: https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#create
[`push`]: https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#push
[`workflow_dispatch`]: https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#workflow_dispatch

This build type MUST NOT be used for any other event type. The reason for this
restriction is to ensure that both producer and consumer are clear on semantics.
The event types above are simple and have unambiguous semantics about what
software is supposed to be built. Others are irrelevant for software builds
(such as `issues`), not intended for release builds (such as `pull_request`), or
have complex semantics that need further analysis (such as `deployment` or
`repository_dispatch`). To add support for another event type, please open a
[GitHub Issue][SLSA Issues].

Note: This build type is **not** meant to describe execution of a subset of a
top-level workflow, such as an action, job, or reusable workflow. Only workflows
have sufficient [isolation] between invocations, whereas actions and jobs do
not. Reusable workflows do have sufficient isolation, but supporting both
top-level and reusable would make the schema too error-prone.

[SLSA Issues]: https://github.com/slsa-framework/slsa/issues
[GitHub Actions]: https://docs.github.com/en/actions
[event types]: https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows
[isolation]: /spec/v1.0/requirements#isolation-strength

## Build Definition

### External parameters

All external parameters are REQUIRED unless empty.

<table>
<tr><th>Parameter<th>Type<th>Description

<tr id="inputs"><td><code>inputs</code><td>object<td>

The full [inputs context] for `workflow_dispatch` events; unset for other event
types. This field SHOULD be omitted if empty.

<tr id="source"><td><code>source</code><td>string<td>

URI of the git commit containing the top-level workflow file, in [SPDX Download
Location] format: `git+<repo>@<ref>`. For most workflows, this represents the
source code to be built.

This can be computed from the [github context] using
`"git+" + github.server_url + "/" + github.repository + "@" + github.ref`.

[SPDX Download Location]: https://spdx.github.io/spdx-spec/v2.3/package-information/#77-package-download-location-field

<tr id="vars"><td><code>vars</code><td>object<td>

The full [vars context]. This field SHOULD be omitted if empty.

<tr id="workflowPath"><td><code>workflowPath</code><td>string<td>

The path to the workflow YAML file within `source`.

This can be computed from the [github context] `github.workflow_ref`, removing
the prefix `github.repository + "/"` and the suffix `"@" + github.ref`. Take
care to consider that the path and/or ref MAY contain `@` symbols.

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
| `github.actor_id`        | string | The numeric ID of the user that triggered the initial workflow run. |
| `github.event_name`      | string | The name of the event that triggered the workflow run. |

> TODO: What about `repository_id`, and `repository_owner_id`? Those
> are not part of the context so they're harder to describe, and the repository
> ones should arguably go on the `source` paramater rather than be here.
>
> Also `base_ref` and `head_ref` are similar in that they are annotations about
> `source` rather than a proper parameter.

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
