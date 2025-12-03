---
title: "Supply Chain Robots, Electric Sheep, and SLSA"
author: "Brett Smith"
is_guest_post: true
---

# Supply Chain Robots, Electric Sheep, and SLSA

_By Brett Smith, Distinguished Software Developer at SAS Institute_

## Why is securing the supply chain important?

In my mind's eye, the "electric sheep" are the products we build and sell to
generate revenue. To create "electric sheep", we build "supply chain robots"
that dream of "electric sheep". The robots are our automated pipelines, our
CI/CD systems, and our infrastructure. They construct the sheep, herd them along
the software development lifecycle (SDLC), and shepherd them to market.

That all sounds great but, there are wolves at the door. Smart digital wolves.
And they are not just trying to eat the electric sheep, they mean to reprogram
the robots, poison the assembly line, and turn our own infrastructure against
us. The reality of software supply chain security today is that we need supply
chain robots to protect everything from the digital wolves.

## Why This Matters

After a few major attacks, the government decided to protect itself as
governments should. On May 12, 2021, the White House dropped Executive Order
14028 on Cybersecurity. And with that, if you wanted to sell to the federal
government, you had a whole new set of regulations to meet.

So you skim the Executive Order. It reads like an android interpretation of
lawyers and lawmakers notes on engineering security documentation. Excellent
vague bits like the following:

- **PO.5.1**: Separate and protect each environment involved in software
  development
- **PO.5.2**: Secure and harden development endpoints
- **PW.6.1**: Use compiler, interpreter, and build tools that offer security
  features
- **PW.6.2**: Determine which tool features should be used and implement
  approved configurations
- **PS.1.1**: Store all forms of code based on least privilege principles
- **PS.3.2**: Collect, safeguard, maintain, and share provenance data for all
  software components

For reference it sends you down the rabbit hole of NIST standards, which are
just as vague. The next step is to leverage your company's ISO subscription to
start digging into ISO 27001. ISO 27002 guidelines give you a glimmer of hope
but still no real answers.

How do you turn this mountain of abstract policy into concrete action?

## SLSA: From Confusion to Clarity

SLSA (pronounced "salsa") is a comprehensive security framework for software
supply chains. Think of it as a maturity model - organizations can progressively
improve their security posture by advancing through levels. Each track focuses
on different aspects of the supply chain: Build focuses on artifact creation
integrity, while Source focuses on code trustworthiness. The framework is
designed to be practical and incrementally adoptable, allowing organizations to
start where they are and improve over time. Version 1.2-rc1 introduces the
reintegrated Source Track after focusing solely on Build in v1.0.

SLSA provides us with:

- A common vocabulary to talk about software supply chain security
- A way to secure your incoming supply chain by evaluating the trustworthiness
  of the artifacts you consume
- An actionable checklist to improve your own software’s security
- A way to measure your efforts toward compliance with the Secure Software
  Development Framework (SSDF)

The framework establishes three trust boundaries encouraging the right
standards, attestation, and technical controls, so we can harden the system from
these threats and risks. SLSA is a check-list of standards and controls to
prevent tampering, improve integrity, secure packages and infrastructure in your
projects, platform, and enterprises. It is about identifying and closing attack
vectors in the Supply Chain and proper governance of artifacts throughout the
chain.

Validating Artifact Integrity through verification is a key component of SLSA
which helps to:

- Prevent Integrity Attacks
- Prevent Unauthorized Modifications
- Validate Artifact Integrity
- Close Attack Vectors

Most importantly for our EO 14028 journey: SLSA translated policy requirements
into technical implementation steps.

## The Two Tracks: Build and Source

The two tracks are complementary but independent. Build Track has levels L0-L3,
while Source Track has levels L1-L4. Organizations can advance on one track
without necessarily being at the same level on the other, though both are
important for comprehensive supply chain security. The Build Track addresses
threats during the compilation and packaging phase, while Source Track addresses
threats in code creation and management. Together, they provide end-to-end
visibility and protection from source code to deployed artifact.

### Build Track: The Provenance Receipt

The Build Track uses provenance as a receipt for your software build. It answers
three critical questions:

