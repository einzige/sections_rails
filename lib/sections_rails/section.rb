module SectionsRails
  require "sections_rails/config"
  require "action_view"

  class Section
    include ActionView::Helpers::AssetTagHelper
    include ActionView::Helpers::RenderingHelper

    # TODO(KG): remove unnessessary.
    attr_reader :asset_path, :css, :directory_name, :filename, :absolute_asset_path, :js, :locals, :partial, :partial_path, :path # NOTE (SZ): too many? :)

    def initialize section_name, rails_obj = nil, options = {}
      section_name = section_name.to_s

      # Helpers for filenames.
      @filename       = File.basename section_name, '.*'
      @directory_name = File.dirname section_name
      @directory_name = '' if @directory_name == '.'
      @asset_path     = @directory_name != '' ? File.join(@directory_name, @filename, @filename) : File.join(@filename, @filename)
      @absolute_asset_path  = File.join Rails.root, SectionsRails.config.path, @asset_path
      @partial_path   = File.join Rails.root, SectionsRails.config.path, @directory_name, @filename, "_#{@filename}"

      # Options.
      @js             = options[:js]
      @css            = options[:css]
      @partial        = options[:partial]
      @locals         = options[:locals]

      # For running view helper methods.
      @rails_obj = rails_obj
    end

    def find_existing_filename basename, extensions
      extensions.each do |ext|
        path = "#{@absolute_asset_path}.#{ext}"
        return path if File.exists? path
      end
      nil
    end

    # Returns the filename of the partial of this section, or nil if this section has no partial.
    def find_partial_filename
      find_existing_filename @partial_path, SectionsRails.config.partial_extensions
    end


    # TODO: replace this with find_asset.
    def has_asset? *extensions
      extensions.flatten.each do |ext|
        return true if File.exists?("#{@absolute_asset_path}.#{ext}")
      end
      false
    end

    # TODO: replace this with find_asset.
    def has_default_js_asset?
      has_asset? SectionsRails.config.js_extensions
    end

    # TODO: replace this with find_asset.
    def has_default_style_asset?
      has_asset? SectionsRails.config.css_extensions
    end

    # Returns whether this section has a template.
    # Deprecated.
    def has_partial?
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

          if self.has_partial?
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
