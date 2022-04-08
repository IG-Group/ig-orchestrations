# avro

This module generates an [Apache Avro](https://avro.apache.org/) binding from the IG US RFED Orchestration. It uses [Fix Repository to Apache Avro](https://github.com/FIXTradingCommunity/fix-orchestra-avro) to generate the schemas and Avro tools to generate the Java binding.

The Avro schema artefact is published as a zip file with "schema" as a Maven co-ordinate ```classifier```.

* avro-\<version>\-schema.zip
* avro-\<version>\.jar

These Avro schemas correspond to the FIX messages. These schemas may be used to compose additional schemas.

Please see [Fix Repository to Apache Avro](https://github.com/FIXTradingCommunity/fix-orchestra-avro) for additional information and examples.