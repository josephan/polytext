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
  Reads.Translation
}
