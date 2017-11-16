defmodule Polytext.Repo.Migrations.CreateDocumentTags do
  use Ecto.Migration

  def change do
    create table(:document_tags, primary_key: false) do
      add :document_id, references(:documents, on_delete: :nothing)
      add :tag_id, references(:tags, on_delete: :nothing)
    end

    create index(:document_tags, [:document_id])
    create index(:document_tags, [:tag_id])
  end
end
