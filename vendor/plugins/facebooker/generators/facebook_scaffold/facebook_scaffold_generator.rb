class Rails::Generator::Commands::Create
    def register_fbml_mime_type_alias
      path = destination_path('config/initializers/mime_types.rb')
      content = "Mime::Type.register_alias 'text/html', :fbml"  
      unless File.read(path).match(Regexp.escape(content))
	logger.register "text/html, :fbml"
	File.open(path, 'a') { |file| file.write(content) }
      end
    end
end
class Rails::Generator::Commands::Destroy
    def register_fbml_mime_type_alias
	# do nothing
    end
end

class FacebookScaffoldGenerator < Rails::Generator::NamedBase
  default_options :skip_timestamps => false, :skip_migration => false

  attr_reader   :controller_name,
                :controller_class_path,
                :controller_file_path,
                :controller_class_nesting,
                :controller_class_nesting_depth,
                :controller_class_name,
                :controller_underscore_name,
                :controller_singular_name,
                :controller_plural_name
  alias_method  :controller_file_name,  :controller_underscore_name
  alias_method  :controller_table_name, :controller_plural_name

  def initialize(runtime_args, runtime_options = {})
    super

    @controller_name = @name.pluralize

    base_name, @controller_class_path, @controller_file_path, @controller_class_nesting, @controller_class_nesting_depth = extract_modules(@controller_name)
    @controller_class_name_without_nesting, @controller_underscore_name, @controller_plural_name = inflect_names(base_name)
    @controller_singular_name=base_name.singularize
    if @controller_class_nesting.empty?
      @controller_class_name = @controller_class_name_without_nesting
    else
      @controller_class_name = "#{@controller_class_nesting}::#{@controller_class_name_without_nesting}"
    end
  end

  def manifest
    record do |m|
      # Check for class naming collisions.
      m.class_collisions(controller_class_path, "#{controller_class_name}Controller", "#{controller_class_name}Helper")
      m.class_collisions(class_path, "#{class_name}")

      # Controller, helper, views, test and stylesheets directories.
      m.directory(File.join('app/models', class_path))
      m.directory(File.join('app/controllers', controller_class_path))
      m.directory(File.join('app/helpers', controller_class_path))
      m.directory(File.join('app/views', controller_class_path, controller_file_name))
      m.directory(File.join('app/views/layouts', controller_class_path))
      m.directory(File.join('test/functional', controller_class_path))
      m.directory(File.join('test/unit', class_path))
      m.directory(File.join('public/stylesheets', class_path))

      for action in scaffold_views
        m.template(
          "view_#{action}.html.erb",
          File.join('app/views', controller_class_path, controller_file_name, "#{action}.html.erb")
        )
        m.template(
          "view_#{action}.fbml.erb",
          File.join('app/views', controller_class_path, controller_file_name, "#{action}.fbml.erb")
        )
      end

      # Layout and stylesheet.
      m.template('layout.html.erb', File.join('app/views/layouts', controller_class_path, "#{controller_file_name}.html.erb"))
      m.template('layout.fbml.erb', File.join('app/views/layouts', controller_class_path, "#{controller_file_name}.fbml.erb"))
      m.template('style.css', 'public/stylesheets/scaffold.css')
      m.template('facebook_style.css', 'public/stylesheets/facebook_scaffold.css')

      m.template(
        'controller.rb', File.join('app/controllers', controller_class_path, "#{controller_file_name}_controller.rb")
      )

      m.template('functional_test.rb', File.join('test/functional', controller_class_path, "#{controller_file_name}_controller_test.rb"))
      m.template('helper.rb',          File.join('app/helpers',     controller_class_path, "#{controller_file_name}_helper.rb"))

      m.route_resources controller_file_name

      m.dependency 'model', [name] + @args, :collision => :skip

      m.register_fbml_mime_type_alias
    end
  end

  protected
    # Override with your own usage banner.
    def banner
      "Usage: #{$0} scaffold ModelName [field:type, field:type]"
    end

    def add_options!(opt)
      opt.separator ''
      opt.separator 'Options:'
      opt.on("--skip-timestamps",
             "Don't add timestamps to the migration file for this model") { |v| options[:skip_timestamps] = v }
      opt.on("--skip-migration",
             "Don't generate a migration file for this model") { |v| options[:skip_migration] = v }
    end

    def scaffold_views
      %w[ index show new edit ]
    end

    def model_name
      class_name.demodulize
    end

end
