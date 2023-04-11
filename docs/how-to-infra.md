---
title: How to SLSA for infrastructure providers
description: If you're looking to jump straight in and try SLSA, here's a quick start guide for the steps to take to reach the different SLSA levels.
layout: standard
---

This is a quick-start guide for infrastructure providers that want to support
SLSA for their users. The work involved in supporting SLSA differs depending
on the sort of infrastructure you provide.

If you provide...

-   **build automation or CI/CD,** then you first need to verify that your
infrastructure is suitable to produce SLSA provenance. To learn more about
verifying your system for SLSA conformance, see
[Verifying build platforms](/spec/v1.0/verifying-systems).
After verifying your system, you need to support generating SLSA provenance. To
learn more about producing provenance, see
[Producing artifacts](/spec/v1.0/requirements). To learn more about the SLSA
provenance format, see [Provenance](/provenance/v1).
-   **a [package registry](/spec/v1.0/terminology.md#package-model),** then you
need to verify and distribute provenance for the software you distribute. To
learn more about verifying provenance, see
[Verifying artifacts](/spec/v1.0/verifying-artifacts). To learn more about
distributing provenance, see
[Distributing provenance](/spec/v1.0/distributing-provenance).
-   **a compiler or other CLI build tool,** then we recommend you do nothing.
While your tool can produce SLSA provenance, it will never be able to reach
Build levels beyond Build Level 1. Instead, encourage your users to produce
SLSA provenance in their build automation tool or CI/CD pipeline.
