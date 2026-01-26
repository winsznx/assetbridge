;; AssetBridge - Cross-chain asset migration
(define-constant ERR-NOT-VALIDATOR (err u100))
(define-constant ERR-ALREADY-CLAIMED (err u101))

(define-map migrations
    { migration-id: uint }
    { owner: principal, asset-id: (buff 32), amount: uint, target-chain: (string-ascii 32), claimed: bool }
)

(define-map validators { validator: (buff 32) } { is-validator: bool })
(define-data-var migration-counter uint u0)

(define-public (initiate-migration (asset-id (buff 32)) (amount uint) (target-chain (string-ascii 32)))
    (let (
        (migration-id (var-get migration-counter))
    )
        (map-set migrations { migration-id: migration-id } {
            owner: tx-sender,
            asset-id: asset-id,
            amount: amount,
            target-chain: target-chain,
            claimed: false
        })
        (var-set migration-counter (+ migration-id u1))
        (ok migration-id)
    )
)

(define-public (claim-migration (migration-id uint))
    (let (
        (migration (unwrap! (map-get? migrations { migration-id: migration-id }) ERR-ALREADY-CLAIMED))
        (validator-hash (keccak256 (unwrap-panic (to-consensus-buff? tx-sender))))
    )
        (asserts! (default-to false (get is-validator (map-get? validators { validator: validator-hash }))) ERR-NOT-VALIDATOR)
        (asserts! (not (get claimed migration)) ERR-ALREADY-CLAIMED)
        (map-set migrations { migration-id: migration-id } (merge migration { claimed: true }))
        (ok true)
    )
)

(define-read-only (get-migration (migration-id uint))
    (map-get? migrations { migration-id: migration-id })
)
