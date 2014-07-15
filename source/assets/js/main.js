

var Dial = function() {
  function findKeyframesRule(animationName) {
    var ss = document.styleSheets;
    var rule = null;
    for (var i = 0; i < ss.length; i++) {
      for (var j = 0; j < ss[i].cssRules.length; j++) {
        if (ss[i].cssRules[j].type == window.CSSRule.WEBKIT_KEYFRAMES_RULE && ss[i].cssRules[j].name == animationName) {
          rule = ss[i].cssRules[j];
        }
      }
    }
    return rule;
  }

  var lastDegrees = 164;

  function createRotationAnimation(degrees) {
    var keyframes = findKeyframesRule("dialmove");
    var diffFromOriginal = lastDegrees - degrees;
    var ruleTexts = [];
    for (var i = keyframes.cssRules.length - 1; i >= 0; i--) {
      var rule = keyframes.cssRules[i];
      ruleTexts.push(rule.cssText);
      keyframes.deleteRule(rule.keyText);
    }
    for (var i = ruleTexts.length - 1; i >= 0 ; i--) {
      var cssText = ruleTexts[i];
      var matches = cssText.match("(\\d+)deg");
      var ruleDegrees = parseInt(matches[1]);
      var ruleDiffFromOriginal = lastDegrees - ruleDegrees;
      var newRuleDegrees = degrees + ruleDiffFromOriginal;
      if (ruleDegrees === 0) {
        newRuleDegrees = 0;
      }
      var replaced = cssText.replace(matches[0], newRuleDegrees + "deg");
      keyframes.insertRule(replaced);
    }
    return keyframes;
  }

  function rotateDial(degrees) {
    var animation = createRotationAnimation(degrees);
    document.getElementById('dial').style.webkitAnimationName = undefined;
    setTimeout(function() {
      document.getElementById('dial').style.webkitAnimationName = "dialmove";
    }, 100);
    lastDegrees = degrees;
  }

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
    $.get(url, {url: urlOrSlug, human_breakdown: "true"}, function(data, textStatus) {
        if (textStatus === 'error' || textStatus === 'timeout') {
          errorCallback();
        }
        else {
          callback(new Score(data));
        }
      });
  }
};

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

  var breakdownTable = function() {
    return $(".scoreboard-row table tbody");
  }

  var setBreakdown = function(breakdown) {
    breakdownTable().empty();
    var breakdowns = [];
    for (var description in breakdown) {
      var scorePossibleTuple = breakdown[description];
      var score = scorePossibleTuple[0];
      score = scorePossibleTuple;
      var possible = scorePossibleTuple[1];
      possible = 40;
      breakdowns.push({description: description, score: score, possible: possible});
    };
    breakdowns.sort(function(a, b) {
      if (a.score == b.score) {
        return a.possible > b.possible;
      }
      return a.score > b.score;
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
  }

  this.show = function(score) {
    $(".results-container").show();
    $(".repo-name").text(score.url);
    $(".repo-score").text(score.score);
    $(".repo-score").removeClass("red green yellow").addClass(scoreToColor[score.score]);
    setBreakdown(score.breakdown);

    dial.rotateToScore(score.score);

  }
}

$(function() {
    var result = new Result();

    $("#find-score").click(function() {
      ScoreAPI.find($("#score-url").val(), function(score) {
        window.score = score;
        result.show(score);
      }, function() {
        // an error happened :(
      })
    });
});
