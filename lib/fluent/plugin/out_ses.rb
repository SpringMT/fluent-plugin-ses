require "fluent/plugin/ses/version"

module Fluent
  class SESOutput < Fluent::BufferedOutput
    Fluent::Plugin.register_output('ses', self)

    def initialize
      super
      require 'aws-sdk'
    end

    include SetTagKeyMixin
    config_set_default :include_tag_key, false
    include SetTimeKeyMixin
    config_set_default :include_time_key, true

  end
end
