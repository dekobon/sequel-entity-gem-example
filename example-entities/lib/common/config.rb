# Encoding: utf-8

require 'socket'
require 'yaml'
require 'hashie'

##
# Module that provides gems with basic configuration.
#
# @author Elijah Zupancic
module Configuration
  class << self
    @base_path = File.join(File.dirname(__FILE__), '../../config')

    attr_accessor :base_path

    ##
    # Loads YAML configuration file from the config directory and symbolizes
    # the resulting hash, so that we can use it like an ordinary symbolic hash.
    def load_yaml_config(base_path, filename)
      fail ArgumentError, "Can't load a file with a bad path" unless base_path
      fail ArgumentError, "Can't load a file with a filename" unless filename

      file = File.expand_path(File.join(base_path, filename))
      hash = YAML.load_file(file)
      Hashie::Mash.new(hash)
    end

    ##
    # Load the general purpose configuration file and insert in
    # substitution variables.
    def load_config(filename)
      config = load_yaml_config(@base_path, filename)
      substitutions(config)
    end

    ##
    # Apply all of the substitutions we have defined for the config file.
    def substitutions(config)
      config.keys.each { |k| rewrite_hostname(config, config[k]) if config[k] }
      config
    end

    ##
    # We return the local hostname as a substitution parameter to make our
    # life easier because it will typically be the default value in the
    # configuration file.
    def rewrite_hostname(config, element)
      element.each do |k, v|
        element[k] = Socket.gethostname if v == %q|${hostname}|
      end
    end
  end
end
