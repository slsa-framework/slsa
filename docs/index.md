---
title: Supply-chain Levels for Software Artifacts
subheading: Safeguarding artifact integrity across any software supply chain
levels:
    - 1:
        title: Level 1
        text: Easy to adopt, giving you supply chain visibility and being able to generate provenance
        badge: /images/SLSA-Badge-level1.svg
    - 2:
        title: Level 2
        text: Starts to protect against software tampering and adds minimal build integrity guarantees
        badge: /images/SLSA-Badge-level2.svg
    - 3:
        title: Level 3
        text: Hardens the infrastructure against attacks, more trust integrated into complex systems
        badge: /images/SLSA-Badge-level3.svg
    - 4:
        title: Level 4
        text: The highest assurances of build integrity and measures for dependency management in place
        badge: /images/SLSA-Badge-level4.svg
testimonials:
    - 1:
        quote: This is our chance to work with the industry, set a standard which we can all agree to, and work together to raise the collective bar.
        name: Trishank Karthik Kuppusamy
        role: Staff Engineer at Datadog
        logo: /images/datadog.png
    - 2:
        quote: Software supply chain visibility will become a cross-industry need to establish best practices and trusted evidence in each link.
        name: Bruno Domingues
        role: CTO, Financial Services Industry, Intel
        logo: /images/intel-logo.png
    - 3:
        quote: Having a common language and standard for objectively measuring our supply chain security is a must in order to even begin meeting EO 14028.
        name: Trishank Karthik Kuppusamy
        role: Staff Engineer at Datadog
        logo: /images/datadog.png
    - 4:
        quote: The threat to the software supply chain is real and growing, 650% from the last year. However, changing development process without slowing down is a major barrier.
        name: Bruno Domingues
        role: CTO, Financial Services Industry, Intel
        logo: /images/intel-logo.png
    - 5:
        quote: Regulated industries such as Financial Services are being more vocal on defining their responsibility on the software supply chain. Having control and traceability as a requirement is taking shape.
        name: Bruno Domingues
        role: CTO, Financial Services Industry, Intel
        logo: /images/intel-logo.png

---
<!--{% if false %}-->

**NOTE: This site is best viewed at https://slsa.dev.**

<!--{% endif %}-->

<!-- Hero -->
<section class="hero home flex justify-center items-center relative">
    <video class="absolute object-cover h-full w-full z-0" autoplay muted loop>
      <source src="images/v1.mp4" type="video/mp4">
      Your browser does not support the video tag.
    </video>
    <div class="wrapper inner text-green z-20">
        <h1 class="md:pr-32">{{ page.subheading }}</h1>
    </div>
</section>

<section class="section intro bg-light-green flex justify-center items-center pt-32 pb-16">
    <div class="wrapper inner w-full">
        <div class="flex flex-wrap justify-between items-center">
            <div class="text w-full md:w-1/2">
                <h2 class="h2 mb-8">What is SLSA?</h2>
                <p><strong>Supply chain Levels for Software Artifacts, or SLSA (salsa).</strong></p>
                <p>It’s a security framework, a check-list of standards and controls to prevent tampering, improve integrity, and secure packages and infrastructure in your projects, businesses or enterprises. It’s how you get from safe enough to being as resilient as possible, at any link in the chain.</p>
            </div>
            <div class="w-full md:w-1/3 md:mt-0 mt-8">
                <img src="images/logo-mono.svg" alt="SLSA logo mark mono version">
            </div>
        </div>
    </div>
</section>
<section class="section bg-white flex flex-col justify-center items-center">
    <div class="wrapper inner w-full">
        <div class="flex flex-wrap justify-between items-start">
            <div class="text w-full md:w-1/3">
                <h3 class="h2 p-0">The supply chain problem</h3>
            </div>
            <div class="w-full md:w-1/2 md:mt-0 mt-8">
                <p>Any software can introduce vulnerabilities into a supply chain. As a system gets more complex, it’s critical to already have checks and best practices in place to guarantee artifact integrity, that the source code you’re relying on is the code you’re actually using. Without solid foundations and a plan for the system as it grows, it’s difficult to focus your efforts against tomorrow’s next hack, breach or compromise.</p>
                <a href="spec/{{ site.current_spec_version }}/#supply-chain-threats" class="cta-link h5 font-semibold mt-8">More about supply chain attacks</a>
            </div>
        </div>
        <img class="mt-16 mx-auto w-full md:w-3/4" src="images/SupplyChainDiagram.svg" alt="the supply chain problem image">
    </div>
