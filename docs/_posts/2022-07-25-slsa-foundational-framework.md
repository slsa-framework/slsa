---
title: "All about that Base(line): How Cybersecurity Frameworks are Evolving with Foundational Guidance"
author: "Jennifer Privette"
is_guest_post: true
---

<!-- markdownlint-disable MD036 -->
*In coordination with Aaron Bacchi, Emmy Eide, Melba Lopez, Brandon Lum, and Moshe Zioni*

SUMMARY: Software security frameworks are beginning to give organizations foundational guidance they can build on so that they can start small with easily achievable tasks, and then increase to the highest assurances of integrity. SLSA does this in four levels of maturity. NIST also recently updated one of its main cybersecurity frameworks with foundational guidance. This blog shows examples of foundational guidance from both SLSA and NIST and introduces a mapping document that illustrates the correlation among SLSA and other existing frameworks.
<p>&nbsp;</p>

Organizations large and small are eager for measured, actionable guidance on how to improve their cybersecurity supply chain posture. Well before the United States President's [Executive Order mandate](https://www.whitehouse.gov/briefing-room/presidential-actions/2021/05/12/executive-order-on-improving-the-nations-cybersecurity/), frameworks like [Supply chain Levels for Software Artifacts (SLSA)](https://slsa.dev/) were organizing practical advice for supply chain security divided into increasingly sophisticated levels that built a foundation for success.

These SLSA levels for software, supply chains, and their component parts start small, with easily achievable tasks to help organizations gain visibility right away and then increase to the highest assurances of integrity.

Few frameworks are like SLSA. Many, including the National Institute of Standards and Technology (NIST) frameworks historically, can be overlapping, and sometimes overwhelming. It can be difficult to know where to start. It can be difficult to assess where you are in your efforts. In June, the SLSA community published a [guest blog post](2022-06-15-slsa-ssdf.md) about the relationship between SLSA and the Secure Software Development Framework (SSDF).

In addition to SSDF, NIST updated one of its main publications in the area of supply chain risk management,*[Cybersecurity Supply Chain Risk Management Practices for Systems and Organizations (NIST SP 800-161r1)](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-161r1.pdf)*. This authoritative body of work is a treasure trove of recommended practices and this update, among other things,  interprets the intent of those best practices–within the context of the 2021 United States Executive Order (EO) on Cybersecurity 14028. It formulates them as recommendations that outline increasingly advanced guidance in a new maturity model called **Key Practices**.

This is significant because it now recognizes the need for **foundational guidance**. Many entities who make up critical infrastructures are mostly small to medium-sized companies with widely varying capabilities. Without being overly prescriptive, it is important that frameworks such as SP800-161r1 and others provide the ability for organizations to understand where they are in their security journey in an objective manner that helps them start right away and then build for the future.

That’s the “secret sauce” in the SLSA framework, right? The foundational guidance that begins with the basics and helps you get better over time is a key ingredient in SLSA.

The addition of foundational guidance in the US government’s NIST material is quite welcome, and similar clarifications could follow later this year in the NIST Cybersecurity Framework as it relates to both the EO and organization expectations.

