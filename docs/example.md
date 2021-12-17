---
layout: specifications
---
# Motivating example

Consider the example of using [curl](https://curl.se) through its
[official docker image][curlimages/curl]. What threats are we exposed to in the
software supply chain? (We choose curl simply because it is a popular
open-source package, not to single it out.)

The first problem is figuring out the actual supply chain. This requires
significant manual effort, guesswork, and blind trust. Working backwards:

-   The "latest" tag in Docker Hub points to
    [7.72.0](https://hub.docker.com/layers/curlimages/curl/7.72.0/images/sha256-3c3ff0c379abb1150bb586c7d55848ed4dcde4a6486b6f37d6815aed569332fe?context=explore).
-   It claims to have come from a Dockerfile in the
    [curl/curl-docker](https://github.com/curl/curl-docker/blob/d6525c840a62b398424a78d792f457477135d0cf/alpine/latest/Dockerfile)
    GitHub repository.
-   That Dockerfile reads the following artifacts, assuming there are no further
    fetches during build time:
    -   Docker Hub image:
        [registry.hub.docker.com/library/alpine:3.11.5](https://hub.docker.com/layers/alpine/library/alpine/3.11.5/images/sha256-cb8a924afdf0229ef7515d9e5b3024e23b3eb03ddbba287f4a19c6ac90b8d221?context=explore)
    -   Alpine packages: libssh2 libssh2-dev libssh2-static autoconf automake
        build-base groff openssl curl-dev python3 python3-dev libtool curl
        stunnel perl nghttp2
    -   File at URL: https://curl.haxx.se/ca/cacert.pem
-   Each of the dependencies has its own supply chain, but let's look at
    [curl-dev], which contains the actual "curl" source code.
-   The package, like all Alpine packages, has its build script defined in an
    [APKBUILD](https://git.alpinelinux.org/aports/tree/main/curl/APKBUILD?id=166f72b36f3b5635be0d237642a63f39697c848a)
    in the Alpine git repo. There are several build dependencies:
    -   File at URL: https://curl.haxx.se/download/curl-7.72.0.tar.xz.
        -   The APKBUILD includes a sha256 hash of this file. It is not clear
            where that hash came from.
    -   Alpine packages: openssl-dev nghttp2-dev zlib-dev brotli-dev autoconf
        automake groff libtool perl
-   The source tarball was _presumably_ built from the actual upstream GitHub
    repository
    [curl/curl@curl-7_72_0](https://github.com/curl/curl/tree/curl-7_72_0), by
    running the commands `./buildconf && ./configure && make && ./maketgz
    7.72.0`. That command has a set of dependencies, but those are not well
    documented.
-   Finally, there are the systems that actually ran the builds above. We have
    no indication about their software, configuration, or runtime state
    whatsoever.

Suppose some developer's machine is compromised. What attacks could potentially
be performed unilaterally with only that developer's credentials? (None of these
are confirmed.)

-   Directly upload a malicious image to Docker Hub.
-   Point the CI/CD system to build from an unofficial Dockerfile.
-   Upload a malicious Dockerfile (or other file) in the
    [curl/curl-docker](https://github.com/curl/curl-docker/blob/d6525c840a62b398424a78d792f457477135d0cf/alpine/latest/Dockerfile)
    git repo.
-   Upload a malicious https://curl.haxx.se/ca/cacert.pem.
-   Upload a malicious APKBUILD in Alpine's git repo.
-   Upload a malicious [curl-dev] Alpine package to the Alpine repository. (Not
    sure if this is possible.)
-   Upload a malicious https://curl.haxx.se/download/curl-7.72.0.tar.xz. (Won't
    be detected by APKBUILD's hash if the upload happens before the hash is
    computed.)
-   Upload a malicious change to the [curl/curl](https://github.com/curl/curl/)
    git repo.
-   Attack any of the systems involved in the supply chain, as in the
    [SolarWinds attack](https://www.crowdstrike.com/blog/sunspot-malware-technical-analysis/).

SLSA intends to cover all of these threats. When all artifacts in the supply
chain have a sufficient SLSA level, consumers can gain confidence that most of
these attacks are mitigated, first via self-certification and eventually through
automated verification.

Finally, note that all of this is just for curl's own first-party supply chain
steps. The dependencies, namely the Alpine base image and packages, have their
own similar threats. And they too have dependencies, which have other
dependencies, and so on. Each dependency has its
[own SLSA level](#scope-of-slsa) and the
[composition of SLSA levels](#composition-of-slsa-levels) describes the entire
supply chain's security.

For another look at Docker supply chain security, see
[Who's at the Helm?](https://dlorenc.medium.com/whos-at-the-helm-1101c37bf0f1)
For a much broader look at open source security, including these issues and many
more, see [Threats, Risks, and Mitigations in the Open Source Ecosystem].

## Vision: Case Study

Let's consider how we might secure [curlimages/curl] from the
[motivating example](#motivating-example) using the SLSA framework.

### Incrementally reaching SLSA 4

Let's start by incrementally applying the SLSA principles to the final Docker
image.

#### SLSA 0: Initial state

![slsa0](images/slsa-0.svg)

Initially the Docker image is SLSA 0. There is no provenance. It is difficult to
determine who built the artifact and what sources and dependencies were used.

The diagram shows that the (mutable) locator `curlimages/curl:7.72.0` points to
(immutable) artifact `sha256:3c3ff…`.

#### SLSA 1: Provenance

![slsa1](images/slsa-1.svg)

We can reach SLSA 1 by scripting the build and generating
[provenance](https://github.com/in-toto/attestation). The build script was
already automated via `make`, so we use simple tooling to generate the
provenance on every release. Provenance records the output artifact hash, the
builder (in this case, our local machine), and the top-level source containing
the build script.

In the updated diagram, the provenance attestation says that the artifact
`sha256:3c3ff…` was built from
[curl/curl-docker@d6525…](https://github.com/curl/curl-docker/blob/d6525c840a62b398424a78d792f457477135d0cf/alpine/latest/Dockerfile).

At SLSA 1, the provenance does not protect against tampering or forging but may
be useful for vulnerability management.

#### SLSA 2 and 3: Build service

![slsa2](images/slsa-2.svg)

To reach SLSA 2 (and later SLSA 3), we must switch to a hosted build service
that generates provenance for us. This updated provenance should also include
dependencies on a best-effort basis. SLSA 3 additionally requires the source and
build platforms to implement additional security controls, which might need to
be enabled.

In the updated diagram, the provenance now lists some dependencies, such as the
base image (`alpine:3.11.5`) and apk packages (e.g. `curl-dev`).

At SLSA 3, the provenance is significantly more trustworthy than before. Only
highly skilled adversaries are likely able to forge it.

#### SLSA 4: Hermeticity and two-person review

![slsa4](images/slsa-4.svg)

SLSA 4 [requires](requirements.md) two-party source control and hermetic builds.
Hermeticity in particular guarantees that the dependencies are complete. Once
these controls are enabled, the Docker image will be SLSA 4.

In the updated diagram, the provenance now attests to its hermeticity and
includes the `cacert.pem` dependency, which was absent before.

At SLSA 4, we have high confidence that the provenance is complete and
trustworthy and that no single person can unilaterally change the top-level
source.

### Full graph

![full-graph](images/slsa-full-graph.svg)

We can recursively apply the same steps above to lock down dependencies. Each
non-source dependency gets its own provenance, which in turns lists more
dependencies, and so on.

The final diagram shows a subset of the graph, highlighting the path to the
upstream source repository ([curl/curl](https://github.com/curl/curl)) and the
certificate file ([cacert.pem](https://curl.se/docs/caextract.html)).

In reality, the graph is intractably large due to the fanout of dependencies.
There will need to be some way to trim the graph to focus on the most important
components. While this can reasonably be done by hand, we do not yet have a
solid vision for how best to do this in an scalable, generic, automated way. One
idea is to use ecosystem-specific heuristics. For example, Debian packages are
built and organized in a very uniform way, which may allow Debian-specific
heuristics.

### Composition of SLSA levels

An artifact's SLSA level is not transitive, so some aggregate measure of
security risk across the whole supply chain is necessary. In other words, each
node in our graph has its own, independent SLSA level. Just because an
artifact's level is N does not imply anything about its dependencies' levels.

In our example, suppose that the final [curlimages/curl] Docker image were SLSA
4 but its [curl-dev] dependency were SLSA 0. Then this would imply a significant
security risk: an adversary could potentially introduce malicious behavior into
the final image by modifying the source code found in the [curl-dev] package.
That said, even being able to _identify_ that it has a SLSA 0 dependency has
tremendous value because it can help focus efforts.

Formation of this aggregate risk measure is left for future work. It is perhaps
too early to develop such a measure without real-world data. Once SLSA becomes
more widely adopted, we expect patterns to emerge and the task to get a bit
easier.

### Accreditation and delegation

Accreditation and delegation will play a large role in the SLSA framework. It is
not practical for every software consumer to fully vet every platform and fully
walk the entire graph of every artifact. Auditors and/or accreditation bodies
can verify and assert that a platform or vendor meets the SLSA requirements when
configured in a certain way. Similarly, there may be some way to "trust" an
artifact without analyzing its dependencies. This may be particularly valuable
for closed source software.

<!-- Links -->

[Threats, Risks, and Mitigations in the Open Source Ecosystem]: https://github.com/Open-Source-Security-Coalition/Open-Source-Security-Coalition/blob/master/publications/threats-risks-mitigations/v1.1/Threats%2C%20Risks%2C%20and%20Mitigations%20in%20the%20Open%20Source%20Ecosystem%20-%20v1.1.pdf
[curl-dev]: https://pkgs.alpinelinux.org/package/edge/main/x86/curl-dev
[curlimages/curl]: https://hub.docker.com/r/curlimages/curl
