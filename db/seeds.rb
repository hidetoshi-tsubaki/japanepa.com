# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

max_level = 200
levels = []
prev_threshold = 100

max_level.times do |number|
  prev_threshold *= 1.05
  threshold2 = number * 5
  threshold_point = (prev_threshold + threshold2) / 2
  levels << Level.new( threshold: threshold_point)
end

Level.import levels



Admin.create!(
  email: 'tsubaki@japanepa',
  password: 'japanepa',
  password_confirmation: 'japanepa'
)