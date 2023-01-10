The provenance consumer is responsible for deciding whether they trust a builder to produce SLSA Build L3 provenance. However, assessing Build L3 capabilities requires information about a builder's construction and operating procedures that the consumer cannot glean from the provenance itself. To aid with such assessments, we provide a common threat model and builder model for reasoning about builders' security. We also provide a questionnaire that organizations can use to describe their builders to consumers along with sample answers that do and do not satisfy the SLSA Build L3 requirements.

## Threat Model

### Attacker Goal

The attacker's primary goal is to tamper with a build to create unexpected, vulnerable, or malicious behavior in the output artifact while avoiding detection. Their means of doing so is generating build provenance that does not faithfully represent the built artifact's origins or build process. 

More formally, if a build with external parameters P would produce an artifact with binary hash X and a build with external parameters P' would produce an artifact with binary hash Y, they wish to produce provenance indicating a build with external parameters P produced an artifact with binary hash Y.

This diagram represents a successful attack:

![image](insert_image_url_here)

Note: Platform abuse and attacks against builder availability are out of scope of this document.

TODO: Align/cross-reference with SLSA Provenance Model.

### Types of attackers

We consider three attacker profiles differentiated by the attacker's capabilities and privileges.

#### Low privilege

-  Examples
    -  Anyone on the internet
    -  Build platform insiders without administrative access

-  Capabilities
    -  Create builds on the build platform.
    -  Modify their builds' external parameters.
    -  Modify their builds' environments and run arbitrary code inside those environments.
    -  Read the source repo.
    -  Fork the source repo. Modify their fork and build from it.
    -  Access builder maintainers' intranet or other internal communications (e.g. email, design documents)

#### Medium privilege 

-  Examples
    -  Project maintainer

-  Capabilities 
    -  All listed under "low privilege"
    -  Create new builds in the package's build project
    -  Modify the source repo and build from it.

#### High privilege

-  Examples
    -  Build platform admin

-  Capabilities
    -  All listed under "low privilege"
    -  Run arbitrary code on the build platform
    -  Read and modify network traffic

## Build Model

The build model consists of five components: parameters, the build platform, one or more build executors, a build cache, and output storage. The data flow between these components is shown in the diagram below.

![image](insert_image_url_here)

The following sections detail each element of the build model and prompts for assessing its ability to produce SLSA Build L3 provenance.

### Parameters

Parameters are the external interface to the builder. They must include references to the source to be built and the build definition/script to be executed. They may include instructions to the build platform for how to create the build executor (e.g. which operating system to use). They may include additional strings to pass to the build executor.

#### Prompts for Assessing Parameters

-  How does the platform process user-provided parameters? Examples: sanitizing, parsing, not at all
-  Which parameters are processed by the control plane and which are processed by the executor? 
-  What sort of parameters does the control plane accept for executor configuration? 

### Control Plane

The build platform is the control plane that orchestrates each independent build execution. It is responsible for setting up each build and cleaning up afterwards. The platform must generate and sign provenance for each SLSA Build L3+ build performed on the system. The platform is operated by one or more administrators, who have privileges to modify the platform.

#### Prompts for Assessing Control Planes

-  Administration
    -  What are they ways an employee can use privileged access to influence a build or provenance generation? Examples: physical access, terminal access, access to cryptographic secrets
    -  What controls are in place to detect or prevent the employee from abusing such access? Examples: two-person approvals, audit logging
    -  Roughly how many employees have such access?
    -  How are privileged accounts protected? Examples: two-factor authentication, client device security policies
    -  What plans do you have for recovering from security incidents and system outages? Are they tested? How frequently?

-  Provenance generation
    -  How does the control plane observe the build to ensure the provenance's accuracy?
    -  Are there situations in which the control plane will not generate provenance for a completed build? What are they? 

-  Development practices
    -  How do you track the control plane's software and configuration? Example: version control
    -  How do you build confidence in the control plane's software supply chain? Example: SLSA L3+ provenance, build from source
    -  How do you secure communications between builder components? Example: TLS with certificate transparency.
    -  Are you able to perform forensic analysis on compromised executors? How? Example: retain base images indefinitely

-  Creating executors
    -  How does the control plane share data with executors? Example: mounting a shared file system partition
    -  How does the control plane protect its integrity from executors? Example: not mount its own file system partitions on executors
    -  How does the control plane prevent executors from accessing its cryptographic secrets? Examples: dedicated secret storage, not mounting its own file system partitions on executors

-  Managing cryptographic secrets
    -  How do you store the  control plane's cryptographic secrets?
    -  Which parts of the organization have access to the control plane's cryptographic secrets?
    -  What controls are in place to detect or prevent employees abusing such access? Examples: two-person approvals, audit logging
    -  How frequently are cryptographic secrets rotated? Describe the rotation process.
    -  What is your plan for remediating cryptographic secret compromise? How frequently is this plan tested?

### Executor

The build executor is the independent execution environment where the build takes place. Each executor must be isolated from the build platform and from all other executors. Build users are free to modify the environment inside the executor arbitrarily. Build executors must have a means to fetch input artifacts (source, dependencies, etc).

#### Prompts for Assessing Executors

-  Isolation technologies 
    -  How are executors isolated from the control plane and each other? Examples: VMs, containers, sandboxed processes
    -  How have you hardened your executors against malicious tenants? Examples: configuration hardening, limiting attack surface
    -  How frequently do you update your isolation software?
    -  What is your process for responding to platform vulnerability disclosures? What about vulnerabilities in your dependencies?

-  Creation and destruction
    -  What environment is available in executors on creation? How were the elements of this environment chosen?
    -  How long could a compromised executor remain active in the build system?

-  Network access
    -  Are executors able to call out to remote execution? If so, how do you prevent them from tampering with the control plane or other executors over the network?
    -  Are executors able to open services on the network? If so, how do you prevent remote interference through these services?

### Cache

Builders may have zero or more caches to store frequently used dependencies. Build executors may have either read-only or read-write access to caches.

#### Prompts for Assessing Caches

-  What sorts of caches are available to build executors?
-  How are those caches populated?
-  How do you defend against cache poisoning attacks? Example: content-addressable storage

### Output Storage

Output Storage holds built artifacts and their provenance. Storage may either be shared between build projects or allocated separately per-project.

#### Prompts for Assessing Output Storage

-  How do you prevent builds from reading or overwriting files that belong to another build? Example: authorization on storage
-  What processing, if any, does the control plane do on output artifacts?

## Builder Evaluation

Organizations can either self-attest to their answers or seek an audit/certification from a third party. Questionnaires for self-attestation should be published on the internet. Questionnaires for third-party certification need not be published. All provenance generated by L3+ builders must contain a non-forgeable attestation of the builder's L3+ capabilities with a limited validity period. Any secret materials used to prove the non-forgeability of the attestation must belong to the attesting party.