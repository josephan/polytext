# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Polytext.Repo.insert!(%Polytext.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Polytext.{
  Repo,
  Accounts,
  Accounts.User,
  Reads,
  Reads.Document,
  Reads.Sentence,
  Reads.Tag,
}

hash_pass = &Comeonin.Bcrypt.hashpwsalt/1

Polytext.Repo.transaction(fn ->
  admin = Repo.insert!(%User{name: "Joseph An", email: "test@test.com", password_hash: hash_pass.("123123"), admin: true})
  user = Repo.insert!(%User{name: "User 2", email: "test2@test.com", password_hash: hash_pass.("123123")})

  doc = Ecto.build_assoc(admin, :documents, %{title: "Test Document 1"}) |> Repo.insert!()

  Ecto.build_assoc(doc, :sentences, english: "Hello my name is Joseph.", korean: "안녕하세요 제 이름은 요셉입니다.") |> Repo.insert!()

  Ecto.build_assoc(doc, :sentences, english: "And my favourite programming language is Elixir.", korean: "그리고 내가 좋아하는 프로그래밍 언어는 Elixir입니다.") |> Repo.insert!()

  Ecto.build_assoc(doc, :sentences, english: "This website is build using elixir!", korean: "이 웹 사이트는 엘릭서를 사용하여 제작되었습니다!") |> Repo.insert!()

  Ecto.build_assoc(doc, :sentences, english: "JavaScript is also used for the editor and mobile app.", korean: "JavaScript는 편집기 및 모바일 앱에도 사용됩니다.") |> Repo.insert!()

end)
