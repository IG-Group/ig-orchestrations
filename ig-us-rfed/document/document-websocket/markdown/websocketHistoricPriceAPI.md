# Chart Data Web Socket API FIX/JSON

## Introduction

This document specifies the Rules of Engagement the Historic Price API.

## Related Documents

See also [ WebSocket API ](websocketAPI.md)

## WebSocket URL

### Demo

wss://demo-iguspretrade.ig.com/pretrade

### Production

wss://iguspretrade.ig.com/pretrade

## Components

### CandleData

| Field/Component Name | Required? | Comments                                                                                                             |
|----------------------|-----------|----------------------------------------------------------------------------------------------------------------------|
| StartDate            | y         | Start Date of the reported interval. In format yyyy-MM-dd'T'HH:mm:ss.SSSX in UTC timezone                            |
| EndDate              | c         | End Date of the reported interval, present on Historic Candles. In format yyyy-MM-dd'T'HH:mm:ss.SSSX in UTC timezone |
| First                | y         | First Price in the reported interval                                                                                 |
| Last                 | y         | Last Price in the reported interval                                                                                  |
| High                 | y         | Highest Price in the reported interval                                                                               |
| Low                  | y         | Lowest Price in the reported interval                                                                                |

## Application Messages

### Chart Data Subscription Request

| Field/Component Name | Required? | Comments                                                                                                                                                |
|----------------------|-----------|---------------------------------------------------------------------------------------------------------------------------------------------------------|
| Standard Header      | Y         | MsgType "ChartDataSubscriptionRequest"                                                                                                                  |
| ReqID                | y         | Unique ID for the request                                                                                                                               |
| SecurityID           | y         | Required by IG, Marketplace Assigned Identifier for the security as provided by IG                                                                      |
| SecurityIDSource     | y         | Required by IG, distinguishes the source of the SecurityID. Must be "MarketplaceAssignedIdentifier".                                                    |
| Interval             | y         | The requested interval for the candle data. Valid intervals are: <ul><li>SECOND</li><li>FIVE_MIN</li><li>FIFTEEN_MIN</li><li>HOUR</li><li>DAY</li></ul> |

Example Message

```json
{
  "MsgType": "ChartDataSubscriptionRequest",
  "ApplVerID": "FIX50SP2",
  "CstmApplVerID": "IGUS/PreTrade/V1",
  "SendingTime": "2021-08-09T17:26:57.042",
  "ReqID": "2",
  "SubscriptionRequestType": "SnapshotAndUpdates",
  "SecurityID": "CS.D.GBPUSD.CZD.IP",
  "SecurityIDSource": "MarketplaceAssignedIdentifier",
  "Interval": "FIVE_MIN"
}
```

### Chart Data Subscription Response

| Field/Component Name    | Required? | Comments                                                                                                                                      |
|-------------------------|-----------|-----------------------------------------------------------------------------------------------------------------------------------------------|
| Standard Header         | Y         | MsgType "ChartDataSubscriptionResponse"                                                                                                       |
| ReqID                   | y         | Unique ID corresponding to the request                                                                                                        |
| SubscriptionRequestType | Y         | Expect <ul><li>"SnapshotAndUpdates"</li><li>"DisablePreviousSnapshot"</li></ul>                                                               |
| Interval                | y         | The interval for the candle data. Valid intervals are: <ul><li>SECOND</li><li>FIVE_MIN</li><li>FIFTEEN_MIN</li><li>HOUR</li><li>DAY</li></ul> |
| CandleData              | y         | The Chart Data                                                                                                                                |

Example Message

```json
{
  "MsgType": "ChartDataSubscriptionResponse",
  "ApplVerID": "FIX50SP2",
  "SendingTime": "2021-08-09T17:28:09.032",
  "ReqID": "2",
  "Interval": "FIVE_MIN",
  "CandleData": {
    "StartDate": "2021-08-09T18:25:00.000+00:00",
    "First": {
      "Bid": 1.3847,
      "Offer": 1.3848
    },
    "Last": {
      "Bid": 1.38478,
      "Offer": 1.38488
    },
    "High": {
      "Bid": 1.38481,
      "Offer": 1.38491
    },
    "Low": {
      "Bid": 1.38466,
      "Offer": 1.38478
    }
  }
}
```

### Chart Data Request Reject

| Field/Component Name     | Required? | Comments                                                                                             |
|--------------------------|-----------|------------------------------------------------------------------------------------------------------|
| Standard Header          | Y         | MsgType "ChartDataRequestReject"                                                                     |
| ReqID                    | y         | Unique ID corresponding to the request                                                               |
| SecurityID               | y         | Required by IG, Marketplace Assigned Identifier for the security as provided by IG                   |
| SecurityIDSource         | y         | Required by IG, distinguishes the source of the SecurityID. Must be "MarketplaceAssignedIdentifier". |
| ChartRequestRejectReason | y         | The reject reason                                                                                    |

### ChartRequestRejectReason

| Value                              |
|------------------------------------|
| UnknownSymbol                      |
| RequestExceedsLimit                |
| TooLateToEnter                     |
| NotAuthorizedToRequestData         |
| DuplicateRequest                   |
| UnsupportedSubscriptionRequestType |
| Other                              |

