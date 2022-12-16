
{%- if false %}

# IGNORED header to fool markdownlint

{%- endif %}

{%- assign url_parts = page.url | split: '/' %}
{%- assign spec_name = url_parts[1] %}
{%- assign spec_version = url_parts[2] %}
{%- assign spec_version_num = spec_version | remove: 'v' %}
{%- assign spec_version_num = spec_version | remove: 'v' %}
{%- assign current_version = site.data.versions[spec_name].current %}
{%- assign current_version_num = current_version | remove: 'v' %}

{%- if site.data.versions[spec_name].versions[spec_version].status %}

## Status: {{ site.data.versions[spec_name].versions[spec_version].status }}

{%- if spec_version_num < current_version_num %}
This draft has been superseded. [View the latest version]({{ page.url | replace: spec_version, site.data.versions[spec_name].current | relative_url}}).
{%- endif %}

For more information regarding the meaning of this status, see the [Specification Stages definition](../../spec-stages).

{%- endif %}
