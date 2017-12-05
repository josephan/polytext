defmodule Polytext.Reads.Translation do
  use Ecto.Schema
  import Ecto.Changeset
  alias Polytext.Reads.{Sentence, Translation}

  schema "translations" do
    field :language, LanguageEnum
    field :text, :string

    belongs_to :sentence, Sentence

    timestamps()
  end

  @doc false
  def changeset(%Translation{} = translation, attrs) do
    translation
    |> cast(attrs, [:text, :language])
    |> validate_required([:text, :language])
  end
end
