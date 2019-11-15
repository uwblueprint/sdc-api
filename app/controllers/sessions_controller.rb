# frozen_string_literal: true
class SessionsController < Devise::SessionsController
  respond_to :json
end
