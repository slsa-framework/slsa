# Contributing to SLSA

Thank you for your interest in contributing to SLSA. Please ensure you abide by
our [Code of Conduct](code-of-conduct.md) when engaging with the SLSA community.

The SLSA project is authored on GitHub using [Issues] to describe proposed work
and [Pull Requests] to submit changes.

If you would like to contribute to the SLSA Blog, please see: https://github.com/slsa-framework/governance/blob/main/6._Contributing.md

For other ways to engage with the SLSA community, see our [README](README.md).

[Issues]: https://github.com/slsa-framework/slsa/issues
[Pull Requests]: https://github.com/slsa-framework/slsa/pulls

## Finding a good first issue

If you want to start helping but are unsure which issue might be good - you can look for issues with the label [`website`](https://github.com/slsa-framework/slsa/labels/website) if you have Jekyll, CSS, or design knowledge, these changes do not require in depth understanding of the SLSA specifications.

Alternately you can look for issues with a [`shovel-ready`](https://github.com/slsa-framework/slsa/labels/shovel-ready) label, these should be well-defined and ready to be worked on.

## Proposing changes

If a change is small enough to be fully discussed in a pull request, jump
straight to [Submitting changes].

Otherwise, we recommend the following process to propose and reach agreement on
changes:

1.  The proposer finds or creates a [GitHub Issue][Issues] describing the
    problem and proposes an idea to address that problem.

2.  The community discusses and refines the idea, guided by the steering
    committee.

3.  If supplemental documents are needed, the proposer creates a
    [proposal document] to describe the proposal and references the document
    from the Issue. This can be valuable in cases where the topic is too complex
    to fully describe in an Issue comment.

4.  Once there is general agreement that the proposal is sound, the proposer
    [submits][submitting changes] a pull request implementing the idea. Final
    agreement happens on the pull request.

[proposal document]: https://github.com/slsa-framework/slsa-proposals

## Submitting changes

[submitting changes]: #submitting-changes

All changes require peer review through GitHub's pull request (PR) feature.

### Markdown style

Changes to any of the Markdown files in the repository should meet our Markdown
style, as encoded in our [markdownlint configuration](.markdownlint.yaml). In
addition we prefer to keep our Markdown documents wrapped at 80 columns (though
this is not currently enforced).

To check (and fix) style problems before sending a PR you can run linting
locally with `npm run lint && ./lint.sh` or `npm run format && ./lint.sh`.

```shell
$ npm run lint && ./lint.sh

> lint
> markdownlint .

CONTRIBUTING.md:77 MD022/blanks-around-headings Headings should be surrounded by blank lines [Expected: 1; Actual: 0; Above] [Context: "### Pull request conventions"]
$ npm run format && ./lint.sh

> format
> markdownlint . --fix

$
```

If you haven't already you'll need to install npm (e.g. `sudo apt install npm`)
and package dependencies (`npm install`).

### Pull request conventions

[pull request conventions]: #pull-request-conventions

PRs are expected to meet the following conventions:

-   PR title follows [Conventional Commits][][^semantic-action] using the form
    `<type>: <subject>`, where:
    -   `<type>` is one of the values in the [table below](#pull-request-types).
    -   `<subject>` concisely explains *what* the PR does.
-   PR body explains *what* and *why* in a bit more detail, providing
    enough context for a reader to understand the change. See
    [Writing good CL descriptions](https://google.github.io/eng-practices/review/developer/cl-descriptions.html)
    for more advice (in that doc, "CL" means PR and "first line" means PR title;
    ignore the section about tags.)
-   PR title and body use imperative tense, e.g. "update X" (not "updated
    X" or "updates X").
-   Every commit has a [signed-off-by] tag.
    -   Note: Commit messages do not otherwise matter because we use the [squash
        and merge] method, with the PR title and body as the squash
        commit message.
-   Example of a good PR title and body:
    https://github.com/slsa-framework/slsa/pull/840 (predates our `<type>`
    convention).

[^semantic-action]: As implemented via [action-semantic-pull-request].

[Conventional Commits]: https://www.conventionalcommits.org/en/v1.0.0/
[action-semantic-pull-request]: https://github.com/amannn/action-semantic-pull-request

### Pull request types

Every PR must be categorized using one of the following `<type>` values. The
purpose is twofold: to make it easier for readers to understand the scope of the
PR at a glance, and to allow us to adjust the minimum review period and number
of approvers based on how sensitive the PR is.

Use the closest entry in the table that applies, selecting the first one if
multiple apply. If you are not sure which type to use, take a guess and a
maintainer will update if needed. See [review and approval] for the meaning of
"waiting period" and "# approvers".

| Type | Meaning | Waiting period | # Approvers
|---|---|---|---
| `content` | A change to the meaning of the specification. Must include a [changelog entry]. | 72h | 3
| `editorial` | A clarification to the specification that does not change its meaning, beyond a simple `fix`. | 24h | 2
| `nonspec` | A change to a non-specification, non-blog page, beyond a simple `fix`. | 24h | 2
| `blog` | A new or updated blog post. (Do not mix with categories above.) | 24h | 2
| `fix` | A fix for obvious typos, broken links, and similar. | 0h | 1
| `style` | A user-visible style or layout change. No content changes. | 0h | 1
| `impl` | A user-invisible change, such as editing a README or the repo configuration. | 0h | 1

Note 1: PR authors with write access to the repo count as second or third
approvers for their own PRs. For example, if the author of a PR with the
`content` type has write access to the repo, then the PR only requires
two additional approvers before merging. However, a PR with the `impl` type
always requires one reviewer, even if the author has write access.

Note 2: If the PR only touches files in the [Draft](docs/spec-stages.md)
specification stage, then the "waiting period" and "# reviewers" are relaxed and
up to Maintainer discretion (including the PR author if they're a maintainer). Note
that a relaxed number of reviewers and waiting period may result in more back
and forth with the expanded set of reviewers as drafts are finalized.
Drafts should be indicated in the PR title following a pattern of `<type>: draft: <subject>`.
Files in the Draft stage have a large banner at the top of each rendered page,
as well as the text "Status: Draft".

[squash and merge]: https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/incorporating-changes-from-a-pull-request/about-pull-request-merges#squash-and-merge-your-commits

### Changelog entry

[changelog entry]: #changelog-entry

All `content` changes to the specification should also include a brief
description of the change in the adjacent `whats-new.md` file, in order to help
readers of an updated version of the specification to more easily identify
changes.

### Review and approval

[review and approval]: #review-and-approval

Review process:

1.  Ensure that the PR meets the [pull request conventions].

2.  If there is a particular set of maintainers you've been working with, feel
    free to assign the PR to them.  If they don't have time to review they
    should feel free to assign to someone else, or provide feedback on when
    they can get to it.  Otherwise, assign to
    `@slsa-framework/specification-maintainers`.
    -   Feel free to ping the reviwers in the
    [slsa-specification Slack](https://openssf.slack.com/archives/C03NUSAPKC6)
    when the PR is ready for review.
    -   You will need a different number of approvals for different
    [PR types](#pull-request-types). Your reviewers may ask that you use a
    different PR type.

3.  Wait an appropriate amount of time to allow for lazy consensus. Different
    types have different minimum waiting periods. The waiting period begins at
    the timestamp of either the final required approval or the latest non-author
    comment, whichever is later.
    -   If a few days have passed without any feedback please feel free to ping
    the PR and [in Slack](https://openssf.slack.com/archives/C03NUSAPKC6).

4.  Once the waiting period has passed, a maintainer will merge your PR. Expect
    your PR to be squashed+merged unless your reviewers advise you otherwise.
    If your PR has not been merged within 48h of the waiting period having
    passed, and a reason for that has not been added as a PR comment, use the
    PR's comment thread to request the PR be merged.

### Signing your work

[signed-off-by]: #signing-your-work

When contributing patches to the project via pull request, please indicate that
you wrote the patch or have permission to pass it on by including your sign-off.

If you can certify this, answering yes to each of the statements below (from
[developercertificate.org](https://developercertificate.org/)):

<pre>
Developer Certificate of Origin

Copyright (C) 2004, 2006 The Linux Foundation and its contributors.

Everyone is permitted to copy and distribute verbatim copies of this
license document, but changing it is not allowed.

Developer's Certificate of Origin 1.1

By making a contribution to this project, I certify that:

(a) The contribution was created in whole or in part by me and I
    have the right to submit it under the open source license
    indicated in the file; or

(b) The contribution is based upon previous work that, to the best
    of my knowledge, is covered under an appropriate open source
    license and I have the right under that license to submit that
    work with modifications, whether created in whole or in part
    by me, under the same open source license (unless I am
    permitted to submit under a different license), as indicated
    in the file; or

(c) The contribution was provided directly to me by some other
    person who certified (a), (b) or (c) and I have not modified
    it.

(d) I understand and agree that this project and the contribution
    are public and that a record of the contribution (including all
    personal information I submit with it, including my sign-off) is
    maintained indefinitely and may be redistributed consistent with
    this project or the open source license(s) involved.
</pre>

you can add a `Signed-off-by:` line to each commit message:

`Signed-off-by: Some Author <some.author@example.com>`

You can automatically append a sign-off to a commit by passing the `-s` /
`--sign-off` option to `git commit`:

`git commit -s`

**Note**: this requires your `user.name` and `user.email` are set correctly
in your git config.

## SLSA versions management

The main working draft is located in the `spec/draft` folder while the various versions are in specific folders:

```none
spec/draft
spec/v0.1
spec/v0.2
spec/v1.0
spec/v1.0-rc1
spec/v1.0-rc2
spec/v1.1
```

`spec/draft` is where all new work should take place. To publish a new version of the SLSA specification, copy the draft folder to a version specific folder (e.g., `spec/v1.1`) and make the necessary changes to that folder: it is possible for instance that not all that is in the draft should be included in which case you will need to remove that content, and several config and navigation files need to be updated such as:

```none
_data/nav/config.yml
_data/nav/v1.1.yml (corresponding to the version you are creating)
_data/versions.yml
_redirects
```

To patch a specific version of the specification, the changes should be made to both the corresponding folder as well as, if applicable, to all later versions including the draft folder.

Unfortunately we've not figured out a better way to handle the different versions with Jekyll. If you do, please let us know!

To compare the changes between two versions you may find it handy to use the [diff site script](https://github.com/slsa-framework/slsa/tree/main/docs#comparing-built-versions).

**Note**: When publishing new versions of the SLSA specification, make sure to follow the [Specification stages and versions documentation](docs/spec-stages.md) and the [Specification Development Process](https://github.com/slsa-framework/governance/blob/main/5._Governance.md#4-specification-development-process) to ensure compliance with the [Community Specification License](https://github.com/slsa-framework/governance/blob/main/1._Community_Specification_License-v1.md).

## Workstream lifecycle

Major workstreams that require considerable effort, such as a new release, a new
track, or a new level, should have a top-level GitHub issue and a shepherd to
oversee the workstream and move it along. Without a shepherd, a workstream is
likely to stagnate. If you would like to be a shepherd for a workstream, just
nominate yourself in the issue.

Responsibilities of the shepherd:

-   Maintaining the top-level GitHub issue to track the overall workstream
-   Breaking down the workstream into tasks
-   Pinging open issues and pull requests when stale
-   Getting consensus among Contributors and Maintainers
-   Suggesting priorities
-   Providing regular updates to the community
-   Adding a workstream entry in [README.md](README.md)

Template for GitHub issue:

-   Title: `Workstream: <name>`
-   Assignee: \<shepherd\>
-   Labels: [`workstream`](https://github.com/slsa-framework/slsa/labels/workstream)
-   Description:

    ```markdown
    This is a tracking issue for [SHORT DESCRIPTION].

    [Workstream shepherd]: YOUR NAME (@GITHUB_USERNAME)

    Sub-issues:

    -   [ ] #1234
    -   [ ] #4568

    [Workstream shepherd]: https://github.com/slsa-framework/slsa/blob/main/CONTRIBUTING.md#workstream-lifecycle

    ---

    [any other text]

    ```
