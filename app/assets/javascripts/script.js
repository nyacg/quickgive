$(window).load(function (){
	
	var viewportHeight = $(window).height();
	var bgHeight = $(".background-image").height();
	var $heightElements = $(".above-container, .timeline-container");
	//console.log(bgHeight + " " + viewportHeight);

	var campaignData = {
		initialTarget: 300,
		stretchTarget: 500,
		currentTotal: 100,
		donors: {0: {name: "Robert", date: "01/02/14", amount: 50}, 1: {name: "Harry", date: "07/02/14", amount: 50}}
	};

	//console.log(campaignData);
	
	if(bgHeight >= viewportHeight*1.1){
		$heightElements.height(viewportHeight*1.1);
		drawTimeline(viewportHeight, campaignData);
	} else {
		$heightElements.height(bgHeight-50);
		//$('head').append("<style type='text/css'>.timeline:before{height: " + bgHeight-50 + "px !important;}</style>");
	}

	$('.timeline-badge').hide();
	

	function drawTimeline(viewportHeight, campaignData){
		var lineHeight = viewportHeight*0.75;
		var progHeight = 0

		if(campaignData.currentTotal <= campaignData.initialTarget){
			progHeight = lineHeight*0.8*campaignData.currentTotal/campaignData.initialTarget;
		} else {
			progHeight = lineHeight*0.8 + lineHeight*0.2*(campaignData.currentTotal - campaignData.initialTarget)/(campaignData.stretchTarget - campaignData.initialTarget);
		}

		//console.log(progHeight/lineHeight);

		$('head').append("<style type='text/css'>.timeline:before{height: " + lineHeight + "px !important;} .timeline:after{height: " + progHeight + "px !important;}</style>");
	
		var numDonors = campaignData.donors.length;
		var runningTotal = 0;
		for(i=0; i<numDonors; i++){
			runningTotal += campaignData.donors.i.amount
		}

	}
});