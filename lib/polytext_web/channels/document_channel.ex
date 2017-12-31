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

  def handle_in("update_document", %{"title" => title, "sentences" => sentences_data}, socket) do
    doc = Polytext.Reads.get_document!(socket.assigns.document_id) 
    
    if doc.title != title, do: Polytext.Reads.update_document(doc, %{title: title})

    for sentence <- doc.sentences do
      case Enum.find(sentences_data, fn s -> sentence.id == s["id"] end) do
        nil -> nil
        s -> update_translations(sentence, s)
        _ -> nil
      end
    end

    last_updated(socket)
    {:noreply, socket}
  end

  def handle_in("add_sentence", _payload, socket) do
    doc = Polytext.Reads.get_document!(socket.assigns.document_id) 
    {:ok, sentence} = Polytext.Reads.add_sentence(doc, [:korean, :english])
    sentence = sentence |> Polytext.Repo.preload(:translations)
    add_sentence(socket, sentence)
    {:noreply, socket}
  end

  def handle_in("delete_sentence", %{"id" => id}, socket) do
    {:ok, _doc} = Polytext.Reads.delete_sentence(socket.assigns.document_id, id)
    broadcast!(socket, "delete_sentence", %{id: id})
    {:noreply, socket}
  end

  defp update_translations(sentence, s_data) do
    for translation <- sentence.translations do
      case translation_found_and_edited?(translation, s_data) do
        {:ok, t} ->
          Polytext.Reads.update_translation(translation, %{text: t["text"]})
        _ -> nil
      end
    end
  end

  defp translation_found_and_edited?(translation, s_data) do
    case Enum.find(s_data["translations"], fn t -> translation.id == t["id"] end) do
      nil -> false
      t -> if translation.text != t["text"], do: {:ok, t}, else: false
      _ -> false
    end
  end

  defp add_sentence(socket, sentences) do
    broadcast!(socket, "add_sentence", sentences)
  end

  defp last_updated(socket) do
    timestamp = DateTime.utc_now() |> DateTime.to_unix()
    broadcast!(socket, "updated_at", %{"timestamp" => timestamp})
  end
end
