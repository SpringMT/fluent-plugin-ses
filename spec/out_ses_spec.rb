#!/usr/bin/env ruby
# encoding: UTF-8

require File.dirname(__FILE__) + '/spec_helper'
require 'aws-sdk-v1'

DEFAULT_CONFIG = %[
  aws_key_id  foo
  aws_sec_key bar
  aws_region  region
  from        spring
  to          mt
  subject     test
]
INVALID_CONFIG_AWS_KEY_ID_NIL = %[
  aws_sec_key bar
  aws_region  region
  from        spring
  to          mt
  subject     test
]
INVALID_CONFIG_FROM_NIL = %[
  aws_key_id  foo
  aws_sec_key bar
  aws_region  region
  to          mt
  subject     test
]
INVALID_CONFIG_TO_BLANK = %[
  aws_key_id  foo
  aws_sec_key bar
  aws_region  region
  from        spring
  subject     test
]
TEST_CONFIG = %[
  aws_key_id
  aws_sec_key
  from
  to
  subject     test
]

def create_driver(conf=DEFAULT_CONFIG)
  Fluent::Test::BufferedOutputTestDriver.new(Fluent::SESOutput).configure(conf)
end

describe Fluent::SESOutput do
  before { Fluent::Test.setup }
  describe :configure do
    before do
      dummy_object = (Class.new { define_method :verified? do; true end }).new
      AWS::SimpleEmailService.any_instance.stub(:identities).and_return({'spring' => dummy_object})
      AWS::SimpleEmailService.any_instance.stub_chain(:client, :send_email).and_return(true)
    end
    context 'valid' do
      it { d = create_driver }
    end
    context 'invalid aws_key_id is nil' do
      it { expect{ d = create_driver INVALID_CONFIG_AWS_KEY_ID_NIL }.to raise_error(Fluent::ConfigError) }
    end
    context 'invalid from is nil' do
      it { expect{ d = create_driver INVALID_CONFIG_FROM_NIL }.to raise_error(Fluent::ConfigError) }
    end
  end

  describe :start do
    context 'invalid from mail' do
      before do
        dummy_object = (Class.new { define_method :verified? do; false end }).new
        AWS::SimpleEmailService.any_instance.stub(:identities).and_return({'spring' => dummy_object})
      end
      it { expect{ d = create_driver DEFAULT_CONFIG; d.run }.to raise_error(Fluent::ConfigError) }
    end
    context 'invalid to is blank' do
      it { expect{ d = create_driver INVALID_CONFIG_TO_BLANK; d.run }.to raise_error(Fluent::ConfigError) }
    end
  end

  describe :format do
    context 'valid' do
      before do
        dummy_object = (Class.new { define_method :verified? do; true end }).new
        AWS::SimpleEmailService.any_instance.stub(:identities).and_return({'spring' => dummy_object})
        AWS::SimpleEmailService.any_instance.stub_chain(:client, :send_email).and_return(true)
      end
      it do
        d = create_driver
        time = Time.parse("2013-03-19 00:00:00 UTC").to_i
        d.emit({"a"=>1}, time)
        d.emit({"a"=>2}, time)
        d.expect_format %[2013-03-19T00:00:00Z\ttest\t{"a":1}\n2013-03-19T00:00:00Z\ttest\t{"a":2}\n]
        d.run
      end
    end
  end

  describe :write do
    context 'test_write' do
      it do
        skip 'If sending email actually, remove skip' do
        d = create_driver TEST_CONFIG
        time = Time.parse("2013-03-19 00:00:00 UTC").to_i
        d.emit({"a" => 1}, time)
        d.emit({"a" => "test"}, time)
        d.emit({"a" => "テスト"}, time)
        d.emit({"a" => nil}, time)
        d.emit({"a" => true}, time)
        d.emit({a: "テスト"}, time)
        d.emit({a: :test}, time)
        d.emit({a: :"テスト"}, time)
        d.emit({:"テスト" => :"テスト"}, time)
        d.run
        end
      end
    end
  end

end



