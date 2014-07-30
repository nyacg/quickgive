$(window).load(function (){
	
	var viewportHeight = $(window).height();
	var bgHeight = $(".background-image").height();
	//console.log(bgHeight + " " + viewportHeight);
	
	if(bgHeight >= viewportHeight*1.1){
		$(".above-container").height(viewportHeight*1.1);
	} else {
		$(".above-container").height(bgHeight-50);
	}
	
});