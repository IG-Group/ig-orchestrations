# Trade FIX API

## Trade Product Offering
The Trade API supports order entry and a subset of post trade messages.

Request messages supported are 
*    NewOrderSingle 
*    NewOrderList
*    OrderCancelReplaceRequest 
*    OrderCancelRequest
*    AccountSummaryReportRequest
*    RequestForPositions
*    OrderStatusRequest
*    OrderMassStatusRequest

Response messages supported are
*    AccountSummaryReport
*    ExecutionReport
*    OrderCancelReject
*    RequestForPositionsAck
*    PositionReport


##	High Message Rate Protection
In order to protect both IG’s and our Clients’ systems, we have implemented a quota in the Trade API.
For each session, we monitor the rate of incoming application messages (i.e. excluding admin messages such as heartbeats). If the number breaches a threshold subsequent orders will be rejected due to the quota breached.
A quota is applied for each type of message. The available quota is refilled based on a refill interval and refill count.

|Message | Quota interval | Max Limit | Quota Refill Count (over interval) |
|---|---|---|---|
|NewOrderSingleMessage | 1m | 200 |100 |
|NewOrderListMessage   | 1m | 100 |10 |
|OrderCancelReplaceRequestMessage | 1m | 200 |100 |
|OrderCancelRequestMessage | 1m | 200 |100 |
|AccountSummaryReportRequestMessage | 1m | 10 |10 |
|OrderStatusRequestMessage | 1m | 200 |10 |
|OrderMassStatusRequestMessage | 1m | 10 |10 |
|RequestForPositionsMessage | 1m | 10 |10 |


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

###	QuoteID
IG supports the ‘Previously Quoted’ order type (D) for new orders. For orders of this type, clients must provide a QuoteID for the order. The QuoteID should be obtained from either the OfferID or BidID depending on the Side, from the Quote message on the Pre Trade API.

### The Effect of Side and Order Type

|Side of Primary Order or Position|Side of Contingent Order|Order Type of Contingent Order|Effect|
|---|---|---|---|
|Buy|Sell|Stop order to stop losses|PegOffsetValue will be subtracted from the price of the Primary Order to derive the Stop Price|
|Buy|Sell|Limit order to take profit|PegOffsetValue will be added to the price of the Primary Order to derive the Limit Price|
|Sell|Buy|Stop order to stop losses|PegOffsetValue will be added to the price of the Primary Order to derive the Stop Price|
|Sell|Buy|Limit order to take profit|PegOffsetValue will be subtracted from the price of the Primary Order to derive the Limit Price|

### Orders Contingent on a Working Order

PegOffsetValue must be a positive value on order placement.
The actual Price will depend on the price at which the order is filled.

|Working Order Side|Contingent Order Side|Primary (Working) Order Price|Order Type of Contingent Order|PegOffsetValue|Target Price|
|---|---|---|---|---|---|
|Buy|Sell|100|Stop order to stop losses|15|100 – 15 = 85|
|Buy|Sell|100|Limit order to take profit|25|100 + 25 = 125|
|Sell|Buy|100|Stop order to stop losses|15|100 + 15 = 115|
|Sell|Buy|100|Limit order to take profit|25|100 – 25 = 75|

### Execution Restatement
In some scenarios an Execution Restatement may be issued using an ExecutionReport.

An open position may have one attached order representing a StopLoss or TakeProfit order for the security at any one time.

IG will automatically update the size of a StopLoss or TakeProfit order if the aggregate size of the position changes. In this case IG will send an order restatement for the StopLoss or TakeProfit with the updated OrderQty. This is custom behaviour of IG automatically adjusting StopLoss and TakeProfit orders.

The ExecRestatmentReason has been extended to indicate the above scenarios

