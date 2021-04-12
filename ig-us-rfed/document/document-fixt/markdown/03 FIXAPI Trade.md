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

The ExecRestatementReason has been extended to indicate the above scenarios

|ExecRestatementReason|Value|Description|
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


## Trade examples

### Market Order
```
NewOrderSingle:
8=FIXT.1.1 | 9=187 | 35=D | 34=82 | 49=IGClient | 52=20210325-21:58:48.393 | 56=IGUSTRADE | 1=LQ76J | 11=marketOrder1+1616709528383 | 15=USD | 22=M | 38=1 | 40=1 | 48=CS.D.GBPUSD.CZD.IP | 54=1 | 59=4 | 60=20210325-21:58:48.000 | 10=030 | 
Execution Report (New Order):
8=FIXT.1.1 | 9=278 | 35=8 | 34=135 | 49=IGUSTRADE | 52=20210325-21:58:48.690 | 56=IGClient | 1=LQ76J | 6=0 | 11=marketOrder1+1616709528383 | 14=0 | 15=USD | 17=EXAAAAF9ZWGCKA8 | 22=M | 31=0 | 32=0 | 37=ORAAAAF9ZWGCJA8 | 38=1 | 39=0 | 40=1 | 44=1.3485 | 48=CS.D.GBPUSD.CZD.IP | 54=1 | 59=4 | 60=20210325-21:58:48.633 | 150=0 | 151=1 | 636=Y | 10=236 | 
Execution Report (Fill):
8=FIXT.1.1 | 9=288 | 35=8 | 34=136 | 49=IGUSTRADE | 52=20210325-21:58:48.692 | 56=IGClient | 1=LQ76J | 6=1.3485 | 11=marketOrder1+1616709528383 | 14=1 | 15=USD | 17=EXAAAAF9ZWGCMA8 | 22=M | 31=1.3485 | 32=1 | 37=ORAAAAF9ZWGCJA8 | 38=1 | 39=2 | 40=1 | 44=1.3485 | 48=CS.D.GBPUSD.CZD.IP | 54=1 | 59=4 | 60=20210325-21:58:48.633 | 150=F | 151=0 | 636=N | 10=006 | 
```

### Limit Good to Cancel Order
```
Limit GTC Order:
8=FIXT.1.1 | 9=200 | 35=D | 34=62 | 49=IGClient | 52=20210325-21:58:35.878 | 56=IGUSTRADE | 1=LQ76J | 11=LimitGTCOrder1+1616709515878 | 15=USD | 22=M | 38=1 | 40=2 | 44=1.33859 | 48=CS.D.GBPUSD.CZD.IP | 54=1 | 59=1 | 60=20210325-21:58:35.000 | 10=123 | 
New Order Execution Report:
8=FIXT.1.1 | 9=281 | 35=8 | 34=115 | 49=IGUSTRADE | 52=20210325-21:58:36.128 | 56=IGClient | 1=LQ76J | 6=0 | 11=LimitGTCOrder1+1616709515878 | 14=0 | 15=USD | 17=EXAAAAF9ZWGA6A8 | 22=M | 31=0 | 32=0 | 37=ORAAAAF9ZWGA5A8 | 38=1 | 39=0 | 40=2 | 44=1.33859 | 48=CS.D.GBPUSD.CZD.IP | 54=1 | 59=1 | 60=20210325-21:58:36.094 | 150=0 | 151=1 | 636=Y | 10=065 | 
```

