# Use Cases

These are some of the use cases for SLSA. Of these the first use case (a developer checking
their own packages prior to publishing) is the most ready for adoption as it does not require
interactions with any other party.

## Developer publishing a software package

A developer, BarInc, has the following goals in applying SLSA:

1.  Protect their users from malicious changes to the BarImage container image.
2.  Protect their reputation, which would be harmed, if BarImage were compromised.
3.  Access to metadata for auditing and ad-hoc analysis.

BarInc can acheive these goals when publishing the container image by:

1.  Upgrading their source control systems to meet higher SLSA levels.
2.  Upgrading their build system to meet higher SLSA levels.
3.  Ensuring BarImage **MUST** go through a secure control-point in order to be published.
4.  Having the control-point check the candidate BarImage against its provenance, checking:
    1.  That the expected builder created it.
    2.  That the builder meets some minimum SLSA level.
    3.  That the source repos listed in the provenance meet some minimum SLSA level.
    4.  That the build entry point listed in the provenance is what they expect.
    5.  (TBD) That the binary dependencies listed in the provenance meet some minimum SLSA level.
5.  Only publishing the container image if all the checks in #4 pass.
6.  Storing the provenance and all other attestations for future reference.

This approach allows BarInc to acheive their goals without requiring any changes from their users
or from their distribution channels. It doesn't, however, protect their users from a published
BarImage from being tampered with after publication (though there may be other ways to address
those concerns, such as code-signing after verification, and time-of-use verification).

## Developer using third party software packages

A developer using BarImage wants to ensure it hasn't been tampered with before using it.

They could do this by:

1.  Requesting BarInc to publish the [in-toto SLSA Provenance] and any additional attestations (such
    as [source control attestations]) for BarImage each time it is released.
2.  Requesting BarInc to publish the public keys its builder uses to sign the attestations.
    -   (TBD) [Determine how to convey these keys].
3.  Requesting BarInc to confirm what SLSA level their builder and source control system meet.
    -   In the future there may be an accredidation body that confirm this _for_ BarInc.
4.  Determining what policy to apply to BarImages.
    -   They could create this policy on first use based on the data provided in the in-toto SLSA Provenance.
        Any significant deviations (e.g. builder changed, source repo changed) would cause failure. OR
    -   BarInc could _publish_ a suggested policy for users of BarImage on their website.
5.  Establishing a secure control-point that any uses of BarImage must pass through in order to be used.
    -   E.g. On import to a local Docker registry.
6.  Having the control-point check the candidate BarImage against its provenance, checking it against the
    policy from #4.
7.  Only importing the container image if all the checks in #6 pass.

This approach protects the developer without having to rely on any trust in intermediate package
repositories.

## Package Repository accepting a software package

A Package Repository (e.g. Docker Hub) wants to protect their users from malicious changes to the
container images uploaded to the repo.

They could do this by:

1.  Requesting publishers of containers to publish the [in-toto SLSA Provenance] and any additional
    attestations (such as [source control attestations]) each time a new image is pushed to the
    repository.
    -   (TBD) Where to store this provenance?
2.  Requesting publishers to publish the public keys it's builder uses to sign the attestations.
    -   (TBD) [Determine how to convey these keys]
3.  Requesting publishers to confirm what SLSA level their builder and source control system meet.
    -   In the future there may be an accredidation body that confirm this _for_ the publishers.
4.  Determining what policy to apply to published images.
    -   They could create this policy on first use based on the data provided in the in-toto SLSA Provenance.
        Any significant deviations (e.g. builder changed, source repo changed) would cause a push
        failure. OR
    -   The Package Repository could have publishers configure their specific policy as a part of their
      repo.
        -   The Package Repository could make these policies publicly readable by users of the repo.
        -   (TBD) How to securely update these policies.
5.  Checking new containers against the policy from #4.
6.  Preventing container images that fail the check in #5 from being made public.

This approach could protect users of protected repos from malicious tampering without requring all
users to do their own policy checks of each image they consume.

[Determine how to convey these keys]: https://github.com/slsa-framework/slsa/issues/101
[in-toto SLSA Provenance]: https://slsa.dev/provenance
[source control attestations]: https://github.com/in-toto/attestation/issues/47
