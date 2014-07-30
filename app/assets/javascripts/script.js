$(window).load(function (){
	
	var viewportHeight = $(window).height();
	var bgHeight = $(".background-image").height();
	var $heightElements = $(".above-container, .timeline-container");
	//console.log(bgHeight + " " + viewportHeight);

	var campaignData = {
		initialTarget: 300,
		stretchTarget: 500,
		currentTotal: 150,
		donors: [{name: "Robert", date: "01/02/14", amount: 50, via: "Twitter"}, {name: "Harry", date: "07/02/14", amount: 50, via: "Facebook"}, {name: "Vesko", date: "07/02/14", amount: 50, via: "Facebook"}]
	};

	$('.timeline-badge').hide();
	//console.log(campaignData);
	
	if(bgHeight >= viewportHeight*1.1){
		$heightElements.height(viewportHeight*1.1);
		drawTimeline(viewportHeight, campaignData);
	} else {
		$heightElements.height(bgHeight-50);
		//$('head').append("<style type='text/css'>.timeline:before{height: " + bgHeight-50 + "px !important;}</style>");
	}


	$('.timeline-badge').mouseover(function(){
		$(this).next('.timeline-panel').show();
	}).mouseleave(function(){
		$(this).next('.timeline-panel').hide();
	});

	

	function drawTimeline(viewportHeight, campaignData){
		var lineHeight = viewportHeight*0.75;
		var progHeight = 0;

		if(campaignData.currentTotal <= campaignData.initialTarget){
			progHeight = lineHeight*0.8*campaignData.currentTotal/campaignData.initialTarget;
		} else {
			progHeight = lineHeight*0.8 + lineHeight*0.2*(campaignData.currentTotal - campaignData.initialTarget)/(campaignData.stretchTarget - campaignData.initialTarget);
		}

		//console.log(progHeight/lineHeight);

		$('head').append("<style type='text/css'>.timeline:before{height: " + lineHeight + "px !important;} .timeline:after{height: " + progHeight + "px !important;}</style>");
	
		var numDonors = campaignData.donors.length;
		//console.log(numDonors);
		var runningTotal = 0;
		for(i=0; i<numDonors; i++){
			var donor = campaignData.donors[i];
			runningTotal += donor.amount;
			//console.log(runningTotal);
			var $badge = $("<li><div class='timeline-badge small primary'>"/*<i class='glyphicon glyphicon-gbp'></i>*/+"</div><div class='timeline-panel'><div class='timeline-heading'><h4 class='timeline-title'>" + donor.name + "</h4><p><small class='text-muted'><i class='glyphicon glyphicon-time'></i> " + donor.date + " hours ago via " + donor.via + "</small></p></div><div class='timeline-body'><p>£" + parseFloat(Math.round(donor.amount * 100) / 100).toFixed(2) + "</p></div></div></li>");
			$('.timeline').append($badge);

			var height = 0;

			if(runningTotal <= campaignData.initialTarget){
				height = lineHeight*0.8*runningTotal/campaignData.initialTarget - 10 - 20*i;
			} else {
				height = lineHeight*0.8 + lineHeight*0.2*(runningTotal - campaignData.initialTarget)/(campaignData.stretchTarget - campaignData.initialTarget) - 10 - 20*i;
			}

			$badge.css('top', height);
		}
	}
});