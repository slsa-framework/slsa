# Use Cases

## Vendor publishing a software package

A vendor, BarInc, has the following goals in applying SLSA:

1.  Protect their users from malicious changes to the BarImage container image
2.  Protect their reputation, which would be harmed, if BarImage were compromised

BarInc can acheive these goals when publishing the container image by:

1.  Upgrading their source control systems to meet higher SLSA levels.
2.  Upgrading their build system to meet higher SLSA levels.
3.  Ensuring BarImage **MUST** go through a secure choke-point in order to be published.
4.  Have the choke-point check the candiate BarImage against it's provenance, checking:
    1.  That the expected builder created it.
    2.  That the builder meets some minimum SLSA level
    3.  That the source repos listed in the provenance meet some minimum SLSA level
    4.  That the build entry point listed in the provenance is what they expect
    5.  (TBD) That the binary dependencies listed in the provenance meet some minimum SLSA level
5.  Only publishing the container image if all the checks in #4 pass.

This approach allows BarInc to acheive their goals without requiring any changes from their users
or from their distribution channels.  It doesn't, however, protect their users from a published
BarImage from being tampered with after publication (though there may be other ways to address
those concerns, such as code-signing after verification, and time-of-use verification).

## Developer using third party software packages

A developer using BarImage wants to ensure it hasn't been tampered with before using it.

They could do this by:

1.  Requesting BarInc to publish the 
    [in-toto Provenance](https://github.com/in-toto/attestation/blob/main/spec/predicates/provenance.md)
    and any additional attestations (such as
    [source control attestations](https://github.com/in-toto/attestation/issues/47)) for BarImage
    each time it is released.
2.  Requesting BarInc to publish the public keys it's builder uses to sign the attestation.
    * (TBD) [Determine how to convey these keys](https://github.com/slsa-framework/slsa/issues/101).
4.  Requesting BarInc to confirm what SLSA level their builder and source control system meet.
    * In the future there may be an accredidation body that confirm this _for_ BarInc.
5.  Determining what policy to apply to BarImages
    * They could create this policy on first use based on the data provided in the in-toto Provenance.
      Any significant deviations (e.g. builder changed, source repo changed) would cause failure. OR
    * BarInc could _publish_ a suggested policy for users of BarImage on their website.
5.  Establish a secure choke-point that any uses of BarImage must pass through in order to be used.
    *  E.g. On import to a local Docker registry
6.  Have the choke-point check the candiate BarImage against it's provenance, checking it against the
    policy from #4.
7.  Only import the container image if all the checks in #6 pass.

## Package Repository accepting a software package

A Package Repository (e.g. Maven, NPM) wants to protect their users from malicious changes to the
software packages uploaded to the repo.
