# encoding: UTF-8

class CreateVideojsUserTrack < ActiveRecord::Migration
  def up
    create_table :videojs_user_tracks, :options => 'ENGINE=Innodb DEFAULT CHARSET=utf8', :comment => "每个用户的播放视频小节的时间频度" do |t|
      t.string  :video_id, :default => 0, :comment => "视频ID"
      t.integer :uid, :default => 0, :comment => "用户ID"
      t.integer :video_second_length, :default => 0
      t.text    :status, :comment => "初始化一个长度为要播放视频的以秒为单位长度的数组，各元素初始为零。如果视频正在播放，则给该秒加一; 重复播放，则继续加一。示例格式为" # copied from README
      t.timestamps
    end
    add_index :videojs_user_tracks, [:video_id, :uid]
  end

  def down
  end

end
