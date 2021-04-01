# Attestation-based Policies

Author: lodato@google.com \
Date: March 2021 \
Status: EARLY DRAFT

## Objective

Standardize the terminology, data model, and interfaces for admission control
policy based on [software attestations](attestations.md).

## Model and Terminology

*TODO: Define what an attestation-based admission control policy is.*

<p align="center"><img width="50%" src="images/policy_model.svg"></p>

To make the decision, a policy engine combines the following:

-   The artifact identifier, usually a cryptographic content hash.
-   One or more attestations about the artifact or related artifacts.
-   A policy describing the requirements as a function of the attestations.

The decision is usually "allow" or "deny". It may be preventative
("enforcement") or detective ("auditing").

*TODO: Better define the policy model, including the notion of attester, subject
verification, logging, etc.*

*TODO: Note that a policy decision may itself be an attestation that can be fed
into further policy decisions down the line.*

*TODO: Two modes: (a) only allow if a "good" attestation exists,
even if there also exists some "bad" attestation; (b) block if some "bad"
attestation exists, even if there also exists some "good" attestation. Talk
about threat model and whether the attestation storage is trusted. (a) is better
for enforcement in the critical path, while (b) is useful for vulnerability
remediation.*