### Update Limit Good to Cancel Order price
```
OrderCancelReplaceRequest for previous order:
8=FIXT.1.1 | 9=226 | 35=G | 34=63 | 49=IGClient | 52=20210325-21:58:36.344 | 56=IGUSTRADE | 1=LQ76J | 11=LimitGTCOrder1Replace+1616709516340 | 15=USD | 22=M | 37=ORAAAAF9ZWGA5A8 | 38=1 | 40=2 | 44=1.30859 | 48=CS.D.GBPUSD.CZD.IP | 54=1 | 59=1 | 60=20210325-21:58:36.000 | 10=218 | 
Execution Report:
8=FIXT.1.1 | 9=320 | 35=8 | 34=116 | 49=IGUSTRADE | 52=20210325-21:58:36.685 | 56=IGClient | 1=LQ76J | 6=0 | 11=LimitGTCOrder1Replace+1616709516340 | 14=0 | 15=USD | 17=EXAAAAF9ZWGA8A8 | 22=M | 31=0 | 32=0 | 37=ORAAAAF9ZWGA5A8 | 38=1 | 39=0 | 40=2 | 41=LimitGTCOrder1+1616709515878 | 44=1.30859 | 48=CS.D.GBPUSD.CZD.IP | 54=1 | 59=1 | 60=20210325-21:58:36.602 | 150=5 | 151=1 | 636=Y | 10=120 | 
```
### Order Status
```
Order Status Request for previous order:
8=FIXT.1.1 | 9=130 | 35=H | 34=87 | 49=IGClient | 52=20210325-21:58:52.479 | 56=IGUSTRADE | 1=LQ76J | 37=ORAAAAF9ZWGA5A8 | 790=orderStatusReq+1616709532471 | 10=011 | 
Order Status Response:
8=FIXT.1.1 | 9=300 | 35=8 | 34=148 | 49=IGUSTRADE | 52=20210325-21:58:52.750 | 56=IGClient | 1=LQ76J | 6=0 | 11=LimitGTCOrder1Replace+1616709516340 | 14=0 | 15=USD | 17=0 | 22=M | 31=0 | 32=0 | 37=ORAAAAF9ZWGA5A8 | 38=1 | 39=0 | 40=2 | 44=1.30859 | 48=CS.D.GBPUSD.CZD.IP | 54=1 | 59=1 | 60=20210325-21:58:52.287 | 150=I | 151=1 | 636=Y | 790=orderStatusReq+1616709532471 | 10=005 | 
```

### Order cancellation
```
Cancel Request for previous order:
8=FIXT.1.1 | 9=197 | 35=F | 34=64 | 49=IGClient | 52=20210325-21:59:54.794 | 56=IGUSTRADE | 1=LQ76J | 11=ocrrOrderCancel+1616709516786 | 22=M | 37=ORAAAAF9ZWGA5A8 | 38=1 | 40=2 | 48=CS.D.GBPUSD.CZD.IP | 54=1 | 60=20210325-21:59:54.000 | 10=175 | 
Order Cancel Execution Report:
8=FIXT.1.1 | 9=321 | 35=8 | 34=117 | 49=IGUSTRADE | 52=20210325-21:59:55.088 | 56=IGClient | 1=LQ76J | 6=0 | 11=ocrrOrderCancel+1616709516786 | 14=0 | 15=USD | 17=EXAAAAF9ZWGBAA8 | 22=M | 31=0 | 32=0 | 37=ORAAAAF9ZWGA5A8 | 38=1 | 39=4 | 40=2 | 41=LimitGTCOrder1Replace+1616709516340 | 44=1.30859 | 48=CS.D.GBPUSD.CZD.IP | 54=1 | 59=1 | 60=20210325-21:59:55.009 | 150=4 | 151=1 | 636=N | 10=105 | 
```

