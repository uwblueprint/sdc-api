class QuestionsController < ApplicationController
    
    def get_questions

        @Question = Question.all
        render json: @Question

    end
end
