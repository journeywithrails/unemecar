module Admin::AuditsHelper
	
	def changes_column(record)
		keys = record.changes.keys
		res = ""
		keys.each do |key|
			begin
				res += "#{key}: #{record.changes[key][0]} -> #{record.changes[key][1]}<br/>"
			rescue
				res += ""
			end
			
		end
		res
	end
end
