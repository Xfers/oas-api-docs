import React, {Component} from 'react'
import './LandingPage.css'
import {Dropdown, Button} from 'semantic-ui-react'

const apiVersionOptions = [
	{
		text: 'API V3',
		value: 'V3',
	},
	{
		text: 'API V4',
		value: 'V4',
	}
]
const countryOptions = [
	{
		text: 'Singapore',
		value: 'Singapore',
		flag: 'sg'
	},
	{
		text: 'Indonesia',
		value: 'Indonesia',
		flag: 'sg'
	}
]

class ErrorPage extends Component {
	constructor(props){
		super(props)
		this.state = {
			apiVersion: null,
			country: null
		}
		this.onCountryChange = this.onCountryChange.bind(this)
		this.onApiVersionChange = this.onApiVersionChange.bind(this)
		this.onEnterClick = this.onEnterClick.bind(this)
		this.canEnter = this.canEnter.bind(this)
	}

	onCountryChange(e,{value}){
		this.setState({
			country: value
		})
	}
	onApiVersionChange(e,{value}){
		this.setState({
			apiVersion: value
		})
	}
	onEnterClick(e,{value}){
		let path = "/" + this.state.apiVersion +"/"+ this.state.country
		this.props.history.push(eval('`'+path+'`'))
	}
	canEnter(){
		return this.state.apiVersion == null || this.state.country == null
	}
	render(){
  	return (
			<div className="wrap">
				<div className="title">
					<h1>404 - page not found</h1>
					<div className="buttons">
						<div className="dropdown-api-version">
							<Dropdown
								placeholder='API Version'
								selection
								fluid
								onChange = {(e,{value}) => this.onApiVersionChange(e,{value})}
								options={apiVersionOptions}
							/>
						</div>
						<div className="dropdown-country">
							<Dropdown
								placeholder='Country'
								selection
								fluid
								onChange = {(e,{value}) => this.onCountryChange(e,{value})}
								options={countryOptions}
							/>
						</div>
						<Button
						compact
						disabled = {this.canEnter()}
						onClick = {(e,{value}) => this.onEnterClick(e,{value})}
						circular>
							Enter
						</Button>
					</div>
				</div>
			</div>
		)
	}
}


export default ErrorPage;