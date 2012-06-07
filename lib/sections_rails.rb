require 'sections_rails/string_tools'

module SectionsRails

  require "sections_rails/railtie" if defined?(Rails)
  
  def section combined_name, options = {}
    result = []

    # Split the parameter into file name and directory name.
    directory, filename = split_path combined_name
    directory_path = "#{Rails.root}/app/sections/#{directory}#{filename}"    # Directory of section: /app/sections/admin/logo

    # Add assets of section when in dev mode.
    file_path = "#{directory_path}/#{filename}"                              # Base path of filename in section: /app/sections/admin/logo/logo
    if Rails.env != 'production'

      # Include JS assets.
      if options.has_key? :js
        if options[:js]
          # Custom :js filename given --> load the given JS file.
          result << javascript_include_tag("#{directory}#{filename}/#{options[:js]}")
        else
          # js: false given --> don't do anything here.
        end
      else
        # No :js option given --> load the default JS file.
        if File.exists?("#{file_path}.js") || File.exists?("#{file_path}.js.coffee") || File.exists?("#{file_path}.coffee")
          result << javascript_include_tag("#{directory}#{filename}/#{filename}")
        end
      end

      # Include CSS assets.
      if options.has_key? :css
        if options[:css]
          # Custom :css option given --> render the given file.
          result << stylesheet_link_tag("#{directory}#{filename}/#{options[:css]}")
        else
          # css: false given --> don't render any css.
        end
      else
        # No :css option given --> render the default :css file.
        if File.exists?("#{file_path}.css") || File.exists?("#{file_path}.css.scss") || File.exists?("#{file_path}.css.sass") || File.exists?("#{file_path}.scss") || File.exists?("#{file_path}.sass") 
          result << stylesheet_link_tag("#{directory}#{filename}/#{filename}")
        end
      end
    end

    # Render the section partial into the view.
    partial_path = "#{directory_path}/_#{filename}.html"
    if options.has_key? :partial
      if options[:partial] == :tag
        # :partial => :tag given --> render the tag.
        result << content_tag(:div, '', :class => filename)
      elsif options[:partial]
        # some value for :partial given --> render the given partial.
        result << render(:partial => "/../sections/#{directory}#{filename}/#{options[:partial]}", :locals => options[:locals])
      else
        # partial: false or nil given --> render nothing
      end
    else
      # No :partial option given --> render the file or tag per convention.
      if File.exists?("#{partial_path}.erb") || File.exists?("#{partial_path}.haml")
        result << render(:partial => "/../sections/#{directory}#{filename}/#{filename}", :locals => options[:locals])
      else
        result << content_tag(:div, '', :class => filename)
      end
    end
    result.join("\n").html_safe
  end
  
end

ActionView::Base.send :include, SectionsRails
