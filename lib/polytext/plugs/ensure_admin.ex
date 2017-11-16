defmodule Polytext.Plugs.EnsureAdmin do
  import Plug.Conn
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]

  alias Polytext.Router.Helpers

  def init(_params) do
  end

  def call(conn, _params) do
    if conn.assigns.current_user && conn.assigns.current_user.admin do
      conn
    else
      conn
      |> put_flash(:error, "Sorry you have be an admin to login to that page.")
      |> redirect(to: Helpers.page_path(conn, :home))
      |> halt()
    end
  end
end
