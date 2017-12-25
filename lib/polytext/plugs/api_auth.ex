defmodule Polytext.Plugs.ApiAuth do
  import Plug.Conn

  alias Polytext.Accounts.User
  alias Polytext.Repo
  alias Phoenix.Token

  @salt "user auth"

  def init(_opts) do
  end

  def call(conn, _opts) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] ->
        case verify_token(conn, token, max_age: 315_360_000) do
          {:ok, user_id} ->
            user = user_id && Repo.get(User, user_id)
            assign(conn, :current_user, user)
          _ ->
            conn
        end
      _ -> conn
    end
  end

  def verify_token(conn, token, opts \\ []) do
    Token.verify(conn, @salt, token, opts)
  end

  def sign_token(conn, user) do
    Token.sign(conn, @salt, user.id)
  end

  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
  def login(conn, email, given_pass) do
    user = Polytext.Repo.get_by!(User, email: email)

    cond do
      user && checkpw(given_pass, user.password_hash) ->
        {:ok, user, sign_token(conn, user)}
      user ->
        {:error, :bad_request}
      true ->
        dummy_checkpw()
        {:error, :bad_request}
    end
  end

  def logout(conn) do
    token = sign_token(conn, conn.assigns.current_user)
    verify_token(conn, token, max_age: 1)
  end
end
