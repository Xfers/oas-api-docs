import React from 'react';
import { Dropdown, Icon } from 'semantic-ui-react'
import { Redirect } from 'react-router-dom'


const DropdownCountry = props => {

  const options = props.dropDownOptions;

  function handleChange(e,{value}){

    redirectToTarget(value);
  }

  function redirectToTarget(path){
    props.history.push(eval('`'+path+'`'))
  }

  let docName = props.docName;

  function getCurrOption() {

    for(let i = 0 ; i < options.length ; i ++) {
      if (options[i].label === docName) {
        return options[i]
      }
    }
  }

  return(

    <Dropdown
      {...props}
      button
      value = {getCurrOption()}
      placeholder = {<span> <Icon name="world"/> </span>}
      onChange = {(e,{value}) => handleChange(e,{value})}
      options = {options}

    />
  )
}

export default DropdownCountry;
