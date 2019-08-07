import React, { Component } from 'react';
import { RedocStandalone } from 'redoc';
import ToTopButton from "../ToTopButton.js";

class MasterOas extends Component {
  constructor(props) {
    super(props);
    this.state = {
      definitionJSON: require('../oas_spec/master-openapi.json'),
      windowWidth: 0,
      windowHeight: 0
    }
    this.updateDimensions = this.updateDimensions.bind(this);
    this.renderLogo = this.renderLogo.bind(this);
    this.convertRemToPixel = this.convertRemToPixel.bind(this);
    this.renderEmptyLogo = this.renderEmptyLogo.bind(this);
  }

  componentDidMount() {
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

  renderLogo(showLogo) {
    if (showLogo) {
      return (
        <div className = "logo-wrapper">
          <img
          className ="logo"
          src={require("../images/Xfers_Blue_120.png")}
          />
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
    return (
      <div className="App" >
        {this.renderLogo(showLogo)}
          <div className="country-header">
            {this.renderEmptyLogo(showLogo)}
            <div className = "title-wrapper">
              <h1
              className="country-header-title"
              >API documentation for Master</h1>
            </div>
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
      </div>
    );
  }
}

export default MasterOas;
