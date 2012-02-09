module Admin::RacesHelper
	def distance_unit_column(record)
		Race::DISTANCE_UNITS[record.distance_unit] unless record.distance_unit.blank?
	end
	
	def distance_unit_form_column(record, input_name)
		select(:record, :distance_unit, {"km" => 0, "miles" => 1}, {}, {})
	end
end
