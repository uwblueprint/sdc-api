# frozen_string_literal: true

class QuestionsController < ApplicationController
  def index
    @questions = Question.all
    render json: @questions
  end
end
