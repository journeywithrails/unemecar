class Question < ActiveRecord::Base
	has_many :answers
	has_many :question_options, :order => :q_order, :dependent => :destroy
	
	
	belongs_to :event
	attr_accessor :dname
	#question types constants
	SINGLE_LINE_TEXT = 0
	MULTI_LINE_TEXT = 1
	DROPDOWN_LIST = 2
	CHECKBOXES = 3
	RADIO_BUTTONS = 4
	
	Q_TYPES = ["Single Line Text", "Multi-line Text", "Dropdown List", "Checkboxes", "Radio Buttons"]
  after_save :save_question_options

  #validates_associated :question_options

  def self.SELECT_Q_TYPES
    {"Single Line Text" => 0, "Multi-line Text" => 1, "Dropdown List" => 2, "Checkboxes" => 3,
      "Radio Buttions" => 4
    }
  end
  
  def new_option_attributes=(option_attributes)
    logger.debug option_attributes.inspect
    option_attributes.each do |attributes|
      question_options.build(attributes)
    end 
  end

  def new_answers_attrs=(aattr)
    aattr.each do |attributes|
      answers.build(attributes)
    end
  end
  
private
  def save_question_options
    question_options.each do |option|
      option.save(false)
    end
  end

  def save_answers
    answers.delete_all
    answers.each {|a| a.save(false) if a.new_record? }
  end
  
end
