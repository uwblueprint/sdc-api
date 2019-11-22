# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :validatable, :rememberable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtBlacklist
end
