defmodule Polytext.Reads.Translation do
  use Ecto.Schema
  import Ecto.Changeset
  alias Polytext.Reads.{Sentence, Translation}

  schema "translations" do
    field :audio_uri, :string
    field :language, :integer
    field :text, :string

    belongs_to :sentence, Sentence

    timestamps()
  end

  @doc false
  def changeset(%Translation{} = translation, attrs) do
    translation
    |> cast(attrs, [:text, :language, :audio_uri])
    |> validate_required([:text, :language, :audio_uri])
  end
end
