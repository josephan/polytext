defmodule PolytextWeb.PageController do
  use PolytextWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
