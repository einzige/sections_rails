module SectionsRails
  
  def section name
    out = []
    out << javascript_include_tag("#{name}/#{name}") if File.exists? "#{Rails.root}/app/sections/#{name}/#{name}.js"
    out << stylesheet_link_tag("#{name}/#{name}") if File.exists? "#{Rails.root}/app/sections/#{name}/#{name}.css"
    if File.exists? "#{Rails.root}/app/sections/#{name}/_#{name}.html.erb" 
      out << render(:partial => "/../sections/#{name}/#{name}")
    else
      out << "<div class=\"#{name}\"></div>"
    end
    out.join("\n").html_safe
  end
  
end

ActionView::Base.send :include, SectionsRails