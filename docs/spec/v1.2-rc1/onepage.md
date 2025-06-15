---
title: SLSA Specification
description: A one-page rendering of all that is included in SLSA 1.2-RC1.
noindex: true
---
{%- comment -%}
A single page containing all the following files as different sections
{%- endcomment -%}

{% assign dir = "/spec/v1.2-rc1/" %}
{% assign filenames = "whats-new,about,threats-overview,use-cases,principles,faq,future-directions,terminology,tracks,provenance,build-requirements,distributing-provenance,verifying-artifacts,assessing-build-platforms,build-env-track-basics,threats,source-requirements,verifying-source,assessing-source-systems,verified-properties,attestation-model,build-provenance,verification_summary" %}

{% include onepage.liquid dir=dir filenames=filenames %}
