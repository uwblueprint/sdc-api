# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it "is valid with valid attributes" do
    expect(User.new(email: "test@test.com", password:"password")).to be_valid
  end
  it "is not valid without email" do
    user = User.new(email: nil)
    expect(user).to_not be_valid
  end
  it "is not valid without encrypted password" do
    user = User.new(password: nil)
    expect(user).to_not be_valid
  end
  it "is not valid with invalid email" do
    user = User.new(email: "not_an_email", password: "testing")
    expect(user).to_not be_valid
  end
  it "is not valid with password shorter than 6 chars" do
    user = User.new(email: "test@test.com", password: "p")
    expect(user).to_not be_valid
  end
end