|ExecRestatmentReason|Value|Description|
|---|---|---|
|SystemStopLossSizeAdjustment | 100 |When there is a change in an account's aggregate position of an instrument then an existing stop loss order is restated with its OrdQty updated by the system. |
|SystemTakeProfitSizeAdjustment | 101 | When there is a change in an account's aggregate position of an instrument then an existing Take Profit order is restated with its OrdQty updated by the system.|
|SystemTrailingStopAdjustment | 102 | In the event of a trailing stop price being updated by the system when pegged to a market price.|
|SystemOTOContingentAdjustment | 103 | In the event of a contingent order being restated due to the associated OTO order executing. For example a resting order executes and its contingent stop order becomes working and is then restated. |


## Application Messages

### NewOrderSingle

The New Order Single message type is used by institutions wishing to electronically submit orders to IG Group for execution. This submits a single order for a single instrument.

#### Orders "attached" to a Position

New Order Single may be used to create a new order attached to a position.
Attaching Orders to a position is an IG specific usage and departs from the standard FIX specification. Orders that are attached to a position will be automatically cancelled if the position is closed.

SecurityID must be provided to identify the relevant position.

Only Order Type “Stop” and “Limit” are valid for "attached" orders.

For attached orders Price or StopPx fields are used to specify the Limit or Stop Price respectively.

TimeInForce must be “GoodTillCancel”.

See "OrderAttributeGrp" to specify that the Order must be attached.


#### OrderAttributeGrp

|Field/Component Name|Required?|Comments|
|---|---|---|
|OrderAttributeType|N|If present must be <ul><li>"AttachedOrder"</li></ul> indicating that the order must be attached to an existing position.|
|OrderAttributeValue|C|Required if OrderAttributeType "AttachedOrder" is present. Must be:<ul><li>"Y"</li><li>"N"</li></ul>|

### OrderCancelRequest

The Order Cancel Request message requests the cancellation of all of the remaining quantity of an existing order. 
Contingent Orders that are not yet active working orders cannot be cancelled. Active working orders are indicated in an ExecutionReport with 363=Y (WorkingIndicator=true).
They can be cancelled once they are working orders.

### OrderCancelReplaceRequest (Order Update)

The Order Cancel/Replace Request is used to change the parameters of an existing order.
Please note that the only Order parameters that can be changed are Price/StopPx and ExpireTime (for GTD orders). OrderQty cannot be changed.

Field values described as “rejected” will result in rejection of the received message. The response will be an Order Cancel Reject with an appropriate CxlRejReason.

Contingent Orders that are not yet working orders cannot be amended.
They can be amended once they are working orders.

If a working order is attached to a position the size of the order depends on the position size and cannot be amended with an OrderCancelReplaceRequest.

### OrderStatusRequest

Request the status of a currently active order.

An execution report will return the status of the order if it is found.  

If the order is not active or not found, an execution report response will be sent with OrdRejReason="UnknownOrder".

### OrderMassStatusRequest

Execution reports will be returned for orders matching criteria specified within the request.

We have implemented Order Mass Status Request to allow the identification of active orders. Only currently active orders will be returned (orders with an Order Status of “New”).

ExecutionReports with ExecType (150) ="Order Status" are returned for all orders matching the criteria provided on the request.

### ExecutionReport

In this implementation the execution report message is used to:
*	confirm the receipt of an order
*	confirm changes to an existing order (i.e. accept cancel and replace requests)
*	relay order status information
*	relay fill information on working orders
*	reject orders

For contingent orders, the IG implementation of an execution report message includes additional fields, ContingencyType, RefOrderID and RefOrderIDSource.  These fields will not be assigned (will not be present) unless an execution is being reported for an order contingent on another order.

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


### OrderMassStatusRequest

Execution reports will be returned for orders matching criteria specified within the request.

We have implemented Order Mass Status Request to allow the identification of active orders. Only currently active orders will be returned (orders with an Order Status of “New”).

ExecutionReports with ExecType (150) ="Order Status" are returned for all orders matching the criteria provided on the request.

