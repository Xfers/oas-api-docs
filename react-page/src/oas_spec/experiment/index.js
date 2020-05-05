const combined = Object.assign(
    require("./base.json"),
    {
        paths: Object.assign(
            require("./paths/direct_payment/queries.json"),
            require("./paths/payment_collector/queries.json"),
            require("./paths/direct_payment/va_bank_transfer.json"),
            require("./paths/direct_payment/unique_amount_bank_transfer.json"),
            require("./paths/payment_collector/fixed_virtual_account.json"),
        ),
        base_class: {
            payment: require("./base_class/payment.json"),
            direct_payment: require("./base_class/direct_payment.json")
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