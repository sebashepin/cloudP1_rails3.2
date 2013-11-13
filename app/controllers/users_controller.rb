require 'fog'
class UsersController < ApplicationController
  
  #before_filter :signed_in_user, only: [:index, :edit, :update, :show]
  #before_filter :correct_user,   only: [:edit, :update, :show]

  def index
    @users = User.all
    #@users = User.paginate(page: params[:page])
  end


  def show
    @user = User.find(params[:id])
    #@videos = @user.videos.paginate(page: params[:page], :per_page => 4)
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def create
    #@user = User.new(user_params)
    @user = User.new(params[:user]) 
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to VSL-o-ROR!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def upload

    name = params[:datafile].original_filename
    #name = 'diermo'
    directory = "public/uploads"
    path = File.join(directory, name)
    File.open(path, "wb") { |f| f.write(params[:datafile].read) }
    flash[:success] = 'Thank you! We have received the video. You may see it on your profile soon.'
    redirect_to user_path(params[:user_id])
#    @uvideo = Video.new
#    @uvideo.name = params[:name]
#    @uvideo.user_id = params[:user_id]
#    @uvideo.estado =  Video::PROCESSING_STATE
#    uploaded_io = params[:file]
#    path = "public/uploads/"+uploaded_io.original_filename

#    #File.open(path, 'wb:ASCII-8BIT') do |file|
#    #  file.write(uploaded_io.read)
#    #end

#    #uploadPath = "public/uploads/" + File.absolute_path(path).split('public/uploads/')[1]
#    #@uvideo.file = uploadPath
#    #suffix = File.absolute_path(path).split(".")[1]
#    key = File.basename(path)
#    puts "Key"
#    puts key
#    puts "Path"
#    puts path

#    #container.files.create :key => 'public/'+'uploads/'+@uvideo.user_id.to_s+"/"+key.to_s, :body => File.open(path)
#    #AWS::S3.new.buckets['co.videocloud.bucket'].objects['public/'+'uploads/'+@uvideo.user_id.to_s+"/"+key.to_s].write(:file => path)
   

#    if @uvideo.save
#      service = Fog::Storage.new(
#        :provider             => 'Rackspace',
#        :rackspace_username   => ENV['RACKSPACE_API_USER'],
#        :rackspace_api_key    => ENV['RACKSPACE_API_KEY']
#      )

#      container = service.directories.get('videofiles')

#      File.open(path, 'rb') do |io|
#        directory.files.create( :key => 'public/'+'uploads/'+@uvideo.user_id.to_s+"/"+key.to_s,
#                                :body => io)
#      end

#      flash[:success] = 'Thank you! We have received the video. You may see it on your profile soon.'
#      redirect_to user_path(@uvideo.user_id)
#    end
    

  end



  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    # Before filters

    def signed_in_user
      redirect_to signin_url, notice: "Please sign in." unless signed_in?
    end
    
    def correct_user
      @user = User.where(email: :email,password: :password)
      redirect_to(root_url) unless current_user?(@user)
    end


end
