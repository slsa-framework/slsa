# SLSA Common Platform Requirements

TODO: Write this document.

Common requirements for every trusted system involved in the supply chain
(source, build, distribution, etc.)

*   <a id="security"></a>**[Security]** The system meets some TBD baseline
    security standard to prevent compromise. (Patching, vulnerability scanning,
    user isolation, transport security, secure boot, machine identity, etc.
    Perhaps
    [NIST 800-53](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-53r5.pdf)
    or a subset thereof.)

*   <a id="access"></a>**[Access]** All physical and remote access must be
    rare, logged, and gated behind multi-party approval.

*   <a id="superusers"></a>**[Superusers]** Only a small number of platform admins
    may override the guarantees listed here. Doing so MUST require approval of a
    second platform admin.
