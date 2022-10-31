Provenance: {
    "buildDefinition": {
        "topLevelInputs": { 
            "buildType": string,
            "inputArtifacts": {...Artifact},
            "entryPoint": string,
            "additionalParameters": {...}
        },
        "buildDependencies": {
            "resolvedDependencies": [...Artifact],
            "environment": {...}
        }
    },
    "runDetails": {
        "builder": {,
            "id": string,
            "version": string
        },
        "metadata": {,
            "invocationId": string,
            "startedOn": time.Time,
            "finishedOn": time.Time
        },
        "byproducts": [...Artifact]
    }
}

Artifact: {
    "uri": string,
    "digest": DigestSet,
    "localName": string,
    "downloadLocation": string,
    "mediaType": string
}

DigestSet: {
    "sha256": string,
    "sha512": string,
    "sha1": string,
    // TODO: list the other standard algorithms
    ...string
}
