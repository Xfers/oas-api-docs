import React, { Component } from 'react';
import '.././App.css'
import { RedocStandalone } from 'redoc';

class MasterOas extends Component {
  constructor(props) {
    super(props);
    this.state = {
      masterOasDoc: require('../oas_spec/master-openapi.json'),
      country: "Master",
      definitionJSON: null,
      loading: false
    }
    this.updateDefinitionJSON = this.updateDefinitionJSON.bind(this)
  }

  updateDefinitionJSON(country){
    if (country === "Master") {
      this.setState({
        definitionJSON: this.state.masterOasDoc,
        country: country
      })
    }
    else {
      throw new Error("Invalid country name check string");
    }
  }

  componentWillMount() {
    this.updateDefinitionJSON(this.state.country)
  }

  render() {
    return (
      <div className="App" >
          <h1
            className="country-header-title"
          >API documentation for {this.state.country}</h1>
        <RedocStandalone
          spec={this.state.definitionJSON}
          options={{
            nativeScrollbars: true,
            theme: { colors: { primary: { main: '#dd5522' } } },
            jsonSampleExpandLevel: 0,
            menuToggle: true,
            requiredPropsFirst: true
          }}
        />
      </div>
    );
  }
}

export default MasterOas;
