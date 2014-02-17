# Encoding: utf-8

##
# Default namespace for database entity classes. Typically, the entities
# will be imported into the working namespace within the application
# that loaded the gem.
module ::Entities
  Dir[File.dirname(__FILE__) + '/entities/models/*.rb'].each do |file|
    require file
  end
end

include ::Entities
