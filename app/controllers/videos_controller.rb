# encoding: UTF-8
class VideosController < ApplicationController
  def new
    @video = Video.new
  end

  def create
    @video = Video.new(params[:video])
    @video.estado = Video::PROCESSING_STATE
    @user = @video.user
    if @video.save
      @video.update_attributes(path: "#{@video.video}")
      flash[:success] = 'Thank you! We have received the video. You may see it on your profile soon.'
      redirect_to user_path(@user)
    else
      flash[:error] = 'Error loading video.'
      redirect_to user_path(@user)
    end
  end

  def index
    @videos = Video.paginate(page: params[:page] , :per_page => 4)
  end
end
