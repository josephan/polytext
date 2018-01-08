defmodule Polytext.Repo.Migrations.CreateAudios do
  use Ecto.Migration

  def change do
    create table(:audios) do
      add :source_url, :string
      add :text_hash, :string
      add :language, :integer
      add :sentence_id, references(:sentences, on_delete: :delete_all)

      timestamps()
    end

    create index(:audios, [:sentence_id])
    create unique_index(:audios, [:sentence_id, :language], name: :audios_sentence_id_language_index)
  end
end
