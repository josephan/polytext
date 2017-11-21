defmodule Polytext.Reads.Document do
  use Ecto.Schema
  import Ecto.Changeset
  alias Polytext.Accounts.User
  alias Polytext.Reads.{Document, Sentence, Tag}


  schema "documents" do
    field :title, :string
    field :published, :boolean

    belongs_to :user, User
    has_many :sentences, Sentence
    many_to_many :tags, Tag, join_through: "document_tags"

    timestamps()
  end

  @doc false
  def changeset(%Document{} = document, attrs) do
    document
    |> cast(attrs, [:title])
    |> validate_length(:title, min: 3, max: 250)
    |> validate_required([:title])
  end
end