# document
This project generates Rules of Engagement documentation. It contains 2 maven sub modules which represent customisations for the FIXT and FIXP Websocket APIs.  

The output of each sub module is generated markdown and an html website. The generation takes IG's orchestra file as input. The output is assembled into a zip distribution.

In each sub module separate static Markdown documents form constituent parts of the API documentation. This includes the introduction, product offering, on-boarding process and examples.

The packaged assembly can be downloaded from the following locations:

| **API**   | **Artifact** |
|-----------|--------------------------|
| WebSocket | [![Sonatype Nexus (Releases)](https://img.shields.io/nexus/r/com.ig.orchestrations.us.rfed/document-websocket?label=WebSocket&server=https%3A%2F%2Foss.sonatype.org%2F)](https://oss.sonatype.org/#nexus-search;gav~com.ig.orchestrations.us.rfed~document-websocket~~~) | 
| FIX5.0SP2	    | [![Sonatype Nexus (Releases)](https://img.shields.io/nexus/r/com.ig.orchestrations.us.rfed/document-fixt?label=FIXT&server=https%3A%2F%2Foss.sonatype.org%2F)](https://oss.sonatype.org/#nexus-search;gav~com.ig.orchestrations.us.rfed~document-fixt~~~)   |

## Markdown
Each sub module contains the static Rules of Engagement Markdown documents and generates a Markdown document (called orchestration.md) from the orchestration. These documents are can be viewed without needing to download the packaged artifacts.

* [WebSocket](./document-fixt/markdown/readme.md)
* [FIX5.0SP2](./document-websocket/markdown/readme.md)

The roe markdown file is generated in the package phase but can be manually generated from the command line (enter either the document-fixt or document-websocket directory).

```
mvn exec:java@orchestra-md-generation
```

## HTML
The project generates html pages to target/html during the maven package phase.


