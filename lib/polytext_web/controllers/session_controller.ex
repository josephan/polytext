defmodule PolytextWeb.SessionController do
  use PolytextWeb, :controller

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => %{"email" => email, "password" => pass}}) do
    case Polytext.BrowserAuth.login_by_email_and_pass(conn, email, pass) do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "Welcome back to Polytext")
        |> redirect(to: original_path(conn))
      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Invalid username/password combination")
        |> render("new.html")
    end
  end

  defp original_path(conn) do
    path = get_session(conn, :original_path)
    if path do
      path
    else
      page_path(conn, :index)
    end
  end

  def delete(conn, _params) do
    conn
    |> Polytext.BrowserAuth.logout()
    |> redirect(to: page_path(conn, :index))
  end
end
