defmodule Polytext.Plugs.RequireLogin do
  import Plug.Conn
  import Phoenix.Controller, only: [render: 3]

  def init(_params) do
  end

  def call(conn, _params) do
    if conn.assigns[:current_user] do
      conn
    else
      conn
      |> put_status(:unauthorized)
      |> render(PolytextWeb.ErrorView, :"401")
      |> halt()
    end
  end
end
