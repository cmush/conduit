defmodule Conduit.Accounts.Projectors.User do
  use Commanded.Projections.Ecto,
    application: Conduit.App,
    name: "Accounts.Projectors.User",
    consistency: :strong

  alias Conduit.Accounts.{
    Events.UserRegistered,
    Projections.User
  }

  project(
    %UserRegistered{
      user_uuid: user_uuid,
      username: username,
      email: email,
      hashed_password: hashed_password
    },
    fn multi ->
      Ecto.Multi.insert(multi, :user, %User{
        uuid: user_uuid,
        username: username,
        email: email,
        hashed_password: hashed_password,
        bio: nil,
        image: nil
      })
    end
  )
end
