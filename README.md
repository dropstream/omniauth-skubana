# OmniAuth Skubana

This is an OmniAuth strategy for authenticating to Skubana. To use it, you'll need to sign up as an App Developer with 
Skubana to receive an AppKey and AppSecret.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'omniauth-skubana'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install omniauth-skubana

## Usage

````ruby
OmniAuth::Builder do
    provider :skubana,
              'app_key', 'app_secret',
              :callback_url => "http://www.example.com/auth/skubana/callback",                             
              :scope => 'read_inventory+write_inventory'

end
````

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dropstream/omniauth-skubana.

