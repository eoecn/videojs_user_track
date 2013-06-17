# encoding: UTF-8

class VideojsUserTrack < ActiveRecord::Base
  attr_accessible :video_id, :uid, :video_second_length, :status, :mark_watched

  # like array index in Ruby, idx begins with 0
  def inc_seconds seconds, last_played_at = nil
    return false if seconds.blank?
    seconds = seconds.map(&:to_i).uniq
    return false if seconds.detect {|second| (second > ut.video_second_length) || (second < 0)} # 大于video_second_length的秒一定不合法

    seconds.each do |second|
      data[second] ||= 0
      data[second] +=  1
      data[second] = 9 if data[second] >= 10 # 最多只记录9次
    end
    self.last_played_at = last_played_at if not last_played_at.to_i.zero?

    resave!
  end

  # 返回未看的 最大连续区域的首个索引
  def max_unwatched_range_begin_at
    data_str = data.join
    flags = data_str.scan(/[1-9]+|0+/)
    flag_zero_max = flags.select {|i| i.to_i.zero? }.max {|i| i.length }
    return 0 if flag_zero_max.nil?
    data_str.index(flag_zero_max) + 1
  end

  def played_percents
    return 0 if data.size.zero?
    data.reject {|i| i.to_i.zero? }.size / data.size.to_f
  end

  def finished?
    # 避免视频没有初始化
    (video_second_length > 10) &&
    # 总时长误差不超过5秒
    ((data.length - video_second_length).abs <= 5) &&
    (
      # 判断中断次数是否超过总秒数的二十分之一，否则就算看完。
      # 比如60秒的视频，里面没看的只有3秒，不管连续还是不连续，就算看完了。
      (played_percents >= 0.95) ||
      # 或者强制标记看完
      self.mark_watched
    )
  end

  def data
    @data ||= (begin
      a = JSON.parse(ut.status.to_s) rescue []
      (a[ut.video_second_length - 1] ||= 0) if not ut.video_second_length.zero?
      a.map(&:to_i)
    end)
  end

  # alias user_track
  def ut; self end
  def resave!
    ut.status = data.to_json
    ut.save!
  end

end
