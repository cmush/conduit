defmodule Conduit.Router do
  use Commanded.Commands.Router

  alias Conduit.Accounts.{Aggregates.User, Commands.RegisterUser}
  alias Conduit.Support.Middleware.{Validate, Uniqueness}

  middleware(Validate)
  middleware(Uniqueness)

  # identify(User, by: :user_uuid)
  dispatch([RegisterUser], to: User, identity: :user_uuid)
end
