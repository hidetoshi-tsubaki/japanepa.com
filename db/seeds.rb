# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

max_level = 500
levels = []
current_point = 10

levels << Level.new( threshold: 0)
max_level.times do |number|
  current_point = current_point + (100 + number * number) / 2
  levels << Level.new( threshold: current_point)
end

Level.import levels

Admin.create!(
  name: 'japanepa.com',
  password: 'japanepa',
  password_confirmation: 'japanepa'
)