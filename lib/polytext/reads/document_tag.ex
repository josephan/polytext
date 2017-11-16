defmodule Polytext.Reads.DocumentTag do
  use Ecto.Schema
  import Ecto.Changeset
  alias Polytext.Reads.DocumentTag


  schema "document_tags" do
    field :document_id, :id
    field :tag_id, :id

    timestamps()
  end

  @doc false
  def changeset(%DocumentTag{} = document_tag, attrs) do
    document_tag
    |> cast(attrs, [])
    |> validate_required([])
  end
end
