import React from 'react';
import ReactDOM from 'react-dom';

class SentenceEditor extends React.Component {
  render() {
    return (
      <div>
        <h4>Content</h4>
      </div>
    );
  }
}

ReactDOM.render(
  <SentenceEditor />,
  document.getElementById("react-sentence-editor")
)
