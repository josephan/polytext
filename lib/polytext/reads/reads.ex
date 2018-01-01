defmodule Polytext.Reads do
  import Ecto.Query, warn: false
  alias Polytext.Repo
  alias Polytext.Reads.{Document, Sentence}

  def get_document!(id) do
    Repo.get!(Document, id)
    |> Repo.preload(sentences: from(Sentence, order_by: [asc: :inserted_at]))
  end

  def get_document_with_user!(id, user_id) do
    from(doc in Document,
         join: u in assoc(doc, :user),
         where: doc.id == ^id and u.id == ^user_id,
         preload: [user: u])
    |> Repo.one!
    |> Repo.preload(sentences: from(Sentence, order_by: [asc: :inserted_at]))
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

  def update_document(%Document{} = document, attrs) do
    document
    |> Document.changeset(attrs)
    |> Repo.update()
  end

  def delete_document(%Document{} = document) do
    Repo.delete(document)
  end

  def update_sentence(%Sentence{} = sentence, attrs) do
    sentence
    |> Sentence.changeset(attrs)
    |> Repo.update()
  end

  def add_sentence(%Document{} = doc) do
    Ecto.build_assoc(doc, :sentences) |> Repo.insert()
  end

  def delete_sentence(document_id, sentence_id) do
    Repo.one!(from s in Sentence, where: s.id == ^sentence_id and s.document_id == ^document_id)
    |> Repo.delete()
  end
end
