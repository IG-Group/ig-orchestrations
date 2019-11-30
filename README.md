# ig-orchestrations
FIX Repository Orchestrations for IG Group Rules of Engagement

## How To
Artifacts on which this project depends are not available from public mvn repositories.

First, checkout and build locally the master branch from the IG fork of the FIX Orchestrations Project.

This will publish to the local mvn repository the FIX Standard Orchestration on which this project depends.

```
git clone https://github.com/IG-Group/orchestrations.git
cd orchestrations
mvn clean install
```

Now you can build this project to publish the IG US RFED Orchestration.
```

git clone https://github.com/IG-Group/ig-orchestrations.git
cd ig-orchestrations
mvn clean install
```
