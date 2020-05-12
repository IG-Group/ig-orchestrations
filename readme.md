# ig-orchestrations
FIX Repository Orchestrations for IG Group Rules of Engagement

## Purpose

This project specialises the standard FIX orchestration to build an IG Orchestration (repository) and a corresponding JSON schema and Java binding.

## How To

You can build this project as follows:

(you need jdk8 in the path)

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