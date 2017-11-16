defmodule Polytext.Plugs.RequireLogin do
  import Plug.Conn
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]

  alias PolytextWeb.Router.Helpers

  def init(_params) do
  end

  def call(conn, _params) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "Sorry you have been logged in do access that page.")
      |> redirect(to: Helpers.page_path(conn, :index))
      |> halt()
    end
  end
end
