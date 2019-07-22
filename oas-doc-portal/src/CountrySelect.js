import React from 'react';
import Select from 'react-select';



const CountrySelect = props => {

  const options = [
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

  const customStyles = {
    option: (provided, state) => ({
      ...provided,
      borderBottom: '1px dotted pink',
      color: state.isSelected ? 'red' : 'blue',
      padding: 20,
    }),
    control: () => ({
      // none of react-select's styles are passed to <Control />
      width: 200,
    }),
    singleValue: (provided, state) => {
      const opacity = state.isDisabled ? 0.5 : 1;
      const transition = 'opacity 300ms';

      return { ...provided, opacity, transition };
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
      style = {customStyles}
    />
  )
}

export default CountrySelect;
