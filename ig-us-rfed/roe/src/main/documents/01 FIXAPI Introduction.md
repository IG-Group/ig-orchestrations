# IG US FIX API 
## Introduction

This document specifies the Rules of Engagement for parties connecting to IG Group for the purpose of electronic trading/market data using the IG US FIX APIs.

The FIX protocol version is 5.0SP2.

IG Group offers a subset of pre trade, trade and post trade Application Messages specified by the FIX protocol.
Fields and Messages supported by this implementation are documented here. Messages that are not supported are rejected. Fields that are not supported are mentioned only if they are conditionally required by the FIX Protocol. IG specific extensions are documented. Fields that are required by the FIX Protocol are identified, in some cases IG requires fields that are optional or conditional in the standard protocol.

## Scope

This document addresses the Rules of Engagement that are mainly concerned with technical aspects of the integration. Specialisations and exceptions to the conventional FIX standards are defined here

## Intended Audience

This document is for those involved in integration, conformance testing and other aspects of implementing  connectivity to IG Group.

## Contacts and Support Information

For queries about accounts, orders or positions please contact Trading Services.

|Department|Contact Email |
|---|---|
|FIX Technical Support (Live environment only)|FIXSupport@ig.com|
|FIX Development and Support during on-boarding|FIXDevelopment@ig.com|

## Related Documents

[IG Orchestration for UG US RFED API](https://github.com/IG-Group/ig-orchestrations/tree/master/ig-us-rfed).

FIX 5.0 SP2 specifications.
http://fiximate.fixtrading.org/

FIX Transport (FIXT) specification
https://www.fixtrading.org/family-of-standards/fixt/

## Character Encoding
The Character Encoding is ISO-8859-1.

##	Network Connectivity Options
Default connectivity solution is SSL over the Internet.
Alternative connectivity solutions including VPNs and datacentre cross connects need to be discussed with IG.
Specialised secure network providers such as Radianz may be implemented if required.

Default Custom Application Version ID must be supplied on the Logon message to access the behaviour described in this Rules of Engagement.
See the Implementation Notes for DefaultCstmApplVerID.

### FIX Session Security
FIX Session security is implemented by;
•	IP based authentication of connecting hosts
•	SSL encryption of the session. The connecting counter-party must have a static IP address or addresses.
•	Or Encrypting the transport using an IPSec LAN to LAN VPN solution

###	Duplicate and Resend Message Handling
Duplicate and resent messages will be handled as defined by the FIXT 1.1 Specification.

###	Logging and Monitoring
IG Group will monitor connectivity and retain FIX logs for purposes of auditing and trouble shooting.

## Integration and Conformance
This section describes the process of implementing a FIX integration connecting to IG Group.
### Initiation and Development
Document specialised requirements and configuration.
Development contact details will be exchanged.
Initial connectivity is established and development work and testing can commence as required by the counter party and IG Group.
Please allow 5 working days lead time for firewall and network configuration.
### Integration Testing
IG Group and the connecting party collaborate to perform end to end integration testing and begin to work through the required conformance cases.
### Conformance
A set of conformance tests is conducted by IG Group and the counter party to verify that the integration is complete, correct and compatible with the production trading environment. This will include testing FIX Session layer scenarios such as reconnecting following an interruption of service.
### Go Live
Production configuration is agreed and activated.
Production support contact details will be exchanged.
The live system is made available to the counterparty.

## Failover and Regular Datacentre Migrations
Roughly 2 times a year, IG performs regular network maintenance, and in the process, migrates our datacentre from one site to another. This results in our Production and Demo environment IP addresses swapping over. When this happens, we will send out a notification email.

In the future, IG may change their external facing IP addresses. Therefore, we strongly recommend always using the hostname, rather than the IP address directly.

This maintenance forms part of IG’s Disaster Recovery (DR) plan. Therefore, in a real-life DR scenario, the above change could take place at any time with no notice. Therefore, all clients should make sure they are equipped and prepared to perform the required actions on their side independently in order to prevent prolonged outage

## Session Configuration
Please configure your FIX sessions with the following parameters:
```
    [IG Session]
    DefaultApplVerID=FIX.5.0SP2
    SenderCompID=<User name>
    TargetCompID=<IGUS/IGUSTRADE>
    SocketConnectHost=<Host>
    SocketConnectPort=<Port>
    ResetOnLogon=Y
    ResetOnLogout=N
    ResetOnDisconnect=N
    HeartBtInt=60
    ReconnectInterval=30
    StartTime=22:01:00 Europe/London
    EndTime=22:00:00 Europe/London
```

### SenderCompID
The SenderCompID should be the username used by the client to log on to IG web site.
This identifies the client that is logging on. 

### TargetCompID
The TargetCompID will depend on the API you connect to. This should be
|FIX API| TargetCompID |
|--- |--- |
| PreTrade | IGUS |
| Trade |IGUSTRADE | 

## Authentication
Authorisation to access and trade on an account as well as to obtain pre trade data depends on user credentials for an IG client supplied on the Logon message (35=A).

Failure to provide correct credentials for a IG account will result in a failure to establish the FIX session connection.

Each client account will need to be enabled for FIX access by IG in order for the Logon to succeed. 

## Standard Request Header

|Field Name|Required?|Comments|
|---         |---|---|
|MsgType     |Y  |Defines the message type|
|ApplVerID|N|Specifies the service pack release being applied at message level. Enumerated field with values assigned at time of service pack release|
|CstmApplVerID|N| Specifies a custom extension to a message being applied at the message level. Enumerated field|
|SendingTime |Y|Time request is sent|

## Common Fields and Constraints
### SecurityID and SecurityIDSource

IG supports a unique identity for each instrument.

The Symbol uniquely identifies an instrument at a given point in time.

In some cases, such as for futures, the Symbol can be "reused" once the instrument has expired or been otherwise terminated. The effect of instrument lifecycle is discussed in the PreTrade section of the API.
This does not happen routinely for Spot instruments.

|Field|Description|
|---|---|
|SecurityID|Required by IG, Marketplace Assigned Identifier for the security as provided by IG|
|SecurityIDSrc|Required by IG, distinguishes the source of the SecurityID. Must be "M".|

### Symbol
Symbol is used as a displayable identity for the security. SecurityIDSrc and SecurityID should be used to identify the security. 

### Currency
Although the FIX specification does not require that currency be set, IG Group does require that currency be set (on trading messages) to avoid any ambiguity.

Currency will be regarded as case-sensitive.

The currency supplied will be checked against the instrument to ensure a valid match.

As defined in the FIX Specification (Volume 6, Appendix A) the Currency Codes are ISO 4217 codes.  

Prices must be expressed in the units defined by the currency code. 

IG Group supports trading in a restricted set of currencies.
Valid values depend on the individual instrument and are specified in the Security List message on the Pre Trade API.

###	Quantities
OrderQty, LongQty and ShortQty decimal values are supported to a maximum of 2 decimal places.

