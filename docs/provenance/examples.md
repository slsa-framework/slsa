## Docker Rebuilder 

```jsonc
"predicate": {
  "buildDefinition": {
    "type": "https://slsa.dev/docker-build/v0.1",
    // Really want two things:
    // - source
    // - builder image
    // In this model, which is which?
    "configSource": {
      "uri": "git+https://github.com/bcoe/slsa-on-github-test@refs/heads/main",
      "digest": { "sha1": "deadbeef" }
    }
    "additionalSources": [{

    }]
  },
  "runDetails": {
  }
}
```

## Tekton

## GitHub Actions

```jsonc
"buildDefinition": {
    "type": "github-actions-workflow",
    "configSource": {
        "uri": "https://github.com/MarkLodato/myproject",
        "digest": { "sha1": "..." },
        "entryPoint": ".github/workflows/build.yml"
    },
    "parameters": { /* object */ },
    "materials": [
        {
            "uri": "<URI>",
            "digest": { /* DigestSet */ }
        }
    ]
},
"instanceMetadata": {
    "builder": {
        "service": "github-actions",
        "tenantProject": "<URI>",
    },
    "invocationId": "<STRING>",
    "startedOn": "<TIMESTAMP>",
    "finishedOn": "<TIMESTAMP>",
    "environment": { /* object */ }, // TODO: feels off
    "evaluatedConfig": {
        "digest": { /* DigestSet */ }
    }
},
```
