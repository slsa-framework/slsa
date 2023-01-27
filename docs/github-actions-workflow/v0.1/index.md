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
| [`deployment`]        | Creation of a deployment. NOTE: This contains |
| [`push`]              | Creation or update of a git tag or branch. |
| [`workflow_dispatch`] | Manual trigger of a workflow. |

[`create`]: https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#create
[`deployment`]: https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#deployment
[`push`]: https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#push
[`workflow_dispatch`]: https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#workflow_dispatch

This build type MUST NOT be used for any other event type unless this
specification is first updated. This ensures that the [external parameters] are
fully captured and that the semantics are unambiguous. Other event types are
irrelevant for software builds (such as `issues`) or have complex semantics that
may be error prone or require further analysis (such as `pull_request` or
`repository_dispatch`). To add support for another event type, please open a
[GitHub Issue][SLSA Issues].

Note: Consumers are REQUIRED to reject unrecognized external parameters, so new
event types can be added without a major version bump as long as they do not
change the semantics of existing external parameters.

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

[External parameters]: #external-parameters

All external parameters are REQUIRED unless empty.

<table>
<tr><th>Parameter<th>Type<th>Description

<tr id="deployment"><td><code>deployment</code><td>object<td>

The non-default [deployment body parameters] for `deployment` events; unset for
other event types. SHOULD omit parameters that have a default value to make
verification easier. SHOULD be unset if there are no non-default values.

Only includes the following parameters (as of API version 2022-11-28) because
these are the only ones that have an effect on the build: `payload`,
`environment`, `description`, `transient_environment`, `production_environment`.

Can be computed from the [github context] using the corresponding fields from
`github.event.deployment`, filtering out default values (see API docs) and using
`original_environment` for `environment`.

<tr id="inputs"><td><code>inputs</code><td>object<td>

The `inputs` from `workflow_dispatch` events; unset for other event types.
SHOULD omit empty inputs to make verification easier. SHOULD be unset if there
are no non-empty inputs.

Can be computed from the [github context] using `github.event.inputs`.

<tr id="source"><td><code>source</code><td>string<td>

URI of the git commit containing the top-level workflow file, in [SPDX Download
Location] format (`git+<repo>@<ref>`), without ".git" on the repo name. For most
workflows, this represents the source code to be built.

Can be computed from the [github context] using
`"git+" + github.server_url + "/" + github.repository + "@" + github.ref`.

<tr id="vars"><td><code>vars</code><td>object<td>

The [variables] passed in to the workflow. This SHOULD be unset if there are no
vars.

Can be computed from the [vars context] using `vars`.

<tr id="workflowPath"><td><code>workflowPath</code><td>string<td>

The path to the workflow YAML file within `source`.

`github.workflow_ref`, removing the prefix `github.repository + "/"` and the
suffix `"@" + github.ref`. Take care to consider that the path and/or ref MAY
contain `@` symbols.

</table>

[SPDX Download Location]: https://spdx.github.io/spdx-spec/v2.3/package-information/#77-package-download-location-field
[deployment body parameters]: https://docs.github.com/en/rest/deployments/deployments?apiVersion=2022-11-28#create-a-deployment--parameters
[github context]: https://docs.github.com/en/actions/learn-github-actions/contexts#github-context
[variables]: https://docs.github.com/en/actions/learn-github-actions/variables
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
