import React from 'react';
import { Button, Dropdown, Flag, Icon } from 'semantic-ui-react'


const DropdownCountry = props => {

  const options = [
    {
      key: "Singapore",
      text: (
        <span>
          <Flag name="sg" />
          Singapore
        </span>
      ),
      value: "Singapore"
    },
    {
      key: "Indonesia",
      text: (
        <span>
          <Flag name="id" />
          Indonesia
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
  console.log(options.map(x => {
        if(x.value == country) {
          return x;
        }
      }))
  return(

    <Dropdown
      placeholder = {<span> Select Country <Icon name="world"/> </span>}
      compact
      onChange = {(e,{value}) => handleChange(e,value)}
      selection
      options = {options}

    />
  )
}

export default DropdownCountry;
