---
title: SLSA Specification
description: A one-page rendering of all that is included in SLSA v1.0.
---
{%- comment -%}
A single page containing all the following files as different sections
{%- endcomment -%}

{% assign dir = "/spec/v1.0/" %}
{% assign filenames = "whats-new,levels,principles,terminology,requirements,verifying-systems,threats,faq,future-directions" %}

{% include onepage.liquid dir=dir filenames=filenames %}
