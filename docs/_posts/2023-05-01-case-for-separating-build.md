---
title: "Building a Better Supply Chain: The Case for Separating Build"
author: Melba Lopez, Kris Kooi
is_guest_post: false
---


SLSA’s mission is to ensure the integrity of build systems and the software they produce. Our original vision was a single set of comprehensive security standards that encompassed the full software supply chain. As we iterated on the specification, we came to see that the original vision was flawed. 

Supply chains by their very nature span operational domains, and it is not common or realistic to expect a single team or organization to secure one end-to-end. Instead, we decided to decompose SLSA in a way that establishes clear ownership for each component of the supply chain and allows each owner to work in parallel.

## The case for separation

SLSA v0.1 levels only work when a single entity controls the entire software supply chain lifecycle, which is often not the case.  The infrastructure comprising the build system, the source code and image/template repositories, and the security scanning tools are all assumed to be within the trust boundary.  The trust model breaks down when multiple “entities” control a portion of the software supply chain. 

<image align = "center" image height = "300px" img src="https://user-images.githubusercontent.com/101211710/235577022-f7102111-d4d5-43e1-b014-78e19209a203.png" alt="Single Trust" />
     
     
### Scenario 1: Controlled Build, CI/CD, & Partial Controlled Source 
<image align = "right" image height = "175px" img src="https://user-images.githubusercontent.com/101211710/235576995-c15449fe-f8f6-4af0-8d5d-5bcf0e6b6d70.png" alt = "Scenario 1" />

Real-world systems have complex trust and operational boundaries that make it difficult to make meaningful security statements with a single attestation. The following example illustrates why we separated SLSA into different tracks.

Outsourcing portions of infrastructure to a service provider may hinder the ability to provide a full SLSA attestation.  Organizations may want to outsource due to lack of skills or resources. However, if the provider does not have full control/visibility, 100% SLSA attestation would be unlikely.   

<image align = "right" image height = "200px" img src="https://user-images.githubusercontent.com/101211710/235576570-62b23cb2-fdde-4056-b4f1-9d96fc379d4d.png" alt = "Scenario 1" /> The example in the diagrams may be more common, especially in the open source community.  As the community focuses on code development, they may “outsource” the build, security checks, etc. to an organization such as GitHub.  Thus, the open source community may be able to make claim of SLSA compliance for source, but would need the attestation for the build/security vetting from the service provider (GitHub as provided in this example).

Let's take a look at another example, in which the producer is responsible for the majority of the supply chain security components.  


### Scenario 2: Outsourced CI/CD
CI/CD-aaS service providers may attest to some aspects of the build, while consumers may attest to the remaining portions of the software supply chain (illustrated below).    
<image align = "float" image height = "275px" img src="https://user-images.githubusercontent.com/101211710/235576527-d3ab6f42-f690-482d-ae8e-2854b9f0a232.png" alt = "Scenario 2" /> 


## Future of SLSA Tracks

The SLSA community wanted to ensure that the requirements were clear with no ambiguity for the SLSA 1.0 release.  When considering expanded use cases and the complexity that comes with them, we decided collectively to create Build as a separate track.   This allows flexibility for organizations and the open source community to adhere to some (or all) of the SLSA requirements. 

Additionally, the Supply Chain Integrity Working Group is collaborating with [SLSA and S2C2F](https://docs.google.com/document/d/1E9BvXkNhbLPj6AnUjoAbci3TI5FdnCY2zpi4UZnM7D8/edit?disco=AAAAq2cLbqE) to leverage the full potential of OSSF’s technologies together further reducing software supply chain risks.  As we continue our journey, we welcome collaboration and input from the community! 

## Closure/Conclusion
While the build process is crucial, the SLSA contributors and maintainers recognize that Software Supply Chain Security is a multi-faceted problem that extends beyond this stage. As the framework evolves, it will expand its scope to include other critical aspects of the SDLC, such as secure source code management and dependency ingestion. For instance, future iterations of SLSA will introduce more stringent requirements for source code management in a source track that might include code reviews, vulnerability scanning, and secure coding practices. These measures will ensure that the source code ingested into a build is secure and free of common vulnerabilities. Similarly, SLSA may also explore ways to ensure that dependencies, such as third-party libraries, are following security standards, up-to-date, and free from known security issues in a dependency track.

For more about our SLSA tracks, please see another great blog post [“The Breadth and Depth of SLSA”](https://slsa.dev/blog/2023/04/the-breadth-and-depth-of-slsa), by another maintainer.


