defmodule Polytext.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Polytext.Accounts.User
  alias Polytext.Reads.Document

  schema "users" do
    field :email, :string, null: false
    field :name, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :password_hash, :string
    field :admin, :boolean, default: false, null: false
    field :email_verified, :boolean, default: false, null: false

    has_many :document, Document

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :name])
    |> validate_required([:email])
    |> unique_constraint(:email)
    |> validate_length(:name, min: 3, max: 20)
    |> validate_length(:email, min: 6, max: 254)
    |> validate_format(:email, ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/)
  end

  def registration_changeset(%User{} = user, params) do
    user
    |> changeset(params)
    |> cast(params, [:password, :password_confirmation], [])    
    |> validate_required([:password, :password_confirmation])
    |> validate_length(:password, min: 6, max: 100)
    |> validate_length(:password_confirmation, min: 6, max: 100)
    |> validate_confirmation(:password, message: "does not match password")
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

