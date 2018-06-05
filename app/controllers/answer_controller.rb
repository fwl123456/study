class AnswerController < ApplicationController

	def index
		@answer = Answer.questions(params[:question])
	end

end