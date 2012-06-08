module SectionsRails
  require "sections_rails/config"

  class Section
    attr_reader :asset_path, :css, :directory_name, :filename, :absolute_asset_path, :js, :locals, :partial, :partial_include_path, :partial_file_path

    def initialize section_name, view = nil, options = {}
      section_name = section_name.to_s

      # Helpers for filenames.
      @filename             = File.basename section_name, '.*'
      @directory_name       = File.dirname(section_name).gsub(/^\.$/, '')

      # Options.
      @js      = options[:js]
      @css     = options[:css]
      @partial = options[:partial]
      @locals  = options[:locals]

      # For running view helper methods.
      @view = view
    end

    # Path of the folder on the file system.
    # Example: 'app/sections/folder/section'
    def folder_filepath
      @folder_filepath ||= File.join SectionsRails.config.path, @directory_name, @filename
    end

    # Path to access assets on the file system.
    # Includes only the base name of assets, without extensions.
    # Example: 'app/sections/folder/section/section'
    def asset_filepath
      @asset_filepath ||= File.join SectionsRails.config.path, asset_includepath
    end

    # Path for including assets into the web page.
    #
    def asset_includepath
      @asset_includepath ||= File.join(@directory_name, @filename, @filename).gsub(/^\//, '')
    end

    # The path for accessing the partial on the filesystem.
    # Example: '
    def partial_filepath
      @asset_filepath ||= File.join SectionsRails.config.path, partial_includepath
    end

    # For including the partial into views.
    def partial_includepath
      @partial_includepath ||= File.join(@directory_name, @filename, "_#{@filename}").gsub(/^\//, '')
    end

    # Returns the asset_path of asset with the given extensions.
    # Helper method.
    def find_asset_path asset_option, extensions
      return nil if asset_option == false
      return asset_option if asset_option
      extensions.each do |ext|
        file_path = "#{asset_filepath}.#{ext}"
        return asset_includepath if File.exists? file_path
      end
      nil
    end

    # Returns the path to the JS asset of this section, or nil if the section doesn't have one.
    def find_css_asset_path
      find_asset_path @css, SectionsRails.config.css_extensions
    end

    # Returns the path to the JS asset of this section, or nil if the section doesn't have one.
    def find_js_includepath
      find_asset_path @js, SectionsRails.config.js_extensions
    end

    # Returns the filename of the partial of this section, or nil if this section has no partial.
    def find_partial_filename
      SectionsRails.config.partial_extensions.each do |ext|
        path = "#{partial_filepath}.#{ext}"
        return path if File.exists? path
      end
      nil
    end

    # Returns a list of all section names in the given text.
    #
    # @param [ String ] text
    # @return [ Array<String> ]
    def self.find_sections text

      # Find sections in ERB templates.
      result = text.scan(/<%=\s*section\s+['":]([^'",\s]+)/).flatten.sort.uniq

      # Find sections in HAML templates.
      result.concat text.scan(/^\s*\=\s*section\s+['":]([^'",\s]+)/).flatten.sort.uniq

      result
    end

    # TODO: replace this with find_asset.
    def has_asset? *extensions
      extensions.flatten.each do |ext|
        return true if File.exists?("#{asset_filepath}.#{ext}")
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
      @view.lookup_context.template_exists? @partial_path
    end

    # TODO(SZ): missing specs.
    def render
      result = []

      # Include assets only for development mode.
      if Rails.env != 'production'

        # Include JS assets.
        if js
          result << @view.javascript_include_tag(File.join(path, js))
        elsif js == false
          # ":js => false" given --> don't include any JS.
        elsif has_default_js_asset?
          result << @view.javascript_include_tag(asset_path)
        end

        # Include CSS assets.
        if css
          result << @view.stylesheet_link_tag(File.join(path, css))
        elsif css == false
          # ":css => false" given --> don't include any CSS.
        elsif has_default_style_asset?
          result << @view.stylesheet_link_tag(@asset_path)
        end
      end

      # Render the section partial into the view.
      case partial
        when :tag
          result << @view.content_tag(:div, '', :class => filename)

        when false
          # partial: false given --> render nothing

        when nil
          # partial: nil given --> render default partial

          if self.has_partial?
            result << @view.render(:partial => asset_path, :locals => locals)
          else
            result << @view.content_tag(:div, '', :class => filename)
          end

        else
          # partial: custom path given --> render custom partial

          result << @view.render("#{path}/#{partial}", locals)
      end

      result.join("\n").html_safe
    end
  end
end
