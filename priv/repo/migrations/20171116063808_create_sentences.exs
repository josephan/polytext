defmodule Polytext.Repo.Migrations.CreateSentences do
  use Ecto.Migration

  def change do
    create table(:sentences) do
      add :document_id, references(:documents, on_delete: :delete_all)

      timestamps()
    end

    create index(:sentences, [:document_id])
  end
end
