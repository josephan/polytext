alias Polytext.{
  Repo,
  Accounts,
  Accounts.User,
  Reads,
  Reads.Document,
  Reads.Sentence,
  Reads.Translation
}

import_if_available Ecto.Query, only: [from: 1, from: 2]
import_if_available Ecto.Changeset, only: [change: 2]
