class Video 
  include Dynamoid::Document
  extend CarrierWave::Mount
  #attr_accessible :name, :video, :user_id, :path, :id, :video_converted
  field :name
  field :video
  field :user_id
  field :path
  field :id
  field :video_converted
  field :estado
  validates :name, :presence => true
  belongs_to :user

  mount_uploader :video, VideoUploader
  mount_uploader :video_converted, VideoConvertedUploader
  #validates :estado, :presence => true
  #validates :video, :presence => true
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  #validates :email, :presence => true, :format => { :with => email_regex }

  #scope :converted, where('videos.converted_at IS NOT NULL')
  #scope :ordered_desc_by_created_at, order('videos.created_at DESC')

  PROCESSING_STATE = 0
  CONVERTED_STATE = 1

  after_save :convert_video

  def convert_video
    self.delay.process_video
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
    end
  end
end
