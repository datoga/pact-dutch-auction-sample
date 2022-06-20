(define-keyset 'admin-keyset
(read-keyset "admin-keyset"))


(module dutch-auction 'admin-keyset

  "Sample: Dutch auction NFTs smart contract."

  (defschema auction
    running:bool
    initialPrice: decimal
    stepPerBlock: decimal
    initialBlock:integer
    initialTime:time
    endTime:time
  )

  (deftable auction-table:{auction})

  (defschema inventory
    auctionId:string
    name:string
    sold:bool
  )

  (deftable inventory-table:{inventory})

  (defschema transaction
    auctionId:string
    buyer:string
    nft:string
    price:decimal
  )

  (deftable transaction-table:{transaction})

  (defun create-auction (auctionId initialPrice stepPerBlock)
    (insert auction-table auctionId
    {
      "running": false,
      "initialPrice": initialPrice,
      "stepPerBlock": stepPerBlock,
      "initialBlock": 0,
      "initialTime": (time "2016-07-22T11:26:35Z"),
      "endTime": (time "2016-07-22T11:26:35Z")
    })
  )

  (defun start-auction (auctionId endTime)
    (update auction-table auctionId
    {
      "running": true,
      "initialBlock": (at 'block-height (chain-data) ),
      "initialTime": (at 'block-time (chain-data) ),
      "endTime": endTime
    })
  )

  (defun stop-auction (auctionId)
    (update auction-table auctionId
    {
      "running": false
    })
  )

  (defun add-nft (auctionId address name)
    (insert inventory-table address
    {
      "auctionId":auctionId,
      "name": name,
      "sold": false
    })
  )

  (defun buy-nft (txId auctionId nft price)
    (let (
        (running (is-running auctionId))
        (inTime (in-time auctionId))
        (currentPrice (current-price auctionId))
        (available (is-available nft))
        (nftAuctionId (get-auction-id-from-nft nft))
      )
      (enforce running "The auction must be running")
      (enforce inTime "The auction time is exhausted")
      (enforce (= auctionId nftAuctionId) "The NFT must be registered to the auction")
      (enforce available "The NFT must be available")
      (enforce (>= price currentPrice) "The price must be higher or equal than current price")
      (enforce (> currentPrice 0.0) "The current price must not be positive")
      (insert transaction-table txId
      {
        "auctionId":auctionId,
        "buyer":(at 'sender (chain-data) ),
        "nft": nft,
        "price":price
      })
      (update inventory-table nft
        {
          "sold": true
        }
      )
    )
  )

  (defun current-price:decimal(auctionId)
   (with-read auction-table auctionId {
     "initialBlock":= initialBlock,
     "initialPrice":= initialPrice,
     "stepPerBlock":= stepPerBlock
   }
     (let* (
       (currentBlock (at 'block-height (chain-data) ))
       (difference (- currentBlock initialBlock))
       (currentPrice (- initialPrice (* difference stepPerBlock) ) )
     )
        (if (< currentPrice 0.0) 0.0 currentPrice)
      )
    )
  )

  (defun is-available:bool(address)
   (with-read inventory-table address { "sold":=sold }
      (not sold)
   )
  )

  (defun get-auction-id-from-nft:string(address)
   (with-read inventory-table address { "auctionId":=auctionId }
     auctionId
   )
  )

  (defun is-running:bool(auctionId)
   (with-read auction-table auctionId { "running":=running }
     running
   )
  )

  (defun in-time:bool(auctionId)
   (with-read auction-table auctionId { "endTime":=endTime }
     (< (at 'block-time (chain-data)) endTime)
   )
  )

  (defun available-nfts:object ()
    (select inventory-table (where "sold" (= false)))
  )

  (defun sold-nfts:object ()
    (select inventory-table (where "sold" (= true)))
  )

  (defun transactions:object ()
    (select transaction-table (constantly true))
  )

  (defun stats:object()
    {
      "available_nfts":(available-nfts),
      "sold_nfts":(sold-nfts),
      "transactions":(transactions)
    }
  )
)

(create-table auction-table)
(create-table inventory-table)
(create-table transaction-table)
