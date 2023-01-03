defmodule Conduit.Accounts.Commands.RegisterUser do
  @enforce_keys [:user_uuid]
  @derive {Inspect, only: [:user_uuid, :username, :email]}
  defstruct [
    :user_uuid,
    :username,
    :email,
    :password,
    :hashed_password,
    :image,
    :bio
  ]

  use ExConstructor
  use Vex.Struct

  validates(:user_uuid, uuid: true)
  validates(:username, presence: [message: "can't be empty"], string: true, unique_username: true)
  validates(:email, presence: [message: "can't be empty"], string: true)
  validates(:hashed_password, presence: [message: "can't be empty"], string: true)

  defimpl Conduit.Support.Middleware.Uniqueness.UniqueFields,
    for: Conduit.Accounts.Commands.RegisterUser do
    def unique(_command),
      do: [
        {:username, "has already been taken"}
      ]
  end
end
