FactoryGirl.define do
  factory :repository do
    name                "string"
    user_id             "string"
    stars               "string"
    language            "string"
    organization        "string"
    github_id           1234
    forked              false
    processed           false
  end
end