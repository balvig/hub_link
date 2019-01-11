# Hub Link

When you just want the raw pull request and review data from GitHub (for
metrics etc)

## Usage

Add this line to your application's Gemfile:

 ```ruby
 gem "hub_store"
```

And then you can do:

```ruby
repos = "balvig/hub_link,balvig/hub_store"
link = HubLink::Link.new(repos, start_date: 3.months.ago)

link.in_batches do |batch|
  batch.prs # =>
  batch.reviews # =>
  batch.review_requests # =>
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/mergometer. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

