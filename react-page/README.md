# What is this?
This directory powers the API documentation that all Xfers' client will see.

#### Important README notes
- Refer to [/src/oas_spec/README.md](https://github.com/Xfers/oas-api-docs/tree/master/react-page/src/oas_spec) for information on details on OAS

# How to contribute

## Optional Env setup(make your life easier)
- Download VS Code [OpenAPI (Swagger) editor](https://marketplace.visualstudio.com/items?itemName=42Crunch.vscode-openapi)
- Download [openapi-lint](https://marketplace.visualstudio.com/items?itemName=mermade.openapi-lint)

1. clone entire repo
2. `cd react-page`
3. `npm install`

**Make changes to `master-openapi.json`**

4. `npm start`
5. open `http://localhost:3000/#/master`
6. make desired changes to `master-openapi.json`. When you save changes `http://localhost:3000/#/master` will hot reload and
you can review the changes you made
7. Once satisfied cd to `ruby-parser` and run `rake generate`
8. View changes made to client facing interface on `http://localhost:3000`
9. Create PR and let PM/Engineer review
10. Once approved run `npm run deploy` in `react-page`
11. Changes will be seen on `https://xfers.github.io/oas-api-docs/#/`

**Generate new documentation for a specific merchant**

4. open `/ruby-parser/config/oas.yml`
5. add a new object at the bottom of the yaml file following this format stated
6. run `rake generate` in `ruby-parser`
7. open `/react-pages/src/pages/TemplateOas.json`
8. Make changes according to comment and save as new file(name of file: {doc-name}.js)
9. open `/react-pages/src/App.js` and make changes according to the comment(make sure you do not delete the comments)
10. run `npm run` in `react-page` and check doc in `http://localhost:3000/#/{doc-name}`
11. Once satisfied create PR and let PM/Engineer review
12. Once approved run `npm run deploy` in `react-page`
13. Changes will be seen on `https://xfers.github.io/oas-api-docs/#/{doc-name}`

#### Other notes
- Refer to [/src/oas_spec/README.md](https://github.com/Xfers/oas-api-docs/tree/master/react-page/src/oas_spec) for information on details on OAS

**Known Errors***
If you receive this error message when you run `npm start`
```
./node_modules/redoc/bundles/redoc.lib.js
Module not found: Can't resolve 'core-js/es6/promise' in '/Users/elsha/dynamic-api-doc/oas-doc-portal/node_modules/redoc/bundles'
```

Run this command to resolve the probelm
`npm i -S core-js@2.5.7`

# How it works

## Overview
The webpage is powered by `React` with the help of `redoc` for the rendering of nice looking documentation from the
JSON file in `/oas_spec` and `semantic-ui-react` for the interactive components of the webpage.

## Overall TODO
- [ ] change the domain name from `https://xfers.github.io` to something more professional(Only Victor have access to this)
- [ ] create test for the react site
- [ ] ensure that there is no dependicy issue
- [ ] find a way to optimise speed of loading the react page
- [ ] Implement loading screen

## App.js details

Here contains all the details for the file `/src/App.js`

### Rendering Documents

The main idea behind the webpage is to allow the client to choose which category(country) they are under and from their choice
the webpage will render the correct documentation for them. This is achieved by declaring the props `country: ` in `App.js` and
`DropdownCountry.js` will update this props when the client specifies the category they are under. Singapore is chose by defaul

Whenever there is a change in the props, `updateDefinitionJSON` will update `definitionJSON` to the JSON that tallies to the
client choice. Changes to definitonJSON will cause the site to render again and `<RedocStandalone/>` will generate a new document
based on the new JSON

### Google analytics

This document has analytics feature. This is powered by the `react-ga` package. Basic information such as the number of people
that viewed the site and which category the client chose(Singapore/Indonesia).

**TODO**
- [ ] Find a way to allow google analytics to record which endpoint the user click on in the docuemntation. Log all the url request to
the site
- [ ] Use Xfers' own google analytics key

### Responsive website(Support multiple window size)

Get window size with this [method](https://gist.github.com/ryanjyost/410817395895015731772d451d4d1d80)

The Xfers' logo collapse the same time as Redoc side bar collapse. According to the `Redoc` source code the side bar collaspes
at `50rem`. `convertRemToPixel` converts `rem` to `pixel` according to the default 1:16 ratio.

To make the country header responsive, the font size is `2.5vw`. Refer to [here](https://css-tricks.com/viewport-sized-typography/) for more information

### Routing

`react-router-dom` is used for the routing of the page. `HashRouter` is used instead of the traditional `BrowserRouter` as
github pages will break if is used to render subpages `BrowserRouter`([info](https://levelup.gitconnected.com/deploying-a-create-react-app-with-routing-to-github-pages-f386b6ce84c2)).


For,
```
<Router
      basename ="/oas-api-docs">
        <div className="App" >
            <Route exact path="/" render={props => (
```
is used because github pages will break if you do not specificy basename. More info [here](https://github.community/t5/GitHub-Pages/My-react-project-doesn-t-work-on-github-pages/m-p/19515/highlight/true#M1438).

**TODO**
- [ ] Find a way to get the `rem` to `pixel` ratio from the browser. There could be a chance that the browser ratio is not 1:16
- [ ] Decide on what the header and to top button should happen when the side bar collaspes

## App.css

**TODO**
- [ ] Find a more elegant way to define the `CSS`. A lot of the styling is hard code -> Might fail

## ToTopButton.js

This is the component to bring the user to the top of the page. Implementation adopted from [here](https://codepen.io/Qbrid/pen/GjVvwL).
