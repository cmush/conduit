defmodule Conduit.Accounts do
  @moduledoc """
  The boundary for the Accounts system.
  """

  alias Conduit.{
    Accounts.Commands.RegisterUser,
    Router
  }

  @doc """
  Register a new user.
  """
  def register_user(attrs \\ %{}) do
    uuid = UUID.uuid4()

    register_user =
      attrs
      |> assign(:user_uuid, uuid)
      |> RegisterUser.new()

    with :ok <- Router.dispatch(register_user, consistency: :strong) do
      get(User, uuid)
    else
      reply -> reply
    end
  end

  defp get(schema, uuid) do
    case Repo.get(schema, uuid) do
      nil -> {:error, :not_found}
      projection -> {:ok, projection}
    end
  end

  defp assign(attrs, key, value), do: Map.put(attrs, key, value)

  # @moduledoc """
  # The Accounts context.
  # """

  # import Ecto.Query, warn: false
  # alias Conduit.Repo

  # alias Conduit.Accounts.User

  # @doc """
  # Returns the list of users.

  # ## Examples

  #     iex> list_users()
  #     [%User{}, ...]

  # """
  # def list_users do
  #   Repo.all(User)
  # end

  # @doc """
  # Gets a single user.

  # Raises `Ecto.NoResultsError` if the User does not exist.

  # ## Examples

  #     iex> get_user!(123)
  #     %User{}

  #     iex> get_user!(456)
  #     ** (Ecto.NoResultsError)

  # """
  # def get_user!(id), do: Repo.get!(User, id)

  # @doc """
  # Creates a user.

  # ## Examples

  #     iex> create_user(%{field: value})
  #     {:ok, %User{}}

  #     iex> create_user(%{field: bad_value})
  #     {:error, %Ecto.Changeset{}}

  # """
  # def create_user(attrs \\ %{}) do
  #   %User{}
  #   |> User.changeset(attrs)
  #   |> Repo.insert()
  # end

  # @doc """
  # Updates a user.

  # ## Examples

  #     iex> update_user(user, %{field: new_value})
  #     {:ok, %User{}}

  #     iex> update_user(user, %{field: bad_value})
  #     {:error, %Ecto.Changeset{}}

  # """
  # def update_user(%User{} = user, attrs) do
  #   user
  #   |> User.changeset(attrs)
  #   |> Repo.update()
  # end

  # @doc """
  # Deletes a user.

  # ## Examples

  #     iex> delete_user(user)
  #     {:ok, %User{}}

  #     iex> delete_user(user)
  #     {:error, %Ecto.Changeset{}}

  # """
  # def delete_user(%User{} = user) do
  #   Repo.delete(user)
  # end

  # @doc """
  # Returns an `%Ecto.Changeset{}` for tracking user changes.

  # ## Examples

  #     iex> change_user(user)
  #     %Ecto.Changeset{data: %User{}}

  # """
  # def change_user(%User{} = user, attrs \\ %{}) do
  #   User.changeset(user, attrs)
  # end
end