module SectionsRails
  module Helpers

    # Returns a list of all section names in the given text.
    #
    # @param [ String ] text
    #
    # @return [ Array<String> ]
    def find_sections text
      result = text.scan(/<%=\s*section\s+['":]([^'",\s]+)/).flatten.sort.uniq
      result.concat text.scan(/^\s*\=\s*section\s+['":]([^'",\s]+)/).flatten.sort.uniq
      result
    end

    # Returns directory and filename portion of the given path.
    #
    # @param [ String ] paths
    #
    # @return [ Array<String, String> ]
    def split_path paths
      dirname = File.dirname(paths)
      dirname = '' if dirname == '.'

      [dirname, File.basename(paths)]
    end
  end
end
