---
title: SLSA Specification
noindex: true
---
{%- comment -%}
A single page containing all the following files as different sections
{%- endcomment -%}

{% assign dir = "/spec/v1.0-rc1/" %}
{% assign filenames = "levels,principles,terminology,requirements,verifying-systems,threats,faq,future-directions,provenance,verification_summary" %}

{% include onepage.liquid dir=dir filenames=filenames %}
