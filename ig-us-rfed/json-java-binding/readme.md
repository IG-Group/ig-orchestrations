# Java Binding
This project generates a Jackson Java binding from the json schema dependency.

## Debugging tips
```

Upstream changes to the orchestra xsl transformation that generates the json schema can break the code generation.
To develop or debug the json schema you can experiment with a json schema, perhaps copied from a working version, by using src/test/resources as the schema location rather than the unpacked dependency.

...
 <artifactId>jsonschema2pojo-maven-plugin</artifactId>
                  <configuration>
<!--                      <sourceDirectory>${project.build.directory}/json-schema</sourceDirectory> -->
                          <sourceDirectory>src/test/resources/definitions</sourceDirectory> 
                      <targetPackage>${target-package}</targetPackage>
                  </configuration>
                  <executions>
...
```

If string index out of bounds exceptions are encountered in the code generation search for an empty string '""' in the json schemas.  