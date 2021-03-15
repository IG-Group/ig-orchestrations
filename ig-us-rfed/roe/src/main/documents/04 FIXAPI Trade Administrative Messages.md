### Administrative Messages
The following Administrative FIX messages are supported;
*	Logon
*	Heartbeat
*	Test Request
*	Resend Request
*	Session-level Reject
*	Sequence Reset (Gap Fill)
*	Logout

## Logon
The Logon message authenticates a user establishing a connection to a remote system. The Logon
message must be the first message sent by the application requesting to initiate a FIX session
Sample message
````
8=FIXT.1.1 | 9=83 | 35=A | 34=1 | 49=ClientUserName | 52=20210312-22:01:00.000 | 56=IGUSTRADE | 1128=9 | 98=0 | 108=10 | 1137=9 | 10=031
````
|Tag |Field Name | Required? | Comments |
|--- |--- | --- |--- |
Standard Header | | Y |MsgType (35) = ‘A’ |
|98 |EncryptMethod |Y |Must be ‘0’ = None |
|108 |HeartBtInterval |Y |A heart beat Interval of 60 seconds is recommended.|
|1137 | DefaultApplVerID | Y | Must be ‘9’ = FIX50SP2 |
|141 | ResetSeqNumFlag | N |Default of ‘N’; if not sent, sequence numbers will not be reset| 
|Standard Trailer | | Y|


## Heartbeat
The Heartbeat monitors the status of the communication link and identifies when the last of a string of
messages was not received.

|Tag |Field Name | Required? | Comments |
|--- |--- | --- |--- |
|Standard Header | | Y |MsgType (35) = ‘0’ |
|112 | TestReqID | C | Required when the heartbeat is the result of a Test Request message |
|Standard Trailer | | Y|


## Test Request
The Test Request message forces a heartbeat from the opposing application.

|Tag |Field Name | Required? | Comments |
|--- |--- | --- |--- |
|Standard Header | | Y |MsgType (35) = ‘1’ |
|112 | TestReqID | Y | Identifier included in Test Request(1) message to be returned in resulting Heart Beat(0) |
|Standard Trailer | | Y|


## Resend Request
The resend request is sent by the receiving application to initiate the retransmission of messages.
This function is utilized if a sequence number gap is detected, if the receiving application lost a
message, or as a function of the initialization process.

|Tag |Field Name | Required? | Comments |
|--- |--- |---| --- |
|Standard Header | | Y |MsgType (35) = ‘2’ |
|7 | BeginSeqNo | Y |  Message sequence number of first message in range to be resent.
|16 | BeginSeqNo | Y |  Message sequence number of last message in range to be resent. If request is for a single message BeginSeqNo (7) = EndSeqNo (16). If request is for all messages subsequent to a particular message, EndSeqNo (16) = '0'(representing infinity). |
|Standard Trailer | | Y|
 

## Reject (Session-level)
The Reject message should be issued when a message is received but cannot be passed through to
the application level. An example of when a reject may be appropriate would be the receipt of a
message with invalid basic data (e.g. MsgType=&) that successfully passes de-encryption, CheckSum
and BodyLength checks. As a rule, messages should be forwarded to the trading application for
business level rejections whenever possible.

|Tag |Field Name | Required? | Comments |
|--- |--- |---| --- |
|Standard Header | | Y |MsgType (35) = ‘3’ |
|45 | RefSeqNum | Y |  MsqSeqNum (34) of rejected message
|371 | RefTagID | N |  The tag number of the FIX field being referenced. |
|372 | RefMsgType | N |  The MsgType (35) of the FIX message being referenced. |
|373 | SessionRejectReason | N |  Code to identify reason for a session-level Reject (3) message. |
|58 | Text | N | Text N Where possible, message to explain reason for rejection. |
|Standard Trailer | | Y|

## Sequence Reset (Gap Fill)
The Sequence Reset message is used by the sending application to reset the incoming sequence
number on the opposing side.

|Tag |Field Name | Required? | Comments |
|--- |--- |---| --- |
|Standard Header | | Y |MsgType (35) = ‘4’ |
|123 | GapFillFlag | N | Indicates that the Sequence Reset (4) message is replacing administrative or application messages that will not be resent. |
|36 | NewSeqNo | Y | New sequence number. |
|Standard Trailer | | Y|

## Logout
The Logout message initiates or confirms the termination of a FIX session.
Sessions with IG Group may terminate without sending a Logout message.

|Tag |Field Name | Required? | Comments |
|--- |--- |---| --- |
|Standard Header | | Y |MsgType (35) = ‘5’ |
|58 | Text | N | Free format text. |
|Standard Trailer | | Y|
