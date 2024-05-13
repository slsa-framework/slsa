---
title: "Securing software artifacts with Tekton Chains and IBM's DevSecOps"
author: "Arnaud J Le Hors"
is_guest_post: true
---

Tekton Chains, and the IBM DevSecOps offering that builds on it, can now be used to secure software artifacts with SLSA.

## From DevOps to DevSecOps

For years the industry has been advocating the modernization of development processes with the adoption of what is known as "DevOps" with the promise that, by combining and automating software development and IT operations, DevOps can speed delivery of higher-quality software. However, with the constant rise in security attacks against all software we've seen a quick shift towards "DevSecOps" which continuously integrates and automates security throughout the DevOps lifecycle. DevSecOps makes security a first class citizen by addressing security concerns throughout the development lifecycle rather than as an afterthought and often last check.

## Tekton Chains

[Tekton](https://tekton.dev) is a powerful and flexible open-source framework for creating continuous integration and delivery (CI/CD) systems which is used in the industry to manage the production and deployments of software artifacts in the cloud as part of a DevOps strategy. [Tekton Chains](https://tekton.dev/docs/chains/) adds to Tekton a resource controller which can be used to manage your supply chain security in Tekton pipelines and move you towards DevSecOps.

As a sign of SLSA's growing adoption, Tekton Chains has been adding support for the production of SLSA Provenance attestations along with the ability to sign and verify artifacts with [sigstore](https://sigstore.dev).

However, if you follow the [Getting Started Supply Chain Security Tekton tutorial](https://tekton.dev/docs/getting-started/supply-chain-security/) you will see that the attestation that you get is in the Provenance v0.1 or v0.2 format. While this is sufficient to achieve SLSA compliance you will probably want to get it in the Provenance v1 format rather since this is what is part of [SLSA v1.0 released last year](/blog/2023/04/slsa-v1-final).

The good news is that thanks to a change introduced in [Tekton Chains v0.17.0](https://github.com/tektoncd/chains/releases/tag/v0.17.0), which was released last summer, Tekton Chains can now produce attestations in the SLSA Provenance v1 format. The challenge is that getting the right configuration to enable this capability involves option names that are not obvious.

Indeed, one must set the Tekton Chains configuration output format option to `slsa/v2alpha3` to get the Provenance v1 format, while setting the format to `slsa/v1` (which is currently the default) produces an attestation in Provenance v0.2. These values are obviously unfortunate. There is actually evidence in the repo that they weren't meant to be exposed to the user but, as it sometimes happens, things that are meant to be temporary stick beyond the initial phase and, as specified in the [How to configure Tekton Chains](https://tekton.dev/docs/chains/slsa-provenance/#how-to-configure-tekton-chains) documentation, `slsa/v2alpha3` is what you must use for now.

Obviously, it would make sense to have more straightforward values and for the v1 format to be the default. I will do what I can by engaging with the Tekton Chains community to help make this happen, but in the meantime you now have the right configuration to get the desired result.

## IBM DevSecOps

The [IBM DevSecOps offering](https://cloud.ibm.com/docs/devsecops) available to IBM Cloud users is based on Tekton and Tekton Chains and since January this year one can use it as a SLSA Level 3 build platform producing SLSA Provenance v1 attestations.

This build platform is used internally by IBM to produce software artifacts such as the [IBM Cloud Paks](https://www.ibm.com/cloud-paks) generating along with them both SBOMs and SLSA Provenance attestations, and IBM Cloud users can equally benefit from it by using it to produce their own software artifacts.

I'm happy to say that the configuration of IBM DevSecOps is a bit more straightforward than that of Tekton Chains and one can simply set the `slsa-attestation` parameter to `1` to get the build platform to produce SLSA attestations in the Provenance v1 format.

You can then use [cosign](https://github.com/sigstore/cosign) to verify the signature on the produced attestation.

More details can be found in the [Configuring collection of SLSA attestations for images](https://cloud.ibm.com/docs/devsecops?topic=devsecops-cd-devsecops-slsa) and the [Pipeline Private Workers - What is SLSA?](https://cloud.ibm.com/docs/ContinuousDelivery?topic=ContinuousDelivery-slsa-whatis) documentation.

## Related information

[SLSA 1.0](/spec/v1.0/)

[SLSA Provenance v1](/spec/v1.0/provenance)

[Secure Your Software Supply Chain with SLSA Level 3 Support on IBM Cloud](https://community.ibm.com/community/user/cloud/blogs/steve-weaver1/2024/01/11/secure-your-software-supply-chain-with-slsa-level)
