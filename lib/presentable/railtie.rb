module Presentable
  class Railtie < Rails::Railtie
    generators do
      require 'presentable/generators/presenter_generator'
    end
  end
end
