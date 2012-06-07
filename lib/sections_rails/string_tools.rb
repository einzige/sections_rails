# Returns a list of all section names in the given text.
def find_sections text
  result = text.scan(/<%=\s*section\s+['":]([^'",\s]+)/).flatten.sort.uniq
  result.concat text.scan(/^\s*\=\s*section\s+['":]([^'",\s]+)/).flatten.sort.uniq
  result
end


# Returns directory and filename portion of the given path.
def split_path paths
  segments = paths.split '/'
  directory = segments[0..-2].join('/')
  directory += '/' if directory.size > 0
  [directory, segments[-1]]
end
