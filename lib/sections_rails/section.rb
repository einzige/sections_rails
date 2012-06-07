module SectionsRails
  require "sections_rails/railtie" if defined?(Rails)

  class Section
    include ActionView::Helpers::AssetTagHelper
    include ActionView::Helpers::RenderingHelper

    # TODO(KG): remove unnessessarry.
    attr_reader :asset_path, :css, :directory, :filename, :global_path, :js, :locals, :partial, :partial_path, :path # NOTE (SZ): too many? :)

    def has_asset? extensions
      extensions.each do |ext|
        return true if File.exists?("#{self.global_path}.#{ext}")
      end
      false
    end

    def has_default_js_asset?
      has_asset?(SectionsRails.config.js_extensions)
    end

    def has_default_style_asset?
      has_asset?(SectionsRails.config.css_extensions)
    end

    def initialize combined_name, options = {}
      self.filename     = File.basename(combined_name)
      self.directory    = File.dirname(combined_name)
      self.path         = File.join(self.directory, self.filename)
      self.asset_path   = File.join(self.path, self.filename)
      self.global_path  = File.join(Rails.root, SectionsRails.config.path, self.path)
      self.partial_path = File.join(self.directory, "_#{filename}")
      self.js           = options.delete(:js)
      self.css          = options.delete(:css)
      self.partial      = options.delete(:partial)
      self.locals       = options
    end

    def render lookup_context
      result = []

      # Only for dev mode.
      if ( ! Rails.config.assets.compress)

        # Include JS assets.
        if js
          result << javascript_include_tag(File.join(path, js))
        elsif has_default_js_asset?
          result << javascript_include_tag(asset_path)
        end

        # Include CSS assets.
        if css
          result << stylesheet_link_tag(File.join(path, css))
        elsif has_default_style_asset?
          result << stylesheet_link_tag(asset_path)
        end
      end

      # Render the section partial into the view.
      case partial
        when :tag
          result << content_tag(:div, '', :class => filename)

        when false
          # partial: false given --> render nothing

        when nil
          # partial: nil given --> render default partial

          if lookup_context.template_exists?(partial_path)
            result << render(asset_path, locals)
          else
            result << content_tag(:div, '', :class => filename)
          end

        else
          # partial: custom path given --> render custom partial

          result << render("#{path}/#{partial}", locals)
      end

      result.join("\n").html_safe
    end
  end
end