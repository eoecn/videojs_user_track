Gem::Specification.new do |s|
  s.name        = 'videojs_user_track'
  s.version     = '0.1'
  s.date        = '2013-04-01'
  s.summary     = File.read("README.markdown").split(/===+/)[0].strip
  s.description = s.summary
  s.authors     = ["David Chen"]
  s.email       = 'mvjome@gmail.com'
  s.homepage    = 'https://github.com/eoecn/videojs_user_track'

  s.files = `git ls-files`.split("\n")
end
