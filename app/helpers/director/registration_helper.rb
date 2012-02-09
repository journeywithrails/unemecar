module Director::RegistrationHelper
	
	def shorten(text, size=20)
		if text.length > size
			"#{text[0..size]}.."
		else
			text
		end
	end
end
