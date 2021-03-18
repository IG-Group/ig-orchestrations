# Post Trade Web Socket API FIX/JSON
## Introduction

This document specifies the Rules of Engagement for the PostTrade websocket API.

## Related Documents

See also [ WebSocket API ](websocketAPI.md)

## Base WebSocket URL

wss://igustrade.ig.com/posttrade

## Fields and Constraints

###	OriginatingClientOrderRef
IG uses the custom tag OriginatingClientOrderRef to represent:

*	the ClOrdID from the client order which resulted in the position
*	a reference from another channel such as web trade

### OriginatingOrderIDRef
IG uses the custom tag OriginatingOrderIDRef to identify the IG Order ID of an order which has resulted in opening the Position. The
OriginatingOrderIDRef value corresponds to the value of OrderId
on the Execution Report for the client order which resulted in opening the position.

### ClosingOrderIDRef
IG uses the custom tag ClosingOrderIDRef to identify the IG Order ID of an order which has resulted in a close or part-close of a position. The ClosingOrderIDRef value corresponds to the value of OrderId on the Execution Report for the client order which resulted in the position change.

###	OpenPrice
IG uses the custom tag OpenPrice to report the price at which a Position is opened, the price will be reported in Currency.

## Components

### Collateral Amount Group (CollateralAmountGrp)

|Field/Component Name|Required?|Comments|
|---|---|---|
|CollateralType|Y|Will be "CASH"|
|CurrentCollateralAmount|Y||

### Margin Amount Group (MarginAmount)

|Field/Component Name|Required?|Comments|
|---|---|---|
|MarginAmt|Y||
|MarginAmtType|Y|Will be one of: <ul><li>"TotalMargin"</li><li>"ControlledRiskMargin"</li><li>"NonControlledRiskMargin"</li></ul>|


###	Position Quantity Group (PositionQty)

Set of tags indicating the quantity for this transaction.
Two types of PosType are used by the IG implementation.
<ul>
  <li>PosType = "TOT" entries are used to report the total size of a position in PositionMaintenanceReport and PositionReport messages.</li>
  <li>PosType = "DLT" entries may also be present in a PositionReport message when reporting a position size change (e.g. partial or full position close).</li>
</ul>

|Field/Component Name|Required?|Comments|
|---|---|---|
|Pos Type|Y|Will contain: <ul><li>"TOT" = Total Transaction Qty</li><li>"DLT" = Net Delta Qty</li></ul>|
|LongQty|N|Decimal quantities are supported (see Quantities).|
|ShortQty|N|Decimal quantities are supported (see Quantities).|
|PosQtyStatus|N|Will be "Accepted"|

### Position Amount Data Group (PositionAmountData)

This component block is populated with the value of the closed part of the position if applicable.

|Field/Component Name|Required?|Comments|
|---|---|---|
|PosAmtType|Y|Will be “SETL” if present. Settlement Value|
|PosAmt|Y|Profit or Loss value of the closed part of the position.|
|PositionCurrency|Y|If present, the currency of the PosAmt, will be the same as SettlCurrency|

## Application messages

### AccountSummaryReportRequest

The Account Summary Report Request message type is an custom extension of the FIX specification by IG Group.  It enables an institution to solicit Account Summary Report messages for a specified account.  The client may request a single snapshot report or subscribe for a stream of updates.

Client account (and optionally, broker account) information is specified in the Parties component.

A FIX client may hold only one current subscription for Account Summary Reports for a given account. Subsequent subscription requests for the same account will be rejected.

Account Summary Report Request messages must include client account details.  These should be provided in the Parties component.

|Field/Component Name|Required?|Comments|
|---|---|---|
|Standard Header|Y|MsgType = "AccountSummaryReportRequest"|
|AccountSummaryReportRequestID|Y|Unique identifier of the request as assigned by institution.|
|Parties Component Block|Y|An entry with Party Role "CustomerAccount" must be present. The PartyID for this entry will be the IG Account ID.|
|SubscriptionRequestType|Y|<ul><li>"Snapshot" indicates that the requestor only wants a snapshot or the current status.</l1><li>"SnapshotAndUpdates" indicates that the requestor wants a snapshot (the current status) plus updates as the account balance changes.</li><li>"DisablePreviousSnapshot" indicates that the requestor wishes to cancel any pending snapshots or updates - this unsubscribes from account balance messages.</li></ul>|