### Previously Quoted Order
```
Quote received:
8=FIXT.1.1 | 9=189 | 35=S | 34=2 | 49=IGUS | 52=20210331-17:17:23.424 | 56=IGClient | 55=[N/A] | 117=qid-1 | 131=myQuoteReq1 | 132=1.3803 | 133=1.38081 | 390=1617211043255172906 | 451=0.00645 | 537=1 | 1867=1617211043255174907 | 10=029 | 

NewOrderSingle, Buy order (uses Quote's OfferPx and OfferID):
8=FIXT.1.1 | 9=216 | 35=D | 34=2 | 49=IGClient | 52=20210331-17:17:23.691 | 56=IGUSTRADE | 1=LQ76J | 11=pqOrder+1617211043641 | 15=USD | 22=M | 38=1 | 40=D | 44=1.38081 | 48=CS.D.GBPUSD.CZD.IP | 54=1 | 59=4 | 60=20210331-17:17:23.000 | 117=1617211043255174907 | 10=167 | 
Execution Report (new order):
8=FIXT.1.1 | 9=272 | 35=8 | 34=2 | 49=IGUSTRADE | 52=20210331-17:17:23.974 | 56=IGClient | 1=LQ76J | 6=0 | 11=pqOrder+1617211043641 | 14=0 | 15=USD | 17=EXAAAAGAFH6MSA8 | 22=M | 31=0 | 32=0 | 37=ORAAAAGAFH6MRA8 | 38=1 | 39=0 | 40=D | 44=1.38081 | 48=CS.D.GBPUSD.CZD.IP | 54=1 | 59=4 | 60=20210331-17:17:23.917 | 150=0 | 151=1 | 636=Y | 10=156 | 
Execution Report (fill):
8=FIXT.1.1 | 9=284 | 35=8 | 34=3 | 49=IGUSTRADE | 52=20210331-17:17:23.974 | 56=IGClient | 1=LQ76J | 6=1.38081 | 11=pqOrder+1617211043641 | 14=1 | 15=USD | 17=EXAAAAGAFH6MUA8 | 22=M | 31=1.38081 | 32=1 | 37=ORAAAAGAFH6MRA8 | 38=1 | 39=2 | 40=D | 44=1.38081 | 48=CS.D.GBPUSD.CZD.IP | 54=1 | 59=4 | 60=20210331-17:17:23.917 | 150=F | 151=0 | 636=N | 10=022 | 
```

### List Order
```
NewOrderList, GTC order with contingent stop and take profit (OTO orders):
8=FIXT.1.1 | 9=547 | 35=E | 34=24 | 49=IGClient | 52=20210325-21:57:34.668 | 56=IGUSTRADE | 66=ListGTCOrder3+1616709454605 | 68=3 | 394=3 | 1385=2 | 73=3 | 11=ListGTCOrder3+1616709454605 | 67=1 | 1=LQ76J | 48=CS.D.GBPUSD.CZD.IP | 22=M | 54=1 | 60=20210325-21:57:34.000 | 38=1 | 40=2 | 44=1.33851 | 15=USD | 59=1 | 11=ListGTCOrder3-Stop+1616709454641 | 67=2 | 1=LQ76J | 48=CS.D.GBPUSD.CZD.IP | 22=M | 54=2 | 60=20210325-21:57:34.000 | 38=1 | 40=3 | 15=USD | 59=1 | 211=0.05 | 1094=5 | 11=ListGTCOrder3-Limit+1616709454659 | 67=3 | 1=LQ76J | 48=CS.D.GBPUSD.CZD.IP | 22=M | 54=2 | 60=20210325-21:57:34.000 | 38=1 | 40=2 | 15=USD | 59=1 | 211=0.05 | 1094=5 | 10=144 | 
Execution Report (New Order):
8=FIXT.1.1 | 9=279 | 35=8 | 34=43 | 49=IGUSTRADE | 52=20210325-21:57:34.952 | 56=IGClient | 1=LQ76J | 6=0 | 11=ListGTCOrder3+1616709454605 | 14=0 | 15=USD | 17=EXAAAAF9ZWF5KA8 | 22=M | 31=0 | 32=0 | 37=ORAAAAF9ZWF5GA8 | 38=1 | 39=0 | 40=2 | 44=1.33851 | 48=CS.D.GBPUSD.CZD.IP | 54=1 | 59=1 | 60=20210325-21:57:34.911 | 150=0 | 151=1 | 636=Y | 10=175 | 
Execution Reports for contingents (not working/active yet)
8=FIXT.1.1 | 9=312 | 35=8 | 34=44 | 49=IGUSTRADE | 52=20210325-21:57:34.953 | 56=IGClient | 1=LQ76J | 6=0 | 11=ListGTCOrder3-Stop+1616709454641 | 14=0 | 15=USD | 17=EXAAAAF9ZWF5LA8 | 22=M | 31=0 | 32=0 | 37=ORAAAAF9ZWF5HA8 | 38=1 | 39=0 | 40=3 | 48=CS.D.GBPUSD.CZD.IP | 54=2 | 59=1 | 60=20210325-21:57:34.911 | 99=1.28851 | 150=0 | 151=1 | 636=N | 1080=ORAAAAF9ZWF5GA8 | 1081=1 | 10=207 | 
8=FIXT.1.1 | 9=313 | 35=8 | 34=45 | 49=IGUSTRADE | 52=20210325-21:57:34.955 | 56=IGClient | 1=LQ76J | 6=0 | 11=ListGTCOrder3-Limit+1616709454659 | 14=0 | 15=USD | 17=EXAAAAF9ZWF5MA8 | 22=M | 31=0 | 32=0 | 37=ORAAAAF9ZWF5JA8 | 38=1 | 39=0 | 40=2 | 44=1.38851 | 48=CS.D.GBPUSD.CZD.IP | 54=2 | 59=1 | 60=20210325-21:57:34.911 | 150=0 | 151=1 | 636=N | 1080=ORAAAAF9ZWF5GA8 | 1081=1 | 10=046 | 
```

