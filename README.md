# SLSA ("salsa") is Supply-chain Levels for Software Artifacts

<img align="right" src="https://github.com/slsa-framework/slsa/blob/main/docs/images/slsa-dancing-goose-logo.svg">

SLSA (pronounced ["salsa"](https://www.google.com/search?q=how+to+pronounce+salsa)) is a security framework from source to service, giving anyone working with software a common language for increasing levels of software security and supply chain integrity. It’s how you get from safe enough to being as resilient as possible, at any link in the chain.

**The best way to read about SLSA is to visit [slsa.dev].**

**The fun way to get a taste of SLSA is to check out the [Operation SLSA videos](https://www.youtube.com/playlist?list=PLVl2hFL_zAh_SLZbHMtkPJf8eJxpmM-ww).**

## What's in this repo?

The primary content of this repo is the [docs/](docs/) directory, which contains the core SLSA specification and sources to the [slsa.dev] website.

You can read [SLSA's documentation here](docs/_spec/). The key documents are `levels` - which defines the framework - and `requirements`, which explains how to attain compliance.

## Project status

The initial v0.1 specification is out and is now ready to be tried out and tested. We encourage the community to try adopting SLSA levels incrementally and to share your experiences back to us. We’ve released a set of tools and services to generate SLSA 1-2 provenance, which we’re looking to develop further soon.

Google has been using an internal version of SLSA since 2013 and requires it for all of their production workloads.

## Steering committee

SLSA is currently led by an initial cross-organization, vendor-neutral steering committee. This committee is:

-   [Bruno Domingues](https://github.com/brunodom) - Intel
-   [David A. Wheeler](https://github.com/david-a-wheeler) - Linux Foundation
-   [Joshua Lock](https://github.com/joshuagl) - VMware
-   [Kim Lewandowksi](https://github.com/kimsterv) - Chainguard
-   [Mark Lodato](https://github.com/MarkLodato) - Google
-   [Mike Lieberman](https://github.com/mlieberman85) - Citi/CNCF
-   [Trishank Karthik Kuppusamy](https://github.com/trishankatdatadog) - Datadog

Shortcut to notify the steering committee on any issues/PRs:

> @slsa-framework/slsa-steering-committee

To email the steering committee, use slsa-steering-committee@googlegroups.com.

## Contributors

-   [Kim Lewandowski](https://github.com/kimsterv)
-   [Tom Hennen](https://github.com/TomHennen)
-   [Jacques Chester](https://github.com/jchestershopify)
-   And [many others](https://github.com/slsa-framework/slsa/graphs/contributors)

## Get involved

We rely on feedback from other organizations to evolve SLSA and be more useful to more people. We’d love to hear your experiences using it.

**Are the levels achievable in your project? Would you add or remove anything from the framework? What else is needed before you can adopt it?**

-   If you want to discuss the framework, [Github issues](https://github.com/slsa-framework/slsa/issues) are [the way](https://i.redd.it/yj67b76hxwd61.jpg).
-   If you want to contribute to the framework take a look at our [contribution guidelines](CONTRIBUTING.md).

### Joining the working group

-   We meet bi-weekly on Thursdays at 9am PT. Anyone is welcome to join, whether to listen or to contribute. The OpenSSF community calendar is [here](https://calendar.google.com/calendar/u/0?cid=czYzdm9lZmhwNWk5cGZsdGI1cTY3bmdwZXNAZ3JvdXAuY2FsZW5kYXIuZ29vZ2xlLmNvbQ).
-   We're part of the OpenSSF [Supply Chain Integrity Working Group](https://github.com/ossf/wg-supply-chain-integrity).
-   Our mailing list is [slsa-discussion@googlegroups.com](https://groups.google.com/g/slsa-discussion).
-   You can join our chat on the OpenSSF Slack [here](https://openssf.slack.com/archives/C029E4N3DPF)

<!-- Links -->

[slsa.dev]: https://slsa.dev
