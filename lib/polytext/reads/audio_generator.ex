# defmodule Polytext.Reads.AudioGenerator do
#   @bucket Application.get_env(:ex_aws, :s3_bucket_name)
#
#   def run(sentence) do
#     sentence
#     |> fetch_audio()
#     |> get_body()
#     |> upload_to_s3()
#     |> update_sentence()
#   end
#
#   defp fetch_audio(sentence) do
#     text = sentence.text
#     voice_id = Polytext.voice_id(language)
#
#     {:ok, %{body: data}} = ExAws.Polly.synthesize_speech(text, voice_id: voice_id)
#     ExAws.S3.put_object(@bucket, "speech-" <> speech.id <> speech.lang, data)
#   end
# end
