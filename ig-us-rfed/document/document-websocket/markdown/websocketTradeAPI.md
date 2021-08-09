# Trade Web Socket API FIX/JSON
## Introduction

This document specifies the Rules of Engagement for Trading with IG.

## Related Documents

See also [ WebSocket API ](websocketAPI.md)

## WebSocket URL

### Demo
wss://demo-igustrade.ig.com/trade

### Production
wss://igustrade.ig.com/trade

## Fields and Constraints

### OrdType (Order Type)

The following Order Types are supported :

* "Market", Market Order
* "Limit", Limit Order
* "Stop",  Stop Order
* "PreviouslyQuoted", Previously Quoted

### TimeInForce

The following TimeInForce values are recognised.

* "GoodTillCancel", Good Till Cancel - GTC
* "GoodTillDate", Good Till Date – GTD
* "FillOrKill", Fill or Kill – FOK
* "ImmediateOrCancel", Immediate or Cancel – IOC

TimeInForce “Good Till Cancel” and “Good Till Date” are the only valid options with Order Type “Stop Order”.

###	Account
In all cases the IG AccountID must be provided on trading messages. This must be the IG Account ID.

### ClOrdID (Client Order ID)
The FIX 5.0 specification requires that ClOrdID be unique for a trading session. IG Group requires that the ClOrdID be unique per IG Client Identity across all trading sessions.

###	RefOrderID and RefOrderIDSource
IG supports the use of RefOrderID and RefOrderIDSource to identify Orders on which another Order may be contingent, RefOrderIDSource may have the following values;

* "OrderID"
* "ClOrdID"

###	TrailingStopIncrement
A custom tag TrailingStopIncrement (5008) is used in the PegInstructions to define the increments by which the trailing stop is adjusted. This is mandatory for a Trailing Stop contingent order.

###	QuoteID
IG supports the ‘Previously Quoted’ order type (D) for new orders.  For orders of this type, clients must provide a QuoteID for the correct Side as obtained from a FIX OTC market data feed for the security.

Quote identifiers are provided to FIX clients in the QuoteID fields of Market Data Incremental Refresh and Market Data Snapshot Full Refresh messages. The use of QuoteID in Market Data messages is an IG Group customisation.

## Components

### OrderQtyData

|Field/Component Name|Required?|Comments|
|---|---|---|
|OrderQty|Y|Required by IG. Number of contracts. Decimal quantities are supported.|

### PegInstructions

PegInstructions may be used for contingent orders in New Order List.

|Field/Component Name|Required?|Comments|
|---|---|---|
|PegOffsetValue|N|May be used for contingent orders in New Order List messages. PegOffsetValue is used to specify the price for contingent Stop or Limit orders. If the Stop or Limit order is contingent on another order the value notionally represents the offset from the primary order’s fill price. Once the primary order is filled the Stop or Limit order become working orders "attached" to the new position. The PegOffsetValue is therefore the offset from the price at which the position was opened. The value should be greater than zero.|
|PegPriceType|N|If provided must be "PrimaryPeg".|

#### The Effect of Side and Order Type

|Side of Primary Order or Position|Side of Contingent Order|Order Type of Contingent Order|Effect|
|---|---|---|---|
|Buy|Sell|Stop order to stop losses|PegOffsetValue will be subtracted from the price of the Primary Order to derive the Stop Price|
|Buy|Sell|Limit order to take profit|PegOffsetValue will be added to the price of the Primary Order to derive the Limit Price|
|Sell|Buy|Stop order to stop losses|PegOffsetValue will be added to the price of the Primary Order to derive the Stop Price|
|Sell|Buy|Limit order to take profit|PegOffsetValue will be subtracted from the price of the Primary Order to derive the Limit Price|

#### Examples: Orders Contingent on a Working Order

PegOffsetValue must be a positive value.
The actual Price will depend on the price at which the order is filled.

|Working Order Side|Contingent Order Side|Primary (Working) Order Price|Order Type of Contingent Order|PegOffsetValue|Target Price|
|---|---|---|---|---|---|
|Buy|Sell|100|Stop order to stop losses|15|100 – 15 = 85|
|Buy|Sell|100|Limit order to take profit|25|100 + 25 = 125|
|Sell|Buy|100|Stop order to stop losses|15|100 + 15 = 115|
|Sell|Buy|100|Limit order to take profit|25|100 – 25 = 75|

