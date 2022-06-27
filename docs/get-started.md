---
title: Get started
layout: standard
hero_text: If you’re looking to jump straight in and try SLSA, here’s a quick start guide for the steps to take to reach the first SLSA level. Level 1 ensures that you’re setting up the foundation of trust in a system and that all your applications are generating appropriate provenance data. It also sets a baseline to achieve higher SLSA compliance later, which we explain in detail below.
---
<section class="section bg-pastel-green flex justify-center items-center">
    <div class="wrapper inner w-full">
        <div class="md:flex justify-between items-start mb-16">
            <div class="text w-full md:w-1/3">
<div class="h2 p-0">

## Reaching SLSA Level 1

</div>
<p class="h4 font-semibold my-6 text-green-dark">Effort: Low</p>
            </div>
            <div class="w-full md:w-2/3">
                <div class="bg-white h-full rounded-lg p-10">
                    <p class="h4 font-bold mb-6">Overview<p>
                    <p>
                        This guide will help you achieve Level 1, and it should take less than a couple of hours for an individual project. The goals is to:
                    <ul class="list-disc my-6 pl-6">
                        <li>Automate your builds</li>
                        <li>Produce provenance data</li>
                    </ul>
                    </p>
                    <p class="mb-10">
                        The tools listed are optional resources only, there for demonstration and context-specific guidance.
                    </p>
                    <p class="h4 font-bold mb-6">Steps</p>
                    <ul class="list-decimal mt-6 mb-10 pl-6">
                        <li>If you don't already use a build service or CI/CD, we recommend you set one up. This is not strictly required but it makes the following steps easier and is needed for higher levels. Consider using a service that is supported in the next step.</li>
                        <li>Generate <a href="provenance">provenance</a> during your build. The <a href="#tools">tools</a> below might be useful. If your build service is not listed there, consider creating a plugin to generate provenance.
                        <li>Make the provenance available to your consumers. We don't yet have a standard convention for this. Best practises will develop as SLSA becomes more popular and we get more experience.</li>
                        <li>You’re Level 1! Add the <a href="images/SLSA-Badge-full-level1.svg">SLSA Level 1 badge</a> to your project's readme.</li>
                    </ul>
                    <p class="h4 font-bold mb-6" id="tools">Tools</p>
                    <ul class="list-disc mt-6 pl-6">
                        <li><a href="https://github.com/slsa-framework/github-actions-demo">GitHub actions provenance generator</a> (SLSA level 1)</li>
                        <li><a href="https://github.com/slsa-framework/azure-devops-demo">Azure DevOps provenance generator</a> (SLSA level 1)</li>
                        <li><a href="https://cloud.google.com/build/docs/securing-builds/use-provenance-and-binary-authorization">Google Cloud Build</a> (SLSA level 2)</li>
                        <li><a href="https://github.com/sigstore/cosign">Sigstore Cosign for storing signed provenance</a></li>
                        <li><a href="https://github.com/buildsec/frsca">OpenSSF - Factory for Repeatable Secure Creation of Artifacts (FRSCA)</a> (Currently SLSA level 2)</li>
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
<div class="h2 p-0">

## Reaching SLSA Level 3

</div>
<p class="h4 font-semibold my-6 text-green-dark">Effort: Low</p>
            </div>
            <div class="w-full md:w-2/3">
                <div class="bg-white h-full rounded-lg p-10">
                    <p class="h4 font-bold mb-6">Overview<p>
                    <p>
                        This guide will help you achieve the <a href="https://slsa.dev/spec/v0.1/requirements#build-requirements">build</a> and <a href="https://slsa.dev/spec/v0.1/requirements#provenance-requirements">provenance</a> requirements of Level 3, and it should take less than a couple of hours for an individual project. The goals is to achieve the following requirements:
                    <ul class="list-disc my-6 pl-6">
                        <li><a href="https://slsa.dev/spec/v0.1/requirements#build-as-code">Build as code</a></li>
                        <li><a href="https://slsa.dev/spec/v0.1/requirements#ephemeral-environment">Ephemeral environment</a></li>
                        <li><a href="https://slsa.dev/spec/v0.1/requirements#isolated">Isolated</a></li>
                        <li><a href="https://slsa.dev/spec/v0.1/requirements#parameterless">Parameterless</a></li>
                        <li><a href="https://slsa.dev/spec/v0.1/requirements#non-falsifiable">Non-falsifiable</a></li>
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
                        <li>Update your documentation to let users know you generate provenance and encourage them to verify it when downloading your binaries. Also, consider contributing to the <a href="https://slsa.dev/blog">SLSA blog</a> and let others know about your journey, or submit a <a href="https://github.com/slsa-framework/slsa/tree/main/case-studies">case study</a>!</li>
                        <li>You’re now generating non-forgeable <a href="https://slsa.dev/">SLSA provenance</a> that meets the <a href="https://slsa.dev/spec/v0.1/requirements#build-requirements">build</a> and <a href="https://slsa.dev/spec/v0.1/requirements#provenance-requirements">provenance</a> requirements for <a href="https://slsa.dev/spec/v0.1/levels">SLSA level 3 and above</a>! Add the <a href="images/SLSA-Badge-full-level3.svg">SLSA Level 3 badge</a> to your project's readme.</li>
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
<div class="h2 mb-8">

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
            <h4 class="h2 font-normal mb-8">Help us improve SLSA</h4>
            <div class="w-full lg:w-full mx-auto text-center">
                <p>Already at SLSA Level 1? Let us know what went well, what didn’t, and what could be improved. We’re developing new tools and onboarding resources to make the process even easier, so your contribution really goes a long way.</p>
                <a href="https://github.com/slsa-framework/slsa/issues" class="cta-link font-semibold h5 center mt-8">Leave a GitHub issue</a><br>
                <a href="community" class="cta-link font-semibold h5 center mt-8">Join the community</a>
            </div>
        </div>
    </div>
</section>
