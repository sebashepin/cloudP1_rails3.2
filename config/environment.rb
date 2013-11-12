# Load the rails application
require File.expand_path('../application', __FILE__)

config.gem "cloudfiles"

# Initialize the rails application
Cloud32::Application.initialize!
