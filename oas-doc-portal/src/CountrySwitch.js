import React from 'react';
import Switch from "react-switch";

const CountrySwitch = props => {

  let currCountry = props.country
  let checked = currCountry === "Singapore"  //Set singapore as checked

  function handleChange(){
    checked = !checked
    console.log(checked)
    if(checked){
      props.updateDefinitionJSON("Singapore")
    } else {
      props.updateDefinitionJSON("Indonesia")
    }


  }

  return (
    <div className = "country-switch">
      <label htmlFor="icon-switch">
        <span> Switch for country </span>
        <Switch
          checked = {checked}
          onChange = {() => handleChange()}
          width = {70}
          uncheckedIcon = {
            <div
              style={{
                display: "flex",
                justifyContent: "center",
                alignItems: "center",
                height: "100%",
                fontSize: 15,
                color: "orange",
                paddingRight: 2
              }}
            >
            <h1> Indo </h1>
            </div>
          }
          checkedIcon = {
            <div
              style={{
                display: "flex",
                justifyContent: "center",
                alignItems: "center",
                height: "100%",
                fontSize: 15,
                color: "orange",
                paddingRight: 2,
              }}
            >
            <h1> SG </h1>
            </div>
          }
        />
      </label>
    </div>
  )
}

export default CountrySwitch;