## Application Messages

### NewOrderSingle

The New Order Single message type is used by institutions wishing to electronically submit orders to IG Group for execution. This submits a single order for a single instrument.

#### Orders "attached" to a Position

New Order Single may be used to create an order attached to a position.
Attaching Orders to a position is an IG specific usage and departs from the standard FIX specification. Orders that are attached to a position will be automatically cancelled if the position is closed.

SecurityID must be provided to identify the relevant position.

Only Order Type “Stop” and “Limit” are valid for "attached" orders.

For attached orders Price or StopPx fields are used to specify the Limit or Stop Price respectively.

TimeInForce must be “GoodTillCancel”.

See "OrderAttributeGrp" to specify that the Order must be attached.

|Field/Component Name|Required?|Comments|
|---|---|---|
|Standard Header|Y|MsgType = “NewOrderSingle”|
|ClOrdID|Y|Unique identifier of the order as assigned by institution. The maximum size of ClOrdID is limited to 60 characters in this implementation.|
|Account|Y|IG Account ID. Required on all trading messages.|
|Instrument|Y|SecurityID and SecurityIDSource are required by IG, Marketplace Assigned Identifier for the security as provided by IG. SecurityIDSource must be "MarketplaceAssignedIdentifier".|
|Side|Y|Side of order. Valid Values are; <ul><li>"Buy"</li><li>"Sell"</li></ul> Other values will be rejected.|
|TransactTime|Y|Time this order request was initiated/released by the trader or trading system. Millisecond resolution is optional. Outgoing messages from IG will include Milliseconds.|
|OrderQtyData|Y|Component. OrderQtyData not evaluated for Orders to be attached to a Position.|
|OrdType|Y|Type of Order. See “Order Types”|
|Price|C|Required for “Limit” and “Previously Quoted” Order Types|
|StopPx|C|Required for “Stop” order types.|
|Currency|Y|Required by IG Group. Identifies currency used for price. Must be set to the correct currency for the instrument. See also “Currency”. |
|QuoteID|C|Required for Previously Quoted Orders. Quote IDs are provided by the IG market data FIX feed|
|TimeInForce|Y|Required by IG Group. See “Time In Force”|
|ExpireTime|C|Required if TimeInForce = "GoodTillDate". Only format “YYYYMMDD-HH:MM:SS “ (whole seconds) is supported.|
|Text|N|Free format text|
|OrderAttributeGrp|N|Order Attribute Group, used to specify if this order will be attached to a position|

#### OrderAttributeGrp

|Field/Component Name|Required?|Comments|
|---|---|---|
|OrderAttributeType|N|If present must be <ul><li>"AttachedOrder"</li></ul> indicating that the order must be attached to an existing position.|
|OrderAttributeValue|C|Required if OrderAttributeType "AttachedOrder" is present. Must be:<ul><li>"Y"</li><li>"N"</li></ul>|

Request:

Example for a “NewOrderSingle” message:

```json
{
  "MsgType": "NewOrderSingle",
  "ApplVerID":"FIX50SP2",
  "CstmApplVerID": "IGUS/Trade/V1",
  "SendingTime": "20190802-21:14:38.717",
  "ClOrdID":"12345",
  "Account":"PDKKL",
  "SecurityID":"CS.D.GBPUSD.CZD.IP",
  "SecurityIDSource":"MarketplaceAssignedIdentifier",
  "Side":"Buy",
  "TransactTime":"20190802-21:14:38.717",
  "OrderQty":"6",
  "OrdTyp":"2",
  "Price":"34.444",
  "Currency":"USD",
  "TimeInForce":"GoodTillDate",
  "ExpireTime":"20190802-17:00:00.000"
}
```

Response: (see Execution Report)

### OrderCancelRequest

The Order Cancel Request message requests the cancellation of all of the remaining quantity of an existing order. Note that the Order Cancel/Replace Request message should be used to partially cancel (reduce) an order.

