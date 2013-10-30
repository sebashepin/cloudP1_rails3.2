task :sqsconversion => :environment do
STATE_PROCESSING=0
STATE_CONVERTED=1

while 0==0 do
  sleep 10
  @sqs = AWS::SQS.new
  @queue=@sqs.queues.create("queue-videocloud")
  @msg = @queue.receive_message
  puts "mensaje recibido "+ @msg.to_s

  if !@msg.nil?
  
  @parts = @msg.body.split(";")
  puts @parts  
    if @parts[0].to_i == STATE_PROCESSING
      video = Video.find(@parts[1])
      video.updated_at = Time.zone.now
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

