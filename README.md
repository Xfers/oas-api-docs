This repo is for Xfers' API documentation.
Beta site for API documentation (https://xfers.github.io/oas-api-docs/)

## Overview

This README contains information regarding the big picture of Xfers' approach to API documentation. To get the detailed information
on the OAS definition or Client facing interface check `react-pages` directory. For information on the `Parser` check `ruby-parser`
directory.

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

1. Changes to content of API documentation or Client facing [interface](https://xfers.github.io/oas-api-docs/)
  - Refer to [/reac-pages/README.md](https://github.com/Xfers/oas-api-docs/tree/master/react-page)
2. Changes to behavior and functionality of Parser
  - Refer to [/ruby-parser/README.md](https://github.com/Xfers/oas-api-docs/tree/master/ruby-parser)

