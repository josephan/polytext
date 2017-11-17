defmodule PolytextWeb.Admin.DocumentController do
  use PolytextWeb, :controller

  alias Polytext.Reads
  alias Polytext.Reads.Document

  def index(conn, _params) do
    documents = Reads.list_documents()
    render(conn, "index.html", documents: documents)
  end

  def new(conn, _params) do
    changeset = Reads.change_document(%Document{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"document" => document_params}) do
    case Reads.create_document(document_params) do
      {:ok, document} ->
        conn
        |> put_flash(:info, "Document created successfully.")
        |> redirect(to: admin_document_path(conn, :show, document))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    document = Reads.get_document!(id)
    render(conn, "show.html", document: document)
  end

  def edit(conn, %{"id" => id}) do
    document = Reads.get_document!(id)
    changeset = Reads.change_document(document)
    render(conn, "edit.html", document: document, changeset: changeset)
  end

  def update(conn, %{"id" => id, "document" => document_params}) do
    document = Reads.get_document!(id)

    case Reads.update_document(document, document_params) do
      {:ok, document} ->
        conn
        |> put_flash(:info, "Document updated successfully.")
        |> redirect(to: admin_document_path(conn, :show, document))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", document: document, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    document = Reads.get_document!(id)
    {:ok, _document} = Reads.delete_document(document)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: admin_document_path(conn, :index))
  end
end
