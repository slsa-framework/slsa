---
title: SLSA specification
description: SLSA is a specification for describing and incrementally improving supply chain security, established by industry consensus. It is organized into a series of levels that describe increasing security guarantees. This is **version 1.1 RC1** of the SLSA specification, which defines the SLSA levels.
---

SLSA is a specification for describing and incrementally improving supply chain
security, established by industry consensus. It is organized into a series of
levels that describe increasing security guarantees.

This is **Version 1.1 Release Candidate 1 (RC1)** of the SLSA
specification, which defines the SLSA levels and recommended attestation
formats, including provenance. This version has been superseded by
[Version 1.0 RC2](../v1.1-rc2/).

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
