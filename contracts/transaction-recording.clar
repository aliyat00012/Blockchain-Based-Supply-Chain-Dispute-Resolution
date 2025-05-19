;; Transaction Recording Contract
;; Documents commercial exchanges between supply chain participants

(define-map transactions uint
  {
    seller: principal,
    buyer: principal,
    product-id: (string-utf8 50),
    quantity: uint,
    price: uint,
    timestamp: uint,
    status: uint  ;; 1 = Pending, 2 = Completed, 3 = Disputed
  }
)

(define-data-var transaction-counter uint u0)

(define-read-only (get-transaction-id)
  (var-get transaction-counter)
)

(define-public (record-transaction
    (buyer principal)
    (product-id (string-utf8 50))
    (quantity uint)
    (price uint))
  (let ((tx-id (var-get transaction-counter)))
    (map-set transactions tx-id {
      seller: tx-sender,
      buyer: buyer,
      product-id: product-id,
      quantity: quantity,
      price: price,
      timestamp: block-height,
      status: u1  ;; Pending
    })
    (var-set transaction-counter (+ tx-id u1))
    (ok tx-id)
  )
)

(define-public (complete-transaction (tx-id uint))
  (let ((tx (unwrap! (map-get? transactions tx-id) (err u1))))
    (asserts! (is-eq (get buyer tx) tx-sender) (err u2)) ;; Only buyer can complete
    (asserts! (is-eq (get status tx) u1) (err u3)) ;; Must be pending

    (map-set transactions tx-id (merge tx {status: u2}))
    (ok true)
  )
)

(define-public (mark-transaction-disputed (tx-id uint))
  (let ((tx (unwrap! (map-get? transactions tx-id) (err u1))))
    (asserts! (or (is-eq (get buyer tx) tx-sender) (is-eq (get seller tx) tx-sender)) (err u2))
    (asserts! (not (is-eq (get status tx) u3)) (err u3)) ;; Not already disputed

    (map-set transactions tx-id (merge tx {status: u3}))
    (ok true)
  )
)

(define-read-only (get-transaction (tx-id uint))
  (map-get? transactions tx-id)
)
