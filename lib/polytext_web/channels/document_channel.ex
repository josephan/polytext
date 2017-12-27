defmodule PolytextWeb.DocumentChannel do
  use PolytextWeb, :channel

  def join("document:" <> document_id, _params, socket) do
    document = Polytext.Reads.get_document_with_user!(document_id, socket.assigns.user_id)
    if document do
      {:ok, socket}
    else
      {:error, %{reason: "You do not have access."}}
    end
  end
end
