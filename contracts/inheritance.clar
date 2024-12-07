;; inheritance contract

(define-map beneficiaries
  { capsule-id: uint }
  {
    beneficiary: principal,
    access-height: uint
  }
)

(define-public (set-beneficiary (capsule-id uint) (beneficiary principal) (access-height uint))
  (begin
    (asserts! (> access-height block-height) (err u400))
    (map-set beneficiaries
      { capsule-id: capsule-id }
      {
        beneficiary: beneficiary,
        access-height: access-height
      }
    )
    (ok true)
  )
)

(define-public (access-as-beneficiary (capsule-id uint))
  (let
    (
      (beneficiary-info (unwrap! (map-get? beneficiaries { capsule-id: capsule-id }) (err u404)))
    )
    (asserts! (is-eq (get beneficiary beneficiary-info) tx-sender) (err u403))
    (asserts! (>= block-height (get access-height beneficiary-info)) (err u403))
    (ok true)
  )
)

(define-read-only (get-beneficiary-info (capsule-id uint))
  (map-get? beneficiaries { capsule-id: capsule-id })
)

