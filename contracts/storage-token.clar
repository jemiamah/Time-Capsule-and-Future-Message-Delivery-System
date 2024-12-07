;; storage-token contract

(define-fungible-token storage-token)

(define-constant contract-owner tx-sender)

(define-public (mint (amount uint) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender contract-owner) (err u403))
    (ft-mint? storage-token amount recipient)
  )
)

(define-public (transfer (amount uint) (sender principal) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender sender) (err u403))
    (ft-transfer? storage-token amount sender recipient)
  )
)

(define-public (burn (amount uint) (owner principal))
  (begin
    (asserts! (is-eq tx-sender owner) (err u403))
    (ft-burn? storage-token amount owner)
  )
)

(define-read-only (get-balance (account principal))
  (ok (ft-get-balance storage-token account))
)

(define-read-only (get-total-supply)
  (ok (ft-get-supply storage-token))
)

