# PreTrade Web Socket API FIX/JSON
## Introduction

This document specifies the Rules of Engagement for PreTrade message dialogues.
This includes Security Reference Data and Quote Negotiation.

## Related Documents

See also [ WebSocket API ](websocketAPI.md)

## WebSocket URL

wss://otapr.ig.com/pretrade

## Fields and Constraints

###	SubscriptionRequestType

SubscriptionRequestType can have the following values.

|Subscription Request Type|Interpretation|
|---|---|
|"Snapshot"|A snaphot of values is requested.|
|"SnapshotAndUpdates"|A snaphot of values is requested followed by updates (subscribe).|
|"DisablePreviousSnapshot"|Disable previous Snapshot + Update Request (unsubscribe).|

## Application Messages
### Security List Request

Request for a List of Securities.

|Field/Component Name|Required?|Comments|
|---|---|---|
|Standard Header|Y|MsgType = ‘SecurityListRequest’|
|SecurityReqID|Y|Must be unique ID|
|SecurityListRequestType|Y|Security List Request Type. Accepted Values are:<ul><li>‘Symbol’ </li>(or SecurityID, SecurityAltID)</li><li>‘AllSecurities’</li></ul>|
|SubscriptionRequestType|N|Subscription Request Type. Accepted Values are: <ul><li>‘Snapshot’</li></ul>|
|Instrument|N||

Response: (see Security List)

### SecurityList

Security List Response returns a List of Securities that match the criteria in the corresponding Security List Request.  
A response with many instruments may be sent in multiple SecurityList fragments sharing a common SecurityReqID value.

|Field/Component Name|Required?|Comments|
|---|---|---|
|Standard Header|Y|MsgType (35) = ‘SecurityList’|
|SecurityReqID|y|ID of the associated request.|
|SecurityResponseID|y|Unique ID of the response.|
|SecurityListRequestResult|y|Result status for the corresponding security request.|
|TotNoRelatedSym|N|Total Number of securities returned for this request, may be greater than the number returned in this individual message.  Will be present.|
|LastFragment|N|Indicates whether this is the last fragment in a sequence of message fragments. |
|SecListGrp|N|Security List Group|

#### Security List Group (SecListGrp)

|Field/Component Name|Required?|Comments|
|---|---|---|
|Instrument|N||
|InstrumentExtension|N||
|RoundLot|N|This is used by IG to denote the value of one point of a quoted price in the denominated currency. This is a member of Component BaseTradingRules with SecurityTradingRules but these are omitted for in the interests of simplicity.|
|UndInstrmtGrp|N|Underlying Instrument Repeating Group|
|Currency|N||
|Text|N||

### QuoteRequest

The quote request message to request quotes.

|Field/Component Name|Required?|Comments|
|---|---|---|
|Standard Header|Y|MsgType = ‘QuoteRequest’|
|QuoteReqID|Y||
|Quote Request Group|Y||
|SubscriptionRequestType|Y|Expect <ul><li>"SnapshotAndUpdates"</li><li>"DisablePreviousSnapshot"</li></ul>|

#### Quote Request Group (QuotReqGrp)
Quote Request Group simply contains the "Instrument" Component

|Field/Component Name|Required?|Comments|
|---|---|---|
|Instrument|Y||

Example for a Quote Request message:

```json
{
  "MsgType": "QuoteRequest",
  "ApplVerID":"FIX50SP2",
  "CstmApplVerID": "IGUS/PreTrade/V1",
  "SendingTime": "20190802-21:14:38.717",
  "QuoteReqID":"12345",
  "SubscriptionRequestType":"SnapshotAndUpdates",
  "QuotReqGrp" : [
    {
        "Symbol":"GBPUSD",
    	"SecurityID":"CS.D.GBPUSD.CZD.IP",
    	"SecurityIDSource":"MarketplaceAssignedIdentifier"
    }
  ]
}
```

Response: See Quote

### Quote

|Field/Component Name|Required?|Comments|
|---|---|---|
|Standard Header|Y|MsgType = ‘Quote’|
|QuoteReqID|Y|ID of the associated quote request|
|QuoteType|y|Expect <ul><li>"Indicative"</li><li>"Tradeable"</li></ul>|
|BidPx|y|Bid Price|
|OfferPx|y|Bid Price|
|BidID|y|Unique identifier for the bid side of the quote.|
|OfferID|y|Unique identifier for the offer side of the quote.|
|NetChgPrevDay|n|Bid Price|

Quote : The Quote message is used as the response to a Quote Request.

```json
{
  "MsgType": "Quote",
  "ApplVerID":"FIX50SP2",
  "CstmApplVerID": "IGUS/PreTrade/V1",
  "SendingTime": "20190802-21:14:38.718",
  "QuoteReqID":"12345",
  "QuoteType":"Tradeable",
  "BidPx":"34.444",
  "OfferPx":"34.446",
  "BidID":"78910",
  "OfferID":"78911",
  "NetChgPrevDay":"-93.3"
}
```
### QuoteCancel

QuoteCancel : The Quote Cancel message is used by an originator of quotes to cancel quotes.

|Field/Component Name|Required?|Comments|
|---|---|---|
|Standard Header|Y|MsgType = ‘QuoteCancel’|
|QuoteReqID|C|Required when quote is in response to a Quote Request message|
|QuoteCancelType|Y|Identifies the type of Quote Cancel request.|
|QuotCxlEntriesGrp|C|Quote Cancel Entries Repeating Group. Required when not cancelling all quotes.|

#### Quote Cancel Entries Group (QuotCxlEntriesGrp)
For QuoteCancel Requests this group contains the Instrument Component.

|Field/Component Name|Required?|Comments|
|---|---|---|
|Instrument|Y||

Message Example :

```json
{
  "MsgType": "QuoteCancel",
  "ApplVerID":"FIX50SP2",
  "CstmApplVerID": "IGUS/PreTrade/V1",
  "SendingTime": "20190802-21:14:38.717",
  "QuoteReqID":"12345",
  "QuoteCancelType":"CancelForOneOrMoreSecurities",
  "NoRelatedSym":[
     {"SecurityID":"CS.D.GBPUSD.CZD.IP",
      "SecurityIDSource":"MarketplaceAssignedIdentifier"}
  ]
}

```
### QuoteRequestReject

The Quote Request Reject message is used to reject Quote Request messages

|Field/Component Name|Required?|Comments|
|---|---|---|
|Standard Header|Y|MsgType = ‘QuoteRequestReject’|
|QuoteReqID|Y||
|QuoteRequestRejectReason|Y|Reason Quote was rejected|
|QuoteReqRjctGrp|Y|QuoteRequestReject Group|

#### Quote Request Reject Group (QuoteReqRjctGrp)
For QuoteRequestReject messages this Group contains the Instrument Component.

|Field/Component Name|Required?|Comments|
|---|---|---|
|Instrument|Y||

```json
{
  "MsgType": "QuoteRequestReject",
  "ApplVerID":"FIX50SP2",
  "CstmApplVerID": "IGUS/PreTrade/V1",
  "SendingTime": "20190802-21:14:38.717",
  "QuoteReqID":"12345",
  "QuoteRequestRejectReason":"UnknownSymbol",
  "QuotReqRjctGrp":[
    {"SecurityID":"CS.D.GBPUSD.CZD.IP",
     "SecurityIDSource":"MarketplaceAssignedIdentifier"}
  ]
}
```
