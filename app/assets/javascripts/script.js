$(window).load(function (){
	
  var data_url = window.location.href + ".json";

	//get some commonly used selectors and values as variables
	var $bg = $('.background-image');
	var $heightElements = $(".above-container, .timeline-container");

	//setup the page for the screen 
	doSizes();

	//make the sizes recalculate when the screen is changes (e.g. rotated)
	$(window).resize(function(){
		doSizes();
	});

	//show the tooltip/labels things when you hover over a circle
	$(document).on('mouseover', '.timeline-badge', function(){
		var $panel = $(this).next('.timeline-panel');
		$panel.show();
	}).on('mouseleave', '.timeline-badge', function(){
		var $panel = $(this).next('.timeline-panel');

		if(!$panel.hasClass('shown')){
			$(this).next('.timeline-panel').hide();
		}
	});

	


	function doSizes(){
		var viewportHeight = $(window).height();
		var viewportWidth = $(window).width();
		var bgHeight = $bg.height();
		var bgWidth = $bg.width();
		var timelineHeight = 0;

		if(bgHeight >= viewportHeight * 1.1 && viewportHeight > 600){
			$heightElements.height(viewportHeight * 1.1);
			timelineHeight = viewportHeight;
		} else {
			$heightElements.height(bgHeight - 100);
			//$('head').append("<style type='text/css'>.timeline:before{height: " + bgHeight-50 + "px !important;}</style>");
			timelineHeight = bgHeight * 0.95;
		}


		if(viewportWidth < 990){
			//console.log(viewportWidth + " " + viewportHeight);
			$('.timeline-container').height(viewportHeight * 1.2);
			$('.above-container').css("height", /*$('.timeline-container').height() + $('.text-container').height() + "px"*/ "100%");
			timelineHeight = viewportHeight * 1.5;
		}

    $.get(data_url).success(function(data) {
      drawTimeline(timelineHeight, data);
    });
		// drawTimeline(timelineHeight, campaignData);
		
		/*if(viewportHeight/viewportWidth > bgHeight/bgWidth){
			$bg.css('position', 'absolute');
		}*/
	}

	
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
		$('head').remove("#timeline-styling");
		$('head').append("<style id='timeline-styling' type='text/css'>.timeline:before{height: " + lineHeight + "px !important;} .timeline:after{height: " + progHeight + "px !important;}</style>");
	
		var numDonors = campaignData.donors.length;
		//console.log(numDonors);

		$(".timeline").empty();
		var runningTotal = 0;
		for(i=0; i<numDonors; i++){
			var donor = campaignData.donors[i];
			runningTotal += donor.amount;
			//console.log(runningTotal);
			var $badge = $("<li><div class='timeline-badge small primary'>"/*<i class='glyphicon glyphicon-gbp'></i>*/+"</div><div class='timeline-panel'><div class='timeline-heading'><h4 class='timeline-title'>" + donor.name + "</h4><p><small class='text-muted'><i class='glyphicon glyphicon-time'></i> " + donor.date + " ago via " + donor.via + "</small></p></div><div class='timeline-body'><p>£" + parseFloat(Math.round(donor.amount * 100) / 100).toFixed(2) + "</p></div></div></li>");
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
