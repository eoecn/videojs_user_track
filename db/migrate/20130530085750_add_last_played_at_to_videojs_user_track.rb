# encoding: UTF-8

class AddLastPlayedAtToVideojsUserTrack < ActiveRecord::Migration
  def change
    add_column :videojs_user_tracks, :last_played_at, :integer, :comment => "上次播放时间"
  end
end
