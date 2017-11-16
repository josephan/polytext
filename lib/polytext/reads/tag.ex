defmodule Polytext.Reads.Tag do
  use Ecto.Schema
  import Ecto.Changeset
  alias Polytext.Reads.{Document, Tag}


  schema "tags" do
    field :name, :string

    many_to_many :tags, Document, join_through: "document_tags"

    timestamps()
  end

  @doc false
  def changeset(%Tag{} = tag, attrs) do
    tag
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
