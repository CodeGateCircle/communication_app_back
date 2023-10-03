# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

workspace = Workspace.create(
  name: "general",
  description: "general",
  icon_image_url: "https://picsum.photos/200/300",
  cover_image_url: "https://picsum.photos/200/300"
)
WorkspaceUser.create(
  workspace_id: workspace.id,
  user_id: 1
)

category = Category.create(
  name: "general",
  workspace_id: workspace.id
)

room = Room.create(
  name: "general",
  description: "general",
  category_id: category.id,
  workspace_id: workspace.id
)
RoomUser.create(
  room_id: room.id,
  user_id: 1
)
