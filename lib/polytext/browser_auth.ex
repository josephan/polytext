defmodule Polytext.BrowserAuth do
  import Plug.Conn

  alias Polytext.Repo
  alias Polytext.Accounts.User

  def init(_opts) do
  end

  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)
    user = user_id && Repo.get(User, user_id)

    assign_user(conn, user)
  end

  def login(conn, user) do
    conn
    |> assign_user(user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  defp assign_user(conn, user) do
    conn
    |> assign(:current_user, user)
    |> assign(:user_token, token(user))
  end

  defp token(nil), do: nil
  defp token(user), do: Phoenix.Token.sign(PolytextWeb.Endpoint, "user socket", user.id)

  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
  def login_by_email_and_pass(conn, email, given_pass) do
    user = Polytext.Repo.get_by(User, email: email)

    cond do
      user && checkpw(given_pass, user.password_hash) ->
        {:ok, login(conn, user)}
      user ->
        {:error, :unauthorized, conn}
      true ->
        dummy_checkpw()
        {:error, :not_found, conn}
    end
  end

  def logout(conn) do
    configure_session(conn, drop: true)
  end
end
