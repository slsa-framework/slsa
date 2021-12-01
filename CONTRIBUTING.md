# Contributing to SLSA

Thank you for your interest in contributing to SLSA. Please ensure you abide by
our [Code of Conduct](code-of-conduct.md) when engaging with the SLSA community.

The SLSA project is authored on GitHub using
[Issues](https://github.com/slsa-framework/slsa/issues) to describe proposed
work and [Pull Requests](https://github.com/slsa-framework/slsa/pulls) to submit
changes.

For other ways to engage with the SLSA community, see our [README](README.md).

## Contributing changes

### Markdown style

Changes to any of the Markdown files in the repository should meet our Markdown
style, as encoded in our [markdownlint configuration](.markdownlint.yaml). In
addition we prefer to keep our Markdown documents wrapped at 80 columns (though
this is not currently enforced).

### Review and approval

All changes require peer review through GitHub's pull request feature.

-   Changes to the specification, such as [Requirements](docs/requirements.md)
    or the [Provenance schema](docs/provenance/), require approval from **two
    steering committee members**, unless the change does not affect the meaning
    (e.g. typo fix or minor reformatting.)

    -   Do an initial round of review with a single reviewer.
    -   Add @slsa-framework/slsa-steering-committee as a reviewer and make it
        clear that you are looking for at least two approvers.
    -   Wait at least one week before submitting to give the community time to
        comment.

-   Other changes only require **one approver**. Any member of @slsa-framework
    can approve. There is no requirement for the author and reviewer to
    represent different companies/organizations.

### Signing your work

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
