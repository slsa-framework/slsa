---
title: Use cases
layout: standard
hero_text: Here’s what SLSA looks like in practice, typical cases to explore and break down how compliance can provide protection. Whether you’re a developer working on a project or part of an enterprise, SLSA can be helpful both for securing your supply chain and clarifying existing tools and processes. The case studies expand even further, and are a work in progress as SLSA gets adopted in the industry.
order: 0
---
<section class="section bg-pastel-green flex justify-center items-center">
    <div class="wrapper inner w-full">
        <div class="mb-16">
            <div class="text w-full">
<div class="h3 p-0">

## Example use cases

</div>
            </div>
            <div class="w-2/4">
            </div>
        </div>
        <div class="flex justify-between items-start mb-12 rounded-xl p-10 bg-white">
            <div class="text w-2/3">
<div class="h3 font-semibold p-0">

### Developers

</div>
            </div>
            <div class="w-3/4">
                    <ul class="list-disc">
                        <li>To inventory all the source and build systems (Level 1)</li>
<li>Decoupling development toolchains (e.g. untrusted IDE extensions) and workflows from the artifacts you publish (Level 2)</li>
<li>Providing a public audit trail of source and builds to demonstrate a commitment to securing a supply chain (Level 3)</li>
<li>Eliminating unilateral access to produce releases so that compromise of your machine or credentials alone won’t be enough to backdoor your package (Level 4)</li>
                    </ul>
            </div>
        </div>
        <div class="flex justify-between items-start mb-12 rounded-xl p-10 bg-white">
            <div class="text w-2/3">
<div class="h3 font-semibold p-0">

### Enterprises

</div>
            </div>
            <div class="w-3/4">
                    <ul class="list-disc">
                    <li>Accounting for all build processes and systems used (Level 1)</li>
<li>Ensuring that release artifacts are built through a common, publicly accessible workflow to facilitate onboarding new maintainers and providing transparency to your users (Level 2)</li>
<li>Stratifying applications by their security sensitivity and ensuring low-assurance projects can’t adversely impact higher-assurance ones (Level 3)</li>
<li>Preventing the compromise of a single employee leading to compromise all your users (Level 4)</li>
                    </ul>
            </div>
        </div>
        <div class="flex justify-between items-start mb-12 rounded-xl p-10 bg-white">
            <div class="text w-2/3">
<div class="h3 font-semibold p-0">

### Platforms

</div>
            </div>
            <div class="w-3/4">
                    <ul class="list-disc">
                    <li>Recording the steps necessary to build a release (Level 1)</li>
<li>Establishing a cryptographic chain of custody between trusted builds and your release and code-signing workflows (Level 2)</li>
                    </ul>
            </div>
        </div>
    </div>
</section>

<section class="section bg-white flex justify-center items-center">
    <div class="wrapper inner w-full">
        <div class="flex justify-between items-start mb-16">
            <div class="text w-2/3">
<div class="h3 p-0 mb-8">

## Case studies

</div>
<p>These case studies go much more in depth. Starting from a particular scenario, they look at how you might harden an entire system over time, starting with immediate problems to solve and following through next steps to incrementally progress through to the higher SLSA levels, with space for the development of automatic analysis and policies. </p>
            </div>
            <div class="w-2/4">
            </div>
        </div>
        <p class="h4">Example case studies</p>
        <ul class="mt-6 mb-16 custom-list">
            <li class="border-t border-b border-black-900">
                <a class="p-0 m-0 text-green-dark w-full hover:no-underline" href="{{ site.baseurl }}/use-cases/publishing-a-software-package">
                    <p class="h3 font-semibold flex items-center pt-8 pb-8">
                        <span class="mr-4">
                        <svg width="18" height="18" viewBox="0 0 18 18" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M0.896251 18C-0.298751 12.0505 -0.298752 5.94951 0.896249 -7.47629e-07C7.1285 2.02552 12.9429 5.081 18 9C12.9429 12.919 7.1285 15.9745 0.896251 18Z" fill="#40DB88"/></svg></span>
                        Publishing a software package
                    </p>
                </a>
            </li>
            <li class="border-b border-black-900">
                <a class="p-0 m-0 text-green-dark w-full hover:no-underline" href="{{ site.baseurl }}/use-cases/consuming-third-party-software">
                    <p class="h3 font-semibold flex items-center pt-8 pb-8">
                        <span class="mr-4">
                        <svg width="18" height="18" viewBox="0 0 18 18" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M0.896251 18C-0.298751 12.0505 -0.298752 5.94951 0.896249 -7.47629e-07C7.1285 2.02552 12.9429 5.081 18 9C12.9429 12.919 7.1285 15.9745 0.896251 18Z" fill="#40DB88"/></svg></span>
                        Consuming third party software
                    </p>
                </a>
            </li>
            <li class="border-b border-black-900">
                <a class="p-0 m-0 text-green-dark w-full hover:no-underline" href="{{ site.baseurl }}/use-cases/package-repository-accepting-a-software-package">
                    <p class="h3 font-semibold flex items-center pt-8 pb-8">
                        <span class="mr-4">
                        <svg width="18" height="18" viewBox="0 0 18 18" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M0.896251 18C-0.298751 12.0505 -0.298752 5.94951 0.896249 -7.47629e-07C7.1285 2.02552 12.9429 5.081 18 9C12.9429 12.919 7.1285 15.9745 0.896251 18Z" fill="#40DB88"/></svg></span>
                        Package repository accepting a software package
                    </p>
                </a>
            </li>
            <li class="border-b border-black-900">
                <a class="p-0 m-0 text-green-dark w-full hover:no-underline" href="{{ site.baseurl }}/example">
                    <p class="h3 font-semibold flex items-center pt-8 pb-8">
                        <span class="mr-4">
                        <svg width="18" height="18" viewBox="0 0 18 18" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M0.896251 18C-0.298751 12.0505 -0.298752 5.94951 0.896249 -7.47629e-07C7.1285 2.02552 12.9429 5.081 18 9C12.9429 12.919 7.1285 15.9745 0.896251 18Z" fill="#40DB88"/></svg></span>
                        Incrementally reaching Level 4 using curl
                    </p>
                </a>
            </li>
        </ul>
        <div class="bg-pastel-green h-full rounded-lg p-10">
            <p class="h4 mb-6 font-bold">Real world examples</p>
            <p><strong>If you’ve been using SLSA already, get in touch.</strong><br><br>
The scenarios above are proof of concepts and theoretical explorations. As more people adopt SLSA, we’ll add case studies to walk you through what long term adoption of the SLSA framework could look like, with real world scenarios, application and discovery, planning and strategic development.<br><br>
The contribution guidelines help guide your feedback, and every contribution is useful for others to see how SLSA can be used in their project or organization.</p>
            <a target="_blank" href="https://github.com/slsa-framework/slsa/tree/main/case-studies" class="cta-link font-semibold h5 mt-8">Submit a case study</a>
        </div>
    </div>
</section>
