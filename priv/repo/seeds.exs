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
  Reads.Translation,
  Reads.Tag,
}

hash_pass = &Comeonin.Bcrypt.hashpwsalt/1

Polytext.Repo.transaction(fn ->
  admin = Repo.insert(%User{name: "Joseph An", email: "test@test.com", password_hash: hash_pass.("123123"), admin: true})
  user = Repo.insert(%User{name: "User 2", email: "test2@test.com", password_hash: hash_pass.("123123")})
end)
