# Use Cases

## Vendor publishing a software package

A vendor, Fooly, has the following goals in applying SLSA:

1. Protect their users from malicious changes to the Fooly app
2. Protect their reputation, which would be harmed, if the Fooly app were compromised

Fooly can acheive these goals when publishing their app by:

1. Upgrading their source control systems to meet higher SLSA levels.
2. Upgrading their build system to meet higher SLSA levels.
3. Ensuring the Fooly app **MUST** go through a secure choke-point in order to be published/signed.
4. Have the choke-point check the candiate Fooly app against it's provenance, checking:
    1. That the expected builder created it.
    2. That the builder meets some minimum SLSA level
    3. That the source repos listed in the provenance meet some minimum SLSA level
    4. That the build entry point listed in the provenance is what they expect
    5. (TBD) That the binary dependencies listed in the provenance meet some minimum SLSA level
5. Only publishing the app if all the checks in #4 pass.

This approach allows Fooly to acheive their goals without requiring any changes from their users
or from their distribution channels.  It doesn't, however, protect their users from published
Fooly apps from being tampered with after publication (though there may be other ways to address
those concerns, such as code-signing after verification).

## Package Repository accepting a software package

A Package Repository (e.g. Maven, NPM) wants to protect their users from malicious changes to the
software packages uploaded to the repo.

## End-user using a software package

TODO: This needs to be fleshed out more.  Is the end-user some other developer that's using a
container image or a library?  Or is the end-user someone that's not a software developer and
they just want to use an app and know that it's what the software publisher intended?  Perhaps
this should be renamed to 'Developer using a software package'?
