defmodule Polytext.Reads do
  import Ecto.Query, warn: false
  alias Polytext.Repo
  alias Polytext.Reads.Document

  def get_document!(id), do: Repo.get!(Document, id)

  def list_documents, do: Repo.all(Document)
  def list_documents(user) do
    Repo.all(
      from d in Document,
      where: d.user_id == ^user.id
    )
  end

  def change_document(%Document{} = document) do
    Document.changeset(document, %{})
  end

  def create_document(attrs \\ %{}) do
    %Document{}
    |> Document.changeset(attrs)
    |> Repo.insert()
  end

  def update_document(%Document{} = document, attrs) do
    document
    |> Document.changeset(attrs)
    |> Repo.update()
  end

  def delete_document(%Document{} = document) do
    Repo.delete(document)
  end
end
