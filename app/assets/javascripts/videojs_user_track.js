/*
 * VideoJS视频播放秒数监控
 * 两个setInterval对播放数组做　浏览器本地　和　服务器　同步。
 *
 * 附加 断点播放时间记录(为了重复利用setInterval事件以节省资源)
 *
*/
window.videojs_user_track = function(videojs, video_id, uid, auth_data_hash) {
  if (!window.jQuery) { throw("Please require jQuery first"); }
  if (!window._V_) { throw("Please require videojs first"); }

  var local_a = [];
  var last_second; // 用于排重，因为实际执行的setInterval一秒很可能超过一秒，所以和上一个读取值比较即可。
  var video_length = 0;
  auth_data_hash = (auth_data_hash || {});

  var store_to_local = function(idx) {
    if (idx != last_second) {
      local_a.push(idx);
      last_second = idx;
      // 记录断点播放
      if (idx > 5) { auth_data_hash.last_played_at = last_second; }
    }
  };
  var sync_to_server = function() {
    // save tmp length, to avoid another function modify it.
    var _l = local_a.length;
    if (video_length === 0) { video_length = Math.round(videojs.duration()); }

    if (_l !== 0) {
      var remote_a = local_a.splice(0, _l);
      // TODO unshift if failure
      $.ajax({
        type: 'PUT',
        url: '/videojs.json',
        data: $.extend(auth_data_hash, {
          video_length: video_length,
          seconds: remote_a,
          video_id: video_id,
          uid: uid
        })
      }).done(function (data, textStatus) {
        if ((data.result + '').match(/fail/)) {
          clearInterval(intevals.local);
          clearInterval(intevals.server);
          console.log(data, "Stoped two setIntevals");
        }
      });
    }
  };
  var inspect = function() {
    console.log((new Date()), ' current seconds is ', local_a);
  };

  var intevals = {};
  // TODO 优化，为了避免循环，只在播放时执行，也可以考虑缓存videojs.paused()
  // 存储播放时间到浏览器本地
  intevals.local = setInterval(function() {
    if (!videojs.paused()) {
      // NOTICE 有时可能因为浏览器资源竞争而导致部分秒没有获取
      var time_idx = Math.round(videojs.currentTime());
      store_to_local(time_idx);
    }
  }, 333);

  // 同步播放时间到服务器
  // 不和存储同步是会因为函数阻塞而错过部分时间段
  setTimeout(function() {
    intevals.server = setInterval(function() {
      sync_to_server();
    }, 3000);

    // 在关闭窗口或离开页面前同步
    // 得允许多个beforeunload事件
    $(window).bind('beforeunload', function(event) {
      console.log("send watching data before close the window...");
      sync_to_server();
    });
  }, 5000); // 需观看5秒以上才考虑同步服务器

};

// 测试对浏览器内存和CPU基本无影响。视频播放完后，内存稳定在130.64MB，即使是重复播放。
// TODO 整理成videojs plugin，但目前videojs master似乎有bug，编译的js运行出错，有时间改下。
