package schema

import (
    "time"
)

#Subject: {
    name: string
    digest: #DigestSet
}

#DigestSet: {
            sha256?: string
            sha224?: string 
            sha384?: string
            sha512?: string
            sha512_224?: string
            sha512_256?: string
            sha3_224?: string
            sha3_256?: string
            sha3_384?: string
            sha3_512?: string
            shake128?: string
            shake256?: string
            blake2b?: string
            blake2s?: string
            ripemd160?: string
            sm3?: string 
            gost?: string
            sha1?: string
            md5?: string
}

//TODO: This should probably live in a shared library.
#Alpha: "[a-zA-Z]"
#Digit: "[0-9]"
#Hexdig: "[0-9a-fA-F]"
#Scheme: "[a-z]*?(\\.?|\\+?|\\-?|.?)*?"
#Unreserved: "(\(#Alpha)|\(#Digit)|\\-|\\.|_|~)"
#Pct_Encoded: "%\(#Hexdig){2}"
#Sub_Delims: "(\\!|\\$|\\&|\\'|\\(|\\)|\\*|\\+|\\,|\\;|\\=)"
#Pchar: "(\(#Unreserved)|\(#Pct_Encoded)|\(#Sub_Delims)|\\:|\\@)"
#IPv6Address: "(?:[A-F0-9]{1,4}:){7}[A-F0-9]{1,4}"
#IPvFuture: "v\(#Hexdig)+\\.(\(#Unreserved)|\(#Sub_Delims)|\\:)+"
#IP_Literal: "(\(#IPv6Address)|\(#IPvFuture))"
#IPv4address: "(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)"
#Port: "\(#Digit)*"
#Reg_Name: "(\(#Unreserved) | \(#Pct_Encoded) | \(#Sub_Delims))*"
#Host: "(\(#IP_Literal)|\(#IPv4address)|\(#Reg_Name))"
#Segment: "\(#Pchar)*"
#Segment_NZ: "\(#Pchar)+"
#Segment_NZ_NC: "(\(#Unreserved)|\(#Pct_Encoded)|\(#Sub_Delims)|\\@)+"
#Path_Abempty: "(\\/\(#Segment))*"
#Path_Absolute: "\\/\(#Segment_NZ)(\\/\(#Segment)).*"
#Path_Rootless: "\(#Segment_NZ)(\\/\(#Segment).*)"
#Path_Empty: ""
#Userinfo: "(\(#Unreserved)|\(#Pct_Encoded)|\(#Sub_Delims)|\\:)*?"
#Authority: "(\(#Userinfo)@)?\(#Host)(\\:\(#Port))?"
#Hier_Part: "(\\/\\/)?(\(#Authority)|\(#Path_Abempty)|\(#Path_Absolute)|\(#Path_Rootless)|\(#Path_Empty))"
#Query: "(\(#Pchar)|\\/|\\?)*"
#Fragment: "(\(#Pchar)|\\/|\\?)*"

#URI: =~ "\(#Scheme):\(#Hier_Part)\((#Query))?\((#Fragment))?"


#TypeURI: #URI
#ResourceURI: #URI

#Provenance: {
  // Standard attestation fields:
  "_type": "https://in-toto.io/Statement/v0.1",
  subject: [...#Subject],

  // Predicate:
  predicateType: "https://slsa.dev/provenance/v0.2",
  predicate: {
    builder: {
      id: #TypeURI
    },
    buildType: #TypeURI,
    invocation?: {
      configSource?: {
        uri?: #ResourceURI,
        digest?: #DigestSet,
        entryPoint?: string
      },
      parameters?: { ... },
      environment?: { ... }
    },
    buildConfig?: { ... },
    metadata?: {
      buildInvocationId?: string,
      buildStartedOn?: time.Time,
      buildFinishedOn?: time.Time,
      completeness?: {
        parameters?: bool,
        environment?: bool,
        materials?: bool
      },
      reproducible?: bool
    },
    materials?: [
      {
        uri?: #ResourceURI,
        digest?: #DigestSet
      }
    ]
  }
}
