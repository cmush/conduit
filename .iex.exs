alias Conduit.{App, Router}
App.start_link()

alias Conduit.Accounts.{
  Aggregates.User,
  Commands.RegisterUser,
  Events.UserRegistered
}

user_params = %{
  user_uuid: UUID.uuid4(),
  bio: "I like to skateboard",
  email: "jake@jake.jake",
  hashed_password: "jakejake",
  image: "https://i.stack.imgur.com/xHWG8.jpg",
  username: "jake"
}

register_user = RegisterUser.new(user_params)
