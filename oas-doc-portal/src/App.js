import React, { Component } from 'react';
import './App.css'
import SwaggerUI from 'swagger-ui';
import '../node_modules/swagger-ui/dist/swagger-ui.css'
import CountrySelect from "./CountrySelect.js";
import Select from 'react-select';

class App extends Component {
  constructor(props) {
    super(props);
    this.state = {
      sgOasDoc: require('/Users/tandeningklement/Desktop/Parser/oas-doc-portal/src/oas_spec/Singapore.json'),
      idOasDoc: require('/Users/tandeningklement/Desktop/Parser/oas-doc-portal/src/oas_spec/Indonesia.json'),
      country: "Indonesia",
      definitionJSON: null,
    }
    this.updateDefinitionJSON = this.updateDefinitionJSON.bind(this)
  }

  updateDefinitionJSON(country){
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

  componentDidUpdate(){
    SwaggerUI({
      domNode: document.getElementById("api-data"),
      spec: this.state.definitionJSON
    })
  }

  componentWillMount() {
    this.updateDefinitionJSON(this.state.country)
  }

  componentDidMount() {
    if (this.state.definitionJSON !== null) {
      SwaggerUI({
        domNode: document.getElementById("api-data"),
        spec: this.state.definitionJSON
      })
    } else {
      throw new Error(this.state.definitionJSON);
    }
  }


  render() {
    return (
      <div className="App" >
        <div style={{
          display: 'block',
          textAlign: 'center'
        }} >
          <CountrySelect
            country = {this.state.country}
            updateDefinitionJSON = {this.updateDefinitionJSON}
            style={{
              width: 200,
              float: 'left'
            }}
          />

          <title
          style = {{
            display: "inline",
            fontSize: 56,
          }}
          >API documentation for {this.state.country}</title>
          </div>
        <div id="api-data" />
      </div>
    );
  }
}

export default App;
