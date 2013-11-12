if Rails.env.production?
  CarrierWave.configure do |config|
    config.cache_dir = "#{Rails.root}/tmp/"
    config.storage = :fog
    config.fog_credentials = {
      :provider             => 'Rackspace',
      :rackspace_username   => ENV['RACKSPACE_API_USER'],
      :rackspace_api_key    => ENV['RACKSPACE_API_KEY']
    }
    config.fog_directory = 'videofiles'
    config.asset_host = '864a675977a58baaf6f2-10c51ea795fac9f637145bfc62a24893.r83.cf5.rackcdn.com'
    #config.asset_host    = "c000000.cdn.rackspacecloud.com"
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
