module SectionsRails

  require "sections_rails/railtie" if defined?(Rails)
  
  def section combined_name
    section = SectionsRails::Section.new(combined_name)

    out = []

    # Add assets of section when in dev mode.
    unless Rails.config.assets.compress
      out << javascript_include_tag(section.asset_path) if section.has_js_asset?
      out << stylesheet_link_tag(section.asset_path)    if section.has_style_asset?
    end

    # Render the section partial into the view.
    if section.has_template? # TODO: replace with template_exists?
      out << render(:partial => section.asset_path)
    else
      out << content_tag(:div, '', :class => filename)
    end

    out.join("\n").html_safe
  end
  
end

ActionView::Base.send :include, SectionsRails
