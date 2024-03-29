module Facebooker
  module Rails
    class FacebookFormBuilder < ActionView::Helpers::FormBuilder
      
      
      second_param = %w(password_field file_field check_box date_select datetime_select time_select)
      third_param = %w(radio_button country_select select time_zone_select)
      fifth_param = %w(collection_select)
      
      def self.create_with_offset(name,offset)
        define_method name do |field,*args|
          options = args[offset] || {}
          build_shell(field,options) do
            super
          end
        end    
      end

      second_param.each do |name|
        create_with_offset(name,0)
      end
      third_param.each do |name|
        create_with_offset(name,1)
      end
      fifth_param.each do |name|
        create_with_offset(name,3)
      end
      
      def build_shell(field,options)
        @template.content_tag "fb:editor-custom", :label=>label_for(field,options) do
          yield
        end
      end
      
      def label_for(field,options)
        options[:label] || field.to_s.humanize
      end
      
      def text(string,options={})
        @template.content_tag "fb:editor-custom",string, :label=>label_for("",options)
      end
      
      
      def text_field(method, options = {})
        options[:label] ||= label_for(method,options)
        add_default_name_and_id(options,method)
        options["value"] ||= value_before_type_cast(object,method)
        @template.content_tag("fb:editor-text","",options)
      end
      
      
      def text_area(method, options = {})
        options[:label] ||= label_for(method,options)
        add_default_name_and_id(options,method)
        @template.content_tag("fb:editor-textarea",value_before_type_cast(object,method),options)        
      end
      
      #
      # Build a text input area that uses typeahed
      # options are like collection_select
      def collection_typeahead(method,collection,value_method,text_method,options={})
        build_shell(method,options) do
          collection_typeahead_internal(method,collection,value_method,text_method,options)
        end
      end
      
      def collection_typeahead_internal(method,collection,value_method,text_method,options={})
        option_values = collection.map do |item|
          value=item.send(value_method)
          text=item.send(text_method)
          @template.content_tag "fb:typeahead-option",text,:value=>value
        end.join
        add_default_name_and_id(options,method)
        options["value"] ||= value_before_type_cast(object,method)
        @template.content_tag("fb:typeahead-input",option_values,options)        
      end
      
      def value_before_type_cast(object,method)
        unless object.nil?
          method_name = method.to_s
          object.respond_to?(method_name + "_before_type_cast") ?
          object.send(method_name + "_before_type_cast") :
          object.send(method_name)
        end
      end
      
      def multi_friend_input(options={})
        build_shell(:friends,options) do
          @template.content_tag("fb:multi-friend-input","",options)
        end
      end

      def buttons(*names)
        buttons=names.map do |name|
          create_button(name)
        end.join
        
        @template.content_tag "fb:editor-buttonset",buttons
      end
      
      def create_button(name)
        @template.content_tag("fb:editor-button","",:value=>name,:name=>"commit")
      end
      
      def add_default_name_and_id(options,method)
        options[:name] ||= "#{object.class.name.underscore}[#{method}]"
        options[:id] ||= "#{object.class.name.underscore}_#{method}"
      end

    end
  end
end