defmodule Polytext.Repo.Migrations.CreateSpeeches do
  use Ecto.Migration

  def change do
    create table(:speeches) do
      add :audio_url, :string
      add :text_hash, :string
      add :language, :integer
      add :document_id, references(:documents, on_delete: :nothing)

      timestamps()
    end

    create index(:speeches, [:document_id])
    create unique_index(:speeches, [:document_id, :language], name: :speeches_document_id_language_index)
  end
end
