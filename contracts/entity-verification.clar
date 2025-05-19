;; Entity Verification Contract
;; Validates supply chain participants

(define-data-var admin principal tx-sender)

;; Entity types: 1 = Manufacturer, 2 = Supplier, 3 = Distributor, 4 = Retailer
(define-map entities principal
  {
    entity-type: uint,
    name: (string-utf8 50),
    is-verified: bool,
    registration-time: uint
  }
)

(define-public (register-entity (entity-type uint) (name (string-utf8 50)))
  (begin
    (asserts! (and (>= entity-type u1) (<= entity-type u4)) (err u1)) ;; Valid entity type
    (asserts! (not (is-entity tx-sender)) (err u2)) ;; Not already registered

    (map-set entities tx-sender {
      entity-type: entity-type,
      name: name,
      is-verified: false,
      registration-time: block-height
    })
    (ok true)
  )
)

(define-public (verify-entity (entity principal))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u3)) ;; Only admin can verify
    (asserts! (is-entity entity) (err u4)) ;; Entity must exist

    (let ((current-data (unwrap! (map-get? entities entity) (err u5))))
      (map-set entities entity (merge current-data {is-verified: true}))
      (ok true)
    )
  )
)

(define-read-only (is-entity (entity principal))
  (is-some (map-get? entities entity))
)

(define-read-only (is-verified-entity (entity principal))
  (match (map-get? entities entity)
    entity-data (get is-verified entity-data)
    false
  )
)

(define-read-only (get-entity-info (entity principal))
  (map-get? entities entity)
)

(define-public (transfer-admin (new-admin principal))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u6)) ;; Only current admin
    (var-set admin new-admin)
    (ok true)
  )
)
