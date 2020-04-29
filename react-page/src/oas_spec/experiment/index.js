const combined = Object.assign(
    require("./base.json"),
    {
        paths: Object.assign(
            require("./paths/direct_payment/bank_transfer.json"),
            require("./paths/payment_collector/fixed_virtual_account.json"),
        ),
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