# Encoding: utf-8


module Application
  Database.db_setup(single_threaded: true,
                    use_models: true) do |db|

    # Load modifications to the default entity models. This also loads the
    # models into the current module and not into the module in which they
    # were defined in the entities gem. So if you were going to access the
    # models from outside of the application package, you would have to
    # access them as Application::EntityName.
    Dir[File.dirname(__FILE__) + '/models/*.rb'].each do |file|
      require file
    end
  end
end
