# frozen_string_literal: true

# ENVIRONMENT VARIABLES

# DEVELOPMENT
if Rails.env.production?
  ENV['SECRET_KEY_BASE'] = 'production-key'
else
  ENV['DB_PASS_DEV'] = 'sdcdev'
  ENV['DB_USER_DEV'] = 'postgres'
  ENV['DB_NAME_DEV'] = 'sdc'
  ENV['DB_HOST_DEV'] = 'localhost'
  ENV['DB_PORT_DEV'] = '5432'
  ENV['DB_TIMEOUT_DEV'] = '5000'
  ENV['DB_ADAPTER_DEV'] = 'postgresql'
  ENV['DB_ENCODING_DEV'] = 'utf8'
  ENV['RAILS_MAX_THREADS_DEV'] = '5'
  ENV['CORS_ORIGIN'] = 'http://localhost:3000'
  ENV['DB_NAME_TEST'] = 'sdc_test'
end
