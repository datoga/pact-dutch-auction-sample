# PACT dutch auction sample

Execution:

`pact dutch-auction.repl -t`

Disclaimer:

- This is just a demo using some parameters to manage dutch auctions in PACT.
- It can handle different auctions at the same time.
- I added just 5 NFTs (instead of 100) to make more visible the stats, where inventory is dumped.
- I don't check any address, signature, etc (keys enforcement for admin and buyers). Of course, in a real app, it is mandatory to check them in order to avoid security risks but I didn't implemented as long it wasn't the core of the demo.

The execution writes this results:

```bash

pact --trace dutch-auction.repl 
dutch-auction.repl:3:0:Trace: Setting transaction keys
dutch-auction.repl:4:0:Trace: Setting transaction data
dutch-auction.repl:7:0:Trace: Begin Tx 0
dutch-auction.repl:8:0:Trace: Loading dutch-auction.pact...
dutch-auction.pact:1:0:Trace: Keyset defined
dutch-auction.pact:5:0:Trace: Loaded module dutch-auction, hash rRY2Pn1i43C_121SZTjonOfQRgnH9NocpJ1QLpfZEek
dutch-auction.pact:165:0:Trace: TableCreated
dutch-auction.pact:166:0:Trace: TableCreated
dutch-auction.pact:167:0:Trace: TableCreated
dutch-auction.repl:9:0:Trace: Commit Tx 0
dutch-auction.repl:11:0:Trace: Begin Tx 1
dutch-auction.repl:12:0:Trace: Using dutch-auction
dutch-auction.repl:14:0:Trace: Updated public metadata
dutch-auction.repl:17:0:Trace: Write succeeded
dutch-auction.repl:19:0:Trace: Write succeeded
dutch-auction.repl:20:0:Trace: Write succeeded
dutch-auction.repl:21:0:Trace: Write succeeded
dutch-auction.repl:22:0:Trace: Write succeeded
dutch-auction.repl:23:0:Trace: Write succeeded
dutch-auction.repl:25:0:Trace: Commit Tx 1
dutch-auction.repl:27:0:Trace: Begin Tx 2
dutch-auction.repl:28:0:Trace: Using dutch-auction
dutch-auction.repl:31:0:Trace: Expect failure: success: Not started
dutch-auction.repl:33:0:Trace: Write succeeded
dutch-auction.repl:34:0:Trace: Commit Tx 2
dutch-auction.repl:37:0:Trace: Begin Tx 3
dutch-auction.repl:39:0:Trace: Using dutch-auction
dutch-auction.repl:41:0:Trace: current price is 10.0
dutch-auction.repl:43:0:Trace: Updated public metadata
dutch-auction.repl:46:0:Trace: Write succeeded
dutch-auction.repl:47:0:Trace: Commit Tx 3
dutch-auction.repl:49:0:Trace: Begin Tx 4
dutch-auction.repl:50:0:Trace: Using dutch-auction
dutch-auction.repl:51:0:Trace: Updated public metadata
dutch-auction.repl:52:0:Trace: Write succeeded
dutch-auction.repl:55:0:Trace: Expect failure: success: Failure low price
dutch-auction.repl:58:0:Trace: Expect failure: success: You cannot buy a non-registered NFT
dutch-auction.repl:60:0:Trace: Write succeeded
dutch-auction.repl:61:0:Trace: Write succeeded
dutch-auction.repl:62:0:Trace: Write succeeded
dutch-auction.repl:65:0:Trace: Expect failure: success: You cannot buy a NFT from another auction
dutch-auction.repl:67:0:Trace: Commit Tx 4
dutch-auction.repl:68:0:Trace: Using dutch-auction
dutch-auction.repl:70:0:Trace: {"available_nfts": [{"auctionId": "test","name": "nft3","sold": false} {"auctionId": "test","name": "nft4","sold": false} {"auctionId": "test","name": "nft5","sold": false} {"auctionId": "another","name": "nft9999","sold": false}],"sold_nfts": [{"auctionId": "test","name": "nft1","sold": true} {"auctionId": "test","name": "nft2","sold": true}],"transactions": [{"auctionId": "test","buyer": "buyer1","nft": "0001","price": 12.2} {"auctionId": "test","buyer": "buyer2","nft": "0002","price": 11.5}]}
dutch-auction.repl:72:0:Trace: Begin Tx 5
dutch-auction.repl:73:0:Trace: Using dutch-auction
dutch-auction.repl:76:0:Trace: Expect failure: success: You cannot buy a NFT which is sold
dutch-auction.repl:78:0:Trace: Commit Tx 5
dutch-auction.repl:80:0:Trace: Begin Tx 6
dutch-auction.repl:81:0:Trace: Using dutch-auction
dutch-auction.repl:84:0:Trace: Updated public metadata
dutch-auction.repl:86:0:Trace: current price after 100 blocks is 8.0
dutch-auction.repl:88:0:Trace: Updated public metadata
dutch-auction.repl:91:0:Trace: Write succeeded
dutch-auction.repl:92:0:Trace: Commit Tx 6
dutch-auction.repl:94:0:Trace: Begin Tx 7
dutch-auction.repl:95:0:Trace: Using dutch-auction
dutch-auction.repl:98:0:Trace: Updated public metadata
dutch-auction.repl:100:0:Trace: current price after 1000 blocks is 0.0
dutch-auction.repl:102:0:Trace: Expect failure: success: The current price reached 0
dutch-auction.repl:103:0:Trace: Commit Tx 7
dutch-auction.repl:106:0:Trace: Updated public metadata
dutch-auction.repl:108:0:Trace: Begin Tx 8
dutch-auction.repl:109:0:Trace: Using dutch-auction
dutch-auction.repl:111:0:Trace: Expect failure: success: The auction time is exhausted
dutch-auction.repl:113:0:Trace: Commit Tx 8
dutch-auction.repl:115:0:Trace: Begin Tx 9
dutch-auction.repl:116:0:Trace: Using dutch-auction
dutch-auction.repl:119:0:Trace: Write succeeded
dutch-auction.repl:121:0:Trace: Updated public metadata
dutch-auction.repl:123:0:Trace: Expect failure: success: The auction has finished
dutch-auction.repl:125:0:Trace: Commit Tx 9
dutch-auction.repl:127:0:Trace: Using dutch-auction
dutch-auction.repl:130:0:Trace: {"available_nfts": [{"auctionId": "test","name": "nft4","sold": false} {"auctionId": "test","name": "nft5","sold": false} {"auctionId": "another","name": "nft9999","sold": false}],"sold_nfts": [{"auctionId": "test","name": "nft1","sold": true} {"auctionId": "test","name": "nft2","sold": true} {"auctionId": "test","name": "nft3","sold": true}],"transactions": [{"auctionId": "test","buyer": "buyer1","nft": "0001","price": 12.2} {"auctionId": "test","buyer": "buyer2","nft": "0002","price": 11.5} {"auctionId": "test","buyer": "buyer3","nft": "0003","price": 9.5}]}
Load successful

```
