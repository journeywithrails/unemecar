class Director::PaymentsController < ApplicationController
	before_filter :login_required, :set_director_event

    def index
        @payments = @dir_event.event_payments.find(:all, :order => "date DESC")
    end
end
