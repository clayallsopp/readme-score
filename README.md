# Readme::Score

TODO: Write a gem description

```ruby
url = "https://raw.githubusercontent.com/CocoaPods/cocoadocs.org/master/README.md"
score = ReadmeScore.for(url)
score.total_score
# => 90
score.text_score
# => 70
score.bonus_score
# => 20
score.bonus_scores
# => {has_gifs: 10, has_tables: 10}
```

## Installation

Add this line to your application's Gemfile:

    gem 'readme-score'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install readme-score

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it ( http://github.com/<my-github-username>/readme-score/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
