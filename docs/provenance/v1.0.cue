{
    // Standard attestation fields:
    "_type": "https://in-toto.io/Statement/v0.1",
    "subject": [...],

    // Predicate:
    "predicateType": "https://slsa.dev/provenance/v1.0-draft",
    "predicate": {
        "buildDefinition": {
            "topLevelInputs": { 
                "buildType": string,
                "inputArtifacts": {
                    [string]: #ArtifactReference
                },
                "entryPoint": string,
                "parameters": {...}
            },
            "buildDependencies": {
                "resolvedDependencies": [...#ArtifactReference],
                "environment": {...}
            }
        },
        "runDetails": {
            "builder": {
                "id": string,
                "version": string
            },
            "metadata": {
                "invocationId": string,
                "startedOn": string,  // timestamp
                "finishedOn": string  // timestamp
            },
            "byproducts": [...#ArtifactReference]
        }
    }
}

#ArtifactReference: {
    "uri": string,
    "digest": {
        "sha256": string,
        "sha512": string,
        "sha1": string,
        // TODO: list the other standard algorithms
        [string]: string
    },
    "localName": string,
    "downloadLocation": string,
    "mediaType": string
}
