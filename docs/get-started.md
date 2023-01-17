---
title: Get started
layout: standard
hero_text: If you’re looking to jump straight in and try SLSA, here’s a quick start guide for the steps to take to reach the the different SLSA levels. 
---

<section class="section bg-pastel-green flex justify-center items-center">
    <div class="wrapper inner w-full">
        <div class="md:flex justify-between items-start mb-16">
            <div class="text w-full md:w-1/3">
<div class="h2 -mt-16 p-0">

## Choosing Your SLSA Level

</div>
            </div>
            <div class="w-full md:w-2/3">
                <div class="bg-white h-full rounded-lg p-10">
                    <p>
For all SLSA levels, you follow the same basic steps:

1) Generate provenance, i.e., document your build process
2) Allow downstream users to verify that the provenance exists

What differs for each level is the robustness of the build and provenance. For more information about provenance see [https://slsa.dev/provenance/v0.2](https://slsa.dev/provenance/v0.2). </p>
    
<p>The builders suggested in this guide meet SLSA expectations. If you believe a build option is missing or misclassified, please <a href="https://github.com/slsa-framework/slsa/issues">open an issue</a>.
                    </p>
                    <p>SLSA levels are progressive: SLSA 3 includes all the guarantees of SLSA 2, and SLSA 2 includes all the guarantees of SLSA 1. Currently, though, the work required to achieve lower SLSA levels will not necessarily accrue toward the work needed to achieve higher SLSA levels. For that reason, <b>you should start with the highest level that’s possible for your project or organization to avoid wasted work</b>. </p>
            <p>        The SLSA level you implement depends on your current build situation:

* If you are using GitHub Actions or Google Cloud Build, jump directly to SLSA 3.  You do not need to implement SLSA 1 or SLSA 2.
* If you are using FRSCA, jump to SLSA 2.  You do not need to implement SLSA 1.
* If you’re using any other build system or are not using a build system, consider adopting GitHub Actions, Google Cloud Build, or FRSCA. If that isn’t possible, start with SLSA 1. Note that if you choose to use SLSA 1, you may not have a growth path to SLSA 2 or SLSA 3.  It is recommended that unless you have a specific reason for using SLSA 1, that you start with SLSA 2, or if possible SLSA 3.

<b>Note:</b> SLSA 4 is not yet supported by any widely available build system.
                </div>
            </div>
<div class="h3 -mt-16 p-0">

### Provenance Verification

</div>
                        <div class="w-full md:w-2/3">
                <div class="bg-white h-full rounded-lg p-10">
                    <p>
Various build methods require different methods to verify provenance. The SLSA community already has some verification methods and is working on additional solutions for provenance verification. Even if there is currently no simple verification method for a particular build system, adopting these builders now means you will be “SLSA ready” when more ecosystem tooling is released. Note that when you create provenance, you must supply to users a method for interpreting what you have created.
                    </p>
                </div>
            </div>
     <div class="h3 -mt-16 p-0">

### Provenance Formatting

</div>
                         <div class="w-full md:w-2/3">
                <div class="bg-white h-full rounded-lg p-10">
                    <p>
Your provenance format depends on who will be consuming it. See <a href="https://slsa.dev/provenance/v0.2">provenance</a> for an explanation of which format to choose. With time, the SLSA community hopes that SLSA Provenance Format will become industry standard, so we encourage you to adopt it if possible.
                    </p>
                </div>
            </div>
            <div class="h3 -mt-16 p-0">

### Provenance Storage

</div>
                        <div class="w-full md:w-2/3">
                <div class="bg-white h-full rounded-lg p-10">
                    <p>
Containers have a standard place to put the provenance in the OCI container registry. With time, the SLSA community hopes to create standard ecosystem-based repositories for provenance. For now, the convention is to keep the provenance attestation with your artifact. Though the sigstore bundle that's used currently is semi-standard, the format of the provenance is currently tool-specific.
                    </p>
                </div>
            </div>
        </div>
    </div>
</section>            



<section class="section bg-pastel-green flex justify-center items-center">
    <div class="wrapper inner w-full">
        <div class="md:flex justify-between items-start mb-16">
            <div class="text w-full md:w-1/3">
<div class="h2 -mt-16 p-0">
<a/ id="SLSA1">
    
## SLSA 1

As mentioned, if you don't already use a build service or CI/CD, we recommend you adopt one of the systems listed under SLSA 2 or SLSA 3. While this is not required for SLSA 1, it makes the following steps easier and is required for higher SLSA levels. Individual developers who wish to put a minimal amount of security on their builds use SLSA 1.
              
               
SLSA 1 requires that the build process is documented. Some tools suggested below also support signed provenance. Though not required, signing your provenance increases trust in the document by showing that it has not been tampered with. 
                 <div class="h3 -mt-16 p-0">

### Tooling
A build configuration file (i.e., cloudbuild.yml, GitHub workflow) qualifies for SLSA 1. It would be considered unsigned, unformatted provenance. 
                     
</div>
                     <p class="h4 font-bold mb-6" id="tools">Tools</p>

#### Build Service Plugins or Extensions

These options work with your build system to produce unsigned, formatted provenance. They do not qualify for SLSA 2 because they are unsigned and not run by the hosted server.                    
</div><ul>
    <a href="https://github.com/slsa-framework/slsa/issues">open an issue</a>
    <li><a  href="https://github.com/slsa-framework/azure-devops-demo">Azure DevOps extension</a></li>
    <li>Jenkins SLSA generator </li>
    <li>Jenkins plugin</li>
    </ul>
 
Downstream users verify the provenance with Cue Policies.                    <ul class="list-disc mt-6 pl-6">
                        <li><a href="https://github.com/slsa-framework/slsa-github-generator#provenance-only-generators">GitHub actions provenance generators</a> (SLSA level 3)</li>
                        <li><a href="https://github.com/slsa-framework/azure-devops-demo">Azure DevOps provenance generator</a> (SLSA level 1)</li>
                        <li><a href="https://cloud.google.com/build/docs/securing-builds/use-provenance-and-binary-authorization">Google Cloud Build</a> (SLSA level 2)</li>
                        <li><a href="https://github.com/sigstore/cosign">Sigstore Cosign for storing signed provenance</a></li>
                        <li><a href="https://github.com/buildsec/frsca">OpenSSF - Factory for Repeatable Secure Creation of Artifacts (FRSCA)</a> (Currently SLSA level 2)</li>
                        <li><a href="https://github.com/in-toto">in-toto</a>: Several in-toto implementations (Go, Java, Rust) and integrations (Jenkins Plugin) support the generation of SLSA provenance attestations</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</section>

<section class="section bg-pastel-green flex justify-center items-center">
    <div class="wrapper inner w-full">
        <div class="md:flex justify-between items-start mb-16">
            <div class="text w-full md:w-1/3">
<div class="h2 -mt-16 p-0">
<a/ id="SLSA3">

## Reaching SLSA Level 3
    
</div>
<p class="h4 font-semibold my-6 text-green-dark">Effort: Low</p>
            </div>
            <div class="w-full md:w-2/3">
                <div class="bg-white h-full rounded-lg p-10">
                    <p class="h4 font-bold mb-6">Overview<p>
                    <p>
                        This guide will help you achieve the <a href="/spec/v0.1/requirements#build-requirements">build</a> and <a href="/spec/v0.1/requirements#provenance-requirements">provenance</a> requirements of Level 3, and it should take less than a couple of hours for an individual project. The goals is to achieve the following requirements:
                    <ul class="list-disc my-6 pl-6">
                        <li><a href="/spec/v0.1/requirements#build-as-code">Build as code</a></li>
                        <li><a href="/spec/v0.1/requirements#ephemeral-environment">Ephemeral environment</a></li>
                        <li><a href="/spec/v0.1/requirements#isolated">Isolated</a></li>
                        <li><a href="/spec/v0.1/requirements#parameterless">Parameterless</a></li>
                        <li><a href="/spec/v0.1/requirements#non-falsifiable">Non-falsifiable</a></li>
                    </ul>
                    </p>
                    <p class="mb-10">
                        The list of tools is not exhaustive. If there are tools missing from this list, please <a href="https://github.com/slsa-framework/slsa/issues">create a GitHub issue</a>.
                    </p>
                    <p class="h4 font-bold mb-6" id="tools">Tools</p>
                    <ul class="list-disc mt-6 mb-10 pl-6">
                        <li><a href="https://github.com/slsa-framework/slsa-github-generator">GitHub actions builders and generators</a> (SLSA level 3)</li>
                    </ul>
                    <p class="h4 font-bold mb-6">Celebrate</p>
                    <ul class="list-decimal mt-6 mb-10 pl-6">
                        <li>Update your documentation to let users know you generate provenance and encourage them to verify it when downloading your binaries. Also, consider contributing to the <a href="/blog">SLSA blog</a> and let others know about your journey, or submit a <a href="https://github.com/slsa-framework/slsa/tree/main/case-studies">case study</a>!</li>
                        <li>You’re now generating non-forgeable <a href="/provenance/">SLSA provenance</a> that meets the <a href="/spec/v0.1/requirements#build-requirements">build</a> and <a href="/spec/v0.1/requirements#provenance-requirements">provenance</a> requirements for <a href="/spec/v0.1/levels">SLSA level 3 and above</a>! Add the <a href="images/gh-badge-level3.svg">SLSA Level 3 badge</a> to your project's readme.</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</section>

<section class="section bg-white flex justify-center items-center">
    <div class="wrapper inner w-full">
        <div class="justify-between items-start md:-mr-10 md:-ml-10">
            <div class="text w-full md:pl-10">
<div class="h2 -mt-16 mb-8">

## Building to higher levels

</div>
            </div>
            <div class="w-full md:pl-10">
                <div class="bg-white">
                    <p>Once the foundations are in place with Level 1, you can start looking towards the higher levels to further strengthen artifact integrity with central monitoring, authentication and automated compilation, as well as more secure development practices. But there’s a few things to consider first:</p>
                </div>
            </div>
            <div class="w-full mt-8">
                <div class="bg-white md:flex justify-between">
                    <div class="mt-6 w-full md:w-1/2 md:pl-10">
                        <p class="h3 font-semibold mb-6 ">Define your ideal state</p>
                        <p class="pb-4">Which level is most realistic, which is appropriate for your project in the short term and for your immediate needs? It can take years to achieve the ideal security state, so having intermediate milestones is important.<br><br>Not all projects require Level 4, and for others it’s impossible to achieve. If it seems unrealistic for your project, focus your efforts on Level 3 instead.</p>
                    </div>
                    <div class="mt-6 w-full md:w-1/2 md:pl-10">
                        <p class="h3 font-semibold mb-6 ">Make progress in parallel</p>
                        <p class="pb-4">You can progressively attain higher SLSA levels. Each artifact’s SLSA level is independent from one another, allowing parallel progress and prioritization based on risk.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>
<section class="section">
    <div class="wrapper inner w-full">
        <div class="md:flex flex-col justify-center items-center mb-8 md:w-2/3 mx-auto md:pl-5">
            <div class="-mt-8 mb-8 md:mb-4"><h4 class="h2 font-normal">Help us improve SLSA</h4></div>
            <div class="w-full lg:w-full mx-auto text-center">
                <p>Already at SLSA Level 1? Let us know what went well, what didn’t, and what could be improved. We’re developing new tools and onboarding resources to make the process even easier, so your contribution really goes a long way.</p>
                <a href="https://github.com/slsa-framework/slsa/issues" class="cta-link font-semibold h5 center mt-8">Leave a GitHub issue</a><br>
                <a href="community" class="cta-link font-semibold h5 center mt-8">Join the community</a>
            </div>
        </div>
    </div>
</section>