### Add new Stop Loss / Take Profit
```
NewOrderSingle, Market order:
8=FIXT.1.1 | 9=187 | 35=D | 34=44 | 49=IGClient | 52=20210325-21:57:49.381 | 56=IGUSTRADE | 1=LQ76J | 11=marketOrder1+1616709469377 | 15=USD | 22=M | 38=1 | 40=1 | 48=CS.D.GBPUSD.CZD.IP | 54=1 | 59=4 | 60=20210325-21:57:49.000 | 10=032 | 
Execution Report (Fill):
8=FIXT.1.1 | 9=290 | 35=8 | 34=85 | 49=IGUSTRADE | 52=20210325-21:57:49.637 | 56=IGClient | 1=LQ76J | 6=1.34858 | 11=marketOrder1+1616709469377 | 14=1 | 15=USD | 17=EXAAAAF9ZWF8GA8 | 22=M | 31=1.34858 | 32=1 | 37=ORAAAAF9ZWF8DA8 | 38=1 | 39=2 | 40=1 | 44=1.34858 | 48=CS.D.GBPUSD.CZD.IP | 54=1 | 59=4 | 60=20210325-21:57:49.599 | 150=F | 151=0 | 636=N | 10=103 | 

NewOrderSingle, attach Stop Loss:
8=FIXT.1.1 | 9=231 | 35=D | 34=45 | 49=IGClient | 52=20210325-21:57:49.868 | 56=IGUSTRADE | 1=LQ76J | 11=TakeProfitClientOrder+1616709469831 | 15=USD | 22=M | 38=1 | 40=2 | 44=1.35858 | 48=CS.D.GBPUSD.CZD.IP | 54=2 | 59=1 | 60=20210325-21:57:49.000 | 2593=1 | 2594=1001 | 2595=Y | 10=082 | 
Execution Report (Stop Loss active):
8=FIXT.1.1 | 9=287 | 35=8 | 34=86 | 49=IGUSTRADE | 52=20210325-21:57:50.098 | 56=IGClient | 1=LQ76J | 6=0 | 11=TakeProfitClientOrder+1616709469831 | 14=0 | 15=USD | 17=EXAAAAF9ZWF8MA8 | 22=M | 31=0 | 32=0 | 37=ORAAAAF9ZWF8LA8 | 38=1 | 39=0 | 40=2 | 44=1.35858 | 48=CS.D.GBPUSD.CZD.IP | 54=2 | 59=1 | 60=20210325-21:57:50.057 | 150=0 | 151=1 | 636=Y | 10=124 | 
```

