import React, {Component} from 'react';
import { Button, Icon } from 'semantic-ui-react'

class ToTopButton extends Component {

  constructor() {
    super();

    this.state = {
        intervalId: 0,
        scrollStepInPx: "50",
        delayInMs: "16.66"
    };
  }

  scrollStep() {
    if (window.pageYOffset === 0) {
        clearInterval(this.state.intervalId);
    }
    window.scroll(0, window.pageYOffset - this.props.scrollStepInPx);
  }

  scrollToTop() {
    let intervalId = setInterval(this.scrollStep.bind(this), this.props.delayInMs);
    this.setState({ intervalId: intervalId });
  }

  render(){
    return(
      <Button
      circular
      active
      icon
        onClick={ () => { this.scrollToTop(); }}
      >
        <Icon name="chevron circle up"/>
      </Button>
    )
  }
}

export default ToTopButton;
