FactoryBot.define do
  factory :database do
    name { "A Database" }
    kind { "mysql" }
    description { "Description" }
    host { "host" }
    port { "3306" }
    username { "username" }
    password { "password" }
  end
end
