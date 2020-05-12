const combined = Object.assign(
    require("./base.json"),
    {
        paths: Object.assign(
            require("./paths/payments/queries.json"),
            require("./paths/payments/cancel.json"),
            require("./paths/direct_payment/virtual_account_bank_transfers.json"),
            require("./paths/direct_payment/unique_amount_bank_transfers.json"),
            require("./paths/static_payment_reference/fixed_virtual_accounts.json"),
        ),
        base_class: {
            payment: require("./base_class/payment.json"),
            static_payment_reference: require("./base_class/static_payment_reference.json"),
        },
        components: {
            definitions: require("../indo/components/definitions.json"), // api v4 schemas use this for now
            parameters: require("../indo/components/parameters.json"),
            examples: require("../indo/components/examples.json"),
            responses: require("../indo/components/responses.json"),
            schemas: require("../indo/components/schemas.json"),
            securitySchemes: require("../indo/components/securitySchemes.json")
        }
    }
)

console.log(combined)
module.exports = combined