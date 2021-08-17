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

Each level provides requirements, processes and best practices to increase trust in software. These look at the integrity of the source and build services, available information about the code, reproducibility and resilience against tampering or human error.

<div class="level-icons m-b-l m-t-xl">

<div class="level">

<div class="level-badge">

![Level 1](images/levelBadge1.svg)

</div>

### Basic protection

Provenance checks to help evaluate risks and security

</div>

<div class="level">

<div class="level-badge">

![Level 2](images/levelBadge2.svg)

</div>
<<<<<<< Updated upstream

### Medium protection

Further checks against the origin of the software

</div>

<div class="level">

=======

### Medium protection

Further checks against the origin of the software

</div>

<div class="level">

>>>>>>> Stashed changes
<div class="level-badge">

![Level 3](images/levelBadge3.svg)

</div>

### Advanced protection

Extra resistance to specific classes of threats

</div>
<div class="level">

<div class="level-badge">

![Level 4](images/levelBadge4.svg)

</div>

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

## How do you mitigate risks to your supply chain?

Any software can introduce vulnerabilities into a supply chain, with recent high profile supply chain attacks proving how costly an attack can be. The requirements and checks that make up the SLSA framework aim to empower developers and software consumers to easily check the integrity of software artifacts, developed in direct response to [known supply chain attacks](levels.md#threats).

</span>
<span>

## Standard security guidelines that scale for your future

SLSA levels are a way to better understand your current security posture, and plan for the future. If you’re a software consumer, you can check that the security information for any software in your supply chain is accurate, whether it provides the exact level of security you need, and help develop, share and promote tools that automate the process.

<div class="pseudo-button">

[Read the requirements](requirements.md)

</div>

</span>

</section>
<!-- Future -->
<section class="breakout">

<div class="wrapper">
<span class="subtitle flushed">In collaboration</span>

## Building towards the future

<span class="subtitle">
Today’s projects, products and services are increasingly complex and open to attack. As that trend continues, we need to scale up our effort to provide more secure, accessible ways to protect the development, distribution and consumption of the software we use, and all the impacted communities behind it.
</span>

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
