# frozen_string_literal: true

class SessionsController < Devise::SessionsController
  respond_to :json

  private

  # this returns a response with the session info in json format
  # including the jti, user, and timestamps
  def respond_with(resource, _opts = {})
    render json: resource
  end

  # upon logout, this is the handler that will handle what to send
  # as response, currently just sets header to 200
  def respond_to_on_destroy
    head :ok
  end
end
