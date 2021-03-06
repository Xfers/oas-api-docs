const combined = Object.assign(
    require("./base.json"),
    {
        tags: require("./tags.json"),
        paths: Object.assign(
            require("./paths/v3.json")
        ),
        components: {
            definitions: require("./components/definitions.json"), // api v4 schemas use this for now
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