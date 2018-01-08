defmodule Polytext do
  @voice_ids %{
    english:    "Joanna",
    korean:     "Seoyeon",
    french:     "Celine",
    german:     "Vicki",
    italian:    "Carla",
    japanese:   "Mizuki",
    norwegian:  "Liv",
    polish:     "Ewa",
    portuguese: "Ines",
    romanian:   "Carmen",
    russian:    "Tatyana",
    spanish:    "Penelope",
    turkish:    "Filiz"
  }

  def languages, do: Map.keys(@voice_ids)
  def languages_string, do: Map.keys(@voice_ids) |> Enum.map(&Atom.to_string/1)

  def voice_id(language) do
    Map.fetch!(@voice_ids, language)
  end
end
