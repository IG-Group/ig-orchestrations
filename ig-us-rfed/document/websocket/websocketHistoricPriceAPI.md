# Chart Data Web Socket API FIX/JSON
## Introduction

This document specifies the Rules of Engagement the Historic Price API.

## Related Documents

See also [ WebSocket API ](websocketAPI.md)

## WebSocket URL

wss://otac.ig.com/v1
## Components
### CandleData

|Field/Component Name|Required?|Comments|
|---|---|---|
|StartDate|y|Start Date of the reported interval|
|EndDate|c|End Date of the reported interval, present on Historic Candles|
|First|y|First Price in the reported interval|
|Last|y|Last Price in the reported interval|
|High|y|Highest Price in the reported interval|
|Low|y|Lowest Price in the reported interval|

## Application Messages

### Chart Data Subscription Request

|Field/Component Name|Required?|Comments|
|---|---|---|
|Standard Header|Y|MsgType "ChartDataSubscriptionRequest"|
|ReqID|y|Unique ID for the request|
|SecurityID|y|Required by IG, Marketplace Assigned Identifier for the security as provided by IG|
|SecurityIDSource|y|Required by IG, distinguishes the source of the SecurityID. Must be "MarketplaceAssignedIdentifier".|
|Interval|y|The requested interval for the candle data. Valid intervals are: <ul><li>TICK</li></ul>|

### Chart Data Subscription Response

|Field/Component Name|Required?|Comments|
|---|---|---|
|Standard Header|Y|MsgType "ChartDataSubscriptionResponse"|
|ReqID|y|Unique ID corresponding to the request|
|SubscriptionRequestType|Y|Expect <ul><li>"SnapshotAndUpdates"</li><li>"DisablePreviousSnapshot"</li></ul>|
|Interval|y|The interval for the candle data. Valid intervals are: <ul><li>SECOND</li><li>FIVE_MIN</li><li>FIFTEEN_MIN</li><li>HOUR</li><li>DAY</li></ul>|
|CandleData|y|The Chart Data|

### Chart Data Request Reject

|Field/Component Name|Required?|Comments|
|---|---|---|
|Standard Header|Y|MsgType "ChartDataRequestReject"|
|ReqID|y|Unique ID corresponding to the request|
|SecurityID|y|Required by IG, Marketplace Assigned Identifier for the security as provided by IG|
|SecurityIDSource|y|Required by IG, distinguishes the source of the SecurityID. Must be "MarketplaceAssignedIdentifier".|
|ChartRequestRejectReason|y|The reject reason|

### ChartRequestRejectReason

|Value|
|---|
|UnknownSymbol|
|RequestExceedsLimit|
|TooLateToEnter|
|NotAuthorizedToRequestData|
|DuplicateRequest|
|UnsupportedSubscriptionRequestType|
|Other|

### Historic Price Candle Request

|Field/Component Name|Required?|Comments|
|---|---|---|
|Standard Header|Y|MsgType "HistoricCandleRequest"|
|ReqID|y|Unique ID for the request|
|SecurityID|y|Required by IG, Marketplace Assigned Identifier for the security as provided by IG|
|SecurityIDSource|y|Required by IG, distinguishes the source of the SecurityID. Must be "MarketplaceAssignedIdentifier".|
|Interval|y|The requested interval for the candle data. Valid intervals are: <ul><li>...</li><li>HOUR</li><li>...</li></ul>|
|StartDate|y|The start date of the interval.|
|EndDate|y|The end date of the interval|

Message Example:

This requests high, low, first and last bid and offer prices in 5 minute resolution.

```json
{
  "MsgType": "HistoricCandleRequest",
  "SendingTime": "20190802-21:14:38.717",
  "CstmApplVerID": "IGUS/PriceHistory/V1",
  "ReqID":"24572562",
  "SecurityID":"CS.D.GBPUSD.CZD.IP",
  "SecurityIDSource":"MarketplaceAssignedIdentifier",
  "Interval":"HOUR",
  "StartDate":"20190801-09:00:00",
  "EndDate":"20190802-21:14:00"
}
```

Response : See Historic Price Candle Response
## Historic Price Candle Response

|Field/Component Name|Required?|Comments|
|---|---|---|
|Standard Header|Y|MsgType "HistoricCandleResponse"|
|ReqID|y|Unique ID for the associated request|
|CandleData Repeating Group|y|The Candle Data|
|Last Message|c|Present and set to true if the message is the last one for the requested period|
|Allowance|Y||

### Allowance

|Field/Component Name|Required?|Comments|
|---|---|---|
|RemainingAllowance|y|Remaining Data Points Allowance|
|TotalAllowance|y|Remaining Data Points Allowance|
|AllowanceExpiry|y|Allowance Expiry|

Message Example:

```json
{
  "MsgType": "HistoricCandleResponse",
  "CstmApplVerID": "IGUS/PriceHistory/V1",
  "SendingTime": "20190802-21:14:38.717",
  "ReqID":"24572562",
  "SecurityID":"CS.D.GBPUSD.CZD.IP",
  "SecurityIDSource":"MarketplaceAssignedIdentifier",
  "CandleData":[
    {"StartDate":"20190801-09:00:00","EndDate":"20190801-10:00:00", "First":20.0, "Last":20.0, "High":21.0, "Low": 19.0},
    {"StartDate":"20190801-10:00:00","EndDate":"20190801-11:00:00", "First":20.0, "Last":20.0, "High":21.0, "Low": 19.0},
    ...
  ],
  "LastMessage" : true,
  "Allowance": {
          "RemainingAllowance": 9970,
          "TotalAllowance": 10000,
          "AllowanceExpiry": 604225
  }
}
```
