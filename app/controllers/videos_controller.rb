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
    puts ""
    puts "parameters used in form"
    puts ""
    puts params[:video]
    puts ""
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

  def uploadForm
    @uvideo = Video.new
  end	

  def upload
    @uvideo = Video.new	
    @uvideo.name = params[:name]
    @uvideo.message = params[:message]
    @uvideo.user_id = session[:user_id]
    @uvideo.estado =  Video::PROCESSING_STATE
    uploaded_io = params[:file]
    path = Rails.root.join('public', 'uploads', uploaded_io.original_filename)

    File.open(path, 'wb:ASCII-8BIT') do |file|
      file.write(uploaded_io.read)
    end
	
    uploadPath = "public/uploads/" + File.absolute_path(path).split('public/uploads/')[1]
    @uvideo.file = uploadPath
    suffix = File.absolute_path(path).split(".")[1]
    target_filename = File.basename(path, suffix) + "mp4"
    destPath = "public/mp4/" + target_filename
    @uvideo.target_file = destPath
    Rails.root.join('public', 'mp4', target_filename)
    key = File.basename(path)
    AWS::S3.new.buckets['co.videocloud.bucket'].objects[key].write(:file => path)

    if @uvideo.save
      flash[:success] = 'Thank you! We have received the video. You may see it on your profile soon.'
      redirect_to user_path(@user)

    end
  end 
end
