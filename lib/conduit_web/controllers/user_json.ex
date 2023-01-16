defmodule ConduitWeb.UserJSON do
  alias Conduit.Accounts.Projections.User

  @doc """
  Renders a list of users.
  """
  def index(%{users: users}) do
    %{user: for(user <- users, do: user(user))}
  end

  @doc """
  Renders a single user.
  """
  def show(%{user: user}) do
    %{user: user(user)}
  end

  defp user(%User{} = user) do
    %{
      username: user.username,
      email: user.email,
      bio: user.bio,
      image: user.image
    }
  end
end
