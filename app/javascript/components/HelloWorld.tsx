import React from "react"

interface Props {
  greeting: string
}

class HelloWorld extends React.Component<Props> {

  render () {
    return (
      <React.Fragment>
        Greeting: {this.props.greeting}
      </React.Fragment>
    );
  }
}

export default HelloWorld