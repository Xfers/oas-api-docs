import React, { Component } from 'react';
import {BrowserRouter as Router, Route} from 'react-router-dom';
import './App.css'
import { RedocStandalone } from 'redoc';
import DropdownCountry from "./DropdownCountry.js";
import MasterOas from "./pages/MasterOas"
import ReactGA from 'react-ga';
import ToTopButton from "./ToTopButton.js";
import API_V4 from "./pages/API_V4.js"
import XfersRedoc from "./components/XfersRedoc.js"
import {Flag } from 'semantic-ui-react'
//import {doc-name} from "./pages/{doc-name}"

ReactGA.initialize("UA-144834615-1");

class App extends Component {
  constructor(props) {
    super(props);
    this.state = {
      sgOasDoc: require('./oas_spec/Singapore.json'),
      idOasDoc: require('./oas_spec/Indonesia.json'),
      country: "Singapore",
      definitionJSON: require('./oas_spec/Singapore.json'),
      windowWidth: 0,
      windowHeight: 0
    }
    this.updateDefinitionJSON = this.updateDefinitionJSON.bind(this);
    this.updateDimensions = this.updateDimensions.bind(this);
    this.renderLogo = this.renderLogo.bind(this);
    this.convertRemToPixel = this.convertRemToPixel.bind(this);
    this.renderEmptyLogo = this.renderEmptyLogo.bind(this);
    this.getCountryForIcon = this.getCountryForIcon.bind(this)

  }

  updateDefinitionJSON(country){
    ReactGA.event({
      category: 'User',
      action: 'Viewing doucmentation for ' + country
    });
    if (country === "Singapore") {
      this.setState({
        definitionJSON: this.state.sgOasDoc,
        country: country
      })
    }
    else if (country === "Indonesia") {
      this.setState({
        definitionJSON: this.state.idOasDoc,
        country: country
      })
    }
    else {
      throw new Error("Invalid country name check string");
    }
  }

  componentDidMount() {
    this.updateDefinitionJSON(this.state.country);
    this.updateDimensions();
    window.addEventListener("resize", this.updateDimensions);
  }

  updateDimensions() {
    let windowWidth = typeof window !== "undefined" ? window.innerWidth : 0;
    let windowHeight = typeof window !== "undefined" ? window.innerHeight : 0;

    this.setState({ windowWidth, windowHeight });
  }

  componentWillUnmount() {

    window.removeEventListener("resize", this.updateDimensions);
  }

  getCountryForIcon(){
    let abrv = ""
    if(this.state.country == "Singapore"){
      abrv = "SG"
    } else if (this.state.country == "Indonesia"){
      abrv = "ID"
    }
    return abrv
  }

  renderLogo(showLogo) {
    if (showLogo) {
      return (
        <div className = "logo-wrapper">
          <img
          className ="logo"
          src={require("./images/Xfers_Blue_120.png")}
          />
          <span
          style={{
            fontWeight: "bold",
            margin: "5px",
          }}
          > {this.getCountryForIcon()}
          </span>
        </div>
      )
    }
  }

  renderEmptyLogo(showLogo) {
    if (showLogo) {
      return (
         <div className = "empty-block">
        </div>
      )
    }
  }

  convertRemToPixel(rem) {
    return rem * 16;
  }

  render() {
    const { windowWidth } = this.state;
    const showLogo = windowWidth > this.convertRemToPixel(50);
    console.log(this.state.loading)
    return (
      <Router
      basename ="/oas-api-docs">
        <div className="App" >
            <Route exact path="/" render={() => (
              <React.Fragment>
                {this.renderLogo(showLogo)}
                <div className="country-header">
                  {this.renderEmptyLogo(showLogo)}
                  <div className = "title-wrapper">
                    <h1
                    className="country-header-title"
                    >API documentation for {this.state.country}</h1>
                  </div>
                  <DropdownCountry
                    className="country-header-dropbox"
                    country = {this.state.country}
                    updateDefinitionJSON = {this.updateDefinitionJSON}
                  />
                </div>
                <div className="up-button">
                  <ToTopButton/>
                </div>
              <RedocStandalone
                spec={this.state.definitionJSON}
                onLoaded={error => {
                  if (!error) {
                    console.log("successfully rendered")
                  }
                }}
                options={{
                  nativeScrollbars: true,
                  theme: { colors: { primary: { main: '#dd5522' } } },
                  pathInMiddlePanel: true,
                  jsonSampleExpandLevel: 5,
                  requiredPropsFirst: true,
                  scrollYOffset: 128,
                  sortPropsAlphabetically: true,
                }}
              />

            </React.Fragment>
          )} />
            <Route exact path="/master" component={MasterOas}/>
            <Route exact path="/API_V4" component={API_V4}/>
            <Route exact path="/test" render={(props) => <XfersRedoc
            {...props}
            oasSpec={require('./oas_spec/Singapore.json')}
            isUrl={false}
            docName={"Singapore"}
            apiVersion = {3}
            dropDownOptions = {
              [
                {
                  key: "Singapore",
                  text: (
                    <span>
                      <Flag name="sg" />
                      SG
                    </span>
                  ),
                  value: "/master"
                },
                {
                  key: "Indonesia",
                  text: (
                    <span>
                      <Flag name="id" />
                      ID
                    </span>
                  ),
                  value: "/API_V4"
                }
              ]
            }
            />
            }/>
          {/* <Route exact path="/{doc-name}" component={{doc-name}}/> */}
        </div>
      </Router>
    );
  }
}

export default App;
