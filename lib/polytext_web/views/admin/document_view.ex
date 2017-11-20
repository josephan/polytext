defmodule PolytextWeb.Admin.DocumentView do
  use PolytextWeb, :view

  def sentences_to_string(changeset) do
    Enum.reduce(changeset.data.sentences, "", fn sentence, acc1 ->
      translation = Enum.reduce(sentence.translations, "", fn translation, acc2 ->
        acc2 <> translation.text <> "\n"
      end)
      acc1 <> translation <> "\n"
    end)
  end

  def language_options do
    [{:"select language", 0} | LanguageEnum.__enum_map__()]
  end
end
