# Csvlite

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/csvlite`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'csvlite'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install csvlite

## Usage

User Table
| id        | name           |
| ----------|:--------------:|
| 1         | Peter          |
| 2         | Dan            |
| 3         | Joey           |

Post Table
| id   | user_id     | title           |
| -----|:-----------:|----------------|
| 1    |   4  | Nothing          |
| 2    |   3  | To            |
| 3    |   1  | Do           |


### One off queries (V1)
```ruby
query = <<-SQL
    SELECT post.title FROM user INNER JOIN post ON user.id = post.user_id WHERE user.name = 'Peter'
SQL

result = CSVLite.query_files(['user.csv', 'post.csv'], query)
```

### One off queries (V2)
```ruby
query = <<-SQL
    SELECT post.title FROM user INNER JOIN post ON user.id = post.user_id WHERE user.name = 'Peter'
SQL

lite = CSVLite.new
lite.load_multiple(['user.csv', 'post.csv'])
result = lite.query(query)
```

### Custom table name
```ruby
query = <<-SQL
    SELECT post.title FROM member INNER JOIN post ON member.id = post.user_id WHERE member.name = 'Peter'
SQL

lite = CSVLite.new
lite.load_from_csv_file('user.csv', 'member')
lite.load_from_csv_file('post.csv')
result = lite.query(query)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/csvlite. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

