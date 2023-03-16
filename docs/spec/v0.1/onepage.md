---
title: SLSA Specification
description: Description of the SLSA standards and technical controls to improve artifact integrity.
layout: standard
---
{%- comment -%}
A single page containing all the following files as different sections
{%- endcomment -%}

{% assign dir = "/spec/v0.1/" %}
{% assign filenames = "terminology,levels,requirements,threats,faq" %}

{% include onepage.liquid dir=dir filenames=filenames %}
