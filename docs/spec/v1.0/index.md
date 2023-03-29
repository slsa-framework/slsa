---
title: SLSA specification
description: SLSA is a specification for describing and incrementally improving supply chain security, established by industry consensus. It is organized into a series of levels that describe increasing security guarantees. This is **version 1.0** of the SLSA specification, which defines the SLSA levels.
---

SLSA is a specification for describing and incrementally improving supply chain
security, established by industry consensus. It is organized into a series of
levels that describe increasing security guarantees.

This is **version 1.0** of the SLSA specification, which defines the SLSA
levels. For other versions, use the chooser <span class="hidden md:inline">to
the right</span><span class="md:hidden">at the bottom of this page</span>. For
the recommended attestation formats, including provenance, see "Specifications"
in the menu at the top.

## About this release candidate

This release candidate is a preview of version 1.0. It contains all
anticipated concepts and major changes for v1.0, but there are still outstanding
TODOs and cleanups. We expect to cover all TODOs and address feedback before the
1.0 final release.

{%- for section in site.data.nav.v10 %}
{%- if section.children %}

## {{ section.title }}

{{ section.description }}

| Page | Description |
| ---- | ----------- |
{%- for child in section.children %}
| [{{child.title}}]({{child.url | relative_url}}) | {{child.description}} |
{%- endfor %}

{%- endif %}
{%- endfor %}