Contingent Orders that are not yet working orders cannot be cancelled.
They can be cancelled once they are working orders.

|Field/Component Name|Required?|Comments|
|---|---|---|
|Standard Header|Y|MsgType = "OrderCancelRequest"|
|OrigClOrdID|C|ClOrdID of the previous order (NOT the initial order of the day) when cancelling or replacing an order. Conditionally required if OrderID is not provided. Either OrderID or OrigClOrdID must be provided.|
|OrderID|C|Conditionally required if OrigClOrdID is not provided. Either OrderID or OrigClOrdID must be provided.|
|ClOrdID|Y|Unique identifier of the order as assigned by institution. The maximum size of ClOrdID is limited to 60 characters in this implementation.|
|Account|Y|IG Account ID. Required on all trading messages.|
|Instrument|Y|SecurityID and SecurityIDSource are required by IG, Marketplace Assigned Identifier for the security as provided by IG. SecurityIDSource must be "MarketplaceAssignedIdentifier".|
|Side|Y|Side of order. Valid Values are; <ul><li>"Buy"</li><li>"Sell"</li></ul> Other values will be rejected.|
|TransactTime|Y|Time this order request was initiated/released by the trader or trading system. Millisecond resolution is optional. Outgoing messages from IG will include Milliseconds.|
|Text|N|Free format text|

Request:

Response: (see FIX execution report)

### OrderCancelReplaceRequest (Order Update)

The Order Cancel/Replace Request is used to change the parameters of an existing order.
Please note that the only Order parameters that can be changed are Price/StopPx and ExpireTime (for GTD orders). OrderQty cannot be changed.

Field values described as “rejected” will result in rejection of the received message. The response will be an Order Cancel Reject with an appropriate CxlRejReason.

Contingent Orders that are not yet working orders cannot be amended.
They can be amended once they are working orders.

If a working order is attached to a position the size of the order depends on the position size and cannot be amended with an OrderCancelReplaceRequest.

|Field/Component Name|Required?|Comments|
|---|---|---|
|Standard Header|Y|MsgType = "OrderCancelReplaceRequest"|
|OrderID|C|Unique identifier of most recent order as assigned by broker. Required when OrigClOrdID cannot be provided, for example in the event that the order being replaced was submitted out of band.|
|OrigClOrdID|C|ClOrdID of the previous order (NOT the initial order of the day) when cancelling or replacing an order. Required when referring to orders that where electronically submitted over FIX.|
|ClOrdID|Y|Unique identifier of replacement order as assigned by institution. Note that this identifier will be used in ClOrdID  field of the Cancel Reject message if the replacement request is rejected. The maximum size of ClOrdID is limited to 60 characters in this implementation.|
|Account|Y|IG Account ID. Required on all trading messages.|
|Instrument|Y|SecurityID and SecurityIDSource are required by IG, Marketplace Assigned Identifier for the security as provided by IG. SecurityIDSource must be "MarketplaceAssignedIdentifier".|
|Side|Y|Side of order. Valid Values are; <ul><li>"Buy"</li><li>"Sell"</li></ul> Other values will be rejected.|
|TransactTime|Y|Time this order request was initiated/released by the trader or trading system. Millisecond resolution is optional. Outgoing messages from IG will include Milliseconds.|
|OrderQtyData|Y|Component. IG Group does not support the modification of order quantity for an existing order.|
|OrdType|Y|Type of Order. See “Order Types”|
|Price |C|Required for “Limit” Order Types.|
|StopPx |C|Required for "Stop" Order Types.|
|TimeInForce|C|If present, must match the original order. Conditionally required if the original order is GTD and the ExpireTime is to be changed.|
|ExpireTime|C|Conditionally required if TimeInForce (59) = GTD. Only format “YYYYMMDD-HH:MM:SS“ (whole seconds) is supported.|
|Text|N|Free format text|

### OrderStatusRequest

Request the status of a currently active order.

An execution report will return the status of the order if it is found.  

If the order is not active or not found, an execution report response will be sent with OrdRejReason="UnknownOrder".

