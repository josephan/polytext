defmodule Polytext do
  @voice_ids [
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
  ]

  def languages, do: Keyword.keys(@voice_ids)
  def languages_string, do: Keyword.keys(@voice_ids) |> Enum.map(&Atom.to_string/1)
end
