require 'presentable/version'
require 'presentable/base_presenter'

module Presentable
  class Error < StandardError; end
end

require 'presentable/railtie' if defined?(Rails)
