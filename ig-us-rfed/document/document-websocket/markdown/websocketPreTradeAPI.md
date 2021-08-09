# PreTrade Web Socket API FIX/JSON
## Introduction

This document specifies the Rules of Engagement for PreTrade message dialogues.
This includes Security Reference Data and Quote Negotiation.

## Related Documents

See also [ WebSocket API ](websocketAPI.md)

## WebSocket URL

### Demo
wss://demo-iguspretrade.ig.com/pretrade

### Production
wss://iguspretrade.ig.com/pretrade

## Fields and Constraints

###	SubscriptionRequestType

SubscriptionRequestType can have the following values.

|Subscription Request Type|Interpretation|
|---|---|
|"Snapshot"|A snaphot of values is requested.|
|"SnapshotAndUpdates"|A snaphot of values is requested followed by updates (subscribe).|
|"DisablePreviousSnapshot"|Disable previous Snapshot + Update Request (unsubscribe).|

## Components

### Security Trading Rules

|Field/Component Name|Required?|Comments|
|---|---|---|
|BaseTradingRules|N|Component|

### Base Trading Rules

|Field/Component Name|Required?|Comments|
|---|---|---|
|RoundLot|N|This is used by IG to denote the value of one point of a quoted price in the denominated currency. This is a member of Component BaseTradingRules with SecurityTradingRules but these are omitted for in the interests of simplicity.|

## Application Messages
### Security List Request

Request for a List of Securities.

|Field/Component Name|Required?|Comments|
|---|---|---|
|Standard Header|Y|MsgType = ‘SecurityListRequest’|
|SecurityReqID|Y|Must be unique ID|
|SecurityListRequestType|Y|Security List Request Type. Accepted Values are:<ul><li>‘AllSecurities’</li></ul>|
|SubscriptionRequestType|N|Subscription Request Type. Accepted Values are: <ul><li>‘Snapshot’</li></ul>|
|Instrument|N||


Example Security Request
```
{
    "MsgType":"SecurityListRequest"
    "SendingTime":"2021-03-25T15:53:40.996",
    "SecurityReqID":"listReq+1616687620989",
    "SubscriptionRequestType":"Snapshot",
    "ApplVerID":"FIX50SP2",
    "SecAltIDGrp":[],
    "SecurityListRequestType":"AllSecurities",
}
```

Response: (see Security List)

### SecurityList

Security List Response returns a List of Securities that match the criteria in the corresponding Security List Request.  
A response with many instruments may be sent in multiple SecurityList fragments sharing a common SecurityReqID value.

|Field/Component Name|Required?|Comments|
|---|---|---|
|Standard Header|Y|MsgType (35) = ‘SecurityList’|
|SecurityReqID|Y|ID of the associated request.|
|SecurityResponseID|Y|Unique ID of the response.|
|SecurityListRequestResult|Y|Result status for the corresponding security request.|
|TotNoRelatedSym|N|Total Number of securities returned for this request, may be greater than the number returned in this individual message.  Will be present.|
|LastFragment|N|Indicates whether this is the last fragment in a sequence of message fragments. |
|SecListGrp|N|Security List Group|

Example Security List response message:
```
{
  "MsgType": "SecurityList",
  "ApplVerID": "FIX50SP2",
  "SendingTime": "2021-03-25T15:53:41.000",
  "SecurityReqID": "secListReq+12345",
  "SecurityResponseID": "listReq+12345~1",
  "SecurityRequestResult": "ValidRequest",
  "TotNoRelatedSym": 3,
  "LastFragment": "LastMessage",
  "SecListGrp": [
    {
      "Symbol": "USD/CAD",
      "SecurityID": "CS.D.USDCAD.CZD.IP",
      "SecurityIDSource": "MarketplaceAssignedIdentifier",
      "SecAltIDGrp": [],
      "SecurityGroup": "CURRENCIES",
      "ContractMultiplier": 1E+5,
      "SecurityDesc": "USD100,000 Contract",
      "ShortSaleRestriction": "NoRestrictions",
      "AttrbGrp": [
        {
          "InstrAttribType": "DealableCurrencies",
          "InstrAttribValue": "CAD"
        }
      ],
      "UndInstrmtGrp": [],
      "Currency": "CAD"
    },
    {
      "Symbol": "GBP/USD",
      "SecurityID": "CS.D.GBPUSD.CZD.IP",
      "SecurityIDSource": "MarketplaceAssignedIdentifier",
      "SecAltIDGrp": [],
      "SecurityGroup": "CURRENCIES",
      "ContractMultiplier": 1E+5,
      "SecurityDesc": "GBP100,000 Contract",
      "ShortSaleRestriction": "NoRestrictions",
      "AttrbGrp": [
        {
          "InstrAttribType": "DealableCurrencies",
          "InstrAttribValue": "USD"
        }
      ],
      "UndInstrmtGrp": [],
      "Currency": "USD"
    },
    {
      "Symbol": "USD/JPY",
      "SecurityID": "CS.D.USDJPY.CZD.IP",
      "SecurityIDSource": "MarketplaceAssignedIdentifier",
      "SecAltIDGrp": [],
      "SecurityGroup": "CURRENCIES",
      "ContractMultiplier": 1E+5,
      "SecurityDesc": "USD100,000 Contract",
      "ShortSaleRestriction": "NoRestrictions",
      "AttrbGrp": [
        {
          "InstrAttribType": "DealableCurrencies",
          "InstrAttribValue": "JPY"
        }
      ],
      "UndInstrmtGrp": [],
      "Currency": "JPY"
    }
  ]
}
```
* The typical Security response will contain around 100 securities not just 3.

#### Security List Group (SecListGrp)

|Field/Component Name|Required?|Comments|
|---|---|---|
|Instrument|N||
|InstrumentExtension|N||
|SecurityTradingRules|N|Component|
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
  "SendingTime": "2021-03-25T15:44:52.644",
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

Example of unsubscription from receiving Quotes using the Quote Request message:
```json
{
  "MsgType": "QuoteRequest",
  "ApplVerID":"FIX50SP2",
  "CstmApplVerID": "IGUS/PreTrade/V1",
  "SendingTime": "2021-03-25T17:44:52.644",
  "QuoteReqID":"12345",
  "SubscriptionRequestType":"DisablePreviousSnapshot",
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

The Quote message is used as the response to a Quote Request.

|Field/Component Name|Required?|Comments|
|---|---|---|
|Standard Header|Y|MsgType = ‘Quote’|
|QuoteReqID|Y|ID of the associated quote request|
|QuoteType|Y|Expect <ul><li>"Indicative"</li><li>"Tradeable"</li></ul>|
|BidPx|Y|Bid Price|
|OfferPx|Y|Offer Price|
|BidID|Y|Unique identifier for the bid side of the quote.|
|OfferID|Y|Unique identifier for the offer side of the quote.|
|NetChgPrevDay|n|Bid Price|

Quote : The Quote message is used as the response to a Quote Request.

```json
{
  "MsgType": "Quote",
  "ApplVerID":"FIX50SP2",
  "CstmApplVerID": "IGUS/PreTrade/V1",
  "SendingTime": "2021-03-25T15:44:52.937",
  "QuoteReqID":"12345",
  "QuoteType":"Tradeable",
  "BidPx":"1.37236",
  "OfferPx":"1.37246",
  "BidID":"78910",
  "OfferID":"78911",
  "NetChgPrevDay":"0.00379"
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
  "SendingTime": "2021-03-25T16:44:52.937",
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
