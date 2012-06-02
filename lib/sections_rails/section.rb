module SectionsRails
  require "sections_rails/config"

  class Section
    attr_reader :asset_path, :directory, :filename, :global_path, :partial_path, :path # NOTE (SZ): not too many? :)

    def has_asset? *extensions
      extensions.flatten.each do |ext|
        return true if File.exists?("#{self.global_path}.#{ext}")
      end
      false
    end

    def has_js_asset?
      has_asset?(SectionsRails.config.js_extensions)
    end

    def has_style_asset?
      has_asset?(SectionsRails.config.css_extensions)
    end

    def has_template?
      File.exists?("#{self.partial_path}.erb") || File.exists?("#{self.partial_path}.haml")
    end

    def initialize combined_name
      @filename     = File.basename(combined_name, '.*')
      @directory    = File.dirname(combined_name)
      @path         = File.join(self.directory, self.filename)
      @asset_path   = File.join(self.path, self.filename)
      @global_path  = File.join(Rails.root, SectionsRails.config.path, self.path)
      @partial_path = File.join(self.directory, "_#{filename}")
    end
  end
end