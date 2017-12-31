import React from 'react';
import moment from 'moment';
import socket from './socket.js';

class DocumentEditor extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      title: props.document.title,
      sentences: props.document.sentences,
      lastSaved: null,
    }

    this.handleTitleChange = this.handleTitleChange.bind(this);
    this.handleTextChange  = this.handleTextChange.bind(this);
    this.saveDocument      = this.saveDocument.bind(this);
    this.updateSaved       = this.updateSaved.bind(this);
    this.createSentence    = this.createSentence.bind(this);
    this.addSentence       = this.addSentence.bind(this);
    this.deleteSentence    = this.deleteSentence.bind(this);
    this.removeSentence    = this.removeSentence.bind(this);
  }

  componentDidMount() {
    socket.connect();
    this.channel = socket.channel(`document:${this.props.document.id}`);
    this.channel.join()
      .receive('ok', (resp) => {
        console.log('joined!');
      })
      .receive('error', (resp) => {
        console.log('could not join!');
      });

    this.channel.on('updated_at', (payload) => { this.updateSaved(payload.timestamp) });
    this.channel.on('add_sentence', (payload) => { this.addSentence(payload) });
    this.channel.on('delete_sentence', (payload) => { this.removeSentence(payload.id) });
  }

  addSentence(payload) {
    this.setState(state => ({sentences: [...state.sentences, payload]}));
  }

  removeSentence(sentence_id) {
    this.setState(state => ({sentences: state.sentences.filter(s => s.id !== sentence_id)}));
  }

  updateSaved(timestamp) {
    this.setState({lastSaved: moment.unix(timestamp).format("LTS")});
  }

  handleTitleChange(event) {
    this.setState({title: event.target.value});
  }

  handleTextChange(event, sentenceId, translationId) {
    const newSentences = this.state.sentences;
    const sInd = newSentences.findIndex(s => s.id === sentenceId);
    const tInd = newSentences[sInd].translations.findIndex(t => t.id === translationId);
    newSentences[sInd].translations[tInd].text = event.target.value;
    this.setState({sentences: newSentences});
  }

  saveDocument() {
    this.updateDocument(this.state.title, this.state.sentences);
  }

  updateDocument(title, sentences) {
    this.channel.push('update_document', {title: title, sentences: sentences});
  }

  createSentence() {
    this.channel.push('add_sentence', {});
  }

  deleteSentence(sentence_id) {
    this.channel.push('delete_sentence', {id: sentence_id});
  }

  render() {
    return (
      <div className="document-editor">
        <button className="btn btn-outline-primary mr-3" onClick={this.saveDocument}>Save Changes</button>
        {this.state.lastSaved && <span className="oi oi-check mr-1 text-success" aria-hidden="true"></span>}
        <span className="text-secondary">{this.state.lastSaved && `Last Saved: ${this.state.lastSaved}`}</span>
        <div className="document-page">
          <input type="text" className="title mb-1" value={this.state.title} onChange={this.handleTitleChange} />
          {this.state.sentences.map((s, i) => (
            <Sentence
              key={s.id}
              sentence={s}
              handleTextChange={this.handleTextChange}
              deleteSentence={this.deleteSentence}
            />
          ))}
          <button className="btn btn-outline-info btn-sm mt-4" onClick={this.createSentence}>Add New Sentence</button>
        </div>
      </div>
    );
  }
}

class Sentence extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      showOptions: false,
    };

    this.showOptions = this.showOptions.bind(this);
    this.hideOptions = this.hideOptions.bind(this);
  } 

  showOptions() {
    this.setState({showOptions: true});
  }

  hideOptions() {
    this.setState({showOptions: false});
  }

  render() {
    const s = this.props.sentence;
    const sRowClass = this.state.showOptions ? 'row-highlighted' : '';
    const sRowBtnClass = this.state.showOptions ? styles.showButton : {};

    return (
      <div className={`sentence-row ${sRowClass}`} onMouseOver={this.showOptions} onMouseLeave={this.hideOptions}>
        {s.translations.map(t => (
          <input type="text"
            style={(t.text === "" || t.text === null) ? styles.emptySentence : {}}
            className="translation mr-1"
            key={t.id}
            value={t.text}
            onChange={(e) => { this.props.handleTextChange(e, s.id, t.id) }} />
        ))}
        <div className="sentence-options">
          <button className="btn btn-outline-dark btn-sm" style={sRowBtnClass} onClick={() => { this.props.deleteSentence(s.id) }}>
            <span className="oi oi-x close-button" aria-hidden="true"></span>
          </button>
        </div>
      </div>
    );
  }
}

const styles = {
  emptySentence: {
    borderBottom: '2px solid black',
  },
  showButton: {
    visibility: 'visible',
  }
}

$(function () {
  $('[data-toggle="tooltip"]').tooltip()
})

export default DocumentEditor;
