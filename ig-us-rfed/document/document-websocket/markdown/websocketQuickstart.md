# Quickstart

## Connect to the WebSockets API
Firstly, establish a connection to the desired APIs, using the relevant listed endpoints for each:
- [PreTrade API](websocketPreTradeAPI.md)
- [Trade API](websocketTradeAPI.md)

## Logon to the WebSockets API (all APIs)
Once a connection has been opened to the WebSockets API, the client needs to negotiate a new session and establish a binding between the connection and the session.

Refer to the Sessions page for further documentation on the Negotiate and Establish messages, as well as authentication and session management flows.

Firstly, send a Negotiate message to the API:
```json
{
    "MessageType": "Negotiate",
    "Timestamp": 1573727261820000000,
    "SessionId": "621224d9-995a-4a05-bd4e-d40589db71d0",
    "ClientFlow": "Unsequenced",
    "Credentials": {
        "CredentialsType": "login",
        "Token": "yourusername:yourpassword"
    }
}
```

The server will respond with NegotiationResponse:
```json
{
    "SessionId": "621224d9-995a-4a05-bd4e-d40589db71d0",
    "RequestTimestamp": 1573727261820000000,
    "ServerFlow": "Unsequenced",
    "MessageType": "NegotiationResponse"
}
```

Next, send an Establish message to bind the session to the WS connection:
```json
{
    "MessageType": "Establish",
    "Timestamp": 1573727261820000010,
    "SessionId": "621224d9-995a-4a05-bd4e-d40589db71d0",
    "KeepaliveInterval": 3000000
}
```

The server will respond with EstablishmentAck:
```json
{
    "SessionId": "621224d9-995a-4a05-bd4e-d40589db71d0",
    "RequestTimestamp": 1573727261820000010,
    "KeepaliveInterval": 30001,
    "MessageType": "EstablishmentAck"
}
```

The session establishment flow has now been completed and the API is ready to accept business requests.

## Requesting security list (PreTrade API)
A list of available securities can be requested by sending a SecurityListRequest message:
```json
{
    "MsgType": "SecurityListRequest",
    "SendingTime": "2021-03-25T15:53:40.996",
    "SecurityReqID": "listReq+1616687620989",
    "SubscriptionRequestType": "Snapshot",
    "ApplVerID": "FIX50SP2",
    "SecAltIDGrp":[],
    "SecurityListRequestType": "AllSecurities"
}
```

