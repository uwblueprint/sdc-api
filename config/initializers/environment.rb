# ENVIRONMENT VARIABLES

# DEVELOPMENT
unless Rails.env.production?
    ENV["DB_PASS"] = "sdcdev"
    ENV["DB_USER"] = "postgres"
    ENV["DB_NAME"] = "sdc"
    ENV["DB_HOST"] = "localhost"
    ENV["DB_PORT"] = "5432"
    ENV["DB_TIMEOUT"] = "5000"
    ENV["DB_ADAPTER"] = "postgresql"
    ENV["DB_ENCODING"] = "utf8"
end