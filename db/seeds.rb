# frozen_string_literal: true

case Rails.env
when 'development'
  User.create(email: ENV['SEED_USER_EMAIL'], password: ENV['SEED_USER_PASSWORD'], jti: SecureRandom.uuid)
end
