# SLSA: Technical Controls

This repository contains an index of technical controls that fit into the
[SLSA Framework](../README.md).

NOTE: This is still a work in progress.

## Contents

-   [Software Attestations](attestations.md): How to represent software artifact
    metadata.
-   [Policies](policy.md): Conventions for how to express security policies
    based on attestations.
-   [Survey](survey.md): Survey of existing and in-development controls that
    relate to the framework.

## Project Goals

(1) Build an ecosystem around software attestations and policies, applicable to
use cases beyond SLSA and supply chain integrity:

-   Establish clear and consistent terminology and data models.
-   Define simple interfaces between layers/components, to allow
    compatibility between implementations and to encourage discrete,
    composable technologies.
-   Recommend a cohesive suite of formats, conventions, and tools that are
    known to work well together.

Currently, there are various projects in this space with overlapping missions
and incompatible interfaces. No one project solves all problems and it is
confusing to understand how the pieces fit together. Our goal is to define a
"well-lit path" to make it easier for users to achieve the guarantees they
desire.

(2) Provide recipes for achieving SLSA, built on the ecosystem above:

-   Identify base technologies that meet the SLSA requirements, which serves as
    guidance to platform implementers on how to build SLSA-compliant platforms.
    Example: "CI/CD platforms should produce provenance attestations in format X."
-   Recommend simple end-to-end solutions for end users (software developers) to
    achieve SLSA. Example: "Configure GitHub this way to reach SLSA 3."
