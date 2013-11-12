class Video < ActiveRecord::Base 
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

  has_attached_file :file
     :storage => :cloud_files,
     :cloudfiles_credentials =>  "#{RAILS_ROOT}/config/rackspace.yml",
     :path => ":attachment/:id/:timestamp_:style.:extension"

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
    #self.delay.process_video
    #this fucking shit wasnt working wiuth queues so it had to be done manually    
    #@sqs=AWS::SQS.new
    #@queue=@sqs.queues.create("queue-videocloud")
    #@queue.send_message(PROCESSING_STATE.to_s+";"+self.id.to_s+";")
  end

  def process_video
    if self.video_converted.url.nil?
      self.updated_at = Time.zone.now
      self.video.cache_stored_file!
      video_url = self.video.current_path.to_s
      puts 'Video url: '+video_url

      movie = FFMPEG::Movie.new(video_url)
      #options = {video_codec: "libx264",
      #          audio_codec: "libfaac"}
      options = {video_codec: "libx264"}
      video_name = self.video.path.split('/').last
      video_converted_url = "#{Rails.root}/tmp/converted_#{UUIDTools::UUID.random_create.hexdigest}_"+video_name[0,video_name.size-4]+'.mp4'
      puts 'Converted url: '+video_converted_url
      movie.transcode(video_converted_url, options)
      self.video_converted.store!(File.open(video_converted_url))
      File.delete(video_converted_url)
      self.estado = CONVERTED_STATE
      self.save

      ses = AWS::SimpleEmailService.new()
      email = User.find_by_id(self.user_id).email
      identity = ses.identities.verify('le.solorzano10@uniandes.edu.co')
      if(identity.verified?)
      ses.send_email(
        :subject => 'Video conversion complete',
        :from => 'le.solorzano10@uniandes.edu.co',
        :to => email,
        :body_text => 'Your video ' + self.name + ' has been converted you can now check it out in you profile at VIDEOS-L-o-ROR')
        puts "email sent to "+email
      end
    end
  end
end
