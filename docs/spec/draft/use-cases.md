---
title: Applying SLSA - two parts: (1) Use cases (2) Guiding principles
description: Applying SLSA has three use cases. Guiding principles will make it clear why you are using SLSA.
---

# {Applying SLSA} 

<!-- Do we need all these div tags below? -->

The pages in this section provide information on general concepts of how and where to put SLSA into practice. They define SLSA [use cases](use-cases) and [guiding principles](principles.md) that will help explain how to implement SLSA more effectively.

## Use cases

SLSA protects against tampering during the software supply chain, but how?
The answer depends on the use case in which SLSA is applied. This page defines the three most common settings where supply chain problems threaten the security of different types of software producing organizations. They include: first party organizations,
oopen source software producers, and vendor services.


## First party organizations

<div class="hidden md:block"><!-- Hide on mobile -->

**How SLSA can be used here:** Reducing risk within an organization from insiders and compromised accounts.

</div>

</div>
<div class="md:w-2/3">

In its simplest form, SLSA can be used entirely within an organization to reduce
risk from internal sources. This is the easiest case in which to apply SLSA
because there is no need to transfer trust across organizational boundaries.

Example of ways an organization might use SLSA internally:

-   A small company or team uses SLSA to ensure that the code being deployed to
    production in binary form is the same one that was tested and reviewed in
    source form.
-   A large company uses SLSA to require two-person review for every production
    change, scalably across hundreds or thousands of employees/teams.
-   An open source project uses SLSA to ensure that compromised credentials
    cannot be abused to release an unofficial package to a package registry.

**Case study:** [Google (Binary Authorization for Borg)](https://cloud.google.com/docs/security/binary-authorization-for-borg)

</div>
</div>

<div class="md:flex gap-5 mb-12 rounded-xl p-10 bg-white">
<div class="md:w-1/3 -mt-8">

## Open source software producers

<div class="hidden md:block"><!-- Hide on mobile -->

**How SLSA can be used here:** Reducing risk from consuming open source software.

</div>

</div>
<div class="md:w-2/3">

SLSA can also be used to reduce risk for consumers of open source software. The
focus here is to map built packages back to their canonical sources and
dependencies. In this way, consumers need only trust a small number of secure
build platforms rather than the many thousands of developers with upload
permissions across various packages.

Example of ways an open source ecosystem might use SLSA to protect users:

-   At upload time, the package registry rejects the package if it was not built
    from the canonical source repository.
-   At download time, the packaging client rejects the package if it was not
    built by a trusted builder.

**Case study:** [SUSE](https://documentation.suse.com/sbp/security/html/SBP-SLSA4/index.html)

</div>
</div>

<div class="md:flex gap-5 mb-12 rounded-xl p-10 bg-white">
<div class="md:w-1/3 -mt-8">

## Vendor services

<div class="hidden md:block"><!-- Hide on mobile -->

**How SLSA can be used here:** Reducing risk from consuming vendor provided software and services.

</div>

</div>
<div class="md:w-2/3">

SLSA can also be used to reduce risk for consumers of vendor-provided
software and services. Unlike open source, there is no canonical source
repository to map to, so instead the focus is on the trustworthiness of claims made
by the vendor.

Example of ways a consumer might use SLSA for vendor-provided software:

-   Prefer vendors who make SLSA claims and back them up with credible evidence.
-   Require a vendor to implement SLSA as part of a contract.
-   Require a vendor to be SLSA certified by a trusted third-party auditor.

</div>
</div>

</div>
</section>

<section class="section bg-white flex justify-center items-center main-content">
<div class="wrapper w-full">

<div class="-mt-16 mb-16">

## Hypothetical example

</div>

For a look at how SLSA might be applied to open source in the future, see the
[hypothetical curl example](../../example.md).

</div>
</section>
