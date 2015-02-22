FactoryGirl.define do
  factory :user do
    email             "string"
    sequence(:login)  {|n| "string #{n}" }
    name              "string"
    company           "string"
    blog              "string"
    gravatar_url      "string"
    location          "string"
    country           "string"
    city              "string"
    github_id         123
    processed         false
  end
end