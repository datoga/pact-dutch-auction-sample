(define-keyset 'admin-keyset
(read-keyset "admin-keyset"))

;(define-keyset 'buyer-keyset
;(read-keyset "buyer-keyset"))

(module dutch-auction 'admin-keyset

  "Dutch auction NFTs samples smart contract."

  (defconst STEP_PER_BLOCK 0.02)
  (defconst INITIAL_PRICE 10.00)

  (defschema auction
    running:bool
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

  (defun create-auction (auctionId)
    (insert auction-table auctionId
    {
      "running": false,
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

  (defun buy-nft (txId auctionId buyer nft price)
    (let ((currentPrice (current-price auctionId)))
      (enforce (>= price currentPrice) "The price must be higher or equal than current price")
      (insert transaction-table txId
      {
        "auctionId":auctionId,
        "buyer":buyer,
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

  (defun current-price:decimal(auctionId)
   (with-read auction-table auctionId { "initialBlock":=initialBlock }
     (let* (
       (currentBlock (at 'block-height (chain-data) ))
       (difference (- currentBlock initialBlock))
     )
        (- INITIAL_PRICE (* difference STEP_PER_BLOCK) )
      )
    )
  )

  (defun is-running:bool(auctionId)
   (with-read auction-table auctionId { "running":=running }
     running
   )
  )









)

(create-table auction-table)
(create-table inventory-table)
(create-table transaction-table)
