defmodule PolytextWeb.Api.TranslationView do
  use PolytextWeb, :view

  def render("translation.json", %{translation: translation}) do
    %{id: translation.id,
      language: translation.language,
      audio_uri: translation.audio_uri,
      text: translation.text}
  end
end
