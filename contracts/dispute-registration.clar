;; Dispute Registration Contract
;; Records claims of non-performance

(define-map disputes uint
  {
    transaction-id: uint,
    claimant: principal,
    respondent: principal,
    reason: (string-utf8 100),
    timestamp: uint,
    status: uint  ;; 1 = Open, 2 = In Progress, 3 = Resolved, 4 = Rejected
  }
)

(define-data-var dispute-counter uint u0)

(define-read-only (get-dispute-id)
  (var-get dispute-counter)
)

(define-public (register-dispute
    (transaction-id uint)
    (respondent principal)
    (reason (string-utf8 100)))
  (let ((dispute-id (var-get dispute-counter)))
    (map-set disputes dispute-id {
      transaction-id: transaction-id,
      claimant: tx-sender,
      respondent: respondent,
      reason: reason,
      timestamp: block-height,
      status: u1  ;; Open
    })
    (var-set dispute-counter (+ dispute-id u1))
    (ok dispute-id)
  )
)

(define-public (update-dispute-status (dispute-id uint) (new-status uint))
  (let ((dispute (unwrap! (map-get? disputes dispute-id) (err u1))))
    (asserts! (or (is-eq (get claimant dispute) tx-sender) (is-eq (get respondent dispute) tx-sender)) (err u2))
    (asserts! (and (>= new-status u1) (<= new-status u4)) (err u3)) ;; Valid status

    (map-set disputes dispute-id (merge dispute {status: new-status}))
    (ok true)
  )
)

(define-read-only (get-dispute (dispute-id uint))
  (map-get? disputes dispute-id)
)
