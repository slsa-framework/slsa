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
                    [string]: #Artifact
                },
                "entryPoint": string,
                "parameters": {...}
            },
            "buildDependencies": {
                "resolvedDependencies": [...#Artifact],
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
            "byproducts": [...#Artifact]
        }
    }
}

#Artifact: {
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
