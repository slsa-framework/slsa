---
title: The Breadth and Depth of SLSA
author: "Mike Lieberman"
is_guest_post: false
---

Interested in getting involved? Now’s the chance to [provide your feedback on the foundational v1 release of the SLSA framework.](2023-02-24-slsa-v1-rc.md)

“Software Supply chain security is more than just the build” is a common response when folks learn about SLSA. This is true. SLSA 1.0 is entirely focused on generating [build provenance](../provenance/v1.md) and assurance around that provenance due to the security capabilities of the build system and security properties of a particular running build. Software Supply Chain Security is the cybersecurity practice of extending left into System Delivery Lifecycle or Software Delivery Lifecycle and the SDLC is more than just the build.

If the SDLC is more than the build, why is the SLSA community only focused on that one aspect? We’re not. We’re just starting with the build. The initial focus on the **build track** is a strategic decision made due to its significance in the overall process. The build serves as the bridge between various inputs, such as source code and dependencies, and the final product, which is the software package or artifact intended to run in production environments or be used as a dependency to downstream consumers.

The build process plays a vital role in ensuring the quality, safety, and security of the final software. This is because it performs actions like compilation, linking and packaging the code while applying various testing, linting, optimization, and security measures. It's the stage where all the source and dependency components come together to form the final product. It is also often one of the hardest to introspect on because it is taking arbitrary source code and transforming it into non-human readable binaries. Consequently, vulnerabilities or misconfigurations in the build system or in the build itself can compromise the security of the software. Similarly, direct attacks on the build system or build itself can introduce malicious behavior in any and all output artifacts.

Focusing on the build process and the provenance of the build artifacts enables the build systems to develop a solid foundation for Software Supply Chain Security. By establishing secure, traceable, and auditable build processes, SLSA aims to minimize the risks associated with compromised or malicious components that end up impacting or being included with the build artifacts.

While the build process is crucial, the SLSA contributors and maintainers recognize that Software Supply Chain Security is a multi-faceted problem that extends beyond this stage. As the framework evolves, it will expand its scope to include other critical aspects of the SDLC, such as secure source code management and dependency ingestion.
For instance, future iterations of SLSA will introduce more stringent requirements for source code management in a **source track** that might include code reviews, vulnerability scanning, and secure coding practices. These measures will ensure that the source code ingested into a build is secure and free of common vulnerabilities. Similarly, SLSA may also explore ways to ensure that dependencies, such as third-party libraries, are following security standards, up-to-date, and free from known security issues in a **dependency track**.

Ultimately, SLSA aims to create a comprehensive, adaptable framework that addresses critical pieces of Software Supply Chain Security. By starting with the **build track**, SLSA establishes a robust foundation on which to build and expand the framework to address other critical aspects of the SDLC. This approach will help end users, whether they are open source project maintainers or stakeholders in a corporation, better understand and mitigate the risks associated with software supply chains, and ultimately develop more secure and reliable software.

For more information visit the SLSA website, [give feedback](https://github.com/slsa-framework/slsa/issues) on the [SLSA v1.0 release candidate](https://slsa.dev/spec/v1.0/) and get involved with the SLSA [community](https://slsa.dev/community).
