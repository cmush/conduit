defmodule Conduit.Router do
  use Commanded.Commands.Router

  alias Conduit.Accounts.{
    Aggregates.User,
    Commands.RegisterUser
  }

  dispatch [RegisterUser], to: User, identity: :user_uuid
end
