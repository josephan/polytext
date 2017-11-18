defmodule Polytext.Repo.Migrations.CreateDocuments do
  use Ecto.Migration

  def change do
    create table(:documents) do
      add :title, :string
      add :user_id, references(:users, on_delete: :nothing)
      add :published, :boolean, default: false, null: false

      timestamps()
    end

    create index(:documents, [:user_id])
  end
end
