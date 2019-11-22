# frozen_string_literal: true

FactoryBot.define do
  factory :jwt_blacklist do
    jwt_id { 'MyString' }
    expire_time { '2019-11-14 20:52:37' }
  end
end
