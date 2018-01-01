import React from 'react';
import moment from 'moment';
import socket from './socket.js';

class DocumentEditor extends React.Component {
  state = {
    published: this.props.document.published,
    title: this.props.document.title,
    primaryLanguage: this.props.languages[0],
    secondaryLanguage: this.props.languages[1],
    sentences: this.props.document.sentences,
    lastSaved: null,
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
    this.channel.on('toggle_published', (payload) => { this.togglePublishedState(payload.published) });
  }

  addSentence = (payload) => {
    this.setState(state => ({sentences: [...state.sentences, payload]}));
  }

  removeSentence = (sentence_id) => {
    this.setState(state => ({sentences: state.sentences.filter(s => s.id !== sentence_id)}));
  }

  updateSaved = (timestamp) => {
    this.setState({lastSaved: moment.unix(timestamp).format("LTS")});
  }

  changePrimaryLanguage = (event) => {
    this.setState({primaryLanguage: event.target.text})
  }

  changeSecondaryLanguage = (event) => {
    this.setState({secondaryLanguage: event.target.text})
  }


  handleTitleChange = (event) => {
    this.setState({title: event.target.value});
  }

  handleTextChange = (event, sentenceId, language) => {
    const newSentences = this.state.sentences;
    const sInd = newSentences.findIndex(s => s.id === sentenceId);
    newSentences[sInd][language] = event.target.value;
    this.setState({sentences: newSentences});
  }

  saveDocument = () => {
    this.updateDocument(this.state.title, this.state.sentences);
  }

  togglePublish = () => {
    this.channel.push('toggle_publish', {published: !this.state.published})
  }

  togglePublishedState = (published) => {
    this.setState(({published: published}))
  }

  updateDocument = (title, sentences) => {
    this.channel.push('update_document', {title: title, sentences: sentences});
  }

  createSentence = () => {
    this.channel.push('add_sentence', {});
  }

  deleteSentence = (sentenceId) => {
    this.channel.push('delete_sentence', {id: sentenceId});
  }

  render() {
    const publishClass = this.state.published ? "btn-outline-danger" : "btn-info";

    return (
      <div className="document-editor">
        <button className={`btn ${publishClass} mr-3`} onClick={this.togglePublish}>{this.state.published ? "Unpublish" : "Publish"}</button>
        <button className="btn btn-primary mr-3" onClick={this.saveDocument}>Save Changes</button>
        {this.state.lastSaved && <span className="oi oi-check mr-1 text-success" aria-hidden="true"></span>}
        <span className="text-secondary">{this.state.lastSaved && `Last Saved: ${this.state.lastSaved}`}</span>
        <div className="document-page">
          <input type="text" className="title mb-2" value={this.state.title} onChange={this.handleTitleChange} placeholder="Enter title here..." />
          <div className="language-select-row mb-2">
            <div className="language-select-column">
              <LanguageSelector
                selectedLanguage={this.state.primaryLanguage}
                changeLanguage={this.changePrimaryLanguage}
                languages={this.props.languages}/>
            </div>
            <div className="language-select-column">
              <LanguageSelector
                selectedLanguage={this.state.secondaryLanguage}
                changeLanguage={this.changeSecondaryLanguage}
                languages={this.props.languages}/>
            </div>
            <div className="invisible" style={styles.hiddenOffset}></div>
          </div>
          {this.state.sentences.map((s, i) => (
            <Sentence
              key={s.id}
              sentence={s}
              primary={this.state.primaryLanguage}
              secondary={this.state.secondaryLanguage}
              handleTextChange={this.handleTextChange}
              deleteSentence={this.deleteSentence}
            />
          ))}
          <button className="btn btn-outline-primary btn-sm mt-4" onClick={this.createSentence}>Add New Sentence</button>
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
    const { sentence, primary, secondary, handleTextChange } = this.props;
    const sRowClass = this.state.showOptions ? 'row-highlighted' : '';
    const sRowBtnClass = this.state.showOptions ? styles.showButton : {};

    return (
      <div className={`sentence-row ${sRowClass}`}
        onMouseOver={this.showOptions}
        onMouseLeave={this.hideOptions}>
        <SentenceInput
          text={sentence[primary] || ""}
          language={primary}
          sentenceId={sentence.id}
          handleTextChange={handleTextChange}
        />
        <SentenceInput
          text={sentence[secondary] || ""}
          language={secondary}
          sentenceId={sentence.id}
          handleTextChange={handleTextChange}
        />
        <div className="sentence-options">
          <button className="btn btn-outline-dark btn-sm"
            style={sRowBtnClass}
            onClick={() => { this.props.deleteSentence(sentence.id) }}>
            <span className="oi oi-x close-button" aria-hidden="true"></span>
          </button>
        </div>
      </div>
    );
  }
}

const LanguageSelector = (props) => {
  return (
    <div className="btn-group">
      <button className="btn btn-outline-primary btn-sm dropdown-toggle" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
        {props.selectedLanguage}
      </button>
      <div className="dropdown-menu">
        {props.languages.map((language, i) => (
          <a key={i} className="dropdown-item" onClick={props.changeLanguage}>{language}</a>
        ))}
      </div>
    </div>
  );
}

const SentenceInput = (props) => {
  return (
    <input type="text"
      style={(props.text === "") ? styles.emptySentence : {}}
      className="translation mr-1"
      value={props.text}
      onChange={(e) => { props.handleTextChange(e, props.sentenceId, props.language) }} />
  )
}

const styles = {
  emptySentence: {
    borderBottom: '2px solid black',
  },
  showButton: {
    visibility: 'visible',
  },
  hiddenOffset: {
    width: 35,
  },
}

$(function () {
  $('[data-toggle="tooltip"]').tooltip()
})

export default DocumentEditor;
