# document
This project generates Rules of Engagement documentation. It contains 2 maven sub modules which include customisations for the FIXT and FIXP Websocket APIs.  

The output of each sub module is generated roe markdown and an interactive html website. The generation takes IG's orchestra file as input. The output is assembled into a zip distribution.

In each sub module separate static mark down documents form constituent parts of IG's API documentation. For example the introduction, product offering, on-boarding process and examples etc. 

## Markdown
Each sub module generates a roe markdown document (called orchestration.md) which is generated from the orchestration file.

The roe markdown file is generated in the package phase but can be manually generated from the command line (enter either the document-fixt or document-websocket directory)
```
mvn exec:java@orchestra-md-generation
```

## HTML
The project generates html pages to target/html during the maven package phase.

