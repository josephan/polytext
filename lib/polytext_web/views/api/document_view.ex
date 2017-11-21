defmodule PolytextWeb.Api.DocumentView do
  use PolytextWeb, :view
  alias PolytextWeb.Api.{DocumentView, SentenceView}

  def render("index.json", %{documents: documents}) do
    %{data: render_many(documents, DocumentView, "document.json")}
  end

  def render("show.json", %{document: document}) do
    %{data: render_one(document, DocumentView, "document_with_sentences.json")}
  end

  def render("document.json", %{document: document}) do
    %{id: document.id,
      title: document.title}
  end

  def render("document_with_sentences.json", %{document: document}) do
    %{id: document.id,
      title: document.title,
      sentences: render_many(document.sentences, SentenceView, "sentence_with_translations.json")}
  end
end
