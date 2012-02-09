class Admin::QuestionsController < ApplicationController
	before_filter :verify_login
	layout "admin"
	active_scaffold :question do |config|
	    config.list.columns = [:title, :question_type, :is_required]
	end
end
