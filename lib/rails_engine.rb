# encoding: UTF-8

module VideojsUserTrack_Rails
  module Auth
  end
 
  class Engine < Rails::Engine
    initializer "videojs_user_track.load_app_instance_data" do |app|
      app.class.configure do
        ['db/migrate', 'app/models', 'app/controllers'].each do |path|
          config.paths[path] += VideojsUserTrack_Rails::Engine.paths[path].existent
        end
      end
    end
  end
end
