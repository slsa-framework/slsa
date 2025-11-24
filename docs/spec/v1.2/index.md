---
title: SLSA specification
description: SLSA is a specification for describing and incrementally improving supply chain security, established by industry consensus. It is organized into a series of levels that describe increasing security guarantees.
---

SLSA is a specification for describing and incrementally improving supply chain
security, established by industry consensus. It is organized into a series of
levels that describe increasing security guarantees.

This is **Version 1.2** of the SLSA specification. It defines several SLSA
levels and tracks, as well as recommended attestation formats, including
provenance.

{%- for section in site.data.nav.main %}
{%- if section.url == page.url %}
{%- for subsection in section.children %}
{%- if subsection.children %}

## {{ subsection.title }}

{{ subsection.description }}

<!-- markdownlint-capture -->
<!-- markdownlint-disable MD055 MD056 -->
| Page | Description
| ---- | -----------
{%- for child in subsection.children %}
| [{{child.title}}]({{child.url | relative_url}}) | {{child.description}}
{%- endfor %}
<!-- markdownlint-restore -->

{%- endif %}
{%- endfor %}
{%- endif %}
{%- endfor %}