### Execution Report restatements following aggregate position update 
```
NewOrderList, Market order 1 with new attached Stop Loss
8=FIXT.1.1 | 9=385 | 35=E | 34=6 | 49=IGClient | 52=20210330-12:47:03.593 | 56=IGUSTRADE | 66=orderList1+1617108423533 | 68=2 | 394=3 | 1385=2 | 73=2 | 11=orderList1+1617108423533 | 67=1 | 1=LQ76J | 48=CS.D.GBPUSD.CZD.IP | 22=M | 54=1 | 60=20210330-12:47:03.000 | 38=1 | 40=1 | 15=USD | 59=3 | 11=orderList1-StopLoss+1617108423568 | 67=2 | 1=LQ76J | 48=CS.D.GBPUSD.CZD.IP | 22=M | 54=2 | 60=20210330-12:47:03.000 | 38=1 | 40=3 | 15=USD | 59=1 | 211=0.05 | 1094=5 | 10=151 | 
Execution Report, Primary order fill:
8=FIXT.1.1 | 9=288 | 35=8 | 34=13 | 49=IGUSTRADE | 52=20210330-12:47:03.925 | 56=IGClient | 1=LQ76J | 6=1.37431 | 11=orderList1+1617108423533 | 14=1 | 15=USD | 17=EXAAAAF98Y9VYA8 | 22=M | 31=1.37431 | 32=1 | 37=ORAAAAF98Y9VTA8 | 38=1 | 39=2 | 40=1 | 44=1.37431 | 48=CS.D.GBPUSD.CZD.IP | 54=1 | 59=3 | 60=20210330-12:47:03.870 | 150=F | 151=0 | 636=N | 10=070 | 
Execution Report, Attached Stop is Working:
8=FIXT.1.1 | 9=313 | 35=8 | 34=14 | 49=IGUSTRADE | 52=20210330-12:47:03.925 | 56=IGClient | 1=LQ76J | 6=0 | 11=orderList1-StopLoss+1617108423568 | 14=0 | 15=USD | 17=EXAAAAF98Y9VZA8 | 22=M | 31=0 | 32=0 | 37=ORAAAAF98Y9VUA8 | 38=1 | 39=0 | 40=3 | 48=CS.D.GBPUSD.CZD.IP | 54=2 | 59=1 | 60=20210330-12:47:03.870 | 99=1.32431 | 150=0 | 151=1 | 636=Y | 1080=ORAAAAF98Y9VTA8 | 1081=1 | 10=161 | 

NewOrderSingle, Market order 2:
8=FIXT.1.1 | 9=190 | 35=D | 34=7 | 49=IGClient | 52=20210330-12:47:04.286 | 56=IGUSTRADE | 1=LQ76J | 11=increasePosition+1617108424285 | 15=USD | 22=M | 38=1 | 40=1 | 48=CS.D.GBPUSD.CZD.IP | 54=1 | 59=4 | 60=20210330-12:47:04.000 | 10=174 | 
Execution Report, order 2 fill:
8=FIXT.1.1 | 9=294 | 35=8 | 34=16 | 49=IGUSTRADE | 52=20210330-12:47:04.518 | 56=IGClient | 1=LQ76J | 6=1.37431 | 11=increasePosition+1617108424285 | 14=1 | 15=USD | 17=EXAAAAF98Y9V8A8 | 22=M | 31=1.37431 | 32=1 | 37=ORAAAAF98Y9V5A8 | 38=1 | 39=2 | 40=1 | 44=1.37431 | 48=CS.D.GBPUSD.CZD.IP | 54=1 | 59=4 | 60=20210330-12:47:04.465 | 150=F | 151=0 | 636=N | 10=194 | 

Execution Report, Restatement of Attached Stop with updated OrderQty:
8=FIXT.1.1 | 9=330 | 35=8 | 34=17 | 49=IGUSTRADE | 52=20210330-12:47:04.518 | 56=IGClient | 1=LQ76J | 6=0 | 11=orderList1-StopLoss+1617108423568 | 14=0 | 15=USD | 17=EXAAAAF98Y9WBA8 | 22=M | 31=0 | 32=0 | 37=ORAAAAF98Y9VUA8 | 38=2 | 39=0 | 40=3 | 41=orderList1-StopLoss+1617108423568 | 48=CS.D.GBPUSD.CZD.IP | 54=2 | 59=1 | 60=20210330-12:47:04.467 | 99=1.32431 | 150=D | 151=2 | 378=100 | 636=Y | 10=147 | 
```

