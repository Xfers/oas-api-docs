const combined = Object.assign(
    require("./base.json"),
    {
        paths: Object.assign(
            require("./paths/payments/queries.json"),
            require("./paths/payments/cancel.json"),
            require("./paths/direct_payment/virtual_account_bank_transfers.json"),
            require("./paths/direct_payment/unique_amount_bank_transfers.json"),
            require("./paths/payment_collector/fixed_virtual_accounts.json"),
            require("./paths/xfers_pay/xfers_pay_dynamic_va.json"),
            require("./paths/xfers_pay/xfers_pay_unique_amount.json"),
            require("./paths/xfers_pay/xfers_pay_fixed_va.json")
        ),
        base_class: {
            payment: require("./base_class/payment.json"),
            payment_collector: require("./base_class/payment_collector.json"),
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