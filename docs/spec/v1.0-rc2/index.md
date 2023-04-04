---
title: SLSA specification
description: SLSA is a specification for describing and incrementally improving supply chain security, established by industry consensus. It is organized into a series of levels that describe increasing security guarantees. This is **version 1.0** of the SLSA specification, which defines the SLSA levels.
---

SLSA is a specification for describing and incrementally improving supply chain
security, established by industry consensus. It is organized into a series of
levels that describe increasing security guarantees.

This is **version 1.0 RC2** of the SLSA specification, which defines the SLSA
levels and recommended attestation formats, including provenance.

{%- for section in site.data.nav.v10-rc2 %}
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
