# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'rspec', :version => 2 do
#  watch(%r{^spec/.+_spec\.rb$})
#  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
#  watch('spec/spec_helper.rb')  { "spec" }
#  watch(/.*/)  { "spec" }
  watch(%r{^app/sections/})        { "spec" }
  watch(%r{^lib/})                 { "spec" }
  watch(%r{^spec/controllers/})    { "spec" }
  watch(%r{^spec/dummy/app/})      { "spec" }
  watch(%r{^spec/sections_rails/}) { "spec" }
end

