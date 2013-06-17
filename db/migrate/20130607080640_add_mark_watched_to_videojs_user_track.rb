# encoding: UTF-8

class AddMarkWatchedToVideojsUserTrack < ActiveRecord::Migration
  def change
    add_column :videojs_user_tracks, :mark_watched, :boolean, :default => false, :comment => "手工标记看完"
  end
end
