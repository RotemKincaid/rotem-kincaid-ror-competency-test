# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Article.delete_all
User.delete_all

editor = User.create!(email_address: "editor@test.com", password: "password", roles: "editor")
user   = User.create!(email_address: "user@test.com",   password: "password", roles: "user")
admin  = User.create!(email_address: "admin@test.com",  password: "password", roles: "admin")

Article.create!(title: "Tech 1", content: "Hello", category: "Tech", user: editor)
Article.create!(title: "Tech 2", content: "Hello", category: "Tech", user: editor)
Article.create!(title: "News 1", content: "Hello", category: "News", user: editor)

editor2 = User.create!(email_address: "editor2@test.com", password: "password", roles: "editor")

Article.create!(title: "Other Editor Article", content: "Not yours", category: "Tech", user: editor2)

