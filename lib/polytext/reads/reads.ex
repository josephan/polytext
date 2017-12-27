defmodule Polytext.Reads do
  import Ecto.Query, warn: false
  alias Polytext.Repo
  alias Polytext.Reads.{Document, Multi}

  def get_document!(id) do
    Repo.one! from doc in Document,
      where: doc.id == ^id,
      left_join: sen in assoc(doc, :sentences),
      left_join: tra in assoc(sen, :translations),
      preload: [sentences: {sen, translations: tra}]
  end

  def get_document_with_user!(id, user_id) do
    Repo.one! from doc in Document,
      join: user in assoc(doc, :user),
      where: doc.id == ^id and user.id == ^user_id,
      left_join: sen in assoc(doc, :sentences),
      left_join: tra in assoc(sen, :translations),
      preload: [user: user, sentences: {sen, translations: tra}]
  end

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

  def create_document(attrs \\ %{}, user) do
    %Document{}
    |> Document.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end

  def create_document_with_csv(attrs \\ %{}) do
    attrs
    |> Multi.DocumentWithCSV.create()
    |> Repo.transaction()
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
