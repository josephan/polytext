defmodule Polytext.Reads.Sentence do
  use Ecto.Schema
  import Ecto.Changeset
  alias Polytext.Reads.{Document, Sentence, Audio}


  @derive {Poison.Encoder, only: [:id | Polytext.languages()]}
  schema "sentences" do
    belongs_to :document, Document
    has_many :audios, Audio

    field :english, :string
    field :korean, :string
    field :french, :string
    field :german, :string
    field :italian, :string
    field :japanese, :string
    field :norwegian, :string
    field :polish, :string
    field :portuguese, :string
    field :romanian, :string
    field :russian, :string
    field :spanish, :string
    field :turkish, :string

    timestamps()
  end

  def to_map(%Sentence{} = sentence) do
    sentence
    |> Map.from_struct()
    |> Map.delete(:__meta__)
    |> Map.delete(:document)
    |> Map.delete(:document_id)
    |> Map.delete(:inserted_at)
    |> Map.delete(:updated_at)
    |> Map.new(fn {k, v} -> {Atom.to_string(k), v} end)
  end

  @doc false
  def changeset(%Sentence{} = sentence, attrs) do
    sentence
    |> cast(attrs, Polytext.languages())
    |> validate_required([])
  end
end
