const combined = Object.assign(
    require("./base.json"),
    {
        paths: Object.assign(
            require("./paths/payments/queries.json"),
            require("./paths/payment_methods/virtual_account_bank_transfers.json"),
            require("./paths/payment_methods/unique_amount_bank_transfers.json"),
            require("./paths/payment_methods/fixed_virtual_accounts.json"),
        ),
        base_class: {
            payment: require("./base_class/payment.json"),
            payment_method: require("./base_class/payment_method.json"),
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