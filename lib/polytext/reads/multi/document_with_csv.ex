defmodule Polytext.Reads.Multi.DocumentWithCSV do
  alias Ecto.Multi
  alias Polytext.Repo
  alias Polytext.Reads.Document

  def create(params) do
    Multi.new
    |> Multi.insert(:document, Document.changeset(%Document{}, params))
    |> Multi.run(:csv, fn _ -> parse_csv(params["csv"].path) end)
    |> Multi.run(:sentences, &create_sentence_with_translations/1)
  end

  defp parse_csv(csv_path) do
    [langs | csv] =
      csv_path
      |> File.read!()
      |> NimbleCSV.RFC4180.parse_string(headers: false)

    {:ok, %{langs: langs, csv: csv}}
  end

  defp create_sentence_with_translations(results) do
    %{document: document, csv: %{langs: langs, csv: csv}} = results

    for sentence <- csv do
      sen = Ecto.build_assoc(document, :sentences) |> Repo.insert!
      for {lang, translation} <- Enum.zip(langs, sentence) do
        sen
        |> Ecto.build_assoc(:translations, %{text: translation, language: lang})
        |> Repo.insert!()
      end
    end

    {:ok, true}
  end
end
