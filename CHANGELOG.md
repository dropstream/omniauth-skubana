# Changelog

All notable changes to this project are documented in this file.

## [Unreleased]

### Changed

- The gem version now comes from the release tag. `lib/omniauth-skubana/version.rb` reads
  a top-level `VERSION` file, committed as a `0.0.0` placeholder, which the release
  workflow writes from the tag with its leading `v` stripped.

## [0.2.0] - 2026-10-19

### Changed

- **Breaking:** requires `omniauth ~> 2.0` and `omniauth-oauth2 >= 1.8, < 2` (previously an
  unpinned `omniauth-oauth2`). Host applications must be on OmniAuth 2.x; Rails apps also
  need [`omniauth-rails_csrf_protection`](https://github.com/cookpad/omniauth-rails_csrf_protection)
  because OmniAuth 2 only accepts `POST` for the request phase.
- Requires Ruby >= 3.2.
- The token request now authenticates through `client_options[:auth_scheme] = :basic_auth`
  instead of a hand-built `Authorization` header. On `oauth2` 2.x this sends the same
  request as before; on `oauth2` 1.x it also stops sending `client_id`/`client_secret` in
  the token request body. This removes the `base64` require, which is no longer a default
  gem as of Ruby 3.4.
- Development toolchain: Bundler 4.x, `rake ~> 13.0`, `rspec ~> 3.13`.
- Replaced Travis CI with GitHub Actions, testing Ruby 3.2 through 3.4.
- Releases are now cut from the GitHub Releases UI: publishing a `vX.Y.Z` release reruns
  the matrix, checks the tag against `version.rb`, and publishes to RubyGems.org via
  trusted publishing (OIDC, no stored API key).

### Added

- `LICENSE.txt` (MIT), now declared in the gemspec.
- Integration specs covering the request phase, the token exchange, the `redirect_uri`
  and the auth hash.
- A weekly `bundle-audit` run, so a new advisory against the locked `oauth2`/`rack`
  chain surfaces here rather than in a consuming app.

### Fixed

- `callback_url` drops the request's query string, so `/auth/skubana?type=shopping` no
  longer sends a `redirect_uri` that does not match the one registered with Skubana, and
  a mount prefix is included only once. (This was tagged as `v0.1.3` but never published
  to RubyGems.)
- `bin/console` required a non-existent `omniauth/skubana` file.
- Development scripts in `bin/` and other scaffolding are no longer packaged in the gem.

## [0.1.2] - 2020-05-21

- Upgraded `omniauth-oauth2` and removed its version constraint.

## [0.1.0] - 2016-08-25

- Initial published strategy.

[Unreleased]: https://github.com/dropstream/omniauth-skubana/compare/v0.2.0...master
[0.2.0]: https://github.com/dropstream/omniauth-skubana/releases/tag/v0.2.0
[0.1.2]: https://rubygems.org/gems/omniauth-skubana/versions/0.1.2
[0.1.0]: https://rubygems.org/gems/omniauth-skubana/versions/0.1.0
