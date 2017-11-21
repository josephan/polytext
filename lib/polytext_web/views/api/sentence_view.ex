defmodule PolytextWeb.Api.SentenceView do
  use PolytextWeb, :view
  alias PolytextWeb.Api.TranslationView

  def render("sentence_with_translations.json", %{sentence: sentence}) do
    %{id: sentence.id,
      translations: render_many(sentence.translations, TranslationView, "translation.json")}
  end
end
