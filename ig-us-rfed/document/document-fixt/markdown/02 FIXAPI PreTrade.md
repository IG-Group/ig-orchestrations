# PreTrade FIX API

## Pre Trade Product Offering

The Pre Trade supports Security Reference Data and Quote Negotiation.

Request messages supported are
*    QuoteRequest
*    SecurityListRequest

Response messages supported are
*    SecurityList
*    Quote
*    QuoteRequestReject

##	High Message Rate Protection
In order to protect both IG’s and our Clients’ systems, we have implemented a quota in the Pre Trade API.
For each session, we monitor the rate of incoming application messages (i.e. excluding admin messages such as heartbeats). If the number breaches a threshold subsequent orders will be rejected due to the quota breached.
A quota is applied for each type of message. The available quota is refilled based on a refill interval and refill count.

|Message | Quota interval | Max Limit | Quota Refill Count (over interval) |
|---  |--- |--- |--- |
|QuoteRequest | 1m | 10 |1 |
|SecurityListRequest   | 1m | 150 |1 |

