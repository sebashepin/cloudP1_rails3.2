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
      @video.update_attributes(path: "public#{@video.video}")
      flash[:success] = 'Hemos recibido el video y muy pronto será revisado y publicado. Gracias por participar del concurso.'
      redirect_to user_path(@user)
    else
      flash[:error] = 'Error cargando el video.'
      #render 'new'
      redirect_to user_path(@user)
    end
  end

  def index
    @videos = Video.ordered_desc_by_created_at
  end
end
