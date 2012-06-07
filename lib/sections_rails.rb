require 'sections_rails/helpers'
require "sections_rails/section"

module SectionsRails
  require "sections_rails/railtie" if defined?(Rails)

  def section name
    SectionsRails::Section.new(name).render(lookup_context)
  end
end

ActionView::Base.send :include, SectionsRails