The response is a SecurityList message, with matching securities in SecListGrp:
```json
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

Refer to the PreTrade page for further documentation about SecurityListRequest and SecurityList.

## Subscribing to quotes (PreTrade API)
QuoteRequest can be used to subscribe to a price stream for an instrument identified by its SecurityID (e.g. CS.D.GBPUSD.CZD.IP), 
which can be found in the SecurityList message.

```json
{
  "MsgType": "QuoteRequest",
  "ApplVerID": "FIX50SP2",
  "CstmApplVerID": "IGUS/PreTrade/V1",
  "SendingTime": "2021-03-25T15:44:52.644",
  "QuoteReqID": "12345",
  "SubscriptionRequestType": "SnapshotAndUpdates",
  "QuotReqGrp" : [
    {
      "Symbol": "GBPUSD",
    	"SecurityID": "CS.D.GBPUSD.CZD.IP",
    	"SecurityIDSource": "MarketplaceAssignedIdentifier"
    }
  ]
}
```

The Quote message is the response to QuoteRequest and also used to deliver quote updates:
```json
{
  "MsgType": "Quote",
  "ApplVerID": "FIX50SP2",
  "CstmApplVerID": "IGUS/PreTrade/V1",
  "SendingTime": "2021-03-25T15:44:52.937",
  "QuoteReqID": "12345",
  "QuoteType": "Tradeable",
  "BidPx": "1.37236",
  "OfferPx": "1.37246",
  "BidID": "78910",
  "OfferID": "78911",
  "NetChgPrevDay": "0.00379"
}
```

To unsubscribe from an instrument quote, send a QuoteRequest with DisablePreviousSnapshot:
```json
{
  "MsgType": "QuoteRequest",
  "ApplVerID": "FIX50SP2",
  "CstmApplVerID": "IGUS/PreTrade/V1",
  "SendingTime": "2021-03-25T17:44:52.644",
  "QuoteReqID": "12345",
  "SubscriptionRequestType": "DisablePreviousSnapshot",
  "QuotReqGrp" : [
    {
      "Symbol": "GBPUSD",
    	"SecurityID": "CS.D.GBPUSD.CZD.IP",
    	"SecurityIDSource": "MarketplaceAssignedIdentifier"
    }
  ]
}
```

## Placing an order (Trade API)
To place a single order for a single instrument, send a NewOrderSingle message:
```json
{
  "MsgType": "NewOrderSingle",
  "ApplVerID": "FIX50SP2",
  "CstmApplVerID": "IGUS/Trade/V1",
  "SendingTime": "2019-08-02T21:14:38.717",
  "ClOrdID": "12345",
  "Account": "XXXXX",
  "SecurityID": "CS.D.GBPUSD.CZD.IP",
  "SecurityIDSource": "MarketplaceAssignedIdentifier",
  "Side": "Buy",
  "TransactTime": "2019-08-02T21:14:38.717",
  "OrderQty": "6",
  "OrdType": "Limit",
  "Price": "1.15",
  "Currency": "USD",
  "TimeInForce": "GoodTillDate",
  "ExpireTime": "2019-08-02T17:00:00.000"
}
```

The ClOrdID should be a unique identifier generated and stored on the client's side.

The Account field must be an IG account ID belonging to the logged-on client that the order will be placed on and is not a client identifier.

The response will be an ExecutionReport message:
```json
{
  "MsgType": "ExecutionReport",
  "ApplVerID": "FIX50SP2",
  "CstmApplVerID": "IGUS/Trade/V1",
  "SendingTime": "2019-08-02T21:14:40.001",
  "OrderID": "DIAAAAJ63W4MKA4",
  "ClOrdID": "12345",
  "ExecID": "0997234657176",
  "ExecType": "Trade",
  "OrdStatus": "Filled",
  "Account": "XXXXX",
  "SecurityID": "CS.D.GBPUSD.CZD.IP",
  "SecurityIDSource": "MarketplaceAssignedIdentifier",
  "Side": "Buy",
  "OrderQty": "6",
  "OrdType": "Limit",
  "Price": "1.15",
  "TimeInForce": "GoodTillDate",
  "ExpireTime": "2019-08-02T17:00:00.000",
  "Currency": "USD",
  "LastQty": "6",
  "LastPx": "1.15",
  "LeavesQty": "0",
  "CumQty": "6",
  "AvgPx": "1.15",
  "TransactTime": "2019-08-02T21:14:38.717"
}
```

For other order types (e.g. contingent orders) and further documentation on order parameters, refer to the Trade page.

## Cancel an order (Trade API)
To cancel an order, send an OrderCancelRequest message:
```json
 {
  "Side": "Buy",
  "Account": "XXXXX",
  "OrderQty": "1",
  "SendingTime": "2022-08-04T16:59:53.026",
  "OrdType": "Limit",
  "ApplVerID": "FIX50SP2",
  "ClOrdID": "orderCancelReq1+1659628793026",
  "SecurityID": "CS.D.GBPUSD.CZD.IP",
  "SecurityIDSource": "MarketplaceAssignedIdentifier",
  "MsgType": "OrderCancelRequest",
  "OrderID": "ORAAAAKGQFL2VAG",
  "TransactTime": "2022-08-04T15:59:53.000"
}
```

The OrderID should match the OrderID of the order being cancelled. 
The ClOrdID must be a new identifier for the cancel request and should be unique.

The response will be an ExecutionReport message:
```json
{
  "OrderID": "ORAAAAKGQFL2VAG",
  "ClOrdID": "orderCancelReq1+1659628793026",
  "OrigClOrdID": "LimitGTCOrder1+1659628792803",
  "ExecID": "EXAAAAKGQFL2YAG",
  "ExecType": "Canceled",
  "OrdStatus": "Canceled",
  "WorkingIndicator": "NotWorking",
  "Account": "XXXXX",
  "SecurityID": "CS.D.GBPUSD.CZD.IP",
  "SecurityIDSource": "MarketplaceAssignedIdentifier",
  "SecAltIDGrp":[],
  "Side": "Buy",
  "OrderQty":1,
  "OrdType": "Limit",
  "Price":1.20409,
  "Currency": "USD",
  "TimeInForce": "GoodTillCancel",
  "OrderAttributeGrp":[],
  "LastQty":0,
  "LastPx":0,
  "LeavesQty":1,
  "CumQty":0,
  "AvgPx":0,
  "TransactTime": "2022-08-04T15:59:53.045",
  "MsgType": "ExecutionReport",
  "ApplVerID": "FIX50SP2",
  "SendingTime": "2022-08-04T15:59:53.056"
}
```

## Request open positions (Trade API)
To request a list of open positions and subscribe to position updates, send a RequestForPositions message:
```json
{
  "Account": "XXXXX",
  "SendingTime": "2022-08-04T16:59:16.750",
  "PosReqID": "PosReqID+1659628756744",
  "SubscriptionRequestType": "SnapshotAndUpdates",
  "ApplVerID": "FIX50SP2",
  "ClearingBusinessDate": "2022-08-04T15:59:16.000",
  "MsgType": "RequestForPositions",
  "PosReqType": "Positions",
  "TransactTime": "2022-08-04T15:59:16.000"
}
```

This will create a subscription for position updates and also send a snapshot of current positions.

The response will be a RequestForPositionsAck message:
```json
{
  "PosMaintRptID": "b262a48c-df39-4208-a997-ff6555fc1c7d",
  "PosReqID": "PosReqID+1659628756744",
  "TotalNumPosReports": 14,
  "PosReqResult": "ValidRequest",
  "PosReqStatus": "Completed",
  "Account": "XXXXX",
  "MsgType": "RequestForPositionsAck",
  "ApplVerID": "FIX50SP2",
  "SendingTime": "2022-08-04T15:59:16.784"
}
```

PositionReport messages will be delivered for each open position:
```json
{
  "PosMaintRptID": "OPAAAAKGCH6TYAG",
  "PositionID": "OPAAAAKGCH6TYAG",
  "PosReqID": "PosReqID+1659628756744",
  "PosReqType": "Positions",
  "TotalNumPosReports": 1,
  "LastRptRequested": "NotLastMessage",
  "PosReqResult": "ValidRequest",
  "UnsolicitedIndicator": "MessageIsBeingSentAsAResultOfAPriorRequest",
  "ClearingBusinessDate": "2022-08-03",
  "Account": "XXXXX",
  "SecurityID": "CS.D.GBPUSD.CZD.IP",
  "SecurityIDSource": "MarketplaceAssignedIdentifier",
  "SecAltIDGrp": [],
  "Currency": "USD",
  "TransactTime": "2022-08-03T15:53:03.610+0000",
  "PositionQty": [
    {
      "PosType": "TotalTransactionQty",
      "LongQty": 1,
      "PosQtyStatus": "Accepted"
    }
  ],
  "PositionAmountData": [],
  "OpenPrice": 1.21415,
  "MsgType": "PositionReport",
  "ApplVerID": "FIX50SP2",
  "SendingTime": "2022-08-04T15:59:16.785"
}
```

Finally, send a RequestForPositions message of type DisablePreviousSnapshot to unsubscribe:
```json
{
  "Account": "XXXXX",
  "SendingTime": "2022-08-04T16:59:17",
  "PosReqID": "PosReqID+1659628756744",
  "SubscriptionRequestType": "DisablePreviousSnapshot",
  "ApplVerID": "FIX50SP2",
  "ClearingBusinessDate": "2022-08-04T15:59:17.000",
  "MsgType": "RequestForPositions",
  "PosReqType": "Positions",
  "TransactTime": "2022-08-04T15:59:17.000"
}
 ```