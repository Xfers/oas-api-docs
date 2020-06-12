import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';
import LandingPage from './pages/LandingPage.js'
import XfersRedoc from './components/XfersRedoc.js'
import { Route, BrowserRouter as Router, Switch  } from 'react-router-dom'
import * as serviceWorker from './serviceWorker';
import {Flag } from 'semantic-ui-react';
import 'semantic-ui-css/semantic.min.css';
import ErrorPage from "./pages/ErrorPage.js"

const routing = (
	<Router
	basename={process.env.PUBLIC_URL}
	>
	<div>
		<Switch>
			<Route exact path="/" render={(props) => props.history.push(eval(`"Singapore"`))} />
			<Route exact path="/Singapore" render={(props) => <XfersRedoc
				{...props}
				oasSpec={require('./oas_spec/sg/index.js')}
				isUrl={false}
				docName={"API documentation for Singapore"}
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
							value: "/Singapore"
						},
						{
							key: "Indonesia",
							text: (
								<span>
									<Flag name="id" />
									ID
								</span>
							),
							value: "/V3/Indonesia"
						}
					]
				}
				/>}
			/>
			<Route exact path="/V3/Indonesia" render={(props) => <XfersRedoc
				{...props}
				oasSpec={require('./oas_spec/indo/index.js')}
				isUrl={false}
				docName={"API documentation for Indonesia"}
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
							value: "/Singapore"
						},
						{
							key: "Indonesia",
							text: (
								<span>
									<Flag name="id" />
									ID
								</span>
							),
							value: "/V3/Indonesia"
						}
					]
				}
				/>}
			/>
			<Route exact path="/experiment" render={(props) => <XfersRedoc
				{...props}
				oasSpec={require('./oas_spec/experiment/index.js')}
				isUrl={false}
				docName={"Payment Gateway (Beta version) for Neu"}
				dropDownOptions = {[]}
				/>}
			/>
			<Route exact path="/payment_gateway" render={(props) => <XfersRedoc
				{...props}
				oasSpec={require('./oas_spec/payment_gateway/index.js')}
				isUrl={false}
				docName={"Payment Gateway (Beta version)"}
				dropDownOptions = {[]}
				/>}
			/>
			<Route exact path="/sg/api/cutting-edge" render={(props) => <XfersRedoc
				{...props}
				oasSpec={require('./oas_spec/sg/index.js')}
				isUrl={false}
				docName={"API documentation for Singapore"}
				dropDownOptions = {[]}
				/>}
			/>
			<Route component={ErrorPage} />
		</Switch>
	</div>
</Router>
)

ReactDOM.render(routing, document.getElementById('root'));

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();
