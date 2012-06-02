require "rails/railtie"
module SectionsRails
  class Railtie < Rails::Railtie

    rake_tasks do
      load "tasks/sections_rails_tasks.rake"
    end

    config.after_initialize do
      ActionController::Base.view_paths << SectionsRails.config.path
    end
  end
end
