module SectionsRails
  module ViewFinder

    # Returns an array with the file name of all views in the given directory.
    # Views are all files that end in .html.erb
    def self.find_all_views root
      result = []
      Dir.entries(root).each do |view_file|
        next if ['.', '..', '.gitkeep'].include? view_file
        next if view_file[-4..-1] == '.swp'
        full_path = "#{root}/#{view_file}"
        if File.directory? full_path
          result.concat find_all_views(full_path)
        else
          result << full_path
        end
      end
      result
    end

    # Used for :prepare_pages. Not used right now.
    def self.parse_views views
      result = {}
      views_to_parse.each do |view_to_parse|
        view_text = IO.read(File.join root, view_to_parse)
        result[view_to_parse] = find_sections_in_text view_text
      end
      result
    end

  end
end
