module SectionsRails
  require "sections_rails/railtie" if defined?(Rails)

  class Section
    attr_reader :asset_path, :directory, :filename, :global_path, :partial_path, :path # NOTE (SZ): not too many? :)

    def has_asset? extensions
      extensions.each do |ext|
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
      self.filename     = File.basename(combined_name)
      self.directory    = File.dirname(combined_name)
      self.path         = File.join(self.directory, self.filename)
      self.asset_path   = File.join(self.path, self.filename)
      self.global_path  = File.join(Rails.root, SectionsRails.config.path, self.path)
      self.partial_path = File.join(self.directory, "_#{filename}")
    end

    def render
      # ?
    end
  end
end