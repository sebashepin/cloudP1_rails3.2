HireFire::Resource.configure do |config|
  config.dyno(:worker) do
    Delayed::Worker.ironmq.queue("default_0").size
  end
end
