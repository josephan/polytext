defmodule Polytext.Repo.Migrations.CreateSentences do
  use Ecto.Migration

  def change do
    create table(:sentences) do
      add :document_id, references(:documents, on_delete: :delete_all)

      add :english, :text
      add :korean, :text
      add :french, :text
      add :german, :text
      add :italian, :text
      add :japanese, :text
      add :norwegian, :text
      add :polish, :text
      add :portuguese, :text
      add :romanian, :text
      add :russian, :text
      add :spanish, :text
      add :turkish, :text

      timestamps()
    end

    create index(:sentences, [:document_id])
  end
end
