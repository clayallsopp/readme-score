

var Dial = function() {

  var rotateDial = function(degrees) {
    degrees = parseInt(degrees);

    var timingOption = function(timing) {
      return {
        '-webkit-animation-timing-function': timing,
        '-moz-animation-timing-function': timing,
        'animation-timing-function': timing
      }
    };

    var transformOption = function(transform) {
      return {
        '-moz-transform': transform,
        '-ms-transform': transform,
        '-webkit-transform': transform,
        'transform': transform
      }
    };

    var keyframeOption = function(timing, transform) {
      var option = {};
      $.extend(option, timingOption(timing), transformOption(transform));
      return option;
    }

    var keyframeName = 'dialmove-' + degrees;
    $.keyframe.define([{
        name: keyframeName,
        '0%': keyframeOption('ease-in', 'rotate(0deg)'),
        '50%': keyframeOption('linear', 'rotate(' + (degrees + 10) + 'deg)'),
        '70%': keyframeOption('linear', 'rotate(' + (degrees - 10) + 'deg)'),
        '85%': keyframeOption('linear', 'rotate(' + (degrees + 5) + 'deg)'),
        '95%': keyframeOption('linear', 'rotate(' + (degrees - 3) + 'deg)'),
        '100%': keyframeOption('ease-out', 'rotate(' + (degrees + 0) + 'deg)'),
    }]);

    this.hide();

    setTimeout(function() {
      $("#dial").playKeyframe({
        name: keyframeName,
        duration: 700
      });
    }, 100);
  }.bind(this);

  this.rotateToScore = function(score) {
    // account for white gaps
    if (score > 19 && score < 24) {
      score = 19;
    }
    if (score > 75 && score < 80) {
      score = 75;
    }
    var degrees = (score / 100.0) * 180.0;
    rotateDial(degrees);
  }

  this.hide = function() {
    document.getElementById('dial').style.webkitAnimationName = undefined;
  }

  return this;
};

var Score = function(data) {
  this.score = parseInt(data.score);
  this.url = data.url;
  this.breakdown = data.breakdown;

  return this;
}

var ScoreAPI = {
  find: function(urlOrSlug, callback, errorCallback) {
    var url = "http://readme-score-api.herokuapp.com/score";
    $.get(url, {url: urlOrSlug, human_breakdown: "true", force: "true"}, function(data, textStatus) {
        if (textStatus === 'error' || textStatus === 'timeout' || data.error) {
          errorCallback();
        }
        else {
          callback(new Score(data));
        }
      });
  }
};

var Embed = function() {
  var $copyButton = $("#copy-image-url");
  var $copyField = $("#image-url");
  var $badge = $("#badge-image");
  var $badgeLink = $("#badge-link");

  var clipboard = new ZeroClipboard($copyButton[0]);
  clipboard.on("ready", function(readyEvent) {
    clipboard.on("aftercopy", function(ev) {
      $copyButton.text("Copied!");
    });
  });
  clipboard.on('error', function(ev) {
    console.log('ZeroClipboard error of type "' + ev.name + '": ' + ev.message);
  });

  this.prepare = function() {
    $copyButton.text("Copy!");
  };
  this.prepare.bind(this);

  this.update = function(scoreUrl) {
    var svgUrl = "http://readme-score-api.herokuapp.com/score.svg?url=" + scoreUrl;
    var linkUrl = "http://clayallsopp.github.io/readme-score?url=" + scoreUrl;

    var markdown = '[![Readme Score](' + svgUrl + ')](' + linkUrl + ')';

    $copyField.val(markdown);
    clipboard.setText(markdown);
    $badge.attr('src', svgUrl);
    $badgeLink.attr('href', linkUrl);
  };
  this.update.bind(this);

  return this;
}

var Result = function() {
  var scoreToColor = {};
  for (var i = 0; i <= 100; i++) {
    if (i < 25) {
      scoreToColor[i] = "red";
      continue;
    }
    if (i < 80) {
      scoreToColor[i] = "yellow";
      continue;
    }
    scoreToColor[i] = "green"
  };

  var dial = new Dial();
  var embed = new Embed();

  var breakdownTable = function() {
    return $(".scoreboard-row table tbody");
  }

  var setBreakdown = function(breakdown) {
    breakdownTable().empty();
    var breakdowns = [];
    for (var description in breakdown) {
      var scorePossibleTuple = breakdown[description];
      var score = parseInt(scorePossibleTuple[0]);
      var possible = scorePossibleTuple[1];
      breakdowns.push({description: description, score: score, possible: possible});
    };
    breakdowns.sort(function(a, b) {
      if (a.score === b.score) {
        return a.possible - b.possible;
      }
      return a.score - b.score;
    });
    for (var i = breakdowns.length - 1; i >= 0; i--) {
      var item = breakdowns[i];
      addBreakdownItem(item.score, item.possible, item.description);
    };
  }

  var addBreakdownItem = function(score, possible, description) {
    var el = "<tr>" +
              '<td class="breakdown-column"><span class="breakdown-score">' + score + '</span> out of ' + possible + '</td>' +
              '<td>' + description + '</td>' +
            '</tr>'
    breakdownTable().append(el);
  };

  var articleForScore = function(score) {
    var scoreString = "" + score;
    if (scoreString[0] == "8") {
      return "an";
    }
    return "a";
  };

  this.show = function(score) {
    dial.hide();
    embed.prepare();

    $(".results-container").show();
    $(".repo-name").text(score.url);
    $(".repo-score").text(score.score);
    $(".repo-score-article").text(articleForScore(score.score));
    $(".repo-score").removeClass("red green yellow").addClass(scoreToColor[score.score]);
    setBreakdown(score.breakdown);
    embed.update(score.url);

    setTimeout(function() {
      dial.rotateToScore(score.score);
    }, 1000);
  }

  this.hide = function() {
    $(".results-container").hide();
  }
}


var QueryString = function () {
  // This function is anonymous, is executed immediately and 
  // the return value is assigned to QueryString!
  var query_string = {};
  var query = window.location.search.substring(1);
  var vars = query.split("&");
  for (var i=0;i<vars.length;i++) {
    var pair = vars[i].split("=");
      // If first entry with this name
    if (typeof query_string[pair[0]] === "undefined") {
      query_string[pair[0]] = pair[1];
      // If second entry with this name
    } else if (typeof query_string[pair[0]] === "string") {
      var arr = [ query_string[pair[0]], pair[1] ];
      query_string[pair[0]] = arr;
      // If third or later entry with this name
    } else {
      query_string[pair[0]].push(pair[1]);
    }
  } 
    return query_string;
} ();

$(function() {
  var result = new Result();
  var $button = $("#find-score");

  var performSearch = function() {
    $("#error-container").hide();
    $button.addClass("loading");
    $button.attr('disabled', 'disabled');
    result.hide();

    var urlOrSlug = $("#score-url").val();
    if (!urlOrSlug) {
      urlOrSlug = "afnetworking/afnetworking";
    }
    ScoreAPI.find(urlOrSlug, function(score) {
      window.score = score;
      result.show(score);
      $button.removeClass("loading");
      $button.removeAttr('disabled');
    }, function() {
      // an error happened :(
      $button.removeClass("loading");
      $button.removeAttr('disabled');
      $("#error-container").show();
    })
  };

  $('#score-url').keyup(function (e) {
    if (e.keyCode === 13) {
      performSearch();
    }
  });

  $("#find-score").click(performSearch);

  if (QueryString.url) {
    $("#score-url").val(QueryString.url);
    $("#find-score").click();
  }
});
