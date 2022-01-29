# ig-orchestrations
FIX Repository Orchestrations for IG Group Rules of Engagement

## Purpose

This project specialises the standard FIX orchestration to build IG Orchestrations (repositories) and corresponding JSON schemas and Java bindings.

## API Markdown Documents

### IG US

* [IG US Document Parent](https://github.com/IG-Group/ig-orchestrations/tree/master/ig-us-rfed/document/readme.md)

    * [WebSocket](https://github.com/IG-Group/ig-orchestrations/tree/master/ig-us-rfed/document/document-websocket/markdown/readme.md)

    * [FIX](https://github.com/IG-Group/ig-orchestrations/tree/master/ig-us-rfed/document/document-fixt/markdown/readme.md)

## Project Structure

```
│   readme.md - Describes how to build the project using Apache Maven and NPM, the outputs of the mvn build steps is generally in subdirectories named  “target”.
└───chart-data - For the Chart Data API this contains the JSON Schema source code and build for the Java bindings.
│   └───java-bindings - Generates the Java/JSON bindings.
│   └───json-schema - Source code for the JSON schema.
└───fixp - For the FIX Performance protocol this contains the JSON Schema source code and build for the Java bindings.
│   └───java-binding - Generates the Java/JSON bindings
│   └───json-schema - Source code for the JSON schema.
└───ig-us-rfed – Contains the FIX “orchestration” and supporting information for the IG US RFED API.
│   |───document/
│   |   └───document-websocket - Generates the Rules of Engagement in markdown and HTML for the WebSocket API.
│   |   └───document-fixt - Generates the Rules of Engagement in markdown and HTML for the FIX50sp2/FIXT1.1 API.
│   └───java-binding - Generates the Java/JSON bindings.
│   └───json-schema – Generates the JSON Schema.
│   └───orchestration – Generates the IG RFED “orchestration” from the FIX Standard orchestration – an XML document.
│   └───ts-interface - TypeScript interfaces.
|___otc - location for OTC API resources
```

## How To

You can build this project using jdk8 as follows:

```
git clone https://github.com/IG-Group/ig-orchestrations.git
cd ig-orchestrations
mvn clean install
```

## TypeScript interfaces
Once ig-orchestration has been built, TypeScript interfaces can be generated using [NodeJs](https://nodejs.org/en/) to use for frontend purposes or applications that use TypeScript.

To generate these, run 2 commands:
```
npm install # installs javascript dependencies  
```

```
npm start # generates TypeScript interfaces from JSON Schemas
```
