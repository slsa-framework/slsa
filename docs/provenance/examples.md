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
