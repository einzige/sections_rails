module SectionsRails
  module Helpers

    # Returns directory and filename portion of the given path.
    #
    # @param [ String ] paths
    # @return [ Array<String, String> ]
    def split_path paths
      dirname = File.dirname(paths)
      dirname = '' if dirname == '.'
      [dirname, File.basename(paths)]
    end

  end
end
