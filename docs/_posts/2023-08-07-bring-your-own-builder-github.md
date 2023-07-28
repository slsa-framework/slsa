---
title: "Build your own SLSA 3+ provenance builder on GitHub Actions"
author: "Andres Almiray (JReleaser), Adam Korczynski (AdaLogics), Philip Harrison (GitHub), Laurent Simon (Google)"
is_guest_post: false
---

It has been an exciting quarter for supply chain security and SLSA, with the release of the [SLSA v1.0 specification](2023-04-19-slsa-v1-final.md), [SLSA provenance support for npm](https://github.blog/2023-04-19-introducing-npm-package-provenance/), and the announcement of new SLSA Level 3 builders for [Node.js](2023-05-11-bringing-improved-supply-chain-security-to-the-nodejs-ecosystem.md) and [containers](2023-06-13-slsa-github-worfklows-container-based.md)! 

SLSA now provides and maintains official builders for [Go](2022/06/slsa-github-workflows), [Node.js](2023/05/bringing-improved-supply-chain-security-to-the-nodejs-ecosystem) and [Container](2023/06/slsa-github-worfklows-container-based) based projects.
But what if you don't use any of these languages or use custom tooling that isn't supported by the official builders?

To empower the community to create their own provenance builders and leverage the secure architecture of the official SLSA builders we are releasing the ["Build Your Own Builder" framework](https://github.com/slsa-framework/slsa-github-generator/tree/main#build-your-own-builder) for GitHub Actions. This makes it easy to take an existing GitHub Action (e.g. [JReleaser](https://jreleaser.org/)) and make it produce [SLSA Build Level 3 provenance](https://slsa.dev/spec/v1.0/requirements#provenance-generation).

Writing a builder from scratch is a tedious multi-month effort. The BYOB framework streamlines this process and cuts the development time down to a few days. As a builder writer, you need not worry about keeping signing keys secure, isolation between builds, the creation of attestations; all this is handled seamlessly by the framework, using the [same security design principles](https://github.com/slsa-framework/slsa-github-generator/tree/main#specifications) as our existing builders.

To demonstrate the flexibility of this framework, we are also announcing three SLSA builders created by [community contributors](https://github.com/laurentsimon/slsa-github-generator/blob/feat/hof/README.md#builder-creation) for the Java ecosystems.

## Build Your Own Builder Framework

The BYOB framework benefits both GitHub Action maintainers and GitHub Action users:

1. For Action maintainers, it makes it easy to meet the [SLSA Build L3](https://slsa.dev/spec/v1.0/levels#build-l3) requirements.
1. For Action users, it makes it easy to adopt SLSA by trusting the BYOB project and the Action code - without worrying about which machine runs the Action.

The BYOB framework provides a set of GitHub Actions and workflows that helps builder authors generate provenance.

The high-level architecture is depicted in the diagram below. The `builder_workflow.yml` represents the builder being created. The BYOB framework, on the right of the diagram, acts as an orchestrator. 

![BYOB architecture](https://github.com/slsa-framework/slsa/assets/64505099/51c796e3-754e-4cd8-b2ea-dd8c23662411)

There are two main steps to using the BYOB framework. First, the builder (`builder_workflow.yml`) initializes the BYOB framework ("Initialize" box on the left). Then it calls the framework ("Run" box on the left). Running the framework transfers execution to the BYOB framework which will run the build in an isolated environment and then generate provenance.

Let's see each of these steps in more detail.

The snippet below shows how the initialization step is performed: the builder initializes the BYOB framework for the ubuntu-latest runner, with a build Action path "./internal/callback_action" and asks it to attest to its inputs. At runtime, the BYOB framework will isolate the "./internal/callback_action" into an ephemeral VM and run it on an ubuntu-latest runner. The call below returns a so-called "slsa-token" object which can then be used to run the framework itself.

```yaml
uses: slsa-framework/slsa-github-generator/actions/delegator/setup-generic@v1.8.0
  with:
    ...
    slsa-runner-label: "ubuntu-latest"
    slsa-build-action-path: "./internal/callback_action"
    slsa-workflow-inputs: ${{ toJson(inputs) }}
```

The second step is to run the BYOB framework with the initialized "slsa-token":

```yaml
uses: slsa-framework/slsa-github-generator/.github/workflows/delegator_generic_slsa3.yml@v1.8.0
  with:
    slsa-token: ${{ needs.slsa-setup.outputs.slsa-token }}
  secrets:
    secret1: ${{ inputs.password }}
    secret2: ${{ inputs.token }}
```

When the run completes, the BYOB framework will generate a list of attestations for the artifacts indicated by the builder. More information is available in our [documentation](https://github.com/slsa-framework/slsa-github-generator/blob/main/BYOB.md#generation-of-metadata-layout-file).

## SLSA Java builders for JReleaser, Maven and Gradle

To validate the design of the BYOB framework and demonstrate its flexibility, we have partnered with new contributors to create three new builders for the [Java ecosystems](https://github.com/slsa-framework/slsa-github-generator/blob/main/README.md#builder-creation):

1. A [JReleaser](https://github.com/jreleaser/release-action/tree/java#slsa-builder) Java builder which wraps the existing [GitHub Action for JReleaser](https://github.com/jreleaser/release-action) into a SLSA3-compliant builder. The integration was done by [aalmiray@](https://github.com/aalmiray), the maintainer of the [JReleaser](https://jreleaser.org) project. The resulting builder is hosted in the same repository as its original [Action](https://github.com/jreleaser/release-action/blob/java/.github/workflows/builder_slsa3.yml), so that JReleaser users can continue using the repositories they are already accustomed to.

2. A [Maven builder](https://github.com/slsa-framework/slsa-github-generator/tree/main/internal/builders/maven#readme), contributed by [AdaLogics](https://adalogics.com). This builder is currently hosted in the OpenSSF SLSA repository.

3. A [Gradle builder](https://github.com/slsa-framework/slsa-github-generator/tree/main/internal/builders/gradle#readme), contributed by [AdaLogics](https://adalogics.com). This builder is currently hosted in the OpenSSF SLSA repository.

These Java builders can publish provenance attestation on Maven central. Additionally, the JReleaser SLSA builder can provide attestation for artifacts published as GitHub release assets and/or uploaded to cloud storage such as AWS S3. Like other builders released by the SLSA Tooling SIG, the provenance can be verified using the [slsa-verifier](https://github.com/slsa-framework/slsa-verifier).

### Verification for your projects

Below is an example for verifying provenance generated by the Maven builder: You will need to know the link of the artifact from the platform it has been distributed to. For Java artifacts, this will typically be Maven central, but you can also verify artifacts released on other platforms like Github.

Maven Central allows you to browse the files of each release, and from there you can find the artifacts along with their provenance files:

![Maven provenance link](https://github.com/slsa-framework/slsa/assets/64505099/14ff1de1-a30c-4683-860c-352dc490c1ef)

Once you have the link to the artifact, you can verify it as follows:

```shell
$ ARTIFACT=test-artifact-0.1.0-jar
$ ARTIFACT_URL="https://repo1.maven.org/maven2/path/to/${ARTFACT}"
$ PROVENANCE_URL="${ARTIFACT_URL}".build.slsa
$ wget "${ARTIFACT_URL}" && wget "${PROVENANCE_URL}"
$ slsa-verifier verify-artifact "${ARTIFACT}" --provenance-path="${ARTIFACT}.build.slsa" --source-uri github.com/org/repo
```

### Verification for your dependencies

A Java project contains not only the main application code, but also its dependencies consumed as "packages". We can therefore recursively verify each dependency's provenance. To this end, we're releasing an [experimental Maven plugin](https://github.com/slsa-framework/slsa-verifier/tree/main/experimental/maven-plugin). The plugin resolves all dependencies of a given project and checks if they have provenance attestations along with their releases. When the plugin finds a dependency that has a provenance statement, it verifies it against the dependency.

The plugin automatically performs the verification when configured in the ["pom.xml"](TODO:link to doc). Or it may be run [manually](TODO:link to doc). See our [documentation](https://github.com/slsa-framework/slsa-verifier/tree/main/experimental/maven-plugin).

The plugin is still a proof-of-concept, but it demonstrates what's possible with and likely to come from the BYOB Framework. With the framework producing L3 provenance for GitHub Actions users, and the plugin automatically verifying Maven packages, you can build an end-to-end solution for an entire ecosystem.

## Conclusion

Thanks to the BYOB framework, it's now possible for maintainers of existing GitHub Actions to start producing SLSA Level 3 provenance attestations! 

If you are a maintainer of an existing GitHub Action, try it out by following the [BYOB documentation](https://github.com/slsa-framework/slsa-github-generator/tree/main#build-your-own-builder) and don't hesitate to report issues or ask questions on the [slsa-github-generator](https://github.com/slsa-framework/slsa-github-generator/issues) repository. 

**Special thanks**: Zach Steindler (GitHub), Ian Lewis, Asra Ali, Appu Goundan (Google) for the help landing this feature (design, reviews, implementation, etc)!
