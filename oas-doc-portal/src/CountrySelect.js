import React from 'react';
import Select from 'react-select';



const CountrySelect = props => {

  const options = [
    {label: "Master", value: "Master"},
    {label: "Singapore", value: "Singapore"},
    {label: "Indonesia", value: "Indonesia"}
  ]

  let country = props.country;

  function handleChange(e){
    country = e.value
    props.updateDefinitionJSON(country);
  }

  function getCurrOption() {

    for(let i = 0 ; i < options.length ; i ++) {
      if (options[i].label === country) {
        return options[i]
      }
    }
  }

  return(

    <Select
      isSearchable = {false}
      value = {options.map(x => {
        if(x.value == country) {
          return x;
        }
      })}
      onChange = {(e) => handleChange(e)}
      options = {options}
      autoFocus = "true"
    />
  )
}

export default CountrySelect;
