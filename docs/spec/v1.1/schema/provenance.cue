{
    // Standard attestation fields:
    "_type": "https://in-toto.io/Statement/v1",
    "subject": [...],

    // Predicate:
    "predicateType": "https://slsa.dev/provenance/v1",
    "predicate": {
        "buildDefinition": {
            "buildType": string,
            "externalParameters": object,
            "internalParameters": object,
            "resolvedDependencies": [ ...#ResourceDescriptor ],
        },
        "runDetails": {
            "builder": {
                "id": string,
                "builderDependencies": [ ...#ResourceDescriptor ],
                "version": { ...string },
            },
            "metadata": {
                "invocationId": string,
                "startedOn": #Timestamp,
                "finishedOn": #Timestamp,
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
