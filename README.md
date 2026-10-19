# OmniAuth Skubana

This is an OmniAuth strategy for authenticating to Skubana. To use it, you'll need to sign up as an App Developer with
Skubana to receive an AppKey and AppSecret.

Requires Ruby >= 3.2, OmniAuth 2.x and `omniauth-oauth2` 1.8 or later.

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

OmniAuth 2 only accepts `POST` for the request phase. In a Rails app, add
[`omniauth-rails_csrf_protection`](https://github.com/cookpad/omniauth-rails_csrf_protection)
to your Gemfile and link to the provider with `button_to` or `link_to ..., method: :post`.

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :skubana,
           'app_key', 'app_secret',
           :callback_url => "http://www.example.com/auth/skubana/callback",
           :scope => 'read_inventory write_inventory'
end
```

Scopes are space-separated. Don't join them with `+`: it is sent encoded as `%2B`, and
Skubana rejects it with `invalid_scope`.

The auth hash carries the token under `credentials`:

```ruby
auth = request.env['omniauth.auth']
auth['credentials']['token']
```

## Configuring

### Configure the site

`client_options[:site]` defaults to `https://app.skubana.com`. Point it elsewhere to
authenticate against Skubana's demo environment:

```ruby
  :client_options => { :site => 'https://demo.skubana.com' }
```

### Configure the callback URL

The strategy overrides `callback_url` to drop the query string that OmniAuth would
otherwise append, because Skubana rejects a `redirect_uri` that does not match the
registered one exactly. Pass `callback_url` to override it outright; otherwise it is
derived from the request, including the mount prefix.

### Client credentials in the token request

`client_options[:auth_scheme]` is pinned to `:basic_auth`, because Skubana expects the
AppKey and AppSecret as HTTP Basic auth on the token request.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

Run `bundle exec bundle-audit check --update` to check the locked dependency tree against
the advisory database; CI runs the same check weekly.

## Releasing

Releases are cut from the [GitHub Releases UI](https://github.com/dropstream/omniauth-skubana/releases/new);
GitHub Actions builds and publishes the gem to [rubygems.org](https://rubygems.org) via
[RubyGems trusted publishing](https://guides.rubygems.org/trusted-publishing/), so no API
key is stored in the repo and the gemspec can keep `rubygems_mfa_required`.

1. Add a `CHANGELOG.md` section for the new version, along with a link definition for the
   new heading at the bottom of that file, and merge it to `master`. There is no version
   to bump: the committed `VERSION` file is a `0.0.0` placeholder.
2. Draft a new release with the target set to `master` and the tag set to the version
   prefixed with `v` — `v0.3.0`, not `0.3.0`. The workflow strips the `v` and uses the
   rest as the gem version.
3. Click **Generate release notes** — the preferred method — then publish. The generated
   notes list the merged pull requests; `CHANGELOG.md` carries the curated prose and
   links back to each release.

Publishing creates the tag, which fires the `Release` workflow: it reruns the full test
matrix, refuses to continue unless the tag looks like `vX.Y.Z`, writes the version into
`VERSION` (and `Gemfile.lock`) in its own checkout, and pushes the gem. That change is
never pushed back to the repo. Note that RubyGems versions are immutable — a bad release
can be yanked, never replaced, so double-check the tag before publishing.

### One-time RubyGems setup

Needed before the first release from CI, and again only if the gem is renamed or moved:
on rubygems.org open the gem -> **Trusted publishers** -> **Create**, with owner
`dropstream`, repository `omniauth-skubana`, workflow `release.yml`, and environment
`release`. The repo also needs an environment named `release`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dropstream/omniauth-skubana.

## License

Available as open source under the terms of the [MIT License](LICENSE.txt).
