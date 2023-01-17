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

* If you are using GitHub Actions or Google Cloud Build, jump directly to <a href="#SLSA3">SLSA 3</a>.  You do not need to implement SLSA 1 or SLSA 2.
* If you are using FRSCA, jump to <a href="#SLSA2">SLSA 2</a>.  You do not need to implement SLSA 1.
* If you’re using any other build system or are not using a build system, consider adopting GitHub Actions, Google Cloud Build, or FRSCA. If that isn’t possible, start with <a href="#SLSA1">SLSA 1</a>. Note that if you choose to use SLSA 1, you may not have a growth path to <a href="#SLSA2">SLSA 2</a> or <a href="#SLSA3">SLSA 3</a>.  It is recommended that unless you have a specific reason for using SLSA 1, that you start with <a href="#SLSA2">SLSA 2</a>, or if possible <a href="#SLSA3">SLSA 3</a>.

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

#### Build Service Plugins or Extensions

These options work with your build system to produce unsigned, formatted provenance. They do not qualify for SLSA 2 because they are unsigned and not run by the hosted server.                    
</div>
    <ul>
    <li><a href="https://github.com/slsa-framework/azure-devops-demo">Azure DevOps extension</a></li>
    <li><a href="https://github.com/slsa-framework/slsa-jenkins-generator">Jenkins SLSA generator</a> </li>
    <li><a href="https://plugins.jenkins.io/in-toto/Jenkins plugin">Jenkins plugin</a></li>
    </ul><p>
    Downstream users verify the provenance with <a href="https://cuelang.org/docs/">Cue Policies</a>.  </p>

#### Build Observers with hosted Services

These options are user-configured inside a hosted service. They observe the build process and produce signed, formatted provenance. These options do not qualify for SLSA 2 because they are configured by users, not the hosted service.
    
    <p>Downstream users verify the provenance with Cue policies and the signature with Cosign. </p>

   <p> <b>Note:</b> If you are using one of these options with Google Cloud Build or GitHub Actions, jump to SLSA 3 and use the builder itself to generate provenance. </p>
<ul>
<li><a href="https://github.com/kubernetes-sigs/tejolote">Tejolote</a> – currently supports Google Cloud Build and GitHub Actions. Prow coming soon. 
If you’re using Tejolote with Google Cloud Build or GitHub Actions, jump to SLSA 3  and generate provenance directly from the builder. </li>
 <li><a href="https://tekton.dev/docs/chains/signed-provenance-tutorial/">Tekton Chains</a> – custom resource definition controller that can generate provenance for Kubernetes OCI containers</li></ul>


</section>

<section class="section bg-pastel-green flex justify-center items-center">
    <div class="wrapper inner w-full">
        <div class="md:flex justify-between items-start mb-16">
            <div class="text w-full md:w-1/3">
<div class="h2 -mt-16 p-0">
<a/ id="SLSA2">

## SLSA 2
    
</div>
                    <p>
                     To achieve SLSA 2, the goals are to:
                        <ul>
                            <li>Run your build on a hosted service that generates and signs provenance</li>
                            <li>Let downstream users verify both the provenance and its signature</li>
                    </ul></p><p>
There is currently only one SLSA 2 builder: 

<ul><li><a href="https://github.com/buildsec/frscahttps://github.com/buildsec/frsca">Factory for Repeatable Secure Creation of Artifacts (FRSCA)</a></li></ul>
                </p><p>
FRSCA is an OpenSSF project that offers a full build pipeline. It is not yet generally available. It qualifies as a SLSA 2 builder because regular users of the service are not able to inject or alter the contents of the provenance it generates. </p>
                <p>FRSCA produces signed, formatted provenance that can be verified by the generic SLSA verifier. </p>
</section>

<section class="section bg-white flex justify-center items-center">
    <div class="wrapper inner w-full">
        <div class="justify-between items-start md:-mr-10 md:-ml-10">
            <div class="text w-full md:pl-10">
<div class="h2 -mt-16 mb-8">
<a/ id="SLSA3">

## SLSA 3
</div>
            </div>
            <div class="w-full md:pl-10">
                <div class="bg-white"><p>
To achieve SLSA 3, you must:<ul>
                    <li>Run your build on a hosted service that generates and signs provenance</li>
                    <li>Ensure that build runs cannot influence each other</li>
                    <li>Produce signed provenance that can be verified and authenticated  </li>
</p>
                </div>
            </div>
<div class="h3 -mt-16 p-0">

### GitHub Actions

</div>
            <div class="w-full mt-8">
                <div class="bg-white md:flex justify-between">
                    <div class="mt-6 w-full md:w-1/2 md:pl-10">
                        <p>If you are building on GitHub Actions, adopt the <a href="https://github.com/slsa-framework/slsa-github-generator">Language-agnostic GitHub provenance generator / builder</a> to make your build qualify for SLSA 3. </p>
                        <p>Use the <a href="https://github.com/slsa-framework/slsa-verifier">Generic SLSA Verifier</a> for provenance verification.
<div class="h3 -mt-16 p-0">

### Google Cloud Builder (paid service)

</div>
                        <p>Google Cloud Build is now SLSA 3 compliant. If you are already using Google Cloud Build, see the documentation on where to find your provenance. </p>
       <p>Use the <a href="https://github.com/slsa-framework/slsa-verifier">Generic SLSA Verifier</a> for provenance verification.</p>  
</section>