The ([attached](https://docs.google.com/spreadsheets/d/1P_xxMlyF5iPV51CqIk8_EhI57aR6wf1Gkrg8sRHBMMQ/edit#gid=0)) mapping document, created by members of the SLSA working group,  loosely illustrates the correlation among SLSA and other existing frameworks and controls. It may be useful to see where SLSA fits within these other frameworks at a glance. As frameworks evolve, the mapping will continue to be updated and community feedback is welcome.

Let’s take a look at this new Key Practices maturity model from SP800-161r1 and overlay some of the SLSA controls.

But first, a little history.
<p>&nbsp;</p>

## The Big Four

The “big four” of cybersecurity supply chain risk management publications are the following NIST documents:

-   *Security and Privacy Controls for Information Systems and Organizations* ([NIST SP 800-53r5](https://csrc.nist.gov/publications/detail/sp/800-53/rev-5/final))
-   *Cybersecurity Supply Chain Risk Management Practices for Systems and Organizations* ([NIST SP 800-161r1](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-161r1.pdf))
-   *Secure Software Development Framework (SSDF) Version 1.1: Recommendations for Mitigating the Risk of Software Vulnerabilities* ([NIST SP 800-218](https://csrc.nist.gov/publications/detail/sp/800-218/final))
-   *Framework for Improving Critical Infrastructure Cybersecurity [Version 1.1](https://www.nist.gov/news-events/news/2018/04/nist-releases-version-11-its-popular-cybersecurity-framework)*

Although the first two are ultimately written for US federal agencies, they are available for everyone to use and include both the criteria to evaluate software security itself as well as developer and supplier security practices. Acquirers and end users of software, products, and services use these publications in tandem to understand what risks to look for and what actions to consider taking in response. SP800-53r5 is the “rock”, the “foundation” and prerequisite reading to the SP800-161r1, which is considered the framework and is mandatory for all US federal agencies. NIST standards are known to be transposed and translated by other entities, global and local, so by extension the standards have a much larger practical effect globally, by other regulatory entities and governments alike.

The newly updated SP800-161r1 includes templates for strategy and implementation plans, risk assessments, information-sharing agreements with business partners and suppliers, but it’s the detailed lists of Key Practices that make this update most useful.
<p>&nbsp;</p>

## Key Practices: Foundational, Sustaining, and Enhancing

Divided into three guidance categories of Foundational, Sustaining, and Enhancing, NIST gives detailed, actionable information at each category.  The guidance helps organizations build cybersecurity supply chain recommendations and requirements into their purchasing activities. Because issues can occur at any point in the lifecycle or any link in the supply chain, the guidance now considers potential vulnerabilities such as sources of code within a given product, or suppliers who provide it.

Organizations of all sizes and sophistication levels can prioritize, customize, and implement these capabilities beginning at the Foundational level. Below is an example from each level.
<p>&nbsp;</p>

### Foundational Guidance Example

Establish a governance capability for managing and monitoring components of embedded software to manage risk across the enterprise (e.g. SBOMs paired with criticality, vulnerability, threat, and exploitability to make this more automated.)

**SLSA Examples:** [Source Version Control](https://slsa.dev/spec/v0.1/requirements#version-controlled), [Scripted Builds](https://slsa.dev/spec/v0.1/requirements#scripted-build), [Provenance Available.](https://slsa.dev/spec/v0.1/requirements#available)
<p>&nbsp;</p>

### Sustaining Guidance Example

Next steps to enhance Cybersecurity Supply Chain Risk Management (C-SCRM). Use confidence building mechanisms such as third-party assessment surveys, on-site visits, and formal certifications such as the ISO 27000 family.

**SLSA Examples:** [Verified History Retention](https://slsa.dev/spec/v0.1/requirements#verified-history), [Build Service](https://slsa.dev/spec/v0.1/requirements#build-service), [Provenance Service Generated](https://slsa.dev/spec/v0.1/requirements#service-generated).
<p>&nbsp;</p>

### Enhancing Guidance Example

Applied with the goal of advancing toward adaptive and predictive C-SCRM capabilities. Automate C-SCRM processes where applicable and practical.

**SLSA Examples**: [Provenance Non-falsifiable](https://slsa.dev/spec/v0.1/requirements#non-falsifiable), [Ephemerial Environment](https://slsa.dev/spec/v0.1/requirements#ephemeral-environment), [Reproducible Build](https://slsa.dev/spec/v0.1/requirements#reproducible).
<p>&nbsp;</p>

## The Cybersecurity Framework: 2.0 and Beyond

The NIST Cybersecurity Framework (CSF) was last updated in 2018 and is currently planning a more significant revision to the Framework: CSF 2.0. The Summary Analysis of requests for information was published in June of this year.

During this update there will be an opportunity to address one of the recurring themes from respondents, which was to be able to have flexible, simple resources that show them where to start, how to prioritize, and where to focus resources that are limited. Practical examples and easy to use guidance can go a long way in helping small to medium-sized organizations get started right away.

Sound familiar?

The Framework already does a good job of differentiating risk levels, but there is an  opportunity here for gaining insight and clarity by adding objective criteria for evaluating a company’s current cybersecurity posture and creating Tier consistency across organizations. This should be accomplished without being prescriptive or making the Framework so monolithic that it is cumbersome, and without reworking it to such an extent as to make the existing Tiers unrecognizable.  Stay tuned to the NIST website to see what they have in store for a 2.0 draft.
<p>&nbsp;</p>

## In Conclusion

Flexible +  Simple + Foundational Guidance = A recipe for a useful framework, whether that is the Cybersecurity Framework, SLSA, or some other framework—organizations are expecting this help from NIST, from their vendors, from their partners, from all of us.

Mapping across frameworks is a helpful resource. But it is also illustrative of a point worth remembering: More is not always better, sometimes more is just more. Here’s hoping for continuing evolution in the area of measured, actionable cybersecurity guidance, like that which is found in the SLSA framework.

Members of the SLSA working group invite community feedback and participation in this [mapping](https://docs.google.com/spreadsheets/d/1P_xxMlyF5iPV51CqIk8_EhI57aR6wf1Gkrg8sRHBMMQ/edit#gid=0) as the SLSA framework evolves and industry interest continues. We hope that seeing how SLSA fits within NIST existing frameworks such as SSDF and the C-SCRM frameworks at a glance is beneficial to your organizations.