### Modifications to Stop Loss / Take Profit orders
```
OrderCancelReplaceRequest, update StopPx for previous attached Stop order (using OrigClOrdID in this case)
8=FIXT.1.1 | 9=243 | 35=G | 34=9 | 49=IGClient | 52=20210330-12:47:06.008 | 56=IGUSTRADE | 1=LQ76J | 11=stopLossOrderReplace1+1617108426008 | 15=USD | 22=M | 38=1 | 40=3 | 41=orderList1-StopLoss+1617108423568 | 48=CS.D.GBPUSD.CZD.IP | 54=2 | 59=1 | 60=20210330-12:47:06.000 | 99=1.33441 | 10=055 | 

Execution Report, order replaced:
8=FIXT.1.1 | 9=324 | 35=8 | 34=21 | 49=IGUSTRADE | 52=20210330-12:47:06.292 | 56=IGClient | 1=LQ76J | 6=0 | 11=stopLossOrderReplace1+1617108426008 | 14=0 | 15=USD | 17=EXAAAAF98Y9WUA8 | 22=M | 31=0 | 32=0 | 37=ORAAAAF98Y9VUA8 | 38=1 | 39=0 | 40=3 | 41=orderList1-StopLoss+1617108423568 | 48=CS.D.GBPUSD.CZD.IP | 54=2 | 59=1 | 60=20210330-12:47:06.250 | 99=1.33441 | 150=5 | 151=1 | 636=Y | 10=008 | 
```

### Opposing order closes out position and triggers the cancellation of attached Stop Loss
```
NewOrderSingle, oppossing sell order for previous Buy order:
8=FIXT.1.1 | 9=192 | 35=D | 34=10 | 49=IGClient | 52=20210330-12:47:06.008 | 56=IGUSTRADE | 1=LQ76J | 11=opposingSellOrder+1617108426008 | 15=USD | 22=M | 38=1 | 40=1 | 48=CS.D.GBPUSD.CZD.IP | 54=2 | 59=4 | 60=20210330-12:47:06.000 | 10=046 | 

Execution Report, NEW Sell order:
8=FIXT.1.1 | 9=281 | 35=8 | 34=22 | 49=IGUSTRADE | 52=20210330-12:47:06.575 | 56=IGClient | 1=LQ76J | 6=0 | 11=opposingSellOrder+1617108426008 | 14=0 | 15=USD | 17=EXAAAAF98Y9WXA8 | 22=M | 31=0 | 32=0 | 37=ORAAAAF98Y9WWA8 | 38=1 | 39=0 | 40=1 | 44=1.374 | 48=CS.D.GBPUSD.CZD.IP | 54=2 | 59=4 | 60=20210330-12:47:06.518 | 150=0 | 151=1 | 636=Y | 10=137 | 
Execution Report, Sell order filled:
8=FIXT.1.1 | 9=289 | 35=8 | 34=23 | 49=IGUSTRADE | 52=20210330-12:47:06.575 | 56=IGClient | 1=LQ76J | 6=1.374 | 11=opposingSellOrder+1617108426008 | 14=1 | 15=USD | 17=EXAAAAF98Y9WZA8 | 22=M | 31=1.374 | 32=1 | 37=ORAAAAF98Y9WWA8 | 38=1 | 39=2 | 40=1 | 44=1.374 | 48=CS.D.GBPUSD.CZD.IP | 54=2 | 59=4 | 60=20210330-12:47:06.518 | 150=F | 151=0 | 636=N | 10=060 | 

Execution Report, Attached Stop cancelled:
8=FIXT.1.1 | 9=287 | 35=8 | 34=24 | 49=IGUSTRADE | 52=20210330-12:47:06.575 | 56=IGClient | 1=LQ76J | 6=0 | 11=stopLossOrderReplace1+1617108426008 | 14=0 | 15=USD | 17=EXAAAAF98Y9W4A8 | 22=M | 31=0 | 32=0 | 37=ORAAAAF98Y9VUA8 | 38=1 | 39=4 | 40=3 | 48=CS.D.GBPUSD.CZD.IP | 54=2 | 59=1 | 60=20210330-12:47:06.520 | 99=1.33441 | 150=4 | 151=1 | 636=N | 10=031 | 
```

