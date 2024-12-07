;; time-capsule contract

(define-map time-capsules
  { capsule-id: uint }
  {
    owner: principal,
    recipient: principal,
    content-hash: (buff 32),
    unlock-height: uint,
    is-delivered: bool
  }
)

(define-data-var last-capsule-id uint u0)

(define-constant contract-owner tx-sender)

(define-public (create-capsule (recipient principal) (content-hash (buff 32)) (unlock-height uint))
  (let
    (
      (capsule-id (+ (var-get last-capsule-id) u1))
    )
    (asserts! (> unlock-height block-height) (err u400))
    (map-set time-capsules
      { capsule-id: capsule-id }
      {
        owner: tx-sender,
        recipient: recipient,
        content-hash: content-hash,
        unlock-height: unlock-height,
        is-delivered: false
      }
    )
    (var-set last-capsule-id capsule-id)
    (ok capsule-id)
  )
)

(define-public (deliver-capsule (capsule-id uint))
  (let
    (
      (capsule (unwrap! (map-get? time-capsules { capsule-id: capsule-id }) (err u404)))
    )
    (asserts! (>= block-height (get unlock-height capsule)) (err u403))
    (asserts! (is-eq (get recipient capsule) tx-sender) (err u403))
    (asserts! (not (get is-delivered capsule)) (err u401))
    (map-set time-capsules
      { capsule-id: capsule-id }
      (merge capsule { is-delivered: true })
    )
    (ok true)
  )
)

(define-read-only (get-capsule (capsule-id uint))
  (map-get? time-capsules { capsule-id: capsule-id })
)

