if Rails.env.production?
  CarrierWave.configure do |config|
    config.cache_dir = "#{Rails.root}/tmp/"
    config.storage = :fog
    config.fog_credentials = {
      :provider             => 'Rackspace',
      :rackspace_username   => ENV['RACKSPACE_API_USER'],
      :rackspace_api_key    => ENV['RACKSPACE_API_KEY']
    }
    #config.fog_directory  = "videostorage"    # required
    #config.asset_host       = "https://#{ENV['VIDEOM_AWS_S3_BUCKET_NAME']}.s3.amazonaws.com"            # optional, defaults to nil
    #config.asset_host       = '//XXXXXXXXXXXXXX.cloudfront.net'            # optional, defaults to nil
    config.fog_public     = true                                   # optional, defaults to true
    #config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}
  end
elsif Rails.env.development?
  CarrierWave.configure do |config|
    config.storage = :file
  end
elsif Rails.env.test?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
end
