import React from 'react';
import socket from './socket.js';

class DocumentEditor extends React.Component {
  constructor(props) {
    super(props);
  }

  componentDidMount() {
    socket.connect();
    console.log(socket);
    let channel = socket.channel(`user:${window.userToken}`);
    console.log(channel);
    channel.join()
      .receive('ok', (resp) => {
        console.log('joined!');
      })
      .receive('error', (resp) => {
        console.log('could not join!');
      });
  }

  render() {
    return (
      <h1>Hello World</h1>
    );
  }
}

export default DocumentEditor;
