class Video
  include Mongoid::Document
  #include Dynamoid::Paperclip
  #extend CarrierWave::Mount
  #attr_accessible :name, :video, :user_id, :path, :id, :video_converted
  attr_accessible :name, :file, :user_id, :path, :id
  field :name
  #field :video
  field :user_id
  field :path
  field :id
  #field :video_converted
  field :estado
  #field :video_content_type
  #field :video_file_size
  #field :video_updated_at
  #field :video_file_name
  field :file
  validates :name, :presence => true

  #has_dynamoid_attached_file :video
  
  #validates :estado, :presence => true
  #validates :video, :presence => true
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  #validates :email, :presence => true, :format => { :with => email_regex }

  #scope :converted, where('videos.converted_at IS NOT NULL')
  #scope :ordered_desc_by_created_at, order('videos.created_at DESC')

  PROCESSING_STATE = 0
  CONVERTED_STATE = 1

  after_save :convert_video

  #has_dynamoid_attached_file :video, :storage => :s3, :s3_credentials => "#{Rails.root}/config/aws.yml", :bucket => "co.videocloud.bucket"
  #validates_attachment_presence :video

  def convert_video
    self.delay.process_video
    #this fucking shit wasnt working wiuth queues so it had to be done manually    
    #@sqs=AWS::SQS.new
    #@queue=@sqs.queues.create("queue-videocloud")
    #@queue.send_message(PROCESSING_STATE.to_s+";"+self.id.to_s+";")
  end

  def process_video
    if self.estado==0
      service = Fog::Storage.new(
        :provider             => 'Rackspace',
        :rackspace_username   => ENV['RACKSPACE_API_USER'],
        :rackspace_api_key    => ENV['RACKSPACE_API_KEY']
      )

      directory = service.directories.get('videofiles')
      pathtoconverted='public/converted'
      key=File.basename(self.path)
      routetofile=File.join(pathtoconverted,File.basename(self.path))
      File.open(routetofile, 'w') do | f |
        directory.files.get(self.path) do | data, remaining, content_length |
        f.syswrite data
      end
      
      movie = FFMPEG::Movie.new(routetofile)
      #options = {video_codec: "libx264",
      #          audio_codec: "libfaac"}
      options = {video_codec: "libx264"}
      video_name = key.to_s.split('.').first
      video_converted_url = "#{Rails.root}/tmp/converted_#{UUIDTools::UUID.random_create.hexdigest}_"+video_name[0,video_name.size-4]+'.mp4'
      
      movie.transcode(video_converted_url, options)
      
      cloudfilespath='public/'+'uploads/'+self.user_id.to_s+"/"+video_name.to_s+'.mp4'
      File.open(video_converted_url, 'rb') do |io|
        container.files.create( :key => cloudfilespath,
                                :body => io)
      end
      File.delete(video_converted_url)
      self.estado = CONVERTED_STATE
      self.path = cloudfilespath
      self.save
    end  
  end
end