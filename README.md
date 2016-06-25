# GoogleMaps

This helps you to work with
Google Maps Distance Matrix API


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'google_maps', git: 'git://github.com/DemonIT/google_maps.git'
```

And then execute:

    $ bundle install

## Usage

Ruby code:

```ruby
@distance_matrix = GoogleMaps::DistanceMatrix.new 'ул. Кольцова, 48, Грозный', 'пр. Калинина, 9, Пятигорск', GOOGLE_API_KEY
puts @distance_matrix.distance.text
puts @distance_matrix.duration.text
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

