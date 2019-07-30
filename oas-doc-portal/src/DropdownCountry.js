import React from 'react';
import { Button, Dropdown } from 'semantic-ui-react'


const DropdownCountry = props => {

  const options = [
    {
      key: "Master",
      text: "Master",
      value: "Master"
    },
    {
      key: "Singapore",
      text: "Singapore",
      value: "Singapore"
    },
    {
      key: "Indonesia",
      text: "Indonesia",
      value: "Indonesia"
    }
  ]

  let country = props.country;

  function handleChange(e,value){
    country = e.value
    props.updateDefinitionJSON(value);
  }

  function getCurrOption() {

    for(let i = 0 ; i < options.length ; i ++) {
      if (options[i].label === country) {
        return options[i]
      }
    }
  }
  console.log(options.map(x => {
        if(x.value == country) {
          return x;
        }
      }))
  return(

    <Dropdown
      text = "Select Country"
      onChange = {(e,{value}) => handleChange(e,value)}
      value = {country}
      selection
      options = {options}

    />
  )
}

export default DropdownCountry;
