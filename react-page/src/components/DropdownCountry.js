import React from 'react';
import { Button, Dropdown, Flag, Icon } from 'semantic-ui-react'


const DropdownCountry = props => {

  const options = [
    {
      key: "Singapore",
      text: (
        <span>
          <Flag name="sg" />
          SG
        </span>
      ),
      value: "Singapore"
    },
    {
      key: "Indonesia",
      text: (
        <span>
          <Flag name="id" />
          ID
        </span>
      ),
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

  return(

    <Dropdown
      button
      placeholder = {<span> <Icon name="world"/> </span>}
      onChange = {(e,{value}) => handleChange(e,value)}
      options = {options}

    />
  )
}

export default DropdownCountry;
