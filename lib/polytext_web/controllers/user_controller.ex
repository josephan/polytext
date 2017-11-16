defmodule PolytextWeb.UserController do
  use PolytextWeb, :controller
  alias Polytext.Accounts
  alias Polytext.Accounts.User

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> Polytext.BrowserAuth.login(user)
        |> put_flash(:info, "Welcome to Polytext! Live long and prosper.")
        |> redirect(to: page_path(conn, :home))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  # def edit(conn, _params) do
  # end
  #
  # def delete(conn, _params) do
  # end
end

