# ReadmeScore

[![Build Status](https://travis-ci.org/clayallsopp/readme-score.svg)](https://travis-ci.org/clayallsopp/readme-score)
[![Readme Score](http://readme-score-api.herokuapp.com/score.svg?url=clayallsopp/readme-score)](http://clayallsopp.github.io/readme-score?url=clayallsopp/readme-score)

Gives a complexity score for a README.

[Check scores of any repo: http://clayallsopp.github.io/readme-score](http://clayallsopp.github.io/readme-score)

Example score:

| Repo                                                          | Score |
|---------------------------------------------------------------|-------|
| https://github.com/RolandasRazma/RRFPSBar                     | 16    |
| https://github.com/JRG-Developer/MediaRSSParser               | 35    |
| https://github.com/ruslanskorb/RSDayFlow                      | 35    |
| https://github.com/samnung/AFHTTPFileUpdateOperation          | 31    |
| https://github.com/schneiderandre/ASCFlatUIColor              | 65    |
| https://github.com/daltoniam/BootstrapUIKit                   | 60    |
| https://github.com/AFNetworking/AFNetworking                  | 95    |
| https://github.com/tomersh/AppleGuice                         | 85    |
| https://github.com/kevindelord/DKHelper                       | 25    |
| https://github.com/saturngod/IAPHelper                        | 75    |
| https://github.com/alskipp/ASValueTrackingSlider              | 87    |
| https://github.com/phranck/CNTreeNode                         | 25    |
| https://github.com/dasdom/DDHDynamicViewControllerTransitions | 91    |
| https://github.com/RestKit/RestKit                            | 100   |


## Installation

Add this line to your application's Gemfile:

    gem 'readme-score'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install readme-score

## Usage

Pass in a URL:

```ruby
url = "https://raw.githubusercontent.com/AFNetworking/AFNetworking/master/README.md"
score = ReadmeScore.for(url)
score.total_score
# => 95
```

Pass in a Github Repo:

```ruby
score = ReadmeScore.for("afnetworking/afnetworking")
score.total_score
# => 95
```

Pass in HTML:

```ruby
html = "AFNetworking is a delightful networking library for iOS and Mac OS X...."
score = ReadmeScore.for(html)
score.total_score
# => 95
```

## Configuration

### Settings

- `ReadmeScore.use_github_api = <boolean>` - whether or not to use the Github API when loading a Github repo's readme. If `false`, will attempt to find the correct readme URL without the API (which could fail unexpectedly). Defaults to `true`

- `ReadmeScore.github_api_token = <token>` - a token to use with the Github API. Supercedes the ENV variable.

### Environment Variables

| ENV                                                          | Description |
|---------------------------------------------------------------|-------|
| READMESCORE_GITHUB_TOKEN                     | If scoring a Github repo, ReadmeScore will try to grab the canonical representation via the Github API. By default, [unauthenticated requests are limited](https://developer.github.com/v3/#rate-limiting) to 60/hour. Set this env variable to increase that limited to 5k/hour.    |
