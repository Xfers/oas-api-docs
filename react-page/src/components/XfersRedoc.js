import React, { Component } from 'react';
import './XfersRedoc.css'
import { RedocStandalone } from 'redoc';
import DropdownCountry from "./DropdownCountry.js";
import ToTopButton from "./ToTopButton.js";
import PropTypes from 'prop-types';

class XfersRedoc extends Component {
  constructor(props) {
    super(props);
    this.state = {
      windowWidth: 0,
      windowHeight: 0
    }
    this.updateDimensions = this.updateDimensions.bind(this);
    this.renderLogo = this.renderLogo.bind(this);
    this.convertRemToPixel = this.convertRemToPixel.bind(this);
    this.renderEmptyLogo = this.renderEmptyLogo.bind(this);
		this.getCountryForIcon = this.getCountryForIcon.bind(this);
		this.renderRedoc = this.renderRedoc.bind(this);

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

  getCountryForIcon(){
    let abrv = ""
    if(this.props.docName == "Singapore"){
      abrv = "SG"
    } else if (this.props.docName == "Indonesia"){
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
          src={require("../images/Xfers_Blue_120.png")}
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
	
	renderRedoc(isUrl){
		if (isUrl) {
			return(<RedocStandalone
				specUrl = {this.props.oasSpec}
				onLoaded={error => {
					if (!error) {
						console.log("successfully rendered")
					}
				}}
				options={redocOptions}
			/>)
		} else {
			return(<RedocStandalone
				spec = {this.props.oasSpec}
				onLoaded={error => {
					if (!error) {
						console.log("successfully rendered")
					}
				}}
				options={redocOptions}
			/>)
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
			<div className="XfersRedoc" >
				{this.renderLogo(showLogo)}
				<div className="country-header">
					{this.renderEmptyLogo(showLogo)}
					<div className = "title-wrapper">
						<h1
						className="country-header-title"
						>API V{this.props.apiVersion} documentation for {this.props.docName}</h1>
					</div>
					<DropdownCountry
						{...this.props}
						className="country-header-dropbox"
						docName = {this.props.docName}
						dropDownOptions = {this.props.dropDownOptions}
					/>
				</div>
				<div className="up-button">
					<ToTopButton/>
				</div>
				{this.renderRedoc(this.props.isUrl)}
			</div>
    );
  }
}

XfersRedoc.propTypes = {
    oasSpec: PropTypes.string.isRequired,
    isUrl: PropTypes.bool.isRequired,
    docName: PropTypes.string.isRequired,
		apiVersion: PropTypes.number.isRequired,
		dropDownOptions: PropTypes.array.isRequired,
}

const redocOptions = {
	nativeScrollbars: true,
	theme: { colors: { primary: { main: '#dd5522' } } },
	pathInMiddlePanel: true,
	jsonSampleExpandLevel: 5,
	requiredPropsFirst: true,
	scrollYOffset: 128,
	sortPropsAlphabetically: false,
}

export default XfersRedoc;
