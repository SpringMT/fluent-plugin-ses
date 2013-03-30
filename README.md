# Fluent::Plugin::SES [![Build Status](https://travis-ci.org/SpringMT/fluent-plugin-ses.png)](https://travis-ci.org/SpringMT/fluent-plugin-ses)

Fluent output plugin for AWS SES

## Installation

Add this line to your application's Gemfile:

    gem 'fluent-plugin-ses'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fluent-plugin-ses

## Configuration

```
<source>
  type               ses
  aws_key_id         YOUR_AWS_KEY
  aws_sec_key        YOUR_AWS_SECRET_KEY
  from               from@example.com
  to                 to@example.com
  cc                 a@example.com,b@example.com #optional
  reply_to_addresses reply@example.com #optional
  subject            test
</source>
```

Also see [AWS SDK for Ruby](http://docs.aws.amazon.com/AWSRubySDK/latest/frames.html).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