|Field/Component Name|Required?|Comments|
|---|---|---|
|Standard Header|Y|MsgType = "OrderStatusRequest"|
|OrderID|C|Conditionally required if ClOrdID is not provided. Either OrderID or ClOrdID must be provided.|
|ClOrdID|C|Conditionally required if OrderID is not provided. Either OrderID or ClOrdID must be provided. |
|OrdStatusReqID|Y|Used to uniquely identify a specific Order Status Request message.|
|Account|Y|IG Account ID.|
|Instrument|Y|Identification of the Instrument|
|Side|Y||

Response: (see Execution Report)

### OrderMassStatusRequest

Execution reports will be returned for orders matching criteria specified within the request.

We have implemented Order Mass Status Request to allow the identification of active orders. Only currently active orders will be returned (orders with an Order Status of “New”).

ExecutionReports with ExecType (150) ="Order Status" are returned for all orders matching the criteria provided on the request.

|Field/Component Name|Required?|Comments|
|---|---|---|
|Standard Header|Y|MsgType = "OrderMassStatusRequest"|
|MassStatusReqID|Y|Unique ID of Mass Status Request.|
|MassStatusReqType|Y|Specifies the scope of the Mass Status Request (AF). Must be: "StatusForOrdersForAPartyID" (Account is used for PartyID)|
|Account|Y|IG Account ID.|

Response: (See Execution Report)

### ExecutionReport

In this implementation the execution report message is used to:
*	confirm the receipt of an order
*	confirm changes to an existing order (i.e. accept cancel and replace requests)
*	relay order status information
*	relay fill information on working orders
*	reject orders

For contingent orders, the IG implementation of an execution report message includes additional fields, ContingencyType, RefOrderID and RefOrderIDSource.  These fields will not be assigned (will not be present) unless an execution is being reported for an order contingent on another order.

|Field/Component Name|Required?|Comments|
|---|---|---|
|Standard Header|Y|MsgType = "ExecutionReport"|
|OrderID|Y|Will be unique for each chain of orders.|
|SecondaryOrderID|N|Will be present only on Fill Execution Reports for working orders that are not contingent on a Position. See: ClosingOrderIDRef in Component PositionQty.|
|ClOrdID|C|Will be present as required for executions against electronically submitted orders that were assigned an ID by the institution. Not required for orders manually entered by the IG Group.|
|OrigClOrdID|C|Will be present in response to Order Cancel and Order Cancel/Replace. Will correspond to ClOrdID of the previous order (NOT the initial order of the day) when cancelling or replacing an order.|
|OrdStatusReqID|C|Required if responding to an Order Status Request.  Echo back the value provided by the requester.|
|MassStatusReqID|C|Required if responding to an Order Mass Status Request. Echo back the value provided by the requester|
|LastRptRequested|N|Can be used when responding to an Order Mass Status Request to indicate that this is the last Execution Reports which will be returned as a result of the request.|
|ListID|C|Required for executions against orders that were submitted as part of a list.|
|ExecID|Y|Unique identifier of execution message as assigned by IG Group. Will be 0 (zero) for ExecType = "OrderStatus".|
|ExecRefID|C|Will be present for ExecType of  “TradeCancel” or “TradeCorrect”|
|ExecType|Y|Will be present. Describes the specific Execution Report  (i.e. "New") while OrdStatus will always identify the current order status (i.e. “PartiallyFilled”)|
|OrdStatus|Y|Describes the current state of a CHAIN of orders.|
|WorkingIndicator|N|Indicates if the order is currently being worked. Applicable only for OrdStatus = "New". ‘N’ indicates that the order is a contingent order that is not yet being worked. Absence of Field should be interpreted as ‘Y’. |
|OrdRejReason|N|May be present for ExecType “Rejected”. Order Reject Reason|
|Account|Y|IG Account ID.|
|Instrument|Y|Instrument|
|Side|Y|<ul><li>"Buy"</li><li>"Sell"</li></ul>|
|OrderQtyData|Y|Component|
|OrdType|Y|Order Type|
|Price|C|Will be present for a Limit Order|
|StopPx|C|Present if a stop order|
|TimeInForce|N|See “Time In Force” Time in force may not be returned on Execution Reports, this does not imply “Day Order” |
|ExpireTime|C|Conditionally required if TimeInForce = "GoodTillDate". Only format “YYYYMMDD-HH:MM:SS “ (whole seconds) is supported.|
|PegInstructions|N|Peg Instructions, used for trailing stops|
|Currency|Y|ISO Currency Code|
|LastQty|C|Present for fills.Quantity of shares bought/sold on this (last) fill.|
|LastPx|C|Present for fills. Price of this (last) fill.|
|LeavesQty|Y| Amount of shares open for further execution. If the OrdStatus is “Canceled”, “DoneForTheDay”, “Expired”, “Calculated” or “Rejected” (in which case the order is no longer active) then LeavesQty could be ‘0’, otherwise LeavesQty = OrderQty – CumQty.|
|CumQty|Y|Currently executed amount for chain of orders.|
|AvgPx|C|Calculated average price of all fills on this order.|
|TransactTime|N|Time this order request was initiated/released by the trader or trading system. Millisecond resolution is optional. Outgoing messages from IG will include Milliseconds.|
|PositionEffect|N|If present, must be; O=Open. In this implementation this will have the effect of opening a position even should it oppose an existing position for the same instrument. The default behaviour (in the absence of this tag) if there is an opposing position is to close (or part close) the opposing position.|
|ContingencyType|C|IG customisation - present for contingent orders only. Must be "OneTriggersTheOther"|
|OrderAttributeGrp|N|Order Attribute Group, used to specify if this order will be attached to a position|
|RefOrderID|C|Will be present if this order is contingent on another order|
|RefOrderIDSource|C|IG customisation – will be present if RefOrderID is present. Identifies the source/type of the RefOrderID. Must be;<ul><li>"OrderID"</li><li>"ClOrdID"</li></ul> |

