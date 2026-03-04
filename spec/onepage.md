---
title: SLSA Specification
description: A one-page rendering of all that is included in the SLSA Working Draft.
noindex: true
---
{%- comment -%}
A single page containing all the following files as different sections
{%- endcomment -%}

{% assign dir = "/spec/v1.2/" %}
{% assign filenames = "whats-new,about,threats-overview,use-cases,principles,faq,future-directions,tracks,build-track-basics,terminology,build-requirements,distributing-provenance,verifying-artifacts,assessing-build-platforms,source-requirements,verifying-source,assessing-source-systems,source-example-controls,threats,attestation-model,provenance,build-provenance,verification_summary" %}

{% include onepage.liquid dir=dir filenames=filenames %}
