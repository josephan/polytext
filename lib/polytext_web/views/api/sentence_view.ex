defmodule PolytextWeb.Api.SentenceView do
  use PolytextWeb, :view

  def render("sentence.json", %{sentence: sentence}) do
    %{
      id:         sentence.id,
      english:    sentence.english,
      korean:     sentence.korean,
      french:     sentence.french,
      german:     sentence.german,
      italian:    sentence.italian,
      japanese:   sentence.japanese,
      norwegian:  sentence.norwegian,
      polish:     sentence.polish,
      portuguese: sentence.portuguese,
      romanian:   sentence.romanian,
      russian:    sentence.russian,
      spanish:    sentence.spanish,
      turkish:    sentence.turkish
    }
  end
end
