defmodule PolytextWeb.DashboardController do
  use PolytextWeb, :controller

  alias Polytext.Reads

  def documents(conn, _params) do
    documents = Reads.list_documents(conn.assigns.current_user)
    render conn, "documents.html", documents: documents
  end
end
