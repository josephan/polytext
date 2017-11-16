defmodule Polytext.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Polytext.Accounts.User


  schema "users" do
    field :admin, :boolean, default: false
    field :email, :string
    field :email_verified, :boolean, default: false
    field :name, :string
    field :password_hash, :string

    timestamps()
  end

  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :email])
    |> validate_required([:email])
    |> unique_constraint(:email)
    |> validate_length(:name, min: 3, max: 30)
    |> validate_length(:email, min: 6, max: 254)
    |> validate_format(:email, ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/)
  end

  def registration_changeset(%User{} = user, params) do
    user
    |> changeset(params)
    |> cast(params, [:password], [])    
    |> validate_required([:password])
    |> validate_length(:password, min: 6, max: 200)
    |> put_pass_hash()
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end
end
