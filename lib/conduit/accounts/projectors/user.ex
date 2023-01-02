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
    %UserRegistered{} = registered,
    fn multi ->
      Ecto.Multi.insert(multi, :user, %User{
        uuid: registered.user_uuid,
        username: registered.username,
        email: registered.email,
        hashed_password: registered.hashed_password,
        bio: nil,
        image: nil
      })
    end
  )
end
