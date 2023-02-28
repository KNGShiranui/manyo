# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# <administratorデータ>
User.create!(
  name: "SW", 
  email: 'SW@example.com', 
  password: '11101252', 
  password_confirmation: '11101252', 
  administrator: true)
  
# <userデータ>
10.times do |i|
  User.create!(
    name: "KNG#{i + 1}", 
    email: "KNG#{i + 1}@gmail.com", 
    password: '11101252', 
    password_confirmation: '11101252')
end

users = User.all
users = users.map{|user| user.id}
start_day = DateTime.new(2023, 1, 5, 0, 0, 0)
last_day = DateTime.new(2023, 3, 15, 23, 59, 59)

# <taskデータ>
10.times do |i|
  Task.create!(
    title: "タスク#{i + 1}",
    content: "万葉#{i + 1}",
    due_date: rand(start_day..last_day),
    priority: rand(0..2),
    status: rand(0..2),
    user_id: users.sample)
end

# <labelデータ>  
10.times do |i|
  Label.create!(name: "step#{i + 1}")
end

# labels = Label.all
# labels = labels.map{|label| label.id}
# tasks = Task.all
# tasks = tasks.map{|task| task.id}

