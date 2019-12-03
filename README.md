This repo is for Xfers' API documentation.
Beta site for API documentation (https://docs.xfers.io/)

## Overview

This README contains information regarding the big picture of Xfers' approach to API documentation. To get the detailed information on how the parser or front end works refer to the dir README. Client facing interface check `react-pages` directory. For information on the `Parser` check `ruby-parser`directory.

## Problem

1. Xfers have multiple products that currently require different documentation.
  - Manually creating the documentation for each product is inefficient and problems of inconsistency will arise
  - Any changes made to the endpoints that are used by multiple documentations require changes to be made manually to each documentation

## Approach

To tackle the above problems, this repo aims to create a way of documentation at a higher level of abstraction. Any changes made to the documentation should only be made to 1 source to ensure efficiency and standardization.

**Flow**

![image](https://user-images.githubusercontent.com/49265907/62617122-6037f600-b93b-11e9-8af2-7e2d3d712157.png)

1. Any changes Xfers wants to make will be made to `/react-page/src/oas_spec/master-openapi.json`
  - `master-openapi.json` will contain all of Xfers endpoints (Singapore-specific and Indonesia-specific) and all of Xfers parameters
2. Run `cd ruby-parser` in the root directory and execute `rake generate` in the command line. This will:
  - read and parse the local `/react-page/src/oas_spec/master-openapi.json`
  - create 2 `.json` files: `Singapore.json` and `Indonesia.json`(or merchant specific Documents). These files will be written to `/react-page/src/oas_spec`
  - The json file will be generated in accordance to `/ruby-parser/config/oas.yml`, where you can state the endpoints you want in each documentation by stating it under the `paths` field (e.g. `"/user/activities"` and `"/authorize*"`
3. The github pages that host our docuementation is built according to json files in the `/react-page/src/oas_spec/` folder. Once the json files have been written into the directory, the page will be updated.

## Features
1. Ability to generate any number of customized documentation quickly by changing `ruby-parser/config/oas.yml`
2. Ability to define specific parameters for different sets of documentation by adding this fied
`"x-custom-params"`. More info [here](https://github.com/Xfers/oas-api-docs/tree/master/react-page/src/oas_spec)
3. Ability to state custom parameter requires wrt to the country add this field ` "x-custom-params-requirements"`
4. API docs analytics powered by Google Analytics(WIP)

## How to contribute

1. Changes to  Client facing [interface](https://xfers.github.io/oas-api-docs/)
  - Refer to [/reac-pages/README.md](https://github.com/Xfers/oas-api-docs/tree/master/react-page)
  
2. Changes to behavior and functionality of Parser
  - Refer to [/ruby-parser/README.md](https://github.com/Xfers/oas-api-docs/tree/master/ruby-parser)
  
3. Changes to content of the docuementation rendered to the client see below

- Refer to [/src/oas_spec/README.md](https://github.com/Xfers/oas-api-docs/tree/master/react-page/src/oas_spec) for information on details on OAS

**Optional Env setup(make your life easier)**
- Download VS Code [OpenAPI (Swagger) editor](https://marketplace.visualstudio.com/items?itemName=42Crunch.vscode-openapi)
- Download [openapi-lint](https://marketplace.visualstudio.com/items?itemName=mermade.openapi-lint)

## How to make changes to documentation

**Env Setup**
1. clone entire repo
2. `cd react-page`
3. `npm install`
4. `cd ..`
5. `cd ruby-parser`
6. `bundle install`

**Generate new documentation for all merchants**

MAKE SURE YOU ARE IN `react-page` folder

1. `npm start`
2. open `http://localhost:3000/V3/Master`
3. make desired changes to `master-openapi.json`. When you save changes `http://localhost:3000/V3/Master` will hot reload and you can review the changes you made
4. Once satisfied cd to `ruby-parser` and run `rake generate`
5. View changes made to client facing interface on `http://localhost:3000`
6. Create PR and let PM/Engineer review
7. Once approved run `npm run deploy` in `react-page`
8. Changes will be seen on `docs.xfers.io`

**Generate new documentation for a specific merchant**

1. open `/ruby-parser/config/oas.yml`
2. add a new object at the bottom of the yaml file following this format stated
3. run `rake generate` in `ruby-parser`
4. open `/react-pages/src/pages/TemplateOas.js`
5. Make changes according to comment and save as new file(name of file: {doc-name}.js)
6. open `/react-pages/src/App.js` and make changes according to the comment(make sure you do not delete the comments)
7. run `npm run` in `react-page` and check doc in `http://localhost:3000/V3/{doc-name}`
8. Once satisfied create PR and let PM/Engineer review
9. Once approved run `npm run deploy` in `react-page`
10. Changes will be seen on `docs.xfers.io`

## API V4
Refer to PR https://github.com/Xfers/oas-api-docs/pull/2 for front end changes
Refer to Issue https://github.com/Xfers/Xfers/issues/11078 for the complete picture


## Xfers / Redoc specific functions(MUST READ BEFORE EDITING OAS DEFINITION!)

Here are information that you cannot find anywhere on the interent. Read this to save your time googling it.

### Xfers specific functions

1. To have path/query/requestBody parameters only present in certain document
- This code will only work if you add into `Parameter Object` and `Schema Object` 
- Legend: `doc_nameX => the name of the document(as per config.yml)`
```
"x-custom-params" : ["doc_name1","doc_name2"],
```
2. To have certain parameters only required for certain document
- This code will only work if you add into `Shema Object` in requestBody
- Legend: `doc_nameX => the name of the document(as per config.yml)`, `paramX => the name of parameters you want to be required by only certain documents`

### Redoc specific functions

Documentation [here](https://github.com/Redocly/redoc/blob/master/docs/redoc-vendor-extensions.md#x-tagGroups)

1. Tags that are for general information and have nothing to do with endpoints
- This code will only work if you add into `Tags Object` in `"tags"`
```
"x-traitTag" : true
```

2. To add sample `curl or ...` http request
```
"x-code-samples": [{
  "lang": "Shell_curl", //Lang of request
  "source": "curl --location --request ..." //example of curl request
}],
```
