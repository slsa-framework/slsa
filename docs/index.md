---
title: Overview
---
# Improving artifact integrity across the supply chain

<!--{% if false %}-->

**NOTE: This site is best viewed at https://slsa.dev.**

<!--{% endif %}-->

<span class="subtitle">

SLSA ("[salsa](https://www.google.com/search?q=how+to+pronounce+salsa)") is **Supply-chain Levels for Software Artifacts.**

A security framework from source to service, giving anyone working with software a common language for increasing levels of software security and supply chain integrity.

</span>

<!-- Levels overview -->
<section class="breakout">

<div class="wrapper">
<span class="subtitle flushed">Overview</span>

## Security levels

Each level provides a number of requirements that will increase trust in software. These look at the integrity of the source and build services, the available information about the code, reproducibility and resilience against both tampering or human error.

<div class="level-icons m-b-l m-t-xl">

<div class="level">

## 1

### Basic protection

Provenance checks to help evaluate risks and security

</div>

<div class="level">

## 2

### Medium protection

Further checks against the origin of the software

</div>

<div class="level">

## 3

### Advanced protection

Extra resistance to specific classes of threats

</div>
<div class="level">

## 4

### Maximum protection

Strict auditability and reliability checks

</div>

</div>

<div class="buttons-horizontal">

<div class="pseudo-button">

[Learn more](levels.md)

</div>

<div class="pseudo-button">

[Read the requirements](requirements.md)

</div>

</div>

</div>

</section>

</section>

<!-- Supply chain diagram -->
<section class="content-block">

![Supply Chain Threats](images/supply-chain-threats.svg)

<section class="col-2">
<span>

## How do you mitigate risks and threats to your supply chain?

Recent high profile supply chain attacks prove how costly an attack can be. It’s difficult to check the integrity of software artifacts today, but SLSA wants to fix that with a set of integrity requirements developers can follow to improve the security of the software they produce.

See SLSA compared to [known supply chain attacks](levels.md#threats).

</span>
<span>

## Standard security guidelines that scale for your future

Software consumers can choose software that provides the needed level of security. SLSA levels are a way to better understand your current security posture, and plan for the future. You can check that the security information for any software in your supply chain is accurate manually, and help develop and share tools that automate the process.

<div class="pseudo-button">

[Read the requirements](requirements.md)

</div>

</span>

</section>
<!-- Future -->
<section class="breakout">

<div class="wrapper">
<span class="subtitle flushed">In collaboration</span>

## Building towards an industry consensus

We’re developing SLSA collectively to tackle common threats across the supply chain.

<div class="pseudo-button m-t-l">

[Get involved](getinvolved.md)

</div>

</div>

<div class="wrapper m-t-xl">
<span class="subtitle flushed">Get started</span>

## See a GitHub Actions demo

Check our demonstration for SLSA level 1 with [a provenance generator for GitHub Actions](https://github.com/slsa-framework/github-actions-demo).

</div>

</section>

<!-- Two column wrap-up -->
<section class="col-2 content-block">
<span>

## SLSA is currently in alpha

The framework is constantly being improved. We encourage the community to try adopting SLSA levels incrementally and to share your experiences back to us.

Google has been using an internal version of SLSA since 2013 and requires it for all of Google's production workloads.

<div class="pseudo-button m-t-l">

[See our roadmap](roadmap.md)

</div>
</span>

<span>

## Get involved

SLSA is building towards an industry consensus. We’re developing SLSA collectively to tackle common threats across the supply chain.

We rely on feedback from other organisations to make it more useful for more people. We’d love to hear from you about your experiences using SLSA.

**Are the levels achievable in your project? Would you add or remove anything from the framework? What’s preventing you from adopting it today?**

<div class="pseudo-button m-t-l">

[Join the conversation](getinvolved.md)

</div>

</span>
