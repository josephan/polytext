defmodule PolytextWeb.DocumentController do
  use PolytextWeb, :controller

  alias Polytext.Reads
  alias Polytext.Reads.Document

  plug :authorized_user? when action in [:edit, :delete]

  def index(conn, _params) do
    documents = Reads.list_documents(conn.assigns.current_user)
    changeset = Reads.change_document(%Document{})
    render(conn, "index.html", documents: documents, changeset: changeset)
  end

  def create(conn, _params) do
    {:ok, document} = Reads.create_document(conn.assigns.current_user)
    redirect(conn, to: document_path(conn, :edit, document))
  end

  def edit(conn, %{"id" => id}) do
    document = Poison.encode!(conn.assigns.document)
    languages = Poison.encode!(Polytext.languages())
    render(conn, "edit.html", document: document, languages: languages)
  end

  def delete(conn, %{"id" => id}) do
    {:ok, _document} = Reads.delete_document(conn.assigns.document)

    conn
    |> put_flash(:info, "Document deleted successfully.")
    |> redirect(to: document_path(conn, :index))
  end

  defp authorized_user?(conn, _opts) do
    document = Reads.get_document_with_user!(conn.params["id"], conn.assigns.current_user.id)
    if document do
      conn
      |> assign(:document, document)
    else
      conn
      |> put_flash(:error, "Sorry, but you don't have access to that document.")
      |> redirect(to: document_path(conn, :index))
      |> halt()
    end
  end
end
