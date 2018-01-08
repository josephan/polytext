defmodule PolytextWeb.DocumentChannel do
  use PolytextWeb, :channel

  alias Polytext.{Reads, Reads.Sentence}

  def join("document:" <> document_id, _params, socket) do
    document = Reads.get_document_with_user!(document_id, socket.assigns.user_id)
    if document do
      {:ok, assign(socket, :document_id, document_id)}
    else
      {:error, %{reason: "You do not have access."}}
    end
  end

  def handle_in("toggle_publish", %{"published" => published}, socket) do
    doc = Reads.get_document!(socket.assigns.document_id) 
    {:ok, doc} = Reads.update_document(doc, %{published: published})
    broadcast!(socket, "toggle_published", %{published: doc.published})
    {:noreply, socket}
  end

  def handle_in("update_document", %{"title" => title, "sentences" => sentences_data}, socket) do
    doc = Reads.get_document!(socket.assigns.document_id) 

    if doc.title != title, do: Reads.update_document(doc, %{title: title})

    for data <- sentences_data do
      case Enum.find(doc.sentences, &(&1.id == data["id"])) do
        nil -> nil
        s -> update_sentence(s, data)
      end
    end
    
    last_updated(socket)

    {:noreply, socket}
  end

  def handle_in("add_sentence", _payload, socket) do
    doc = Reads.get_document!(socket.assigns.document_id) 
    {:ok, sentence} = Reads.add_sentence(doc)
    add_sentence(socket, sentence)
    {:noreply, socket}
  end

  def handle_in("delete_sentence", %{"id" => id}, socket) do
    {:ok, _doc} = Reads.delete_sentence(socket.assigns.document_id, id)
    broadcast!(socket, "delete_sentence", %{id: id})
    {:noreply, socket}
  end

  defp update_sentence(sentence, data) do
    if Sentence.to_map(sentence) != data do
      Reads.update_sentence(sentence, data)
    end
  end

  # defp generate_audio(sentence) do
  #   Task.Supervisor.start_child Polytext.TaskSupervisor, fn ->
  #     Reads.AudioGenerator.run(sentence)
  #   end
  # end

  defp add_sentence(socket, sentences) do
    broadcast!(socket, "add_sentence", sentences)
  end

  defp last_updated(socket) do
    timestamp = DateTime.utc_now() |> DateTime.to_unix()
    broadcast!(socket, "updated_at", %{"timestamp" => timestamp})
  end
end
