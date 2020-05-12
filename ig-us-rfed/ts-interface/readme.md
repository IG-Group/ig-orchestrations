Run as a separate build step with generating JSON schemas first. At parent level, build modules.
```
mvn clean install
```
Make sure the working directory is at 
```
./ig-us-rfed/ts-interface/
```

Then install [NodeJs](https://nodejs.org/en/) and install dependencies:
```
npm install
``` 
To generate TypeScript interfaces from JSON schemas, run:
```
npm start
```