Examples of a “Execution Report” messages:

Full Fill of an order to Buy 2 contracts of GBP/USD

```json
{
  "MsgType": "ExecutionReport",
  "ApplVerID":"FIX50SP2",
  "CstmApplVerID": "IGUS/Trade/V1",
  "SendingTime": "20190802-21:14:40.001",
  "OrderID":"12345",
  "ClOrdID":"12345",
  "ExecID":"0997234657176",
  "ExecType":"Trade",
  "OrdStatus":"Filled",
  "Account":"PDKKL",
  "SecurityID":"CS.D.GBPUSD.CZD.IP",
  "SecurityIDSource":"MarketplaceAssignedIdentifier",
  "Side":"Buy",
  "OrderQty":"6",
  "OrdTyp":"Limit",
  "Price":"35.000",
  "TimeInForce":"GoodTillDate",
  "ExpireTime":"20190802-17:00:00.000",
  "Currency":"USD",
  "LastQty":"6",
  "LastPx":"35.000",
  "LeavesQty":"0",
  "CumQty":"6",
  "AvgPx":"35.000",
  "TransactTime":"20190802-21:14:38.717"
}
```

Response: (see FIX execution report)

### NewOrderList

New Order List is used by IG to support placing a new order with contingent orders.

Only new orders with accompanying contingent orders are expected in New Order List.

Once contingent orders have been accepted the individual orders can be updated using an Order Cancel Replace message. There is no replace list order message.

In this implementation one Stop contingent order and/or one Limit contingent order may be specified. At least one Stop or one Limit order should be present if New Order List is used. If contingent orders are not required please use New Order Single.

A Primary Order together with Contingent Orders can be cancelled using an OrderCancelRequest for the Primary Order.

The following fields must have the same value on all the orders in the list;
*	Account
*	TimeInForce
*	OrderQty
*	Currency

Position Effect and QuoteID will only be evaluated on the Primary Order.

A description of the Contingent Orders may be found in the FIX Specification Version 5.0 Service Pack 2, Volume 4, Category List/Program/Basket Trading.

The Side on the contingent orders must be opposite to the Side of the primary order.

In this implementation PegInstructions are used in the contingent orders to define the offsets from the primary order price (Price or StopPx). Price and StopPx fields are not evaluated in the Contingent Order sections.

See “Component PegInstructions”.

The PegOffsetValue is expected to be the absolute value of the price offset requested. The IG Order Management System will determine the correct price based on the Side and the Order Type. See “The Effect of Side and Order Type”.

