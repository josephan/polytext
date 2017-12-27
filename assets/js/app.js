import React from 'react';
import ReactDOM from 'react-dom';

import "phoenix_html";
import DocumentEditor from './DocumentEditor.js';

const root = document.getElementById("document-editor-root");
if (root !== null) {
  ReactDOM.render(<DocumentEditor document={window.PolytextDocument} />, root);
}
