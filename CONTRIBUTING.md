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

### Pull request conventions

[pull request conventions]: #pull-request-conventions

PRs are expected to meet the following conventions:

-   PR title is of the form `<tag>: <title>`, where:
    -   `<tag>` is one of the values in the table below.
    -   `<title>` concisely explains *what* the PR does.
-   PR description explains *what* and *why* in a bit more detail, providing
    enough context for a reader to understand the change. See
    [Writing good CL descriptions](https://google.github.io/eng-practices/review/developer/cl-descriptions.html)
    for more advice (in that doc, "CL" means PR and "first line" means PR title;
    ignore the section about tags.)
-   PR title and description use imperative tense, e.g. "update X" (not "updated
    X" or "updates X").
-   Every commit has a [signed-off-by] tag.
    -   Note: Commit messages do not otherwise matter because we use the [squash
        and merge] method, with the PR title and description as the squash
        commit message.
-   Example of a good PR title and description:
    https://github.com/slsa-framework/slsa/pull/840 (predates our `<tag>`
    convention).

Every PR must use one of the following `<tag>` values. Earlier entries in the
table have higher precedence. (See [review and approval] for the meaning of
"waiting period" and "# approvers".) If you are not sure, take a guess and a
maintainer will update if needed.

| Tag | Description | Waiting period | # Approvers |
|---|---|---|---|
| `content` | A change to the meaning of the specification | 72h | 3 |
| `editorial` | A clarification to the specification that does not change its meaning | 24h | 2 |
| `nonspec` | A change to a non-specification page. | 24h | 2 |
| `style` | A user-visible style or layout change. No context changes. | 0h | 1 |
| `impl` | A user-invisible change, such as editing a README or the repo configuration. | 0h | 1 |

Note: PR authors with write access to the repo count as second or third
approvers for their own PRs. For example, if the author of a PR with the
`content` tag has write access to the repo, then the PR only requires
two additional approvers before merging. However, a PR with the `impl` tag
always requires one reviewer, even if the author has write access.

[squash and merge]: https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/incorporating-changes-from-a-pull-request/about-pull-request-merges#squash-and-merge-your-commits

### Review and approval

[review and approval]: #review-and-approval

Review process:

1.  Ensure that the PR meets the [pull request conventions].

2.  GitHub will automatically assign the maintainers as reviewers. You will need
    a different number of approvals for different PR tags. Your reviewers may
    ask that you use a different PR tag.

3.  Wait an appropriate amount of time to allow for lazy consensus. Different
    tags have different minimum waiting periods. The waiting period begins at
    the timestamp of either the final required approval or the latest non-author
    comment, whichever is later.

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
