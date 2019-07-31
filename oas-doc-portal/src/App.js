import React, { Component } from 'react';
import {BrowserRouter as Router, Route} from 'react-router-dom';
import './App.css'
import { RedocStandalone } from 'redoc';
import { Dropdown } from 'semantic-ui-react'
import DropdownCountry from "./DropdownCountry.js";
import MasterOas from "./pages/MasterOas"
import ReactGA from 'react-ga';

ReactGA.initialize("UA-144834615-1");

class App extends Component {
  constructor(props) {
    super(props);
    this.state = {
      sgOasDoc: require('/Users/tandeningklement/Desktop/Parser/oas-doc-portal/src/oas_spec/Singapore.json'),
      idOasDoc: require('/Users/tandeningklement/Desktop/Parser/oas-doc-portal/src/oas_spec/Indonesia.json'),
      country: "Singapore",
      definitionJSON: null,
    }
    this.updateDefinitionJSON = this.updateDefinitionJSON.bind(this)
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
      console.log("app "+country)
      throw new Error("Invalid country name check string");
    }
  }

  componentWillMount() {
    this.updateDefinitionJSON(this.state.country)
  }

  render() {
    return (
      <Router
      basename ="/dynamic-api-doc">
        <div className="App" >
            <Route exact path="/" render={props => (
              <React.Fragment>
                <div className="country-header">
                  <h1
                  className="country-header-title"
                  >API documentation for {this.state.country}</h1>
                  <DropdownCountry
                    className="country-header-dropbox"
                    country = {this.state.country}
                    updateDefinitionJSON = {this.updateDefinitionJSON}
                  />
                </div>

              <RedocStandalone
                spec={this.state.definitionJSON}
                options={{
                  nativeScrollbars: true,
                  theme: { colors: { primary: { main: '#dd5522' } } },
                  pathInMiddlePanel: true,
                  jsonSampleExpandLevel: 5,
                  requiredPropsFirst: true,
                }}
              />
            </React.Fragment>
          )} />
            <Route path="/master" component={MasterOas}/>
        </div>
      </Router>
    );
  }
}

export default App;
