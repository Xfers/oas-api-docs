This repo is for Xfers' API documentation.

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
  - For example if you type `ONLY Singapore...` in the description field of the parameter, `Indonesia.json` will not contain the end point.
