defmodule Conduit.Router do
  use Commanded.Commands.Router

  alias Conduit.Accounts.{Aggregates.User, Commands.RegisterUser}

  # identify(User, by: :user_uuid)
  dispatch([RegisterUser], to: User, identity: :user_uuid)
end
