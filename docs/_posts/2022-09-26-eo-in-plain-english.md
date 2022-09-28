---
title: "Executive Order on Secure Supply Chain — in Plain English"
author: "Isaac Hepworth"
is_guest_post: true
---

You may have heard about [EO 14028](https://www.whitehouse.gov/briefing-room/presidential-actions/2021/05/12/executive-order-on-improving-the-nations-cybersecurity/), the “Executive Order on Improving the Nation’s Cybersecurity”, which mandates the establishment of minimum supply chain security standards for all software consumed by the US government. On September 14th the White House Office of Management and Budget (OMB) issued [a memorandum](https://www.whitehouse.gov/wp-content/uploads/2022/09/M-22-18.pdf) setting firm and aggressive timelines for implementation of guidelines stemming from the EO, and you might reasonably be wondering what it all means. If so, this post is for you. We’re going to try to lay it out in plain English and share steps to help you get ready to meet the timelines

## Background

First, a little history.

In **May 2021**, President Biden’s White House published [Executive Order (EO) 14028 on Improving the Nation’s Cybersecurity](https://www.whitehouse.gov/briefing-room/presidential-actions/2021/05/12/executive-order-on-improving-the-nations-cybersecurity/), recognizing “persistent and increasingly sophisticated malicious cyber campaigns that threaten the public sector, the private sector, and ultimately the American people’s security and privacy”. The Executive Order directed the US Secretary of Commerce acting through the Director of NIST to “issue guidance identifying practices that enhance the security of the software supply chain”.

After a [request for comments](https://www.ntia.gov/files/ntia/publications/frn-sbom-rfc-06022021.pdf) in **June 2021**, the US Department of Commerce [issued in July 2021](https://www.ntia.gov/blog/2021/ntia-releases-minimum-elements-software-bill-materials) a report [Minimum Elements for an SBOM](https://www.ntia.doc.gov/files/ntia/publications/sbom_minimum_elements_report.pdf), as part of establishing new baseline security standards for development of software used by the US Federal Government. We published a [blog post on SLSA and SBOMs](2022-05-02-slsa-sbom.md) a little while ago.

In **February 2022**, in accordance with with EO, the US National Institute of Standards and Technology ([NIST](nist.gov)) issued two documents with further standards, now collectively known as the “NIST Guidance”:

-   Secure Software Development Framework (SSDF), SP 800-218 [[link](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-218.pdf)]
-   Software Supply Chain Security Guidance [[link](https://www.nist.gov/system/files/documents/2022/02/04/software-supply-chain-security-guidance-under-EO-14028-section-4e.pdf)]

We covered the SSDF briefly in a [previous slsa.dev blog post](2022-06-15-slsa-ssdf.md), and noted how SLSA could form a ready on-ramp to successful SSDF conformance.

## What’s new

In **September 2022** the White House Office of Management and Budget (OMB) issued [a memorandum](https://www.whitehouse.gov/wp-content/uploads/2022/09/M-22-18.pdf) requiring every Federal agency to comply with the NIST Guidance “when using third-party software on the agency’s information systems or otherwise affecting the agency’s information”.

In **June 2023**, compliance with the NIST Guidance will be required for all “critical software” used by Federal agencies.

In **September 2023**, compliance with the NIST Guidance will be required for all third-party software used by Federal agencies.

## What it means

If your software is sold to, or used by, the US Federal government then your ears should be pricking up about now. Starting next year you will be expected, for each major version of each software product you supply, to provide:

-   A self-attestation that the product was built in conformance with NIST’s Secure Software Development Framework (SSDF). NIST has published online a handy [matrix of SSDF requirements](https://csrc.nist.gov/csrc/media/Publications/sp/800-218/final/documents/NIST.SP.800-218.SSDF-table.xlsx).
-   On request, a Software Bill of Materials (SBOM) for the product. The NTIA report [Minimum Elements of an SBOM](https://www.ntia.doc.gov/files/ntia/publications/sbom_minimum_elements_report.pdf) is a useful starting point for understanding what’s required.
-   On request, other artifacts substantiating SSDF conformance, e.g., output of vulnerability scanners, software provenance metadata, etc.
-   On request, evidence of participation in a Vulnerability Disclosure Program.

Even if your software is not in scope today, you might nonetheless find your customers asking for the same things before long, as the new US Federal Government standards raise the bar across the industry.

## What’s in scope

Notably, the OMB memo extends to software **used** by agencies, not merely software **procured** by agencies. That brings into scope products which haven’t previously had to work with government compliance standards, such as free or liberally licensed ones.

The OMB dictates that agencies will themselves by **December 2022** generate a software inventory listing which products will need to meet the new requirements next year; and of those which are considered “critical” and will need to comply by **June 2023**, ahead of the **September 2023** deadline for everything else. The agencies will use [NIST’s definition](https://www.nist.gov/itl/executive-order-improving-nations-cybersecurity/critical-software-definition-explanatory) to determine criticality.

## What now?

First, don’t panic!

Instead, you can get started right away with some immediate concrete steps:

-   Review the [OMB memorandum](https://www.whitehouse.gov/wp-content/uploads/2022/09/M-22-18.pdf) itself. This blog post provides a plain English summary but omits some details such as how exceptions are handled, how remediation plans work, how self-attestations are made in practice, and so on. It’s worthwhile reading the original text to get the full skinny.
-   Familiarize yourself with the [practices and tasks](https://csrc.nist.gov/csrc/media/Publications/sp/800-218/final/documents/NIST.SP.800-218.SSDF-table.xlsx) of the [Secure Software Development Framework](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-218.pdf) (SSDF), and begin to develop a sense of how your own software development processes map onto NIST’s set. Take note of any glaring gaps you see.
-   Read up on SBOMs. A 2019-era NTIA whitepaper “[Roles and Benefits for SBOM Across the Supply Chain](https://www.ntia.gov/files/ntia/publications/ntia_sbom_use_cases_roles_benefits-nov2019.pdf)” includes a comprehensive catalog of potential benefits offered by SBOMs, and the companion document [Minimum Elements of an SBOM](https://www.ntia.doc.gov/files/ntia/publications/sbom_minimum_elements_report.pdf) lays out a pragmatic starting point.
-   Review [NIST’s definition](https://www.nist.gov/itl/executive-order-improving-nations-cybersecurity/critical-software-definition-explanatory) of “critical software” to understand if your products fall into this category. If so, your conformance with the new standards is expected by June next year, rather than September.
-   See how SLSA can help! Read the previous posts [SBOM + SLSA: Accelerating SBOM success with the help of SLSA](2022-05-02-slsa-sbom.md) and [SLSA for Success: Using SLSA to help achieve NIST’s SSDF](2022-06-15-slsa-ssdf.md).
