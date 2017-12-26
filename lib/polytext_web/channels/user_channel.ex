defmodule PolytextWeb.UserChannel do
  use PolytextWeb, :channel

  def join("user:" <> token, _params, socket) do
    user_id = socket.assigns.user_id
    case Phoenix.Token.verify(socket, "user socket", token, max_age: PolytextWeb.UserSocket.max_age()) do
      {:ok, ^user_id} ->
        {:ok, socket}
      {:error, reason} ->
        {:error, reason}
    end
  end
end
