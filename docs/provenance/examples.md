## Docker Rebuilder

```json5
"predicate": {
    "buildDefinition": {
        "type": "https://slsa.dev/docker-build/v0.1",
        "inputArtifacts": {
            "source": {
                "uri": "git+https://github.com/bcoe/slsa-on-github-test@refs/heads/main",
                "digest": { "sha1": "deadbeef" }
            },
            "buildImage": {
                "uri": "pkg:oci/builder-image?repository_url=gcr.io",
                "digest": { "sha256": "53ca44..." }
            }
        },
        "resolvedDependencies": null,  // not recorded for this builder
        "parameters": {
            "entryPoint": "path/to/config.file"
            // If not a config file, it should go in additionalParams, I think.
            "additionalParams": {
                // Ideally the following are part of the config file:
                "outputPath": "...",
                "command": "...",
                // anything else?...
            }
        }
    },
    "runDetails": {
        "builder": {
            "id": "... something github whatever ..."
        },
        "metadata": {
            "invocationId": "...",
            "startedOn": "...",
            "finishedOn": "...",
        },
        "environment": {
            "systemArtifacts": {
                "builder-binary": {
                    "uri": "git+https://github.com/slsa-framework/slsa-github-generator@refs/tags/v1.2.0",
                    "digest": { "sha1": "bdd89e60dc5387d8f819bebc702987956bcd4913" }
                }
            }
        }
    }
}
```

## Tekton

## GitHub Actions

