# Documentation
This project generates Rules of Engagement documentation. 

Sub modules will output generated markdown (orchestration.md) and a html website. The generation takes IG's orchestra file as input. The output is assembled into a zip distribution.

The packaged assembly can be downloaded from the following locations:

| **API**   | **Artifact** |
|-----------|--------------------------|
| FIX5.0SP2	    | [![Sonatype Nexus (Releases)](https://img.shields.io/nexus/r/com.ig.orchestrations.us.rfed/document-fixt?label=FIXT&server=https%3A%2F%2Foss.sonatype.org%2F)](https://oss.sonatype.org/#nexus-search;gav~com.ig.orchestrations.us.rfed~document-fixt~~~)   |

### Markdown documents
Static markdown documents form constituent parts of the API documentation. This includes the introduction, product offering, on-boarding process and examples.

These documents can be viewed without needing to download the packaged artifacts.

* [FIX5.0SP2](./document-fixt/markdown/readme.md)

The generated roe markdown file is generated in the package phase but can be manually generated from the command line (enter the document-fixt directory).
```
mvn exec:java@orchestra-md-generation
```

### HTML
The project generates html pages to target/html during the maven package phase.


