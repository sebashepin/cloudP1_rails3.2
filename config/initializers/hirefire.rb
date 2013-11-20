HireFire::Resource.configure do |config|
  config.dyno(:worker) do
    HireFire::Macro::Delayed::Job.queue("worker", :mapper => :mongoid)
  end
end
