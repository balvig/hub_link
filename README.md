# Hub Link

When you just want the loop through all the raw pull request and review data from GitHub
(for exporting metrics f.ex).

## Usage

Add this line to your application's Gemfile:

 ```ruby
 gem "hub_link"
```

Then you can do:

```ruby
stream = HubLink::Stream.new("balvig/hub_link", since: 3.months.ago)

stream.in_batches do |batch|
  batch.reviews # => [{ id: 54, reviewer: "balvig", approval: true, ... }]
  batch.prs # => [{ id: 34, merge_time: 6400, ... }]
end
```

Hub Link will loop through the API one page at a time.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/balvig/hub_link. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
