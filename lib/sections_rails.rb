require 'sections_rails/helpers'
require "sections_rails/section"

module SectionsRails
  require "sections_rails/railtie" if defined?(Rails)

  def section name, options = {}
    SectionsRails::Section.new(name, self, options).render
  end
end

ActionView::Base.send :include, SectionsRails
