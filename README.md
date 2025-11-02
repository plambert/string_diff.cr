# StringDiff

Generate the shortest sequence of operations to change string A into string B.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     string_diff:
       github: plambert/string_diff.cr
   ```

2. Run `shards install`

## Usage

```crystal
require "string_diff"

diff = StringDiff.new( a, b )

diff.to_s STDOUT
```

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/your-github-user/diff.cr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Paul M. Lambert](https://github.com/your-github-user) - creator and maintainer
