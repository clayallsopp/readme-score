$(function() {
    $("#find-score").click(function() {
      $.get("http://readme-score-api.herokuapp.com/score", {url: $("#score-url").val()}, function(data) {
        console.log(data);
        $("#score-container").show();
        $("#score").text(data.score);
      });
    });
});
