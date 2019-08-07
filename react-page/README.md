# What is this?
This directory powers the API documentation that all Xfers' client will see.

#### Other notes
- Refer to [/src/oas_spec/README.md](https://github.com/Xfers/oas-api-docs/tree/master/react-page/src/oas_spec) for information on details on OAS
- Refer to [/src/template/README.md](/src/template/README.md) for information on how to create a new path for client specific enpoint

# How it works

## Overview
The webpage is powered by `React` with the help of `redoc` for the rendering of nice looking documentation from the
JSON file in `/oas_spec` and `semantic-ui-react` for the interactive components of the webpage.

## Overall TODO
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
