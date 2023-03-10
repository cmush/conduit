defmodule Conduit.Accounts.Aggregates.User do
  defstruct [
    :uuid,
    :username,
    :email,
    :hashed_password,
    :image,
    :bio
  ]

  alias Conduit.Accounts.{
    Aggregates.User,
    Commands.RegisterUser,
    Events.UserRegistered
  }

  @doc """
  Register a new user
  """
  def execute(%User{uuid: nil}, %RegisterUser{} = register) do
    %UserRegistered{
      user_uuid: register.user_uuid,
      username: register.username,
      email: register.email,
      hashed_password: register.hashed_password,
      image: register.image,
      bio: register.bio
    }
  end

  # State mutators

  def apply(%User{} = user, %UserRegistered{} = registered) do
    %User{
      user
      | uuid: registered.user_uuid,
        username: registered.username,
        email: registered.email,
        hashed_password: registered.hashed_password,
        image: registered.image,
        bio: registered.bio
    }
  end
end
