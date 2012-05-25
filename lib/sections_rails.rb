module SectionsRails

  require "sections_rails/railtie" if defined?(Rails)
  
  def section name
    out = []
    filename = "#{Rails.root}/app/sections/#{name}/#{name}"

    # Add assets of section when in dev mode.
    if Rails.env != 'production'
      out << javascript_include_tag("#{name}/#{name}") if File.exists?("#{filename}.js") || File.exists?("#{filename}.js.coffee") || File.exists?("#{filename}.coffee")
      out << stylesheet_link_tag("#{name}/#{name}") if File.exists?("#{filename}.css") || File.exists?("#{filename}.css.scss") || File.exists?("#{filename}.css.sass") || File.exists?("#{filename}.scss") || File.exists?("#{filename}.sass") 
    end

    # Render the section partial into the view.
    filename = "#{Rails.root}/app/sections/#{name}/_#{name}.html"
    if File.exists?("#{filename}.erb") || File.exists?("#{filename}.haml")
      out << render(:partial => "/../sections/#{name}/#{name}")
    else
      out << content_tag(:div, '', :class => name)
    end

    out.join("\n").html_safe
  end
  
end

ActionView::Base.send :include, SectionsRails
