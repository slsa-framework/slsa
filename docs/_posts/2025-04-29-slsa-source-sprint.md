---
title: Source Track Sprint Recap
author: "Andrew McNamara (RedHat), Tom Hennen (Google), Zachariah Cox (GitHub)"
is_guest_post: false
---

Last week the three of us met to try to make more progress on the source track.  Async collaboration can work well for some things, but on "squishier" topics a higher-bandwidth engagement can be really helpful.  All our work was against the draft version of the spec and before anything becomes official it will go through [the approval process](https://github.com/slsa-framework/governance/blob/main/5._Governance.md#4-specification-development-process).  We'd love your feedback on what we accomplished and discussed (summarized below), so please [let us know](/community#:~:text=welcome%20your%20contributions.-,How%20to%20contribute,-For%20questions%2C%20suggestions) what you think!

The biggest changes made or proposed include:

-   Adding a ['Tag Hygiene' requirement](/spec/draft/source-requirements#:~:text=%E2%9C%93-,Tag%20Hygiene,-If%20the%20SCS) that requires tags that get used externally to be immutable. ([issue](https://github.com/slsa-framework/slsa/issues/1296))
    -   We discussed, but did not yet include, having a requirement that these tags also must come from protected branches. ([issue](https://github.com/slsa-framework/slsa/issues/1353))
-   Adding [Level 4 - Two-Party Review](https://github.com/slsa-framework/slsa/pull/1350) which will require branches at this level to require two people to approve of changes.
-   Clarification of the [Enforced Change Management Process](/spec/draft/source-requirements#source-control-system:~:text=Enforced%20change%20management%20process)
    -   This is meant to allow organizations to enforce _their own_ requirements on what changes can be merged into protected branches.

You can find [all the changes merged and proposed during the sprint here](https://github.com/slsa-framework/slsa/pulls?q=is%3Apr+label%3Asource-track+updated%3A2025-04-24+updated%3A2025-04-23+updated%3A2025-04-25+).

## Source PoC

As a part of our process we reviewed how the SLSA Source PoC claims to [meet the requirements](https://github.com/slsa-framework/slsa-source-poc/blob/main/REQUIREMENTS_MAPPING.md) ([design](https://github.com/slsa-framework/slsa-source-poc/blob/main/DESIGN.md)) to see if we agree on the approach (this helps make sure we're all thinking the same thing about the requirements!) and if we can find any gaps in what it's doing.  The verdict was quite positive!  It seems like a reasonable model that can allow implementation of the SLSA Source Track for GitHub users and will hopefully serve as a model that users of _other_ source control platforms can use to implement their own Source Track compliant SCS (with or without the help of the platform they rely on).  There are some limitations from this approach and it does make some things more difficult.  So it may also result in some feature requests for source platforms that could make controls even stronger. ([issue](https://github.com/slsa-framework/slsa-source-poc/issues/138))

Of course the Source PoC isn't done yet and the design and implementation will need some updates to match the changes made this week, and whatever the spec winds up being when approved.  It also needs some TLC before it's _safe_ and _easy_ to use.  [This approved proposal](https://github.com/ossf/tac/issues/474) for funding from the OpenSSF TAC will help there.

## Why two-party review?

Two-party review is a controversial topic within the SLSA community and as a result was deferred due to an inability to get agreement on if it should be included.  We're taking another shot at it now because the recently revamped [slsa.dev/threats](/threats) page makes it clear that two-party review is the strongest control we have against many of the threats listed for [threat B - Modifying the source](/spec/v1.1/threats#:~:text=(B)%20Modifying%20the%20source,-An%20adversary%20without).

As noted by some, this is one of the first controls enterprises enable while also being a control that can be very difficult for small projects to enable. To account for this we are making this the highest source level as 1-3 are much more easily attained by single-maintainer projects. Those projects can advance as far as possible without adopting two-party review.

To further reduce the burden of this requirement we suggest that reviews cover 'security relevant properties' to allow reviewers to focus on the most pressing aspects of code-review and avoid the perception that these reviews require discussion of 'trivial' issues such as variable names. Of course, organizations may still set a higher bar for review if they wish.

## Next steps

We discussed some other changes but didn't get time to include them.

### SLSA 'properties' that are independent of level

There are some security-relevant properties that don't neatly fit into a level, that affect _multiple_ levels, or that producers might like to claim in a different order (e.g. a producer might want to attest that they conduct TWO_PARTY_REVIEW before they can claim they use a Source Control System that meets all the requirements of Source Level 3).  
SLSA "Properties" would be a mechanism for enforcing and communicating these claims that is independent of any implementation.  ([issue](https://github.com/slsa-framework/slsa/issues/1355))

### Defining how to verify source

With the release of the Source Track, we will establish clear guidelines for how SCS can issue tamper-resistant claims about revisions.
We need to add better documentation on how consumers should verify those claims. How can a consumer verify a revision is the SLSA level they expect?  How can they verify that the revision came from the repo/branch/tag they expect? How can they verify that the policy is still what they want? How can they verify that the policy continuity is still intact?

We also need to document how the Source track and the Build track fit together.  Most users consume source indirectly in the form of artifacts built from that source.  ([issue](https://github.com/slsa-framework/slsa/issues/1356))

### Get ready for release

We'd like to get the source track released (or at least in a release-candidate) in June ahead of [OSS NA](https://events.linuxfoundation.org/open-source-summit-north-america/).  To do that we'll need to evaluate open issues and address them as needed, comb through the spec to make sure the language is right and all the links work.  Most importantly we'll need to get and address feedback from the community.  We made a lot of progress, but there's still a lot to do!
