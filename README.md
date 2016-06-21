# ReadmeScore

[![Build Status](https://travis-ci.org/clayallsopp/readme-score.svg)](https://travis-ci.org/clayallsopp/readme-score)
[![Readme Score](http://readme-score-api.herokuapp.com/score.svg?url=clayallsopp/readme-score&bust=1)](http://clayallsopp.github.io/readme-score?url=clayallsopp/readme-score)

Gives a complexity score for a README.

Check scores of any repo in your browser: [http://clayallsopp.github.io/readme-score](http://clayallsopp.github.io/readme-score)

There's an [HTTP API too](http://github.com/clayallsopp/readme-score-api)!


Example score:

| Repo                                                          | Score |
|---------------------------------------------------------------|-------|
| https://github.com/RolandasRazma/RRFPSBar                     | [![Readme Score](http://readme-score-api.herokuapp.com/score.svg?url=RolandasRazma/RRFPSBar)](http://clayallsopp.github.io/readme-score?url=RolandasRazma/RRFPSBar)    |
| https://github.com/JRG-Developer/MediaRSSParser               | [![Readme Score](http://readme-score-api.herokuapp.com/score.svg?url=JRG-Developer/MediaRSSParser)](http://clayallsopp.github.io/readme-score?url=JRG-Developer/MediaRSSParser)    |
| https://github.com/ruslanskorb/RSDayFlow                      | [![Readme Score](http://readme-score-api.herokuapp.com/score.svg?url=ruslanskorb/RSDayFlow)](http://clayallsopp.github.io/readme-score?url=ruslanskorb/RSDayFlow)    |
| https://github.com/samnung/AFHTTPFileUpdateOperation          | [![Readme Score](http://readme-score-api.herokuapp.com/score.svg?url=samnung/AFHTTPFileUpdateOperation)](http://clayallsopp.github.io/readme-score?url=samnung/AFHTTPFileUpdateOperation)    |
| https://github.com/schneiderandre/ASCFlatUIColor              | [![Readme Score](http://readme-score-api.herokuapp.com/score.svg?url=schneiderandre/ASCFlatUIColor)](http://clayallsopp.github.io/readme-score?url=schneiderandre/ASCFlatUIColor)    |
| https://github.com/daltoniam/BootstrapUIKit                   | [![Readme Score](http://readme-score-api.herokuapp.com/score.svg?url=daltoniam/BootstrapUIKit)](http://clayallsopp.github.io/readme-score?url=daltoniam/BootstrapUIKit)    |
| https://github.com/AFNetworking/AFNetworking                  | [![Readme Score](http://readme-score-api.herokuapp.com/score.svg?url=AFNetworking/AFNetworking)](http://clayallsopp.github.io/readme-score?url=AFNetworking/AFNetworking)    |
| https://github.com/tomersh/AppleGuice                         | [![Readme Score](http://readme-score-api.herokuapp.com/score.svg?url=tomersh/AppleGuice)](http://clayallsopp.github.io/readme-score?url=tomersh/AppleGuice)    |
| https://github.com/kevindelord/DKHelper                       | [![Readme Score](http://readme-score-api.herokuapp.com/score.svg?url=kevindelord/DKHelper)](http://clayallsopp.github.io/readme-score?url=kevindelord/DKHelper)    |
| https://github.com/saturngod/IAPHelper                        | [![Readme Score](http://readme-score-api.herokuapp.com/score.svg?url=saturngod/IAPHelper)](http://clayallsopp.github.io/readme-score?url=saturngod/IAPHelper)    |
| https://github.com/alskipp/ASValueTrackingSlider              | [![Readme Score](http://readme-score-api.herokuapp.com/score.svg?url=alskipp/ASValueTrackingSlider)](http://clayallsopp.github.io/readme-score?url=alskipp/ASValueTrackingSlider)    |
| https://github.com/phranck/CNTreeNode                         | [![Readme Score](http://readme-score-api.herokuapp.com/score.svg?url=phranck/CNTreeNode)](http://clayallsopp.github.io/readme-score?url=phranck/CNTreeNode)    |
| https://github.com/dasdom/DDHDynamicViewControllerTransitions | [![Readme Score](http://readme-score-api.herokuapp.com/score.svg?url=dasdom/DDHDynamicViewControllerTransitions)](http://clayallsopp.github.io/readme-score?url=dasdom/DDHDynamicViewControllerTransitions)    |
| https://github.com/RestKit/RestKit                            | [![Readme Score](http://readme-score-api.herokuapp.com/score.svg?url=RestKit/RestKit)](http://clayallsopp.github.io/readme-score?url=RestKit/RestKit)   |


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
