module SectionsRails
  require 'action_view'
  require "sections_rails/section"
  require "sections_rails/railtie" if defined?(Rails)

  def section name, options = {}, &block
    SectionsRails::Section.new(name, self, options, block).render
  end
end

ActionView::Base.send :include, SectionsRails
