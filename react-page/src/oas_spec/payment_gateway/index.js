const combined = Object.assign(
    require("./base.json"),
    {
        paths: Object.assign(
            require("./paths/payments/queries.json"),
            // require("./paths/payment_methods/unique_amount_bank_transfers.json"),
            require("./paths/payment_methods/fixed_virtual_account_bank_transfers.json"),
            require("./paths/payment_methods/convenience_store_transfers.json"),
        ),
        base_class: {
            cvs_transfers: require("./base_class/cvs_transfers.json"),
            fixed_virtual_account_bank_transfers: require("./base_class/fixed_virtual_account_bank_transfers.json"),
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