</section>
<section class="section bg-pastel-green flex flex-col justify-center items-center">
    <div class="wrapper inner w-full">
        <div class="flex flex-wrap justify-between items-center">
            <div class="text w-full md:w-1/2">
                <h4 class="h2 mb-8">Levels of assurance</h4>
                <p>SLSA levels are like a common language to talk about how secure software, supply chains and their component parts really are. From source to system, the levels blend together industry-recognized best practices to create four compliance levels of increasing assurance.
                These look at the builds, sources and dependencies in open source or commercial software. Starting with easy, basic steps at the lower levels to build up and protect against advanced threats later, bringing SLSA into your work means prioritized, practical measures to prevent unauthorized modifications to software, and a plan to harden that security over time.</p>
                <a href="spec/{{ site.current_spec_version }}/levels" class="cta-link h5 font-semibold mt-8">Read the level specifications</a>
            </div>
            <div class="w-full md:w-2/4 md:mt-0 mt-8 pl-12">
                <img class="w-3/4 mx-auto" src="images/badge-exploded.svg" alt="SLSA levels badge">
            </div>
        </div>
        <div class="flex flex-wrap justify-between items-center mt-16 md:-ml-4 md:-mr-4">
          {%- for level in page.levels -%}
          {%- assign level_content = level | map: level -%}
              <div class="w-full md:w-1/2 md:pl-4 pb-4">
                  {% include levels-card.html index=index level=level_content %}
              </div>
          {%- endfor -%}
        </div>
    </div>
</section>
<section class="section bg-white flex flex-col justify-center items-center">
    <div class="wrapper inner w-full">
        <div class="flex flex-wrap justify-between items-start">
            <div class="text w-full md:w-1/3">
                <h4 class="h2 p-0">Who is SLSA for?</h4>
            </div>
            <div class="w-full md:w-1/2 md:mt-0 mt-8">
                <p>Whether you’re a developer, business or an enterprise, SLSA provides a industry standard, a recognizable and agreed-upon level of protection and compliance.<br><br>
It’s adaptable, and it’s been designed with the wider security ecosystem in mind, for anyone to adopt and use. That could be users requiring that the software they rely on is a particular SLSA level, an open source software project protecting its users by using SLSA compliant infrastructure, or an enterprise using SLSA as guiding principles to harden their own internal supply chains, requiring that dependencies are SLSA compliant too.</p>
            </div>
        </div>
    </div>
</section>
<section class="section bg-pastel-green flex flex-col justify-center items-center">
    <div class="wrapper inner w-full">
        <div class="flex flex-col justify-center items-center mb-16 text-center md:w-2/3 relative mx-auto">
            <p class="h2 mb-10">An industry collaboration</p>
            <p>SLSA is led by an initial cross-organization, vendor-neutral steering group committed to improving the security ecosystem for everyone.</p>
        </div>
        <div class="flex flex-wrap justify-center items-center text-center w-full relative mx-auto">
            {%- for image in site.static_files -%}
                {%- if image.path contains '/logos' -%}
                    <div class="w-full md:w-1/4 mb-12">
                        <img class="mx-auto w-5/12 md:8/12 h-auto" src="{{ site.baseurl }}{{ image.path }}" alt="image" />
                    </div>
                {%- endif -%}
            {%- endfor -%}
        </div>
    </div>
