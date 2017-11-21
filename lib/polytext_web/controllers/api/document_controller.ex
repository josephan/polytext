defmodule PolytextWeb.Api.DocumentController do
  use PolytextWeb, :controller
  alias Polytext.Reads

  action_fallback PolytextWeb.Api.FallbackController

  def index(conn, _params) do
    documents = Reads.list_documents()
    render(conn, "index.json", documents: documents)
  end
  
  def show(conn, %{"id" => id}) do
    document = Reads.get_document!(id)
    render(conn, "show.json", document: document)
  end
end
