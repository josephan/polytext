defmodule Polytext.Repo.Migrations.CreateTranslations do
  use Ecto.Migration

  def change do
    create table(:translations) do
      add :sentence_id, references(:sentences, on_delete: :delete_all)
      add :text, :text
      add :language, :integer
      add :audio_uri, :string

      timestamps()
    end

    create index(:translations, [:sentence_id])
  end
end
