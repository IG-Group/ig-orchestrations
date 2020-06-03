# API Notes for Knock-out CFDs

## Introduction

This document provides notes for the representation of Knock-outs in the API.

See the "General introduction to [Knock Outs](./knockOuts.md)" for product information.

See IG's FIX OTC API Rules of Engagement document for details of the supported and required Message and Fields.

IG provides pricing on the Underlying Instrument for the Knock-out and the price used for trading at a specific Knock-out Level (or Strike) must be derived using the Strike and Underlying price as described in the [PreTrade](#PreTrade) section of this document.

The Strike and PutOrCall fields must be provided in trading messages as described in [Trade](Trade).

## Pre Trade

The permitted Knock-out Strikes are specified in the Strike Rules Component of  Security Definition messages. Strike Rules are not present in the Security List messages. A Security Definition Request must be made to determine the applicable Strikes and the Strike Increment.

The Account must be specified to determine the permitted range of Strikes. This range may also change over time. For example the permitted Minimum and Maximum Strike may change when the Underlying exchange is closed. Accordingly it is advised to request the Security Definition before presenting the range of Strikes.

Provide Account on a Security Definition Request message to obtain the Strike Rules.

![alt text](./SecurityListAndSecurityDefinitionRequests.png "SecurityList and SecurityDefinition Requests")

### SecurityGroup
The following Security Groups are for Knock-outs.

* "KNOCKOUTS_INDICES”
* “KNOCKOUTS_COMMODITIES”
* “KNOCKOUTS_CURRENCIES”
* “KNOCKOUTS_SHARES”

### PutOrCall
The PutOrCall field in the Instrument component can help identity Bull vs Bear Knock-outs.

* Bull : PutOrCall = "Call"
* Bear : PutOrCall = "Put"

### MaturityMonthYear
Knock-out CFDs have an expiry. The MaturityMonthYear field will be provided in the Instrument component of Security Definition messages and SecListGrp in Security List Messages.

### Strike Rules

Strike Rules define the minimum and maximum permitted Strikes (Knock-out Levels) and the Strike Increment as illustrated in the following examples.

The StartStrikePxRange is the Strike Price closest to the current Underlying market price.

The EndStrikePxRange is the Strike Price furthest from the current Underlying market price.

The StrikeIncrement is the value by which the strike price may be incremented within the specified price range.

#### Bull Knock-out

|Field Name|Value|
|---|---|
|StartStrikePxRange|1985|
|EndStrikePxRange|1955|
|StrikeIncrement|-5|

Note that for Bull Knock-outs the StrikeIncrement is negative so the result of addition will be decrement.

|Strike Value|Comment|
|---|---|
|1985|StartStrikePxRange|
|1980|Prior Strike + StrikeIncrement|
|1975|Prior Strike + StrikeIncrement|
|1970|Prior Strike + StrikeIncrement|
|1965|Prior Strike + StrikeIncrement|
|1960|Prior Strike + StrikeIncrement|
|1955|EndStrikePxRange|

#### Bear Knock-out

|Field Name|Value|
|---|---|
|StartStrikePxRange|1210|
|EndStrikePxRange|1240|
|StrikeIncrement|5|

|Strike Value|Comment|
|---|---|
|1210|StartStrikePxRange|
|1215|Prior Strike + StrikeIncrement|
|1220|Prior Strike + StrikeIncrement|
|1225|Prior Strike + StrikeIncrement|
|1230|Prior Strike + StrikeIncrement|
|1235|Prior Strike + StrikeIncrement|
|1240|EndStrikePxRange|

### Pricing Knock-outs

The Knock-out Premium is available from the Security List message. It can be found in the Instrument Attribute Group.

The price to present for a given Knock-out level (strike) is:

* Bull
  * Bid   : (IG Underlying Bid price - Knock-out level) + Knock-out premium
  * Offer : (IG Underlying Offer price - Knock-out level) + Knock-out premium premium
* Bear
  * Bid (Knock-out level - IG Underlying bid price) + Knock-out premium
  * Offer : (Knock-out level - IG Underlying Offer price) + Knock-out premium

## Trade

### MaturityMonthYear

The MaturityMonthYear must be specified in the Instrument component of orders for Knock-out CFDs.

### Strike Price

Previously Quoted orders required a StrikePrice as described in  [Pricing Knockouts](#Pricing-Knock-outs).

### Order Types

The following Order Types are supported for Knock-outs:

* Market
* Previously Quoted

### Time In Force

The following Time In Force are supported for Knock-outs:

* IOC (Immediate Or Cancel)
* FOK (Fill Or Kill)

### Order Messages

The following order messages are applicable for Knock-outs:
* NewOrderSingle
  * Can be used to open a Position or to "attach" a Stop and/or Limit order to a Knock-out Position. The attached orders may not be Knock-outs.
* NewOrderList
  * Can be used the place an Order with contingent Stop and/or Limit orders. The contingent orders may not be Knock-outs. Only FOK and IOC orders are applicable for Knock-outs, working orders for Knock-outs will not exist. Therefore "List Cancel Request" messages are not expected:

The following messages are applicable for working orders attached to an open Knock-out Position and also for contingent orders which have not yet been triggered.

* Order Cancel/Replace Request
* Order Cancel Request

## Post Trade

Open Knock-out Positions can be closed using a Position Maintenance Request. Closing the Position will cancel any attached Stop and/or Limit Orders.
