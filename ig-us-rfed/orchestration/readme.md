# Orchestration

This project uses xslt to :
* add IG specialisations and standard features to the FIX standard orchestration
* remove or customise messages, components and groups that are not used in this implementation

## Published Orchestration

The published orchestration will omit many messages, components and groups that are not used in the implementation.

This is to reduce the "surface area" of IG's "Rules of Engagement". The generated documents will be easier to understand when only cases in use are present.

Two artifacts are published with different classifiers:
* repository - this artifact includes only application messages and is used for JSON, SBE and document generation
* repository-qfj - this artifact is processed to improve compatibility with quickfix/quickfixj. At time of writing there are some defects in the official FIX orchestration and some workaround for QFJ are also needed.

## QuickFIX/J Dictionary

The processing to prepare an orchestration from which a QuickFIX/J dictionary will be generated is more inclusive. Only items that cause errors in the QuickFIX/J build are removed.

This is because :
* QuickFIX/J test cases use messages and components that IG does not employ. It is easier to build and maintain QuickFIX/J if we do not need to customise test code.
* Building QuickFIX/J against the entire standard can assist compatibility and versioning, we would expect clients with conformant FIX implementations to be able to process messages, components, groups, fields and code-sets(enumerations) that are part of the FIX standard. If for example we wanted to use a FIX standard TimeInForce we would expect this to be viewed as a compatible change.
