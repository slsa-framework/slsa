{
    // Standard attestation fields:
    "_type": "https://in-toto.io/Statement/v1",
    "subject": [...],

    // Predicate:
    "predicateType": "https://slsa.dev/provenance/v1?draft",
    "predicate": {
        "buildDefinition": {
            "buildType": string,
            "externalParameters": object,
            "systemParameters": object,
            "resolvedDependencies": [ ...#ResourceDescriptor ],
        },
        "runDetails": {
            "builder": {
                "id": string,
                "version": string,
                "builderDependencies": [ ...#ResourceDescriptor ],
            },
            "metadata": {
                "invocationId": string,
                "startedOn": #Timestamp,
                "finishedOn": #Timestamp,
                "completeness": {
                  "externalParameters": "COMPLETE"|"INCOMPLETE",
                  "systemParameters": "COMPLETE"|"INCOMPLETE",
                  "resolvedDependencies": "COMPLETE"|"INCOMPLETE",
                },
                "reproducibility": "FULLY_REPRODUCIBLE"|"NOT_REPRODUCIBLE",
            },
            "byproducts": [ ...#ResourceDescriptor ],
        }
    }
}

#ResourceDescriptor: {
    "uri": string,
    "digest": {
        "sha256": string,
        "sha512": string,
        "gitCommit": string,
        [string]: string,
    },
    "name": string,
    "downloadLocation": string,
    "mediaType": string,
    "content": bytes, // base64-encoded
    "annotations": object,
}

#Timestamp: string  // <YYYY>-<MM>-<DD>T<hh>:<mm>:<ss>Z
