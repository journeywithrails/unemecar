#Intentionally added line to give error.
#Warning : it will override contab file

if ENV['RAILS_ENV'] == 'development'
  every 10.seconds do 
    runner "Event.send_daily_report"
  end
else
  every 1.day, :at => '12am' do 
    runner "Event.send_daily_report"
  end
end

