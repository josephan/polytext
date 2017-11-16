defmodule Polytext.Reads.Document do
  use Ecto.Schema
  import Ecto.Changeset
  alias Polytext.Accounts.User
  alias Polytext.Reads.{Document, Sentence }


  schema "documents" do
    field :title, :string

    belongs_to :user, User
    has_many :sentences, Sentence

    timestamps()
  end

  @doc false
  def changeset(%Document{} = document, attrs) do
    document
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
