# encoding: UTF-8
class VideosController < ApplicationController
  def new
    @video = Video.new
  end

  def create
    puts video_params
    @video = Video.new(video_params)
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

  def video_params
      params.require(:video).permit(:name, :video, :video_file_name)
  end
end
