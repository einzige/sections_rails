module SectionsRails
  module PartialParser
    
    # Returns a list of all section names in the given text.
    #
    # @param [ String ] text
    # @return [ Array<String> ]
    def self.find_sections text
      return [] if text.blank?

      # Find sections in ERB templates.
      result = text.scan(/<%=\s*section\s+['":]([^'",\s]+)/).flatten.sort.uniq

      # Find sections in HAML templates.
      result.concat text.scan(/^\s*\=\s*section\s+['":]([^'",\s]+)/).flatten.sort.uniq

      result
    end
  end
end

