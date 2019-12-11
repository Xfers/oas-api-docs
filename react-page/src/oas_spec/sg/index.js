const combined = Object.assign(
    require("./base.json"),
    {
        tags: require("./tags.json"),
        paths: Object.assign(
            require("./paths/v3.json"),
            require("./paths/v4.json"),
        ),
        components: {
            parameters: require("./components/parameters.json"),
            examples: require("./components/examples.json"),
            responses: require("./components/responses.json"),
            schemas: require("./components/schemas.json"),
            securitySchemes: require("./components/securitySchemes.json")
        }
    }
)

console.log(combined)
module.exports = combined