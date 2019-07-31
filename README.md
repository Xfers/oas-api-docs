This repo is for Xfers' API documentation.
Beta site for API documentation(https://klementtan.github.io/dynamic-api-doc/)

## Problem

1. Xfers have multiple products that currently require different documentation.
  - Manually creating the documentation for each product is inefficient and problems of inconsistency will arise
  - Any changes made to the endpoints that are used by multiple documentations require changes to be made manually to each documentation
 
## Approach
 
To tackle the above problems, this repo aims to create a way of documentation at a higher level of abstraction. Any changes made to the documentation should only be made to 1 source to ensure efficiency and standardization.

Flow(https://www.lucidchart.com/invitations/accept/a4e6c44e-9b06-4ffb-a75b-3bc50304cc05)

1. Any changes Xfers wants to make will be made to the master-documentation
  - Master-documentation will contain all of Xfers endpoints (Singapore-specific and Indonesia-specific) and all of Xfers parameters
  - Master-documentation will be hosted on swagger-hub gui(https://app.swaggerhub.com/apis/xfers/xfers-api/3)
2. Run `cd xfers-swagger-api` in the root directory and execute `rake generate` in the command line. This will:
  - call swagger hub API to retrieve the our master-docuementation from them
  - create 2 `.json` files: `Singapore.json` and `Indonesia.json`. These files will be written to `/oas-doc-portal/src/oas_spec` and `/xfers-swagger-api/template_oas`
  - The json file will be generated in accordance to `/xfers-swagger-api/config/oas.yml`, where you can state the endpoints you want in each documentation by stating it under the `paths` field (e.g. `"/user/activities"` and `"/authorize*"`
3. The github pages that host our docuementation is built according to json files in the `/oas-doc-portal/src/oas_spec/` folder. Once the json files have been written into the directory, the page will be updated.

## Features
1. Ability to generate any number of customized documentation quickly by changing `xfers-swagger-api/config/oas.yml`
2. Ability to define specific parameters for different sets of documentation by typing `ONLY <clientname>` in the description field of parameters.
  - For example if you type `ONLY Singapore...` in the description field of the parameter, `Indonesia.json` will not contain the parameter.

## How to contribute

1. Change OAS definition
  - Clone this repository
  - run `cd oas-doc-portal`
  - run `npm install`
  - run `npm start`
  - Any changes made to `/src/oas_spec/master-openapi.json` will be reflected on `http://localhost:3000/master`
  - If you made any changes to `master-oas.json`, please create a pull request
  ** extra: use VSCode `OpenAPI(Swagger) editor` to have a sidebar that can help navigate through the json easily and `openapi-linter` to check if you follow the OpenAPI specifications
  
## Other notes
 
 Template of path with requestBody(Post/put)
 ```
  "/endpointpath(without api/v3)/a/b/c": {
      "post/put": {
        "operationId": "testName" # unique name of method. Use camel case
        "tags": [
          "# category of method see "tags"{...} for the available tags"
        ],
        "x-code-samples": [{
          "lang": "Shell_curl",
          "source": "curl --location --request PUT...." # this is the sample curl request use                                                                                                 # https://www.freeformatter.com/json-escape.html to change the curl                                                                   # request to a valid string
        }],
        "summary": "Submit KYC Data", #the name of endpoint that the client will see
        "description": "To provide KYC data in order to change user from unverified status into fully verified status.  \n\nThe image/document provided us must be hosted in an URL then pass the URL to Xfers via this API.  \nMake sure data type for your image is jpeg / png.  \nMaximum size of the image/ document is 10 MB.  \n\nAfter this data is sent, we will do some verifications on our side and may take some time before user gets fully verified.  In Indonesia, fully verified user will be backed by a savings account.\r\nThus, there are required parameters which are mother_maiden_name, id_front_url, selfie_2id_url.\r\nAdditional data will speed up the KYC process.",
        "security": [
          {
            "user-api-token": [ # api verification see securitySchemes for the different key naming

            ]
          }
        ],
        "requestBody": {
          "description": "Request Body. Click on Schema for information on the parameters.", # description of request body
          "required": true, 
          "content": {
            "application/x-www-form-urlencoded": { # request type usually either this or application/json
              "schema": {
                "x-custom-params-requirements" : {
                  "Indonesia" : ["id_front_url", ... ] # only add this key if you want the specific documentation to have                                                            # these parameters as required
                },
                "properties": {
                  "id_front_url": { # parameter name
                    "type": "string", # parameter type
                    "description": "URL storing the front image of user identity card" # parameter description
                  },
                  "callback_url": {
                    "deprecated": true,
                    "type": "string",
                    "x-custom-parms" : ["Indonesia"] #add this key if you want this parameter to only be avaiable for that country
                    "description": "URL to receive callback notifications on account verification changes. This parameter is still supported but is going through deprecation. We strongly advice you to use the dashboard to set callback_url instead."
                  }
                }
              }
            }
          }
        },
        "responses": {
          "200": {
            "description": "Success",
            "content": {
              "application/json": {
                "example": {
                #add example of success JSON
              }
            }
          },
          "4XX": {
            "$ref": "# /components/responses/4XX"
          }
        }
      },
```
