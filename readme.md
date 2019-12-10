# ig-orchestrations
FIX Repository Orchestrations for IG Group Rules of Engagement

## Purpose

This project specialises the standard FIX orchestration to build IG Orchestration (repository) and a corresponding JSON schema and Java binding.

## How To

Artifacts on which this project depends are not available from public mvn repositories.

First, checkout and build locally the FIX Orchestrata Project.

This will publish to the local mvn repository the FIX Standard Orchestration on which this project depends.
```
git clone https://github.com/FIXTradingCommunity/fix-orchestra.git
cd fix-orchestra
mvn clean install
```
Now you can build this project.
```

git clone https://github.com/IG-Group/ig-orchestrations.git
cd ig-orchestrations
mvn clean install
```