### Historic Price Candle Request

| Field/Component Name | Required? | Comments                                                                                                                                                                                                                                  |
|----------------------|-----------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Standard Header      | Y         | MsgType "HistoricCandleRequest"                                                                                                                                                                                                           |
| ReqID                | y         | Unique ID for the request                                                                                                                                                                                                                 |
| SecurityID           | y         | Required by IG, Marketplace Assigned Identifier for the security as provided by IG                                                                                                                                                        |
| SecurityIDSource     | y         | Required by IG, distinguishes the source of the SecurityID. Must be "MarketplaceAssignedIdentifier".                                                                                                                                      |
| Interval             | y         | The requested interval for the candle data. Valid intervals are: <ul><li>SECOND</li><li>FIVE_MIN</li><li>FIFTEEN_MIN</li><li>HOUR</li><li>DAY</li></ul>                                                                                   |
| StartDate            | y         | The start date of the interval. Can be in any timezone but must adhere to format ([see here](https://github.com/IG-Group/ig-orchestrations/blob/master/ig-us-rfed/document/document-websocket/markdown/websocketAPI.md#datetime-formats)) |
| EndDate              | y         | The end date of the interval. Can be in any timezone but must adhere to format ([see here](https://github.com/IG-Group/ig-orchestrations/blob/master/ig-us-rfed/document/document-websocket/markdown/websocketAPI.md#datetime-formats))                                                                                                                                                 |

The maximum number of data points that can be requested is 10,000.

| Interval        | Maximum History Available | Maximum Time Period since Current Time       |
|-----------------|---------------------------|----------------------------------------------|
| 1sec            | 2 days                    | 166 minutes                                  |
| 1min            | 42 days                   | 166 hours                                    |
| 5min            | 365 days                  | 833 hours                                    |
| 15min           | 365 days                  | 2500 hours                                   |
| 1hour           | 365 days                  | 10000 hours                                  |
| 1day/week/month | unlimited                 | 240000 hours / 1680000 hours / 7300000 hours | 

Message Example:

This requests high, low, first and last bid and offer prices in 5 minute resolution.

```json
{
  "MsgType": "HistoricCandleRequest",
  "ApplVerID": "FIX50SP2",
  "SendingTime": "2021-08-09T17:09:16.602",
  "CstmApplVerID": "IGUS/PriceHistory/V1",
  "ReqID": "24572562",
  "SecurityID": "CS.D.GBPUSD.CZD.IP",
  "SecurityIDSource": "MarketplaceAssignedIdentifier",
  "Interval": "FIVE_MIN",
  "StartDate": "2021-08-09T09:00:00.000",
  "EndDate": "2021-08-09T12:00:00.000"
}
```

Response : See Historic Price Candle Response

## Historic Price Candle Response

| Field/Component Name       | Required? | Comments                                                                        |
|----------------------------|-----------|---------------------------------------------------------------------------------|
| Standard Header            | Y         | MsgType "HistoricCandleResponse"                                                |
| ReqID                      | y         | Unique ID for the associated request                                            |
| CandleData Repeating Group | y         | The Candle Data                                                                 |

Message Example:

```json
{
  "MsgType": "HistoricCandleResponse",
  "ApplVerID": "FIX50SP2",
  "CstmApplVerID": "IGUS/PriceHistory/V1",
  "SendingTime": "2021-08-09T17:09:17.602",
  "ReqID": "24572562",
  "SecurityID": "CS.D.GBPUSD.CZD.IP",
  "SecurityIDSource": "MarketplaceAssignedIdentifier",
  "CandleData": [
    {
      "StartDate": "2021-08-09T10:00:00.000+00:00",
      "EndDate": "2021-08-09T10:00:00.000+00:00",
      "First": {
        "Bid": 1.38569,
        "Offer": 1.38579
      },
      "Last": {
        "Bid": 1.38585,
        "Offer": 1.38595
      },
      "High": {
        "Bid": 1.38588,
        "Offer": 1.38598
      },
      "Low": {
        "Bid": 1.38552,
        "Offer": 1.38564
      }
    },
    {
      "StartDate": "2021-08-09T10:00:00.000+00:00",
      "EndDate": "2021-08-09T10:05:00.000+00:00",
      "First": {
        "Bid": 1.38582,
        "Offer": 1.38598
      },
      "Last": {
        "Bid": 1.38725,
        "Offer": 1.38741
      },
      "High": {
        "Bid": 1.38729,
        "Offer": 1.38742
      },
      "Low": {
        "Bid": 1.3858,
        "Offer": 1.38594
      }
    },
    ...
    {
      "StartDate": "2021-08-09T12:55:00.000+00:00",
      "EndDate": "2021-08-09T13:00:00.000+00:00",
      "First": {
        "Bid": 1.38744,
        "Offer": 1.3876
      },
      "Last": {
        "Bid": 1.38774,
        "Offer": 1.38784
      },
      "High": {
        "Bid": 1.38804,
        "Offer": 1.38815
      },
      "Low": {
        "Bid": 1.38734,
        "Offer": 1.38744
      }
    }
  ]
}
```
