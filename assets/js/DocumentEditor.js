import React from 'react';
import socket from './socket.js';

class DocumentEditor extends React.Component {
  constructor(props) {
    super(props);
  }

  componentDidMount() {
    socket.connect();
    // let channel = socket.channel(`document:${this.props.document.id}`);
    let channel = socket.channel(`document:${this.props.document.id}`);
    channel.join()
      .receive('ok', (resp) => {
        console.log('joined!');
      })
      .receive('error', (resp) => {
        console.log('could not join!');
      });
  }

  render() {
    const doc = this.props.document;

    return (
      <div>
        <h1>{doc.title}</h1>
        {doc.sentences.map(s => (
          <div key={s.id}>
            {s.translations.map(t => (
              <p key={t.id}>{t.text}</p>
            ))}
          </div>
        ))}
      </div>
    );
  }
}

export default DocumentEditor;
