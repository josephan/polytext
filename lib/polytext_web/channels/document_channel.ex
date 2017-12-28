defmodule PolytextWeb.DocumentChannel do
  use PolytextWeb, :channel

  def join("document:" <> document_id, _params, socket) do
    document = Polytext.Reads.get_document_with_user!(document_id, socket.assigns.user_id)
    if document do
      {:ok, assign(socket, :document_id, document_id)}
    else
      {:error, %{reason: "You do not have access."}}
    end
  end

  def handle_in("update_title", %{"title" => title}, socket) do
    doc = Polytext.Reads.get_document!(socket.assigns.document_id) 
    if doc.title != title do
      {:ok, doc} = Polytext.Reads.update_document(doc, %{title: title})
      last_updated(socket, doc.updated_at)
    end
    {:noreply, socket}
  end

  defp last_updated(socket, updated_at) do
    broadcast!(socket, "updated_at", %{"timestamp" => Timex.to_unix(updated_at)})
  end
end
