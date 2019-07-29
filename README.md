This repo is for Xfers' API documentation.
Beta site for API documentation(https://klementtan.github.io/dynamic-api-doc/)

Problem

1. Xfers have multiple group of client that requires different type of documentation.
  - Manuaklly creating the documentation for each group of client is inefficient and problems of inconsistency will arise
  - Any changes made to endpoint that are used by multiple groups of client requires changes to be made manually to the the documentations
 
 Approach
 
To tackle this problem, this repo aims to create a way of documentation at a higher level of abstraction. Any changes made to the documentation should only be made to 1 source to ensure efficiency and standardization.

Flow(https://www.lucidchart.com/invitations/accept/a4e6c44e-9b06-4ffb-a75b-3bc50304cc05)

1. Any changes made xfers want to make will be made to the master-documentation
  - Master-documentation will contain all of xfers endpoint(Core API, SG specific and Indo Specific) and all of xfers parameters
  - Master-documentation will be hosted on swagger-hub gui(https://app.swaggerhub.com/apis/xfers/xfers-api/3)
2. Cd into `xfers-swagger-api` and execute `rake generate` in the command line.
  - This will call swagger hub API to retrieve the our master-docuementation from them
  - `rake generate` will create 2 separate `.json` file, `Singapore.json` and `Indonesia.json`. These files will be written to `/oas-doc-portal/src/oas_spec` and `/xfers-swagger-api/template_oas`
  - The json file will be generated in accordance to `oas.yml` in `/xfers-swagger-api/config`. You can state the endpoint you want that documentation to hold by stating it under the `paths` field (ie `"/user/activities"` and `"/authorize*"`
3. The github pages that host our docuementation is built according to json file in the `/oas-doc-portal/src/oas_spec` directory. Once the json file have been written into the directory the page will be updated.

Features
1. Can generate any amount of specific documentation quickly by changing `xfers-swagger-api/config/oas.yml`
2. Can define specific parameters to client by typing `ONLY <clientname>` in the description field of parameters.
  - For example if you type `ONLY Singapore...` in the description field of the parameter, `Indonesia.json` will not contain the parameter.

###How to contribute

1. Change OAS definition
  a. Clone repo
  b. cd oas-doc-portal
  c. run `npm install`
  d. run `npm start`
  e. Any changes made to /src/oas_spec/master-openapi.json will be reflected on localhost://3000 master tab on the top
  f. If you made any changes to master-oas.json create a PR to this repo
  extra: use VSCode `OpenAPI(Swagger) editor` to have a side bar that navigate through the json easily and `openapi-linter`   to check if you follow the OpenAPI specs
  
 Other notes
 
 Template of path with requestBody(Post/put)
 ```
  "/endpointpath(without api/v3)/a/b/c": {
      "post/put": {
        "operationId": "testName" #unique name of method use camel case
        "tags": [
          "#category of method see "tags"{...} for the available tags"
        ],
        "x-code-samples": [{
          "lang": "Shell_curl",
          "source": "curl --location --request PUT...." # this is the sample curl request use                                                                                       # https://www.freeformatter.com/json-escape.html to change the curl                                                          # request to a valid string
        }],
        "summary": "Submit KYC Data", #the name of endpoint that the client will see
        "description": "To provide KYC data in order to change user from unverified status into fully verified status.  \n\nThe image/document provided us must be hosted in an URL then pass the URL to Xfers via this API.  \nMake sure data type for your image is jpeg / png.  \nMaximum size of the image/ document is 10 MB.  \n\nAfter this data is sent, we will do some verifications on our side and may take some time before user gets fully verified.  In Indonesia, fully verified user will be backed by a savings account.\r\nThus, there are required parameters which are mother_maiden_name, id_front_url, selfie_2id_url.\r\nAdditional data will speed up the KYC process.",
        "security": [
          {
            "user-api-token": [ #api verification see secruitySchemes for the different key naming

            ]
          }
        ],
        "requestBody": {
          "description": "Request Body. Click on Schema for information on the parameters.", #description of request body
          "required": true, 
          "content": {
            "application/x-www-form-urlencoded": { #request type usually either this or application/json
              "schema": {
                "x-custom-params-requirements" : {
                  "Indonesia" : ["id_front_url", ... ] #only add this key if you want the specific documentation to have                                                            #these parameters as required
                },
                "properties": {
                  "id_front_url": { #name of parameter 
                    "type": "string", #parameter type
                    "description": "URL storing the front image of user identity card" #parameter description
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
            "$ref": "#/components/responses/4XX"
          }
        }
      },
```