### AccountSummaryReport

The Account Summary Report message type is used by IG to provide account balance information to clients upon request.

|Field/Component Name|Required?|Comments|
|---|---|---|
|Standard Header|Y|MsgType = "AccountSummaryReport"|
|AccountSummaryReportID|Y|Unique identifier of the Account Summary Report.|
|AccountSummaryReportRequestID|N|Unique identifier of the request if applicable.|
|AccountSummaryReportRequestResult|Y|<ul><li>"Valid Request"</li><li>"InvalidOrUnsupportedRequest"</li><li>"UnknownAccount"</li><li>"Unauthorised"</li><li>"NotSupported"</li><li>"Other"</li></ul>If "Other", Text field will be present.|
|ClearingBusinessDate|Y|The Clearing Business Date covered by this request – must be current date.|
|Currency|Y|Identifies the base reporting currency used in this report. Will be Account Base Currency.|
|TotalNetValue|N|Used by IG to report Running Profit & Loss|
|TransactTime|N|The time of summary report generation|
|UnsolicitedIndicator|Y|Set to 'Y' if message is sent as a result of a subscription request not a snapshot request|
|MarginAmount|N||
|Parties|Y||
|CollateralAmountGrp|N||
|Text|N|May contain rejection reason|

### RequestForPositions

Request for Positions may be used to enquire about current open positions.

SubscriptionRequestType is not evaluated, logged on trading sessions are implicitly subscribed to Position Reports for open positions.

|Field/Component Name|Required?|Comments|
|---|---|---|
|Standard Header|Y|MsgType = "RequestForPositions"|
|PosReqID|Y|Unique identifier for the request as assigned by the submitter.|
|PosReqType|Y|Identifies the type of request. Must be "Position".|
|SubscriptionRequestType|N|Used to subscribe/unsubscribe. Defaults to False.<ul><li>Snapshot</li><li>SnapshotAndUpdates</li><li>DisablePreviousSnapshot</li></ul>|
|Account|Y|Account ID.|
|ClearingBusinessDate|Y|The Clearing Business Date covered by this request – must be current date. Should follow the format YYYMMDD|
|TransactTime|Y|Time this request was initiated/released by the trader or trading system. Millisecond resolution is optional. Outgoing messages from IG will include Milliseconds.|

Response: (see FIX Position Report, Request for Positions Ack)

### RequestForPositionsAck

The Request for Positions Ack message is returned by the holder of the position in response to a Request for Positions message. The purpose of the message is to acknowledge that a request has been received and is being processed.

|Field/Component Name|Required?|Comments|
|---|---|---|
|Standard Header|Y|MsgType = "RequestForPositionsAck"|
|PosMaintRptID|Y|Unique identifier for this Position Maintenance Report.|
|PosReqID|N|Unique identifier for the Request for Positions (AN) associated with this report. This field will not be provided if the report is unsolicited.|
|PosReqResult|Y||
|PosReqStatus|Y||
|ClearingBusinessDate|N|The Clearing Business Date covered by this request – must be current date. Should follow the format YYYMMDD|
|Account|Y|IG Account ID. Will always be provided by IG|
|TotalNumPosReports|Y| Total number of Position Reports being returned |
|LastRptRequested|Y| Indicates whether this message is the last report message in response to a request message|                       

### PositionReport
Position Report defines the state of a Position.
Unsolicited Position Reports will be sent when Positions are opened, amended, closed or deleted.

In the event of a Position partial or full close, a PositionQty component block will be present with PosType = "TOT" (Total) and LongQty or ShortQty set to the remaining size of the position. The remaining size will be zero in the event of a full close.  

In the event of a Position partial or full close, an additional PositionQty component block will be present with PosType = "DLT" (Delta) and LongQty or ShortQty set to the size delta for this update.

