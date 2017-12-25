defmodule Polytext.Reads.Speech do
  use Ecto.Schema
  import Ecto.Changeset
  alias Polytext.Reads.{Speech, Document}

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

  schema "speeches" do
    field :audio_url, :string
    field :text_hash, :string
    field :language, LanguageEnum

    belongs_to :document, Document

    timestamps()
  end

  @doc false
  def changeset(%Speech{} = speech, attrs) do
    speech
    |> cast(attrs, [:audio_url, :language])
    |> validate_required([:audio_url, :language])
    |> unique_constraint(:language, name: :speeches_document_id_language_index)
  end
end
