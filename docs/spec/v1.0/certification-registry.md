# Certification Registry

## **TODO**

- [ ] Add a link to the SLSA Self-Certification Questionnaire.

This page lists build systems that have certified conformance to the
[SLSA Framework Version 1.0](index.md) by following the
[Certification](certification.md) process.

## Tier 1 - Self-certified conformance

| Build system | SLSA level | Website | Self-certification | Public key |
| ------------ | ---------- | ------- | ---------------- | ---------- |
{%- for build_system in site.data.spec_v1-0.certification-registry %}
| {{ build_system.name }} | {{ build_system.slsa_level }} | [{{build_system.website }}]({{ build_system.website }}) | [{{build_system.self_attestation }}]({{ build_system.self_attestation }}) | [{{build_system.public_key }}]({{ build_system.public_key }}) | 
{%- endfor %}

## Tier 2 - Third-party verified conformance [TODO]

> **Note:** This tier is not yet implemented.
