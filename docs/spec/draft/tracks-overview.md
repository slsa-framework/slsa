---
title: Overview of SLSA tracks
description: The SLSA specification divides up Software Supply Chain activities into four independent tracks.
---

## Overview of SLSA Tracks.

Multiple activities can make up a supply chain management system.  

Currently there are four separate tracks that are covered by the SLSA specificaton:

| Track Name    | Activity |
| ---           | ---      |
| Build Track  | Process that transforms a set of input artifacts into a set of output artifacts. The inputs may be sources, dependencies, or ephemeral build outputs. |
| Build Environment Track | Describes how a build image was created, how the hosted build platform deployed a build image in its environment, and the compute platform they used. |
| Dependency Track | Software artifacts fetched or otherwise made available to the build environment during the build of the artifact. This includes open and closed source binary dependencies. |
| Source Track | Source code used to create software artificts. Descriptions of how the Source Control System (SCS) and Version Control System (VCS) provide producers and consumers with increasing levels of trust in the source code they produce and consume. |

