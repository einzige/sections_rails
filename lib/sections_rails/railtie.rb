require "rails/railtie"
module SectionsRails
  class Railtie < Rails::Railtie

    rake_tasks do
      load "tasks/sections_rails_tasks.rake"
    end
  end
end
