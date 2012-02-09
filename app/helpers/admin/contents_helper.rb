module Admin::ContentsHelper
  def item_content_form_column(record, input_name)
		fckeditor_textarea( :record, :item_content, :toolbarSet => 'Simple', :name=> input_name, :width => "800px", :height => "400px" )
	end

	def item_content_column(record)
		sanitize(record.item_content)
	end
end
