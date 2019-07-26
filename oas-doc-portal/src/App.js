import React, { Component } from 'react';
import './App.css'
import { RedocStandalone } from 'redoc';
import CountrySelect from "./CountrySelect.js";
import Select from 'react-select';
import { StickyContainer, Sticky } from 'react-sticky';

class App extends Component {
  constructor(props) {
    super(props);
    this.state = {
      sgOasDoc: require('/Users/tandeningklement/Desktop/Parser/oas-doc-portal/src/oas_spec/Singapore.json'),
      idOasDoc: require('/Users/tandeningklement/Desktop/Parser/oas-doc-portal/src/oas_spec/Indonesia.json'),
      masterOasDoc: require('/Users/tandeningklement/Desktop/Parser/oas-doc-portal/src/oas_spec/master-openapi.json'),
      country: "Master",
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
    else if (country === "Master") {
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
        <StickyContainer>
        <div >
          <Sticky>{({ style,isSticky }) =>
            <CountrySelect
              country = {this.state.country}
              updateDefinitionJSON = {this.updateDefinitionJSON}
            />}
           </Sticky>

            <Sticky>{({ style,isSticky }) =>
              <h1 style={style}>API documentation for {this.state.country}</h1>}
            </Sticky>

          </div>
        <RedocStandalone
          spec={this.state.definitionJSON}
          options={{
            nativeScrollbars: true,
            theme: { colors: { primary: { main: '#dd5522' } } },
          }}
        />
        </StickyContainer>
      </div>
    );
  }
}

export default App;
