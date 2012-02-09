class Answer < ActiveRecord::Base
	belongs_to :event_registration
	belongs_to :question
	belongs_to :question_option

  validates_presence_of :question_id, :on => :create, :message => "can't be blank"
  validates_presence_of :event_registration_id, :on => :create, :message => "can't be blank"

  def value
	  qtype = question.question_type
	  return extra_info if qtype == Question::SINGLE_LINE_TEXT or qtype == Question::MULTI_LINE_TEXT
	  return question_option.title if ( qtype == Question::DROPDOWN_LIST or qtype == Question::CHECKBOXES or qtype == Question::RADIO_BUTTONS ) and !question_option.nil?
	  return 'N/A'
  end
  
end
