$(window).load(function (){
	
	//some test data
	var campaignData = {
		campaignerName: "Robert Chandler",
		campaignerTwitter: "nyacg",
		campaignerFacebook: "robert.j.h.chandler",
		campaignerInstagram: "nyahipster",
		initialTarget: 300,
		stretchTarget: 500,
		currentTotal: 150,
		donors: [{name: "Robert", date: "01/02/14", amount: 50, via: "Twitter"}, {name: "Harry", date: "07/02/14", amount: 50, via: "Facebook"}, {name: "Vesko", date: "07/02/14", amount: 50, via: "Facebook"}]
	};

	//get some commonly used values as variables
	var viewportHeight = $(window).height();
	var viewportWidth = $(window).width();
	var $bg = $('.background-image');
	var bgHeight = $bg.height();
	var bgWidth = $bg.width();
	var $heightElements = $(".above-container, .timeline-container");
	//console.log(bgHeight + " " + viewportHeight);

	$('.timeline-badge').hide();
	//console.log(campaignData);
	
	if(bgHeight >= viewportHeight * 1.1){
		$heightElements.height(viewportHeight * 1.1);
	} else {
		$heightElements.height(bgHeight - 100);
		//$('head').append("<style type='text/css'>.timeline:before{height: " + bgHeight-50 + "px !important;}</style>");
	}

	var timelineHeight = viewportHeight;

	if(viewportWidth <= 991){
		//console.log(viewportWidth + " " + viewportHeight);
		$('.timeline-container').height(viewportHeight * 1.5);
		$('.above-container').css("height", /*$('.timeline-container').height() + $('.text-container').height() + "px"*/ "100%");
		timelineHeight = viewportHeight * 1.5;
		$('.text-container').removeClass("big");
	}

	drawTimeline(timelineHeight, campaignData);
	
	/*if(viewportHeight/viewportWidth > bgHeight/bgWidth){
		$bg.css('position', 'absolute');
	}*/

	//show the tooltip/labels things when you hover over a circle
	$('.timeline-badge').mouseover(function(){
		var $panel = $(this).next('.timeline-panel');
		$panel.show();
	}).mouseleave(function(){
		var $panel = $(this).next('.timeline-panel');

		if(!$panel.hasClass('shown')){
			$(this).next('.timeline-panel').hide();
		}
	});
	
	function drawTimeline(viewportHeight, campaignData){
		var lineHeight = viewportHeight*0.75;
		var progHeight = 0;

		if(campaignData.currentTotal <= campaignData.initialTarget){
			progHeight = lineHeight*0.8*campaignData.currentTotal/campaignData.initialTarget;
		} else {
			console.log("else!");
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

		$target = $("<li class='shownli'><div class='timeline-badge " + (campaignData.currentTotal >= campaignData.initialTarget ? 'success' : 'danger')  + "' style='top:-14px'></div><div class='timeline-panel shown'><div class='timeline-heading'><h4 class='timeline-title'>Target to raise £" + campaignData.initialTarget + "</h4></div><div class='timeline-body'></div></div></li>");
		$target.css('top', lineHeight*0.8 - 10 + 'px');

		$current = $("<li class='shownli timeline-inverted'><div class='timeline-panel shown'><div class='timeline-heading'><h4 class='timeline-title'>Current total £" + campaignData.currentTotal + "</h4></div><div class='timeline-body'></div></div></li>");
		$current.css('top', progHeight - 10 + 'px');

		$stretch = $("<li class='shownli timeline-inverted'><div class='timeline-badge " + (campaignData.currentTotal >= campaignData.stretchTarget ? 'success' : 'danger')  + "' style='top:-14px'></div><div class='timeline-panel shown'><div class='timeline-heading'><h4 class='timeline-title'>Stretch target £" + campaignData.stretchTarget + "</h4></div><div class='timeline-body'></div></div></li>");
		$stretch.css('top', lineHeight - 10 + 'px');

		$('.timeline').append($target).append($current).append($stretch);
	}
});