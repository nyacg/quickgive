$(function() {
  $("#searchbox3, #campaign_charity").autocomplete({
    source: function(request, response) {
      $.ajax({
        url: "/charities/search",
        dataType: "json",
        data: {
          query: request.term
        },
        success: function(data) {
          console.log(data)
          response(data);
        }
      });
    }
  });
});  