1. **Identity of the builder** - Who or what built this?
2. **The build process used** - How was it built?
3. **What inputs went into the build** - What materials were used?

This matters because many supply chain attacks happen during the build phase:
attackers compromise build systems, inject malicious code, or substitute
artifacts. Provenance creates an auditable trail.

**Build L0**: No guarantees; you're not doing SLSA yet

**Build L1**: Provenance exists

- Basic provenance generated and distributed
- Prevents mistakes, but easy to bypass
- Quick to implement with minimal workflow changes
- _This got us started on EO requirements for provenance data_

**Build L2**: Hosted build platform

- Provenance signed by the build platform itself
- Requires explicit attack to forge
- Move to platforms like GitHub Actions, GitLab CI, or Google Cloud Build
- _This addressed PW.6.1 and PW.6.2: using hardened build tools_

**Build L3**: Hardened builds

- Strong tamper protection during the build
- Isolated build environments
- Prevents insider threats and credential compromise
- _This satisfied PO.5.1 and PO.5.2: environment separation and hardening_

Build L3 became our target for most releases. It requires significant platform
investment but provides strong protection against sophisticated attacks.

**Future Build Track Level 4** (in development) aims to add even stronger
guarantees, including:

- Pinned dependencies, which guarantee that each build runs on exactly the same
  set of inputs.
- Hermetic builds, which guarantee that no extraneous dependencies are used.
- All dependencies listed in the provenance, which enables downstream verifiers
  to recursively apply SLSA to dependencies.
- Reproducible builds, which enable other build platforms to corroborate the
  provenance.

### Source Track: Trust from Code to Commit

The Source Track addresses "How do we know this source code is what the
organization intended?" It focuses on the change management process: how code
gets into the repository and onto protected branches.

**Source L1**: Version controlled

- Code in a modern version control system like Git
- Foundation for operational maturity
- _This covered PS.1.1: proper storage of all code forms_

**Source L2**: Controls enforced

- Protected branches and tags identified
- All changes recorded and tracked
- Technical controls enforced
- _This ensured proper access control and change tracking_

**Source L3**: Signed and auditable provenance

- Source Control System generates tamper-resistant evidence
- Contemporaneous documentation of revision creation
- Strong guarantees for change management
- _This delivered the PS.3.2 requirement: collecting and safeguarding
  provenance_

**Source L4**: Two-party review

- Requires two trusted persons to review all changes
- Makes unilateral malicious changes much harder
- _This became our gold standard for production code_

## Conclusion: From Chaos to Compliance

SLSA isn't just a checklist, it is a comprehensive framework that addresses
supply chain security systematically. The two tracks, source code security and
build integrity, complement each other. No need to achieve the highest levels
immediately, start where you are and progress incrementally. The attestation
model is powerful. It creates verifiable evidence that can be validated by any
consumer without requiring trust in just one party.

Implementation details vary by ecosystem because what works for Python is
different from what works for Rust, but the principles remain consistent. Start
with Build L1 or Source L2 and progress from there. Both tracks are important
for comprehensive security, though you may prioritize one based on your specific
threats.

If you have a lot of electric sheep, you need a fleet of supply chain robots to
tend them. Build a platform to manage the chaos, herd the cats, eliminate the
unicorns, and eradicate the chaos from your Software Supply Chain.

SLSA is how we get from safe enough to being as resilient as possible, at any
link in the chain.

When we started this journey, Executive Order 14028 was nothing more than pages
of requirements with no clear implementation path. SLSA translated those
abstract requirements into concrete, measurable levels. Build Track mapped to
build tool requirements and environment hardening. Source Track mapped to access
control and provenance collection.

The incremental nature of SLSA levels meant we could show progress, justify
investment, and continuously improve rather than attempting a massive
all-at-once transformation.

You now have an EO 14028 compliant pipeline. Use it for everything.

The pipeline builds the pipeline. Use SLSA as your roadmap. Build a platform to
manage the chaos.

And remember: compliance doesn't equal security, but SLSA helps you achieve
both.

---

_Brett Smith is a Distinguished Software Developer at SAS Institute, where he
helps architect and secure supply chain pipelines for an Analytics,
AI, and Data Management company._
