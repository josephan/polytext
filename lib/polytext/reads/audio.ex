defmodule Polytext.Reads.Audio do
  use Ecto.Schema
  import Ecto.Changeset
  alias Polytext.Reads.{Audio, Sentence}

  schema "audios" do
    field :source_url, :string
    field :text_hash, :string
    field :language, LanguageEnum

    belongs_to :sentence, Sentence

    timestamps()
  end

  @doc false
  def changeset(%Audio{} = audio, attrs) do
    audio
    |> cast(attrs, [:audio_url, :language, :text_hash])
    |> validate_required([:audio_url, :language, :text_hash])
    |> unique_constraint(:language, name: :speeches_document_id_language_index)
  end
end
