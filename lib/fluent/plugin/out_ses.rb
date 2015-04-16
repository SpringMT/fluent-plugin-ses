# encoding: UTF-8

require 'fluent/mixin/plaintextformatter'

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
    include Fluent::Mixin::PlainTextFormatter

    config_param :aws_key_id,  :string
    config_param :aws_sec_key, :string
    config_param :aws_region,  :string

    config_param :from,               :string
    config_param :to,                 :string, :default => ""
    config_param :cc,                 :string, :default => ""
    config_param :bcc,                :string, :default => ""
    config_param :subject,            :string, :default => ""
    config_param :reply_to_addresses, :string, :default => ""

    def start
      super
      options = {}
      if @aws_key_id && @aws_sec_key
        options[:access_key_id]     = @aws_key_id
        options[:secret_access_key] = @aws_sec_key
      end
      AWS.config(:ses => { :region => @aws_region })
      @ses = AWS::SimpleEmailService.new options

      to_addresses  = @to.split ","
      if to_addresses.empty?
        raise Fluent::ConfigError, "To is not nil."
      end

      cc_addresses  = @cc.split ","
      bcc_addresses = @bcc.split ","

      @destination = {:to_addresses => to_addresses}
      unless cc_addresses.empty?
        @destination[:cc_addresses] = cc_addresses
      end
      unless bcc_addresses.empty?
        @destination[:bcc_addresses] = bcc_addresses
      end
      valid!
    end

    def write(chunk)
      body_text = chunk.read.force_encoding "utf-8"

      options = {
        :source      => @from,
        :destination => @destination,
        :message => {
          :subject => {          :data => @subject},
          :body    => {:text => {:data => body_text}},
        },
      }
      reply_to_addresses = @reply_to_addresses.split ","
      unless reply_to_addresses.empty?
        options[:reply_to_addresses] = reply_to_addresses
      end

      begin
        res = @ses.client.send_email options
      rescue => e
        $log.error e.message
      end
    end

    private
    def valid!
      identity = @ses.identities[@from]
      unless identity.verified?
        raise Fluent::ConfigError, "From address is not verified. Please check AWS SES service."
      end
    end

  end
end
