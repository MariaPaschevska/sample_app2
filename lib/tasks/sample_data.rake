namespace :db do
  desc "Fill database with sample data"
  #ensures that the Rake task has access to the local Rails environment, including the User model
  task populate: :environment do
    # Код заполнителя образцов данных для создания административного пользователя
    admin = User.create!(name: "Example User",
                         email: "example@railstutorial.org",
                         password: "foobar",
                         password_confirmation: "foobar")
    admin.toggle!(:admin)

    #create! is just like the create method, except it raises an exception for an invalid user rather than returning false
    User.create!(name: "Example User",
                 email: "example@railstutorial.org",
                 password: "foobar",
                 password_confirmation: "foobar")
    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end
  end
end