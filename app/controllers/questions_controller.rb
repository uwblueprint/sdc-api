class QuestionsController < ApplicationController

    def index

        @Questions = Question.all
        render json: @Questions

    end
end
