# Encoding: utf-8

##
# Check to see if the proper environment variables were defined that
# indicate what environment a gem is running in.
def verify_environment
  # Use Rack environment if available
  if ENV['RACK_ENV'] && !ENV['ENV']
    ENV['ENV'] = ENV['RACK_ENV']
  # Use Rails environment if available
  elsif ENV['RAILS_ENV'] && !ENV['ENV']
    ENV['ENV'] = ENV['RAILS_ENV']
  end

  # Otherwise, use the more general environment setting
  unless ENV['ENV']
    warn 'ENV - environment variable must be defined, defaulting ' +
         'to development'
    ENV['ENV'] = 'development'
  end
end

##
# Returns the current runtime environment.
def environment
  verify_environment
  ENV['ENV']
end
