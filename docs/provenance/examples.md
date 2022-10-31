## Docker-based Rebuilder

```json
"predicate": {
    "buildDefinition": {
        "topLevelInputs": {
            "buildType": "https://slsa.dev/docker-based-build/v0.1",
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
            "id": "..."
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
            "buildType": "https://github.com/slsa-framework/slsa-github-generator/go@v1",
            "inputArtifacts": {
                "source": {
                    "uri": "git+https://github.com/laurentsimon/slsa-verifier-test-gen@refs/heads/main",
                    "digest": {
                        "sha1": "15bf79ea9c89fffbf5dd02c6b5b686b291bfcbd2"
                    }
                },
                "builderBinary": {
                    "uri": "git+https://github.com/slsa-framework/slsa-github-generator@refs/tags/v1.2.0",
                    "digest": { "sha1": "bdd89e60dc5387d8f819bebc702987956bcd4913" }
                }
            },
            "entryPoint": ".github/workflow/release.yml",
            "parameters": null
        },
        "buildDependencies": {
            "resolvedDependencies": [
                {
                  "uri": "git+https://github.com/laurentsimon/slsa-verifier-test-gen@refs/heads/main",
                  "digest": {
                    "sha1": "15bf79ea9c89fffbf5dd02c6b5b686b291bfcbd2"
                  }
                },
                {
                  "uri": "https://github.com/actions/virtual-environments/releases/tag/ubuntu20/20220515.1"
                }
            ],
            "environment": {
                "github_actor": "...",
                "github_event_name": "workflow_dispatch",
                ...
            }
        }
    },
    "runDetails": {
        "builder": {
            "id": "https://github.com/slsa-framework/slsa-github-generator/.github/workflows/builder_go_slsa3.yml@refs/tags/v0.0.1"
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

