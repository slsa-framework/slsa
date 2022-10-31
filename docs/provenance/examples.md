## Docker Rebuilder

```json
"predicate": {
    "buildDefinition": {
        "topLevelInputs": {
            "buildType": "https://slsa.dev/docker-build/v0.1",
            "inputArtifacts": {
                "source": {
                    "uri": "git+https://github.com/bcoe/slsa-on-github-test@refs/heads/main",
                    "digest": { "sha1": "deadbeef" }
                },
                "buildImage": {
                    "uri": "pkg:oci/builder-image?repository_url=gcr.io",
                    "digest": { "sha256": "53ca44..." }
                },
                "builderBinary": {
                    "uri": "git+https://github.com/slsa-framework/slsa-github-generator@refs/tags/v1.2.0",
                    "digest": { "sha1": "bdd89e60dc5387d8f819bebc702987956bcd4913" }
                }
            },
            "entryPoint": "path/to/config.file",
            "parameters": {
                "outputPath": "...",
                "command": "..."
            }
        },
        "buildDependencies": null
    },
    "runDetails": {
        "builder": {
            "id": "... something github whatever ..."
        },
        "metadata": {
            "invocationId": "...",
            "startedOn": "...",
            "finishedOn": "..."
        },
        "byproducts": null
    }
}
```

## Tekton

## GitHub Actions Builder

```json
"predicate": {
    "buildDefinition": {
        "topLevelInputs": {
            "buildType": "... github actions ...",
            "inputArtifacts": {
                "source": {
                    "uri": "...",
                    "digest": { "sha1": "deadbeef" }
                },
                "builderBinary": {
                    "uri": "git+https://github.com/slsa-framework/slsa-github-generator@refs/tags/v1.2.0",
                    "digest": { "sha1": "bdd89e60dc5387d8f819bebc702987956bcd4913" }
                }
            },
            "entryPoint": ".github/workflow/build.yml",
            "parameters": null
        },
        "buildDependencies": null
    },
    "runDetails": {
        "builder": {
            "id": "... something github whatever ..."
        },
        "metadata": {
            "invocationId": "...",
            "startedOn": "...",
            "finishedOn": "..."
        },
        "byproducts": null
    }
}
```

