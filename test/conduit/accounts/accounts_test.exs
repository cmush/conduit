defmodule Conduit.AccountsTest do
  use Conduit.DataCase

  alias Conduit.Accounts
  alias Conduit.Accounts.Projections.User
  alias Conduit.Auth

  describe "register user" do
    @tag :integration
    test "should succeed with valid data" do
      user = build(:user)

      assert {:ok,
              %User{
                email: email,
                bio: bio,
                hashed_password: hashed_password,
                image: image,
                username: username
              }} = Accounts.register_user(user)

      assert user.bio == bio
      assert user.email == email
      assert user.hashed_password == hashed_password
      assert user.image == image
      assert user.username == username
    end

    @tag :integration
    test "should fail with invalid data and return error" do
      assert {:error, :validation_failure, errors} =
               Accounts.register_user(build(:user, username: ""))

      assert errors == %{username: ["can't be empty"]}
    end

    @tag :integration
    test "should fail when username already taken and return error" do
      user = build(:user)

      assert {:ok, %User{}} = Accounts.register_user(user)

      assert {:error, :validation_failure, errors} =
               Accounts.register_user(%{user | email: "jake2@jake.jake"})

      assert errors == %{username: ["has already been taken"]}
    end

    @tag :integration
    test "should fail when registering identical username at same time and return error" do
      1..2
      |> Enum.map(fn _ -> Task.async(fn -> Accounts.register_user(build(:user)) end) end)
      |> Enum.map(&Task.await/1)
    end

    @tag :integration
    test "should fail when username format is invalid and return error" do
      assert {:error, :validation_failure, errors} =
               Accounts.register_user(build(:user, username: "j@ke"))

      assert errors == %{username: ["is invalid"]}
    end

    @tag :integration
    test "should convert username to lowercase" do
      assert {:ok, %User{} = user} = Accounts.register_user(build(:user, username: "JAKE"))

      assert user.username == "jake"
    end

    @tag :integration
    test "should fail when email address already taken and return error" do
      assert {:ok, %User{}} = Accounts.register_user(build(:user, username: "jake"))

      assert {:error, :validation_failure, errors} =
               Accounts.register_user(build(:user, username: "jake2"))

      assert errors == %{email: ["has already been taken"]}
    end

    @tag :integration
    test "should fail when registering identical email addresses at same time and return error" do
      1..2
      |> Enum.map(fn x ->
        Task.async(fn -> Accounts.register_user(build(:user, username: "user#{x}")) end)
      end)
      |> Enum.map(&Task.await/1)
    end

    @tag :integration
    test "should fail when email address format is invalid and return error" do
      assert {:error, :validation_failure, errors} =
               Accounts.register_user(build(:user, email: "invalidemail"))

      assert errors == %{email: ["is invalid"]}
    end

    @tag :integration
    test "should convert email address to lowercase" do
      assert {:ok, %User{} = user} = Accounts.register_user(build(:user, email: "JAKE@JAKE.JAKE"))

      assert user.email == "jake@jake.jake"
    end

    @tag :integration
    test "should hash password" do
      assert {:ok, %User{} = user} = Accounts.register_user(build(:user))
      assert Auth.validate_password("jakejake", user.hashed_password)
    end
  end

  describe "get a user by" do
    setup do
      {:ok, user} = Accounts.register_user(build(:user))
      %{user: user}
    end

    @tag :unit
    test "user by username", %{user: %User{username: username}} do
      assert %User{username: ^username} = Accounts.user_by_username(username)
    end

    @tag :unit
    test "user by email", %{user: %User{email: email}} do
      assert %User{email: ^email} = Accounts.user_by_email(email)
    end
  end

  # use Conduit.DataCase

  # alias Conduit.Accounts

  # describe "users" do
  #   alias Conduit.Accounts.User

  #   import Conduit.AccountsFixtures

  #   @invalid_attrs %{bio: nil, email: nil, hashed_password: nil, image: nil, username: nil}

  #   test "list_users/0 returns all users" do
  #     user = user_fixture()
  #     assert Accounts.list_users() == [user]
  #   end

  #   test "get_user!/1 returns the user with given id" do
  #     user = user_fixture()
  #     assert Accounts.get_user!(user.id) == user
  #   end

  #   test "create_user/1 with valid data creates a user" do
  #     valid_attrs = %{
  #       bio: "some bio",
  #       email: "some email",
  #       hashed_password: "some hashed_password",
  #       image: "some image",
  #       username: "some username"
  #     }

  #     assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
  #     assert user.bio == "some bio"
  #     assert user.email == "some email"
  #     assert user.hashed_password == "some hashed_password"
  #     assert user.image == "some image"
  #     assert user.username == "some username"
  #   end

  #   test "create_user/1 with invalid data returns error changeset" do
  #     assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
  #   end

  #   test "update_user/2 with valid data updates the user" do
  #     user = user_fixture()

  #     update_attrs = %{
  #       bio: "some updated bio",
  #       email: "some updated email",
  #       hashed_password: "some updated hashed_password",
  #       image: "some updated image",
  #       username: "some updated username"
  #     }

  #     assert {:ok, %User{} = user} = Accounts.update_user(user, update_attrs)
  #     assert user.bio == "some updated bio"
  #     assert user.email == "some updated email"
  #     assert user.hashed_password == "some updated hashed_password"
  #     assert user.image == "some updated image"
  #     assert user.username == "some updated username"
  #   end

  #   test "update_user/2 with invalid data returns error changeset" do
  #     user = user_fixture()
  #     assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
  #     assert user == Accounts.get_user!(user.id)
  #   end

  #   test "delete_user/1 deletes the user" do
  #     user = user_fixture()
  #     assert {:ok, %User{}} = Accounts.delete_user(user)
  #     assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
  #   end

  #   test "change_user/1 returns a user changeset" do
  #     user = user_fixture()
  #     assert %Ecto.Changeset{} = Accounts.change_user(user)
  #   end
  # end
end
