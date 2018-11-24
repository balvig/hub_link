# Mergometer

Developer Metrics from GitHub

## Usage

You can either:
- Clone this repository.
- Install the gem.

### Cloning this repository
```
git clone https://github.com/balvig/mergometer.git
cd mergometer
bundle
OCTOKIT_ACCESS_TOKEN=<token> bundle exec exe/mergometer <github_organization/repo_name>
```

### Installing this gem
_This will work only after the gem gets published to RubyGems._
```
gem install mergometer
OCTOKIT_ACCESS_TOKEN=<token> mergometer <github_organization/repo_name>
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/mergometer. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

