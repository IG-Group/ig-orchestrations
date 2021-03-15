# roe
This project is responsible for generating the Rules of Engagement documentation.

A roe mark down document is automatically generated from the orchestration output file within the package phase.

The roe file can be generated from the command line using 
```
mvn exec:java@orchestra-md-generation
```

Separate static mark down documents form constituent parts of the roe. For example the introduction, product offering, on-boarding process and examples etc.

The project glues the mark down documents together to produce one pdf document. This utilises pandoc.

Due to having pandoc installed the pdf is not generated as part of the build but can be generated from the command line using

```
mvn exec:exec@pandoc
```