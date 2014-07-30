$(window).load(function (){
	
	var viewportHeight = $(window).height();
	var bgHeight = $(".background-image").height();
	var $heightElements = $(".above-container, .timeline-container");
	console.log(bgHeight + " " + viewportHeight);
	
	if(bgHeight >= viewportHeight*1.1){
		$heightElements.height(viewportHeight*1.1);
		$('head').append("<style>.timeline:before{height: " + viewportHeight*0.75 + "px !important;}</style>");
	} else {
		$heightElements.height(bgHeight-50);
		$('head').append("<style type='text/css'>.timeline:before{height: " + bgHeight-50 + "px !important;}</style>");
	}

	$('.timeline-badge').hide();
	
});