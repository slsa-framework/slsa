---
title: "Source: Assessing source control systems"
description: Guidelines for assessing source control system security.
---

One of SLSA's guiding [principles](principles.md) is to "trust platforms, verify
artifacts". However, consumers cannot trust source control systems (SCSs) unless
they have some proof that an SCS meets its
[requirements](source-requirements.md).

This page describes the parts of an SCS that consumers SHOULD assess and
provides sample questions consumers can ask when assessing a SCS. See also
[Threats & mitigations](threats.md).

## Threats

### Adversary goal

The SLSA Source track defends against an adversary whose primary goal is to
inject unofficial behavior into protected source code while avoiding detection.
Organizations typically establish change management processes to prevent this
unofficial behavior from being introduced. The adversary's goal is to bypass the
change management process.

### Adversary profiles

Consumers SHOULD also evaluate the souce control systems's ability to defend
against the following types of adversaries.

1.  Project contributors, who can:
    -   Propose changes to protected branches of the source repo.
    -   Upload new content to the source repo.
2.  Project maintainer, who can:
    -   Do everything listed under "project contributors".
    -   Define the purpose of the source repo.
    -   Add or remove contributors to the source repo.
    -   Add or remove permissions granted to contributors of the source repo.
    -   Modify security controls within the source repo.
    -   Modify controls used to enforce the change management process on the
        source repo.
3.  Source control system administrators, who can:
    -   Do everything listed under "project contributors" and "project
        maintainers".
    -   Modify the source repo while bypassing the project maintainer's controls.
    -   Modify the behavior of the Source Control System itself.
    -   Access the control plane's cryptographic secrets.

## Source Control System components

Consumers SHOULD consider at least these elements when assessing a Source
Control System for SLSA conformance: control configuration, change management
interface, control plane, verifier, storage.

![source control system components](images/source-control-system-components.svg)

The following section details these elements.

### Change management interface

The change management interface is the user interface for proposing and
approving changes to protected branches within a source repository. During
normal operation all such changes go through this interface.

### Control configuration

Control configuration is how organizations establish technical controls in a
given source repository. If done well the configuration will reflect the intent
of the organization.

### Technical controls

Technical controls are the organization configured settings that are used to
determine if a revision can be introduced into storage within any particular
context and who has access to those revisions.

The technical controls component is responsible for the storage of these
settings while the [control plane](#control-plane) is responsible for enforcing
the configured controls.

They include:

-   Read/write ACLs,
-   If approvals are required to introduce changes within a given context
-   Which actors are allowed to issue those approvals
-   Organization defined
    [change management processes](#enforced-change-management-process)
    requirements
-   etc...

### Control plane

The control plane is the SCS component that orchestrates the introduction and
creation of new revisions into a source repository. It is responsible for
enforcing [technical controls](#technical-controls) and, at SLSA Source L3+,
generating and signing source provenance for each revision. The control plane is
operated by one or more administrators, who have privileges to modify the
control plane.

### Verifier

The verifier is the SCS component that evaluates source provenance and generates
and signs a
[verification summary attestation](source-requirements#summary-attestation)
(VSA).

### Storage

Storage holds source revisions and their provenance and summary attestations.

## Assessing components

The following are prompts for assessing a Source Control System's ability to
meet the SLSA requirements.

### Prompts for assessing the change management interface

-   How does the SCS manage which actors are permitted to approve changes?
-   What types of non-plain-text changes can the change management interface
    render? How well does the SCS render those changes?
-   What controls does the change management interface provide for enabling
    Trusted Robot Contributions? Example: SLSA Build L3+ provenance, built from
    SLSA Source L4+ source.

### Prompts for assessing control configuration & technical controls

-   How does the SCS prevent regression in control configurations?
    Examples: built-in controls that cannot change, notifying project
    maintainers when controls change, requiring public declaration of control
    changes.
-   How does the SCS prevent individual project maintainers from tampering with
    controls configured by the project?
-   How does the SCS prevent SCS administrators from tampering with a project's
    configured technical controls?

### Prompts for assessing the control plane & verifier

NOTE The control plane and verifier perform related roles within the SCS and
should typically be assessed together.

-   Administration
    -   What are the ways an SCS administrator can use privileged access to
        influence a revision creation, provenance generation, or VSA generation?
        Examples: physical access, terminal access, access to cryptographic
        secrets
    -   What controls are in place to detect or prevent an SCS administrator
        from abusing such access? Examples: two-person approvals, audit logging,
        workload identities
    -   Roughly how many SCS maintainers have such access?
    -   How are privileged accounts protected? Examples: two-factor
        authentication, client device security policies
    -   What plans do you have for recovering from security incidents and
        platform outages? Are they tested? How frequently?

-   Control effectiveness
    -   How does the SCS ensure the control plane is enforcing the
        [technical controls](#technical-controls) are working as intended?

-   Source provenance generation
    -   How does the control plane observe the revision creation to ensure the
        provenance's accuracy?
    -   Are there situations in which the control plane will not generate
        source provenance? What are they?
    -   What details are included in the source provenance? Are they sufficient
        to mitigate tampering with other SCS components?

-   VSA generation
    -   How does the verifier determine what source level a revision meets?
    -   How does the verifier determine the organization's control expectations
        and if they are met?

-   Development practices
    -   How do you track the control plane and verifier's software and
        configuration?
        Example: version control.
    -   How do you build confidence in the control plane's software supply
        chain? Example: SLSA Build L3+ provenance, built from SLSA Source L4+
        source.
    -   How do you secure communications between components? Example: TLS with
        certificate transparency.

-   Managing cryptographic secrets
    -   How do you store the control plane and verifier's cryptographic secrets?
    -   Which parts of the organization have access to the control plane and
        verifier's cryptographic secrets?
    -   What controls are in place to detect or prevent SCS administrators from
        abusing such access? Examples: two-person approvals, audit logging
    -   How are secrets protected in memory? Examples: secrets are stored in
        hardware security modules and backed up in secure cold storage
    -   How frequently are cryptographic secrets rotated? Describe the rotation
        process.
    -   What is your plan for remediating cryptographic secret compromise? How
        frequently is this plan tested?

### Prompts for assessing output storage

-   How do you prevent tampering with storage directly?
-   How do you prevent one project's revisions from affecting another project?

## Source control system evaluation

Organizations can either self-attest to their answers or seek certification from
a third-party auditor. Evidence for self-attestation should be published on
the internet and can include information such as the security model used in the
evaluation. Evidence submitted for third-party certification need not be
published.
