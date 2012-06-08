module SectionsRails
  require "sections_rails/config"
  require "action_view"

  class Section
    include ActionView::Helpers::AssetTagHelper
    include ActionView::Helpers::RenderingHelper

    # TODO(KG): remove unnessessary.
    attr_reader :asset_path, :css, :directory_name, :filename, :absolute_path, :js, :locals, :partial, :partial_path, :path # NOTE (SZ): too many? :)

    def initialize section_name, rails_obj, options = {}

      # Helpers for filenames.
      @filename       = File.basename(section_name, '.*')
      @directory_name = File.dirname(section_name)
      @asset_path     = File.join(@directory_name, @filename, @filename)
      @absolute_path  = File.join(Rails.root, SectionsRails.config.path, @directory_name, @filename, @filename)
      @partial_path   = File.join(Rails.root, SectionsRails.config.path, @directory_name, @filename, "_#{@filename}")

      # Options.
      @js             = options[:js]
      @css            = options[:css]
      @partial        = options[:partial]
      @locals         = options[:locals]

      # For running view helper methods.
      @rails_obj = rails_obj
    end

    def has_asset? *extensions
      extensions.flatten.each do |ext|
        return true if File.exists?("#{@absolute_path}.#{ext}")
      end
      false
    end

    def has_default_js_asset?
      has_asset? SectionsRails.config.js_extensions
    end

    def has_default_style_asset?
      has_asset? SectionsRails.config.css_extensions
    end

    # Returns whether this section has a template.
    def has_template?
      SectionsRails.config.partial_extensions.each do |ext|
        return true if File.exists?("#{@partial_path}.#{ext}")
      end
      false
    end

    # TODO(SZ): missing specs.
    def render
      result = []

      # Include assets only for development mode.
      if Rails.env != 'production'

        # Include JS assets.
        if js
          result << @rails_obj.javascript_include_tag(File.join(path, js))
        elsif js == false
          # ":js => false" given --> don't include any JS.
        elsif has_default_js_asset?
          result << @rails_obj.javascript_include_tag(asset_path)
        end

        # Include CSS assets.
        if css
          result << @rails_obj.stylesheet_link_tag(File.join(path, css))
        elsif css == false
          # ":css => false" given --> don't include any CSS.
        elsif has_default_style_asset?
          result << @rails_obj.stylesheet_link_tag(@asset_path)
        end
      end

      # Render the section partial into the view.
      case partial
        when :tag
          result << @rails_obj.content_tag(:div, '', :class => filename)

        when false
          # partial: false given --> render nothing

        when nil
          # partial: nil given --> render default partial

          if self.has_template?
            result << @rails_obj.render(:partial => asset_path, :locals => locals)
          else
            result << @rails_obj.content_tag(:div, '', :class => filename)
          end

        else
          # partial: custom path given --> render custom partial

          result << @rails_obj.render("#{path}/#{partial}", locals)
      end

      result.join("\n").html_safe
    end
  end
end
