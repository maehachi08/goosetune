# Goosetune

Goosetune is a tool to get YouTube video data of Goosehouse from googleapi v3.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'goosetune', :git => 'git@github.com:maehachi08/goosetune.git', :branch => 'master'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install specific_install
    $ gem specific_install -l git@github.com:maehachi08/goosetune.git

Or install git clone

    $ git clone git@github.com:maehachi08/goosetune.git
    $ cd goosetune
    $ rake build
    $ gem install pkg/goosetune-?.?.?.gem

## Usage

First, please create .env and set your google api key

```sh
cp .env_sample .env
vim .env
```

### Get video data

```ruby
#!/usr/bin/env ruby
require 'goosetune'
require 'yaml'

goosetune = Goosetune::Youtube::Video.new
ret = goosetune.videos

puts ret.to_yaml
```

### Get view counts

```ruby
#!/usr/bin/env ruby
require 'goosetune'
require 'yaml'

goosetune = Goosetune::Youtube::Video.new
ret = goosetune.get_view_counts

puts ret.to_yaml
```


## Development

Writing... ^^;

## Contributing

1. Fork it ( https://github.com/maehachi08/goosetune/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
