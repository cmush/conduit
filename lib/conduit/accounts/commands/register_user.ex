defmodule Conduit.Accounts.Commands.RegisterUser do
  @enforce_keys [:user_uuid]
  @derive {Inspect, only: [:user_uuid, :username, :email]}
  defstruct [
    :user_uuid,
    :username,
    :email,
    :password,
    :hashed_password
  ]

  use ExConstructor
end