</section>
<section x-data="{swiper: null}" x-init="swiper = new Swiper($refs.container, {
      loop: true,
      slidesPerView: 1,
      spaceBetween: 0,
      dots: true,
      breakpoints: {
        640: {
          slidesPerView: 1,
          spaceBetween: 0,
        },
        768: {
          slidesPerView: 1,
          spaceBetween: 0,
        },
        1024: {
          slidesPerView: 1,
          spaceBetween: 0,
        },
      },
    })"
  class="section bg-white flex flex-col justify-center items-center">
    <div class="wrapper inner w-full">
        <div class="flex flex-col justify-center items-center mb-16 text-center md:w-2/3 relative mx-auto">
            <p class="h2 mb-10">Our ethos</p>
            <p>Today’s projects, products and services are increasingly complex and open to attack. As that trend continues, we need to scale up our effort to provide more secure, accessible ways to protect the development, distribution and consumption of the software we use, and all the impacted communities behind it.</p>
        </div>
      <div class="w-full md:w-2/3 relative mx-auto">
        <div class="absolute inset-y-0 left-0 z-10 flex items-center">
            <button @click="swiper.slidePrev()"
                class="-ml-2 lg:-ml-12 flex justify-center items-center w-10 h-10 focus:outline-none">
                    <svg width="16" height="17" viewBox="0 0 16 17" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M15.2033 16.6509C16.2656 11.3624 16.2656 5.93933 15.2033 0.650878C9.66355 2.45134 4.4952 5.16732 3.49691e-07 8.65088C4.4952 12.1344 9.66355 14.8504 15.2033 16.6509Z" fill="#155757"/></svg>
                </button>
        </div>
        <div class="swiper-container" x-ref="container">
            <div class="swiper-wrapper">
              <!-- Slides -->
              {%- for testimonial in page.testimonials -%}
                  {%- assign testimonial_content = testimonial | map: testimonial -%}
                  <div class="swiper-slide p-4 bg-light-green rounded-lg">
                      {% include testimonial-card.html index=index testimonial=testimonial_content %}
                  </div>
              {%- endfor -%}
            </div>
        </div>
        <div class="absolute inset-y-0 right-0 z-10 flex items-center">
            <button @click="swiper.slideNext()"
                    class="-mr-2 lg:-mr-12 flex justify-center items-center w-10 h-10 focus:outline-none">
                    <svg width="16" height="17" viewBox="0 0 16 17" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M0.796665 16.6509C-0.265559 11.3624 -0.26556 5.93933 0.796663 0.650878C6.33645 2.45134 11.5048 5.16732 16 8.65088C11.5048 12.1344 6.33645 14.8504 0.796665 16.6509Z" fill="#155757"/></svg>
            </button>
        </div>
      </div>
    </div>
</section>
<section class="section bg-light-green flex justify-center items-center">
    <div class="wrapper inner w-full">
        <div class="flex flex-col justify-center items-center text-center md:mb-16 md:w-2/3 relative mx-auto">
            <p class="h2 mb-8">Get started</p>
        </div>
        <div class="flex flex-wrap justify-center items-center w-6/7 mx-auto md:-ml-4 md:-mr-4">
            <div class="w-full md:w-1/2 getting_started_card md:pl-4 md:h-80 mb-8 md:mb-0">
              <a href="get-started#reaching-slsa-level-1" class="hover:no-underline">
                  <div class="bg-white h-full rounded-lg p-10 flex flex-col">
                      <p class="h3 font-semibold mb-8 md:mb-6">Start using SLSA</p>
                      <p>Ready to put your project through its paces? The first on-ramp to SLSA Level 1 is generating provenance. We’ve put together a quick walkthrough with the steps you’ll need to take and available tools you can use.</p>
                      <p class="cta-link h5 font-semibold mt-auto pt-8 md:pt-0">Get started</p>
                  </div>
                </a>
            </div>
            <div class="w-full md:w-1/2 getting_started_card md:pl-4 md:h-80">
              <a href="spec/{{ site.current_spec_version }}/#specifications" class="hover:no-underline">
                  <div class="bg-white h-full rounded-lg p-10 flex flex-col">
                      <p class="h3 font-semibold mb-8 md:mb-6">Review the specifications</p>
                      <p>Want to learn about how it fits your organization’s security? Here’s the documentation behind the framework, with use cases, specific threats (and their prevention), provenance and fully detailed requirements.</p>
                      <p class="cta-link h5 font-semibold mt-auto pt-8 md:pt-0">Learn more</p>
                  </div>
                </a>
            </div>
        </div>
    </div>
</section>
<section class="section bg-green-dark flex justify-center items-center">
    <div class="wrapper inner w-full">
        <div class="flex flex-wrap justify-between items-start text-white">
            <div class="text w-full md:w-1/3">
                <p class="h2 p-0">Project status</p>
            </div>
            <div class="w-full md:w-1/2">
                <div class="rounded-lg text-green p-5 border border-green-400 inline-block mt-8 md:mt-0 mb-8 h4 font-semibold">SLSA is currently in alpha</div>
                <p>The initial v0.1 specification is out and is now ready to be tried out and tested.<br><br>
We’ve released a set of tools and services to generate SLSA 1-2 provenance, which we’re looking to develop further soon.<br><br>
Google has been using an internal version of SLSA since 2013 and requires it for all of their production workloads.</p>
            </div>
        </div>
    </div>
</section>
