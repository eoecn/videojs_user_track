# 在video-js框架里，记录用户重复播放视频里各部分的频度。

### 需求
判断教学视频如何被用户观看的效果，最简单的是看用户如何重复播放或跳过播放。

### 技术详解
初始化一个长度为要播放视频的以秒为单位长度的数组，各元素初始为零。如果视频正在播放，则给该秒加一; 重复播放，则继续加一。

### 使用
1.   添加videojs_user_tracks数据库表，bundle exec rake db:migrate
2.   实现VideojsUserTrack_Rails::Auth#auth方法
3.   在js里引用//= require videojs_user_track.js
4.   配置js参数，比如 _V_.user_track(eoe.video_player, section_id, eoe.uid, {uhash: eoe.uhash})
5.   播放一个视频，看看Rails log或数据库里是否出现了更新

### 用户认证
在config/initializers/videojs_user_track_rails.rb添加如下代码，并实现你的auth方法

```ruby
module VideojsUserTrack_Rails
  module Auth
    def auth
      # your auth code, it can acces the scope in videojs controller
    end
  end
end
```

### TODO
1. 支持其他浏览器内视频播放框架
2. 管理页面