### Subscribe to Position Reports
```
RequestForPositions (Open positions snapshot plus updates):
8=FIXT.1.1 | 9=175 | 35=AN | 34=2 | 49=IGClient | 52=20210325-21:47:06.929 | 56=IGUSTRADE | 1=LQ76J | 60=20210325-21:47:06.000 | 263=1 | 710=PosReqID+1616708826644 | 715=2021-03-25T21:47:06.000+0000 | 724=0 | 10=174 | 

RequestForPositionsAck, (one open position)
8=FIXT.1.1 | 9=164 | 35=AO | 34=3 | 49=IGUSTRADE | 52=20210330-12:54:39.327 | 56=IGClient | 1=LQ76J | 710=PosReqID+1617108879027 | 721=cbd12cf9-72e8-4f16-84af-af609f5e7336 | 727=1 | 728=0 | 729=0 | 10=027 | 
8=FIXT.1.1 | 9=245 | 35=AP | 34=4 | 49=IGUSTRADE | 52=20210330-12:54:39.327 | 56=IGClient | 1=LQ76J | 15=USD | 22=M | 48=CS.D.GBPUSD.CZD.IP | 325=N | 710=PosReqID+1617108879027 | 715=20210330 | 721=OPAAAAF98Y97HA8 | 912=Y | 2618=OPAAAAF98Y97HA8 | 20104=1.37381 | 702=1 | 703=TOT | 704=1 | 706=1 | 10=081 | 

NewOrderSingle, Market Buy order:
8=FIXT.1.1 | 9=186 | 35=D | 34=4 | 49=IGClient | 52=20210330-12:54:39.494 | 56=IGUSTRADE | 1=LQ76J | 11=marketOrder1+1617108879461 | 15=USD | 22=M | 38=1 | 40=1 | 48=CS.D.GBPUSD.CZD.IP | 54=1 | 59=4 | 60=20210330-12:54:39.000 | 10=217 | 
ExecutionReport, order filled:
8=FIXT.1.1 | 9=289 | 35=8 | 34=6 | 49=IGUSTRADE | 52=20210330-12:54:39.777 | 56=IGClient | 1=LQ76J | 6=1.37373 | 11=marketOrder1+1617108879461 | 14=1 | 15=USD | 17=EXAAAAF98ZNV8A8 | 22=M | 31=1.37373 | 32=1 | 37=ORAAAAF98Y97VA8 | 38=1 | 39=2 | 40=1 | 44=1.37373 | 48=CS.D.GBPUSD.CZD.IP | 54=1 | 59=4 | 60=20210330-12:54:39.722 | 150=F | 151=0 | 636=N | 10=231 | 

PositionReport, (Total position in GBPUSD is 1, delta change is also 1):
8=FIXT.1.1 | 9=265 | 35=AP | 34=7 | 49=IGUSTRADE | 52=20210330-12:54:39.777 | 56=IGClient | 1=LQ76J | 15=USD | 22=M | 48=CS.D.GBPUSD.CZD.IP | 325=N | 710=PosReqID+1617108879027 | 715=20210330 | 721=PRAAAAF98ZNWAA8 | 731=2 | 2618=OPAAAAF98ZNV9A8 | 20104=1.37373 | 702=2 | 703=TOT | 704=1 | 706=1 | 703=DLT | 704=1 | 706=1 | 10=099 | 

Unsubscribe to position updates:
8=FIXT.1.1 | 9=175 | 35=AN | 34=5 | 49=IGClient | 52=20210330-12:54:40.227 | 56=IGUSTRADE | 1=LQ76J | 60=20210330-12:54:40.000 | 263=2 | 710=PosReqID+1617108879027 | 715=2021-03-30T12:54:40.000+0000 | 724=0 | 10=143 | 
```

