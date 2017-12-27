defmodule Polytext.Reads.Sentence do
  use Ecto.Schema
  import Ecto.Changeset
  alias Polytext.Reads.Sentence
  alias Polytext.Reads.{Document, Sentence, Translation}


  @derive {Poison.Encoder, only: [:id, :translations]}
  schema "sentences" do
    belongs_to :document, Document
    has_many :translations, Translation

    timestamps()
  end

  @doc false
  def changeset(%Sentence{} = sentence, attrs) do
    sentence
    |> cast(attrs, [])
    |> validate_required([])
  end
end