When present, the "TOT" PositionQty component block will contain a Position ID.  The client reference for the order that originated the position may also be included.

It is an IG customisation to add SettlCurrFxRate to Position Report.

SettlCurrFxRate publishes the FX Rate used if the currency in which the position is held is converted to the Account Base Currency when the Position is closed.

Note that field #OpenPrice is a custom field used by IG.

|Field/Component Name|Required?|Comments|
|---|---|---|
|Standard Header|Y|MsgType = "PositionReport"|
|PosMaintRptID|Y|Unique identifier for this Position Report.|
|PositionID|N|Unique identifier for this position entity.|
|PosReqID|N|Unique identifier for the Request for Positions (AN) associated with this report. This field will not be provided if the report is unsolicited.|
|PosReqType|N|Will be present with values: <ul><li>"Position" – for new or changed positions</li> <li>"BackoutMessage" – for deleted positions</li></ul>|
|TotalNumPosReports|N|Total number of Position Reports being returned.|
|PosReqResult|N|Will be present in a response to a Request for Positions Request.|
|UnsolicitedIndicator|N|Indicates whether or not message is being sent as a result of a subscription request or not.<ul><li>'N'	=	Message is being sent as a result of a prior request</li><li>'Y'	=	Message is being sent unsolicited</li></ul>|
|ClearingBusinessDate|Y|The Clearing Business Date covered by this request. Should follow the format YYYMMDD|
|Account|Y|Account ID|
|SettlCurrency|N|Will be present on position closes|
|MessageEventSource|N|Will be present to identify the event source for Position Changes. See MessageEventSource table below.|
|SettlCurrFxRate|N|SettlCurrFxRate is the rate used to exchange Currency for SettlCurrency. Will be present on position closes.|
|Instrument|N||
|Currency|N|Currency in which the position is held|
|OpenPrice|N|The price at which the Position was opened,  will be reported in Currency|
|SettlPrice|N|Will be present on position closes, will be reported in Currency|
|SettlPriceType|N|Value will be "Final"|
|PositionQty|N||
|PositionAmountData|N||
|Text|N|May  be present, Free format text|
|OriginatingClientOrderRef|N|May be included in a Position Report to indicate the client reference of the originating order. The OriginatingClientOrderRef value may be: <ul><li>the ClOrdID from the client order which resulted in the position</li><li>a reference from another channel such as web trading</li></ul>Only present for PosType = "TOT"|
|OriginatingOrderIDRef|N|May be included in Position Report to identify the IG Order ID of the order which has resulted in opening this position. The OriginatingOrderIDRef value corresponds to the value of OrderId on the Execution Report for the client order which resulted in opening the position.|
|ClosingOrderIDRef|N|May be included in Position Report to identify the IG Order ID of the order which has resulted in a close or part-close of this position. The ClosingOrderIDRef value corresponds to:<ul><li>The value of SecondaryOrderID on the Execution Report for the client order which resulted in the position change where SecondaryOrderID is present.</li><li>the value of OrderId on the Execution Report for the client order which resulted in the position change.</li></ul>|
|LastRptRequested|N| Indicates whether this message is the last report message in response to a request message|                       

#### MessageEventSource

|Message Event Source Value|Comment|
|---|---|
|“FIX”|The change is the result of an instruction submitted via a FIX API.|
|"REST"|The change is the result of an instruction submitted via a REST API.|
|"L2"|The change is the result of an instruction submitted via the L2 dealing application.|
|"Metatrader"|The change is the result of an instruction submitted via a Metatrader dealing application.|
|"Mobile"|The change is the result of an instruction submitted via a Mobile dealing application.|
|"Web"|The change is the result of an instruction submitted via a Web dealing application.|
|"Dealer"|The change is result of dealer intervention.|
|"StopOrLimitFill"|The change is the result of a Stop or Limit fill.|
|"Liquidation"|The change is the result of a liquidation process.|
|"Expiry"|The position has expired.|
|"Roll"|The change is the result of rolling the position.|
|"Other"|The change is the result of process that is not in the above categories.|
