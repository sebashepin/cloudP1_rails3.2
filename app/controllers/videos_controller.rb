# encoding: UTF-8
class VideosController < ApplicationController
  def new
    @video = Video.new
  end

  def new(user_id)
    @video = Video.new
    @video.user_id = user_id
  end

  def create
    puts params[:video]
    @video = Video.new(params[:video])
    @video.estado = Video::PROCESSING_STATE
    puts "Userid"
    @user = User.where(id: @video.user_id).first
    puts @user

    if @video.save
      @video.update_attributes(path: "#{@video.video}")
      flash[:success] = 'Thank you! We have received the video. You may see it on your profile soon.'
      redirect_to user_path(@user)
    else
      flash[:error] = 'Error loading video.'
      puts "Error"
      redirect_to user_path(@user)
    end
  end

  def index
    #@videos = Video.paginate(page: params[:page] , :per_page => 4)
  end
end
