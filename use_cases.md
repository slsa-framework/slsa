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

A developer using third party software packages wants to ensure the third party dependencies
used by their product have not been tampered with.

TODO: Add some options for how developers might do this.

## Package Repository accepting a software package

A Package Repository (e.g. Maven, NPM) wants to protect their users from malicious changes to the
software packages uploaded to the repo.
