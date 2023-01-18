{
    // Standard attestation fields:
    "_type": "https://in-toto.io/Statement/v0.1",
    "subject": [...],

    // Predicate:
    "predicateType": "https://slsa.dev/provenance/v1.0?draft",
    "predicate": {
        "buildDefinition": {
            "buildType": string,
            "externalParameters": { [string]: #ParameterValue },
            "systemParameters": { [string]: #ParameterValue },
            "resolvedDependencies": [ ...#ArtifactReference ],
        },
        "runDetails": {
            "builder": {
                "id": string,
                "version": string,
                "builderDependencies": [ ...#ArtifactReference ],
            },
            "metadata": {
                "invocationId": string,
                "startedOn": #Timestamp,
                "finishedOn": #Timestamp,
            },
            "byproducts": [ ...#ArtifactReference ],
        }
    }
}

#ParameterValue: {
    "artifactRef": #ArtifactReference
} | {
    "scalarValue": string
} | {
    "mapValue": { [string]: string }
} | {
    "arrayValue": [ ...string ]
}

#ArtifactReference: {
    "uri": string,
    "digest": {
        "sha256": string,
        "sha512": string,
        "sha1": string,
        // TODO: list the other standard algorithms
        [string]: string,
    },
    "localName": string,
    "downloadLocation": string,
    "mediaType": string,
}

#Timestamp: string  // <YYYY>-<MM>-<DD>T<hh>:<mm>:<ss>Z