The first order in the list is designated the primary order and subsequent orders are contingent on the primary order being filled.

When the primary order is filled and a contingent order triggered, the PegOffsetValue will be calculated relative to the fill price (LastPx from the Execution Report). This is the opening price of the position. The contingent order or orders are then contingent on the new position.

PegPriceType may be;
*	"PrimaryPeg"

Please note that the IG implementation depends on the ListID being the same as the ClOrdID of the primary order.

This message cannot be used to attach Contingent Orders to an existing order. IG supports a customisation of New Order Single to accomplish this.

|Field/Component Name|Required?|Comments|
|---|---|---|
|Standard Header|Y|MsgType "NewOrderList"|
|ListID|Y|Must be unique, by customer, for the day. Must be the same as the CLOrdID of the primary order.|
|BidType|Y|Must be "NoBiddingProcess"|
|ContingencyType|Y|IG requires this field as New Order List is only supported for the purpose of contingent orders. Must be "OneTriggersTheOther"|
|TotalNoOrders|Y|TotalNumber of Orders in accross all messages. IG does not support fragmenting large list orders across multiple messages so TotNoOrders must equal the number of orders in the Orders Group.|
|ListOrdGrp|Y|Orders Repeating Group|

#### Orders Group  (ListOrdGrp)

|Field/Component Name|Required?|Comments|
|---|---|---|
|ClOrdID|Y|Unique identifier of the order as assigned by institution. Must be the first field in the repeating group. The maximum size of ClOrdID is limited to 60 characters in this implementation.|
|ListSeqNo|Y|Sequence of individual order within list (i.e. ListSeqNo of TotNoOrders, 2 of 25, 3 of 25, . . . )|
|Account|Y|IG Account ID. Required on all trading messages.|
|Instrument|Y|SecurityID and SecurityIDSource are required by IG, Marketplace Assigned Identifier for the security as provided by IG. SecurityIDSource must be "MarketplaceAssignedIdentifier".|
|Side|Y|Side of order. Valid Values are; <ul><li>"Buy"</li><li>"Sell"</li></ul> Other values will be rejected.|
|TransactTime|Y|Time this order request was initiated/released by the trader or trading system. Millisecond resolution is optional. Outgoing messages from IG will include Milliseconds.|
|OrderQtyData|Y|Component|
|OrdType|Y|Type of Order. See “Order Types”|
|Price|C|Required for “Limit” and “Previously Quoted” Order Types. This field is only Evaluated on the Primary Order.|
|StopPx|C|Required for “Stop” order types. This field is only Evaluated on the Primary Order.|
|Currency|Y|Required by IG Group. Identifies currency used for price. Must be set to the correct currency for the instrument. See also “Currency”. |
|QuoteID|C|Required for Previously Quoted Orders (OrdType=D). Quote IDs are provided by the IG quote feed|
|TimeInForce|Y|Required by IG Group. See “Time In Force”|
|ExpireTime|C|Rquired if TimeInForce = "GoodTillDate". Only format “YYYYMMDD-HH:MM:SS “ (whole seconds) is supported.|
|Text|N|Free format text|
|PegInstructions|N|See PegInstructions|
|OrderAttributeGrp|N|Order Attribute Group|

Response: (see FIX Execution Report)

### OrderMassStatusRequest

Execution reports will be returned for orders matching criteria specified within the request.

We have implemented Order Mass Status Request to allow the identification of active orders. Only currently active orders will be returned (orders with an Order Status of “New”).

ExecutionReports with ExecType (150) ="Order Status" are returned for all orders matching the criteria provided on the request.

|Field/Component Name|Required?|Comments|
|---|---|---|
|Standard Header|Y|MsgType = "OrderMassStatusRequest"|
|MassStatusReqID|Y|Unique ID of Mass Status Request.|
|MassStatusReqType|Y|Specifies the scope of the Mass Status Request (AF). Must be: "StatusForOrdersForAPartyID" (Account is used for PartyID)|
|Account|Y|IG Account ID.|
|Instrument|N|Identification of the Instrument. If present the mass order status responses will be limited to the received Instrument.|

Response: (See Execution Report)
