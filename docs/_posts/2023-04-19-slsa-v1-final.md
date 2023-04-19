---
title: SLSA v1.0 is now final!
author: Mark Lodato
is_guest_post: false
---

After almost two years since SLSA's initial preview release, we are pleased to
announce our first official stable version, [SLSA v1.0](/spec/v1.0)! The full
announcement can be found at the [OpenSSF press release], and a description of
changes can be found at [What's new in v1.0](/spec/v1.0/whats-new). Thank you to
all members of the SLSA community who made this possible through your feedback,
suggestions, discussions, and pull requests!

But SLSA doesn't stop here. We intend to continue working through the [backlog]
of editorial feedback we received from RC1 and RC2 and updating the
specification on a rolling basis. Further down the road, our
[plans](/spec/v1.0/future-directions) include expanding the depth and breadth of
the specification.

As always, we welcome contributions from all. Please see the
[Community](/community) page for ways to participate.

## Changes since RC2

There is one breaking change since [RC2](2023-04-04-slsa-v1-rc2.md): the
[provenance](/provenance/v1) field `systemParameters` was renamed to
`internalParameters` to highlight the contrast from `externalParameters`.

[OpenSSF press release]: https://openssf.org/press-release/2023/04/19/openssf-announces-slsa-version-1-0-release/
[backlog]: https://github.com/orgs/slsa-framework/projects/1/views/1
