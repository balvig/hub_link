# Hub Link

When you just want the loop through all the raw pull request and review data from GitHub
(for exporting metrics f.ex).

## Usage

Add this line to your application's Gemfile:

 ```ruby
 gem "hub_store"
```

Then you can do:

```ruby
REPOS = "balvig/hub_link,balvig/hub_store"

stream = HubLink::Stream.new(REPOS, start_date: 3.months.ago)

stream.in_batches do |batch|
  batch.prs # => [{ id: 34, merge_time: 6400, ... }]
  batch.reviews # => [{ id: 54, reviewer: "balvig", approval: true, ... }]
  batch.review_requests # => [{ id: 74, reviewer: "balvig", ... }]
end
```

Hub Link will loop through the API in batches of 2 weeks at a time.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/balvig/hub_link. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
