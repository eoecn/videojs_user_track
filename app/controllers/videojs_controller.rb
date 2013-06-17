# encoding: UTF-8

class VideojsController < ApplicationController
  include VideojsUserTrack_Rails::Auth

  def update
    @result = if auth
      ut = VideojsUserTrack.find_or_create_by_video_id_and_uid(params[:video_id], params[:uid])
      ut.update_attributes(:video_second_length => params[:video_length]) if ut.video_second_length.to_i.zero?
      ut.inc_seconds(params[:seconds], params[:last_played_at])
      'success'
    else
      'auth failure'
    end

    respond_to do |format|
      format.json { render :json => {:result => @result}, :status => 200 }
    end
  end
end