### Order Mass Status
```
8=FIXT.1.1 | 9=119 | 35=AF | 34=8 | 49=IGClient | 52=20210330-12:52:30.610 | 56=IGUSTRADE | 1=LQ76J | 584=MassStatusReqID2+1617108750610 | 585=8 | 10=119 | 

ExecutionReport 1: 
8=FIXT.1.1 | 9=343 | 35=8 | 34=11 | 49=IGUSTRADE | 52=20210330-12:52:30.944 | 56=IGClient | 1=LQ76J | 6=0 | 11=restingClientOrder-Stop+1616709406678 | 14=0 | 15=USD | 17=0 | 22=M | 31=0 | 32=0 | 37=ORAAAAF9ZWF29A8 | 38=1 | 39=0 | 40=3 | 48=CS.D.GBPUSD.CZD.IP | 54=2 | 59=1 | 60=20210325-21:56:47.031 | 99=1.2786 | 150=I | 151=1 | 584=MassStatusReqID2+1617108750610 | 636=N | 912=N | 1080=ORAAAAF9ZWF28A8 | 1081=1 | 10=032 | 
ExecutionReport 2:
8=FIXT.1.1 | 9=344 | 35=8 | 34=12 | 49=IGUSTRADE | 52=20210330-12:52:30.944 | 56=IGClient | 1=LQ76J | 6=0 | 11=restingClientOrder-Limit+1616709406734 | 14=0 | 15=USD | 17=0 | 22=M | 31=0 | 32=0 | 37=ORAAAAF9ZWF3AA8 | 38=1 | 39=0 | 40=2 | 44=1.3786 | 48=CS.D.GBPUSD.CZD.IP | 54=2 | 59=1 | 60=20210325-21:56:47.031 | 150=I | 151=1 | 584=MassStatusReqID2+1617108750610 | 636=N | 912=N | 1080=ORAAAAF9ZWF28A8 | 1081=1 | 10=115 | 

ExecutionReport 3, WorkingIndicator=Y, last order in response (LastRptRequested=Y):
8=FIXT.1.1 | 9=307 | 35=8 | 34=14 | 49=IGUSTRADE | 52=20210330-12:52:30.977 | 56=IGClient | 1=LQ76J | 6=0 | 11=LimitGTCOrder1+1617108750134 | 14=0 | 15=USD | 17=0 | 22=M | 31=0 | 32=0 | 37=ORAAAAF98Y968A8 | 38=1 | 39=0 | 40=2 | 44=1.36391 | 48=CS.D.GBPUSD.CZD.IP | 54=1 | 59=1 | 60=20210330-12:52:30.406 | 150=I | 151=1 | 584=MassStatusReqID2+1617108750610 | 636=Y | 912=Y | 10=191 | 
```

### AccountSummaryReportRequest 
```
AccountSummaryReportRequest:
8=FIXT.1.1 | 9=130 | 35=UA | 34=2 | 49=IGClient | 52=20210330-12:52:23.227 | 56=IGUSTRADE | 263=1 | 20105=accountReq+1617108743110 | 453=1 | 448=LQ76J | 452=24 | 10=148 | 

AccountSummaryReport (Balance=1362739.72, Total margin=1362739.72, PnL=0) 
8=FIXT.1.1 | 9=304 | 35=CQ | 34=2 | 49=IGUSTRADE | 52=20210330-12:52:23.294 | 56=IGClient | 15=USD | 715=20210330 | 900=0 | 1699=1fe75404-6e19-4c15-8db8-d4902fed21fc | 20105=accountReq+1617108743110 | 20106=0 | 453=1 | 448=LQ76J | 452=24 | 1643=3 | 1645=13176.69 | 1644=22 | 1645=0.00 | 1644=100 | 1645=13176.69 | 1644=101 | 1703=1 | 1704=1362739.72 | 1706=Cash | 10=108 | 
```