---
title: SLSA Specification
description: A one-page rendering of all that is included in the SLSA Working Draft.
noindex: true
---
{%- comment -%}
A single page containing all the following files as different sections
{%- endcomment -%}

{% assign dir = "/spec/draft/" %}
{% assign filenames = "whats-new,about,threats-overview,use-cases,principles,faq,future-directions,terminology,tracks,provenance,levels,build-requirements,distributing-provenance,verifying-artifacts,verifying-systems,attested-build-env-levels,threats,source-requirements,verifying-source,verified-properties,attestation-model,build-provenance,verification_summary" %}

{% include onepage.liquid dir=dir filenames=filenames %}
