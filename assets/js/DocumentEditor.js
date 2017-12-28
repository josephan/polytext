import React from 'react';
import moment from 'moment';
import socket from './socket.js';

class DocumentEditor extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      title: props.document.title,
      lastSaved: null,
    }

    this.handleTitleChange = this.handleTitleChange.bind(this);
    this.saveDocument = this.saveDocument.bind(this);
    this.updateSaved = this.updateSaved.bind(this);
  }

  componentDidMount() {
    socket.connect();
    // let channel = socket.channel(`document:${this.props.document.id}`);
    this.channel = socket.channel(`document:${this.props.document.id}`);
    this.channel.join()
      .receive('ok', (resp) => {
        console.log('joined!');
      })
      .receive('error', (resp) => {
        console.log('could not join!');
      });

    this.channel.on('updated_at', (payload) => { this.updateSaved(payload.timestamp) })
  }

  updateSaved(timestamp) {
    this.setState({lastSaved: moment.unix(timestamp).format("LTS")})
  }

  handleTitleChange(event) {
    this.setState({title: event.target.value});
  }

  saveDocument() {
    this.updateTitle(this.state.title);
  }

  updateTitle(title) {
    this.channel.push('update_title', {title: title});
  }

  render() {
    const doc = this.props.document;

    return (
      <div className="document-editor">
        <button className="btn btn-primary mr-3" onClick={this.saveDocument}>Save Changes</button>
        {this.state.lastSaved && <span className="oi oi-check mr-1 text-success" aria-hidden="true"></span>}
        <span className="text-secondary">{this.state.lastSaved && `Last Saved: ${this.state.lastSaved}`}</span>
        <div className="document-page">
          <input type="text" className="title" value={this.state.title} onChange={this.handleTitleChange} />
          {doc.sentences.map(s => (
            <div className="sentence-row" key={s.id}>
              {s.translations.map(t => (
                <input type="text" className="translation" key={t.id} value={t.text} />
              ))}
            </div>
          ))}
        </div>
      </div>
    );
  }
}

export default DocumentEditor;
