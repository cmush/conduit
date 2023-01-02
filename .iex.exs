alias Conduit.{
  App,
  Router,
  Accounts
}

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

# user_params =  %{user_params | username: "jake3", email: "jake3@jake.jake",  user_uuid: UUID.uuid4}
# Accounts.register_user user_params
# %{username: "jake", email: "jake@jake.jake",hashed_password: "jakejake",bio: "I like to skateboard",image: "https://i.stack.imgur.com/xHWG8.jpg",user_uuid: "9b69bafd-bf65-4c61-81f1-599c76449eb3"} |> Accounts.register_user()
