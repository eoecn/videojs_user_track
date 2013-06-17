Rails.application.routes.draw do
  match 'videojs'=> "videojs#update", :via => :put
end
