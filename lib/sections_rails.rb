require 'sections_rails/helpers'

module SectionsRails

  require "sections_rails/railtie" if defined?(Rails)
  
  def section combined_name
    SectionsRails::Section.new(combined_name).render(lookup_context)
  end
end

ActionView::Base.send :include, SectionsRails