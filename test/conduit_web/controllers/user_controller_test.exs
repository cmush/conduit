defmodule ConduitWeb.UserControllerTest do
  use ConduitWeb.ConnCase

  import Conduit.Factory

  alias Conduit.Accounts

  def fixture(:user, attrs \\ %{}) do
    build(:user, attrs) |> Accounts.register_user()
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "register user" do
    @tag :web
    test "should create and return user when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: build(:user))
      json = json_response(conn, 201)["user"]

      assert json == %{
               "bio" => "I like to skateboard",
               "email" => "jake@jake.jake",
               "image" => "https://i.stack.imgur.com/xHWG8.jpg",
               "username" => "jake"
             }
    end

    @tag :web
    test "should not create user and render errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: build(:user, username: ""))

      assert json_response(conn, 422)["errors"] == %{
               "username" => [
                 "can't be empty"
               ]
             }
    end

    @tag :web
    test "should not create user and render errors when username has been taken", %{conn: conn} do
      # register a user
      user_attrs = %{email: "jake2@jake.jake", username: "jake2"}

      build(:user, user_attrs)
      |> Accounts.register_user()

      # attempt to register the same username
      conn =
        post(conn, ~p"/api/users", user: build(:user, %{user_attrs | email: "jake3@jake.jake"}))

      assert json_response(conn, 422)["errors"] == %{
               "username" => [
                 "has already been taken"
               ]
             }
    end
  end

  # import Conduit.AccountsFixtures

  # alias Conduit.Accounts.User

  # @create_attrs %{
  #   bio: "some bio",
  #   email: "some email",
  #   hashed_password: "some hashed_password",
  #   image: "some image",
  #   username: "some username"
  # }
  # @update_attrs %{
  #   bio: "some updated bio",
  #   email: "some updated email",
  #   hashed_password: "some updated hashed_password",
  #   image: "some updated image",
  #   username: "some updated username"
  # }
  # @invalid_attrs %{bio: nil, email: nil, hashed_password: nil, image: nil, username: nil}

  # setup %{conn: conn} do
  #   {:ok, conn: put_req_header(conn, "accept", "application/json")}
  # end

  # describe "index" do
  #   test "lists all users", %{conn: conn} do
  #     conn = get(conn, ~p"/api/users")
  #     assert json_response(conn, 200)["data"] == []
  #   end
  # end

  # describe "create user" do
  #   test "renders user when data is valid", %{conn: conn} do
  #     conn = post(conn, ~p"/api/users", user: @create_attrs)
  #     assert %{"id" => id} = json_response(conn, 201)["data"]

  #     conn = get(conn, ~p"/api/users/#{id}")

  #     assert %{
  #              "id" => ^id,
  #              "bio" => "some bio",
  #              "email" => "some email",
  #              "hashed_password" => "some hashed_password",
  #              "image" => "some image",
  #              "username" => "some username"
  #            } = json_response(conn, 200)["data"]
  #   end

  #   test "renders errors when data is invalid", %{conn: conn} do
  #     conn = post(conn, ~p"/api/users", user: @invalid_attrs)
  #     assert json_response(conn, 422)["errors"] != %{}
  #   end
  # end

  # describe "update user" do
  #   setup [:create_user]

  #   test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
  #     conn = put(conn, ~p"/api/users/#{user}", user: @update_attrs)
  #     assert %{"id" => ^id} = json_response(conn, 200)["data"]

  #     conn = get(conn, ~p"/api/users/#{id}")

  #     assert %{
  #              "id" => ^id,
  #              "bio" => "some updated bio",
  #              "email" => "some updated email",
  #              "hashed_password" => "some updated hashed_password",
  #              "image" => "some updated image",
  #              "username" => "some updated username"
  #            } = json_response(conn, 200)["data"]
  #   end

  #   test "renders errors when data is invalid", %{conn: conn, user: user} do
  #     conn = put(conn, ~p"/api/users/#{user}", user: @invalid_attrs)
  #     assert json_response(conn, 422)["errors"] != %{}
  #   end
  # end

  # describe "delete user" do
  #   setup [:create_user]

  #   test "deletes chosen user", %{conn: conn, user: user} do
  #     conn = delete(conn, ~p"/api/users/#{user}")
  #     assert response(conn, 204)

  #     assert_error_sent 404, fn ->
  #       get(conn, ~p"/api/users/#{user}")
  #     end
  #   end
  # end

  # defp create_user(_) do
  #   user = user_fixture()
  #   %{user: user}
  # end
end
