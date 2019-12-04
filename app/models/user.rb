# frozen_string_literal: true

class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  devise :database_authenticatable, :validatable, :rememberable,
         :jwt_authenticatable, jwt_revocation_strategy: self
end
