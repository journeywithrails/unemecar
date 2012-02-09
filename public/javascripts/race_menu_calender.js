
/*	
	Coding  : Providence Network & Solutions (PVT) Ltd.
	Project : Race Menu (Ruby on Rails)
	Date    : 24 June 2009
*/

function PNSCalender() {
	var date;
	var month;
	var year;
	
	var firstDate;
	var firstMonth;
	var firstYear;
	var firstNumberOfDays 	= 0;
	var firstTotalDays 		= 0;
	var firstNameOfDay 		= 'Sunday';
	var firstSelectedMonth  = 'January';
	
	var secondDate;
	var secondMonth;
	var secondYear;
	var secondNumberOfDays 	= 0;
	var secondTotalDays 	= 0;
	var secondNameOfDay 	= 'Sunday';
	var secondSelectedMonth = 'January';
	
	var monthCollection = ['January','February','March','April','May','June','July','August','September',
						   'October','November','December'];
	var dayCollection   = ['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'];
	var shortDayCollection = ['Mo','Tu','We','Th','Fr','Sa', 'Su'];
	
	var monthDays       = [31,28,31,30,31,30,31,31,30,31,30,31];
	var leapMonthDays   = [31,29,31,30,31,30,31,31,30,31,30,31];
	var numberOfDays    = 0;
	var nameOfDay       = 'Sunday';
	var selectedMonth   = 'January';
	
	var idFirstArray    = new Array();
	var idSecondArray   = new Array();
	
	var currentCalender 	= 'first';
	var totalDays       	= 0;
	var thisCalenderCover   = '';
	var targetDateField 	= '';
	var thisCalenderFrame 	= '';
	var buttonId 			= '';
	
	var specialDayArray 	= ['5/15/2009','5/6/2009','5/24/2009','6/13/2009'];
	
	this.callRaceMenuCalender = function(btnId, calenderCover, targetField, calenderFrame){
		buttonId = btnId;
		thisCalenderCover = calenderCover;
		targetDateField = targetField;
		thisCalenderFrame = calenderFrame;
		
		if($(calenderCover) != null){
			if($(calenderCover).style.display == 'block'){
				$(calenderCover).style.display = 'none';		
				return;
			}
		}
		
		getInitialInformation();
	},
	
	getInitialInformation = function(){
		var today = new Date();
			date  = today.getDate();
			month = today.getMonth();
			year  = today.getFullYear();
			
			firstDate = date;
			firstMonth = month;
			firstYear = year;
			
			secondDate = date;
			if(firstMonth == 11){
				secondMonth = 0;
				secondYear = firstYear + 1;
			} else {
				secondMonth = month + 1;
				secondYear = year;
			}
		
		createCalender(firstYear, firstMonth);
	},
	
	createCalender = function(displayYear, displayMonth){
		var firstYearDays = 0;
		
		if(Math.ceil((displayYear) % 4) == 0 && (Math.ceil((displayYear) % 100) != 0 || Math.ceil((displayYear) % 400) == 0)){  
			for(var i=0; i < displayMonth; i++){
				firstYearDays += leapMonthDays[i];
			}
			firstNumberOfDays = leapMonthDays[displayMonth];
			
		} else {
			for(var i=0; i < displayMonth; i++){
				firstYearDays += monthDays[i];
			}
			firstNumberOfDays = monthDays[displayMonth];
			
		}
		
		
		firstTotalDays  = (displayYear - 1) + (Math.ceil((displayYear - 1) / 4)) - (Math.ceil((displayYear - 1) / 100)); 
		firstTotalDays += (Math.ceil((displayYear - 1) / 400));
		
		firstTotalDays += (firstYearDays );
		
		firstSelectedMonth = monthCollection[displayMonth];
		firstNameOfDay = dayCollection[firstTotalDays % 7];
		buildCurrentCalendar(firstTotalDays);
		
		setUpSecondCalender(displayYear, displayMonth);
	},
	
	
	buildCurrentCalendar = function(firstTotalDays){
		
		var initText  = '<div id=previous_month class=previous_month onclick=updateCurrentCalendar()></div>';
			initText += '<div id=previous_month_indicator class=previous_month_indicator></div>';

		$(thisCalenderFrame).innerHTML = initText;
		
		var startDayIndex = firstTotalDays % 7;
		
		var firCal ='<div id=internal_first_calendar class=internal_first_calendar onmouseover=setCurrentCalender("first")></div>';
		$(thisCalenderFrame).innerHTML += firCal;
		
		for(var i=0; i < shortDayCollection.length; i++){
			$('internal_first_calendar').innerHTML += '<div class=day_heading>' + shortDayCollection[i] + '</div>';	
		}
		
		if(startDayIndex == 0){
			startDayIndex = 7;
		}
		
		for(var i=1 ; i < firstNumberOfDays + startDayIndex; i++){
			if(i >= startDayIndex){
				var txt  = '<div id=date_fir_' + i + ' class=date_style onmouseover=setEffect(id) onclick=updateDateField(id)>';
					txt += (i - startDayIndex + 1) + '</div>';
				idFirstArray[idFirstArray.length] = ('date_fir_' + (i - startDayIndex + 1));
				$('internal_first_calendar').innerHTML += txt;
				
				var thisDay = firstMonth + '/' + (i - startDayIndex + 1) + '/' + firstYear;
				if(isSpecialDay(thisDay)){
					$('date_fir_' + (i - startDayIndex + 1)).style.backgroundColor = '#FFCC99';
				}
				
			} else {
				var txt = '<div class=date_style_empty></div>';
				$('internal_first_calendar').innerHTML += txt;
			}
		}
		
		var ieVersion = navigator.appVersion;
		if(navigator.appName == 'Microsoft Internet Explorer' && ieVersion.lastIndexOf('7') > 0){
			if($(thisCalenderCover) != null){
				$(thisCalenderCover).style.marginLeft = '-130px';
			}
		}
		
		$('previous_month_indicator').innerHTML = firstSelectedMonth + '  ' + firstYear;
		$(thisCalenderCover).style.display = 'block';
	},
	
	isSpecialDay = function(thisDay){
		
		for(var i=0; i < specialDayArray.length; i++){
			if(specialDayArray[i] == thisDay){
				return true;
			}
		}
		return false;
	},
	
	setEffect = function(id){
		
		if(currentCalender == 'first'){
			
			for(var i=0; i < idFirstArray.length; i++){
				var thisDay = firstMonth + '/' + idFirstArray[i].replace('date_fir_','') + '/' + firstYear;
				var isExist = isSpecialDay(thisDay);
				
				if(idFirstArray[i] != id){
					$(id).style.backgroundColor = '#CCCCCC';
					if(document.getElementById(idFirstArray[i]) != null){
						document.getElementById(idFirstArray[i]).style.backgroundColor = '#FFFFFF';	
					}
				}
				
				if(isExist){
					document.getElementById(idFirstArray[i]).style.backgroundColor = '#FFCC99';	
				}
			}
			
		}  else {
			for(var i=0; i < idSecondArray.length; i++){
				var thisDay = secondMonth + '/' + idSecondArray[i].replace('date_sec_','') + '/' + secondYear;
				var isExist = isSpecialDay(thisDay);
				
				if(idSecondArray[i] != id){
					$(id).style.backgroundColor = '#CCCCCC';
					if(document.getElementById(idSecondArray[i]) != null){
						document.getElementById(idSecondArray[i]).style.backgroundColor = '#FFFFFF';
					}
				}
				
				if(isExist){
					document.getElementById(idSecondArray[i]).style.backgroundColor = '#FFCC99';	
				}
			}
		}
	},
	
	updateDateField = function(id){
		
		if($(id) != null){
			var selectedDate = $(id).innerHTML;
			var selectedDay = '';
			
			if(currentCalender == 'first'){
				selectedDay = (firstMonth + 1) + '/' + selectedDate + '/' + firstYear;
			} else {
				selectedDay = (secondMonth + 1) + '/' + selectedDate + '/' + secondYear;	
			}
			
			
			if ('txtToDate' == targetDateField) {
				//if the other date field is blank, that's fine. otherwise compare the dates
				
				if ($('txtFromDate').value == "From:"){
					//everything is fine
				}
				else {
					var to = Date.parse(selectedDay);
					var from = Date.parse($('txtFromDate').value);
					if (to < from) {
						alert('Start date cannot be after end date!');
						return;
					}
				}
				
			}
			else if ('txtFromDate' == targetDateField) {
				//if the other date field is blank, that's fine. otherwise compare the dates
				if ($('txtToDate').value == "From:"){
					//everything is fine
				}
				else {
					var from = Date.parse(selectedDay);
					var to = Date.parse($('txtToDate').value);
					if (to < from) {
						alert('Start date cannot be after end date!');
						return;
					}
				}
			}
			
			
			$(thisCalenderFrame).innerHTML = '';
			$(targetDateField).value = selectedDay;	
			$(thisCalenderCover).style.display = 'none';
			
		} else {
			$(thisCalenderCover).style.display = 'none';	
			$(thisCalenderFrame).innerHTML = '';
		}
	},
	
	setCurrentCalender = function(calenderId){
		currentCalender = calenderId;
	},
	
	updateCurrentCalendar = function(){
	
		if(firstMonth == 0){
			firstMonth = 11;
			firstYear -= 1;
			
		} else {
			firstMonth = (firstMonth - 1);	
		}
		
		createUpdateCalender('previous',firstYear, firstMonth);
		
		var startDayIndex = firstTotalDays % 7;
		
		idFirstArray = [];
		$('internal_first_calendar').innerHTML = '';
		
		for(var i=0; i < shortDayCollection.length; i++){
			$('internal_first_calendar').innerHTML += '<div class=day_heading>' + shortDayCollection[i] + '</div>';	
		}
		
		if(startDayIndex == 0){
			startDayIndex = 7;
		}
		
		for(var i=1; i < firstNumberOfDays + startDayIndex; i++){	
			if(i >= startDayIndex){
				var txt  = '<div id=date_fir_' + i + ' class=date_style onmouseover=setEffect(id) onclick=updateDateField(id)>';
					txt += (i - startDayIndex + 1) + '</div>';
				idFirstArray[idFirstArray.length] = ('date_fir_' + (i - startDayIndex + 1));
				$('internal_first_calendar').innerHTML += txt;
				
				var thisDay = secondMonth + '/' + (i - startDayIndex + 1) + '/' + secondYear;
				if(isSpecialDay(thisDay)){
					$('date_sec_' + (i - startDayIndex + 1)).style.backgroundColor = '#FFCC99';
				}
				
			} else {
				var txt = '<div class=date_style_empty></div>';
				$('internal_first_calendar').innerHTML += txt;
			}
		}
		
		$('previous_month_indicator').innerHTML = firstSelectedMonth + '  ' + firstYear;
		
		if(secondMonth == 0){
			secondMonth = 11;
			secondYear -= 1;
			
		} else {
			secondMonth = (secondMonth - 1);	
		}
				
		createUpdateCalender('next',secondYear, secondMonth);
		
		var startDayIndex = secondTotalDays % 7;
		
		idSecondArray = [];
		$('internal_second_calendar').innerHTML = '';
		
		for(var i=0; i < shortDayCollection.length; i++){
			$('internal_second_calendar').innerHTML += '<div class=day_heading>' + shortDayCollection[i] + '</div>';	
		}
		
		if(startDayIndex == 0){
			startDayIndex = 7;
		}
		
		for(var i=1; i < secondNumberOfDays + startDayIndex; i++){	
			if(i >= startDayIndex){
				var txt  = '<div id=date_sec_' + i + ' class=date_style onmouseover=setEffect(id) onclick=updateDateField(id)>';
					txt += (i - startDayIndex + 1) + '</div>';
				idSecondArray[idSecondArray.length] = ('date_sec_' + (i - startDayIndex + 1));
				
				$('internal_second_calendar').innerHTML += txt;
				
				var thisDay = secondMonth + '/' + (i - startDayIndex + 1) + '/' + secondYear;
				if(isSpecialDay(thisDay)){
					$('date_sec_' + (i - startDayIndex + 1)).style.backgroundColor = '#FFCC99';
				}
				
			} else {
				var txt = '<div class=date_style_empty></div>';
				$('internal_second_calendar').innerHTML += txt;
			}
		}
		
		$('next_month_indicator').innerHTML = secondSelectedMonth + '  ' + secondYear;
		
	},
	
	createUpdateCalender = function(type, displayYear, displayMonth){
		
		if(type == 'previous'){
			var firstYearDays = 0;
			
			if(Math.ceil((displayYear) % 4) == 0 && (Math.ceil((displayYear) % 100) != 0 || Math.ceil((displayYear) % 400) == 0)){  
				for(var i=0; i < displayMonth; i++){
					firstYearDays += leapMonthDays[i];
				}
				firstNumberOfDays = leapMonthDays[displayMonth];
				
			} else {
				for(var i=0; i < displayMonth; i++){
					firstYearDays += monthDays[i];
				}
				firstNumberOfDays = monthDays[displayMonth];
				
			}
			
			firstTotalDays  = (displayYear - 1) + (Math.ceil((displayYear - 1) / 4)) - (Math.ceil((displayYear - 1) / 100)); 
			firstTotalDays += (Math.ceil((displayYear - 1) / 400));
			
			firstTotalDays += firstYearDays;
			
			firstSelectedMonth = monthCollection[displayMonth];
			firstNameOfDay = dayCollection[firstTotalDays % 7];
			
		} else {
			var secondYearDays = 0;
			
			if(Math.ceil((displayYear) % 4) == 0 && (Math.ceil((displayYear) % 100) != 0 || Math.ceil((displayYear) % 400) == 0)){  
				for(var i=0; i < displayMonth; i++){
					secondYearDays += leapMonthDays[i];
				}
				secondNumberOfDays = leapMonthDays[displayMonth];
				
			} else {
				for(var i=0; i < displayMonth; i++){
					secondYearDays += monthDays[i];
				}
				secondNumberOfDays = monthDays[displayMonth];
				
			}
			
			secondTotalDays  = (displayYear - 1) + (Math.ceil((displayYear - 1) / 4)) - (Math.ceil((displayYear - 1) / 100)); 
			secondTotalDays += (Math.ceil((displayYear - 1) / 400));
			
			secondTotalDays += secondYearDays ;
			
			secondSelectedMonth = monthCollection[displayMonth];
			secondNameOfDay = dayCollection[totalDays % 7];
		}
	},
	
	setUpSecondCalender = function(displayYear, displayMonth){
		var secondYearDays = 0;
		
		if(displayMonth == 11){
			displayMonth = 0;
			displayYear += 1;
		} else {
			displayMonth += 1;	
		}
		
		if(Math.ceil((displayYear) % 4) == 0 && (Math.ceil((displayYear) % 100) != 0 || Math.ceil((displayYear) % 400) == 0)){  
			for(var i=0; i < displayMonth; i++){
				secondYearDays += leapMonthDays[i];
			}
			secondNumberOfDays = leapMonthDays[displayMonth];
			
		} else {
			for(var i=0; i < displayMonth; i++){
				secondYearDays += monthDays[i];
			}
			secondNumberOfDays = monthDays[displayMonth];
			
		}
		
		secondTotalDays  = (displayYear - 1) + (Math.ceil((displayYear - 1) / 4)) - (Math.ceil((displayYear - 1) / 100)); 
		secondTotalDays += (Math.ceil((displayYear - 1) / 400));
		
		secondTotalDays += secondYearDays ;
		
		secondSelectedMonth = monthCollection[displayMonth];
		secondNameOfDay = dayCollection[secondTotalDays % 7];	
		
		buildNextMonthCalendar(secondTotalDays);
	},
	
	buildNextMonthCalendar = function(secondTotalDays){
		
		var startDayIndex = secondTotalDays % 7;
		
		var secCal  = '<div id=internal_second_calendar class=internal_second_calendar'; 
			secCal += ' onmouseover=setCurrentCalender("second")></div>';
			
			var ieVersion = navigator.appVersion;
			if(navigator.appName == 'Microsoft Internet Explorer' && ieVersion.lastIndexOf('7') > 0){
				//secCal  = '<div id=internal_second_calendar class=internal_second_calendar_ie7'; 
				//secCal += ' onmouseover=setCurrentCalender("second")></div>';
			}
		
			secCal += '<div id=next_month_indicator class=next_month_indicator></div>';
		
		$(thisCalenderFrame).innerHTML += secCal;
		for(var i=0; i < shortDayCollection.length; i++){
			$('internal_second_calendar').innerHTML += '<div class=day_heading>' + shortDayCollection[i] + '</div>';	
		}
		
		if(startDayIndex == 0){
			startDayIndex = 7;
		}
		
		for(var i=1; i < secondNumberOfDays + startDayIndex; i++){
			if(i >= startDayIndex){
				var txt  = '<div id=date_sec_' + i + ' class=date_style onmouseover=setEffect(id) onclick=updateDateField(id)>';
					txt += (i - startDayIndex + 1) + '</div>';
					
				idSecondArray[idSecondArray.length] = ('date_sec_' + (i - startDayIndex + 1));
				$('internal_second_calendar').innerHTML += txt;
				
				var thisDay = secondMonth + '/' + (i - startDayIndex + 1) + '/' + secondYear;
				if(isSpecialDay(thisDay)){
					$('date_sec_' + (i - startDayIndex + 1)).style.backgroundColor = '#FFCC99';
				}
				
			} else {
				var txt = '<div class=date_style_empty></div>';
				$('internal_second_calendar').innerHTML += txt;
			}
		}
		
		var txtNextBtn = '<div id=next_month class=next_month onclick=updateNextCalendar()></div>';
		
		var ieVersion = navigator.appVersion;
		if(navigator.appName == 'Microsoft Internet Explorer' && ieVersion.lastIndexOf('7') > 0){
			txtNextBtn = '<div id=next_month class=next_month_ie7 onclick=updateNextCalendar()></div>';	
		}
		
		$(thisCalenderFrame).innerHTML += txtNextBtn;
		
		$('next_month_indicator').innerHTML = secondSelectedMonth + '  ' + secondYear;
		
		$(thisCalenderCover).style.display = 'block';
	},
	
	updateNextCalendar = function(){
		
		if(firstMonth == 11){
			firstMonth = 0;
			firstYear += 1;
			
		} else {
			firstMonth = (firstMonth + 1);	
		}
		
		createUpdateCalender('previous',firstYear, firstMonth);
		
		var startDayIndex = firstTotalDays % 7;
		
		idFirstArray = [];
		$('internal_first_calendar').innerHTML = '';
		
		for(var i=0; i < shortDayCollection.length; i++){
			$('internal_first_calendar').innerHTML += '<div class=day_heading>' + shortDayCollection[i] + '</div>';	
		}
		
		if(startDayIndex == 0){
			startDayIndex = 7;
		}
		
		for(var i=1; i < firstNumberOfDays + startDayIndex; i++){	
			if(i >= startDayIndex){
				var txt  = '<div id=date_fir_' + i + ' class=date_style onmouseover=setEffect(id) onclick=updateDateField(id)>';
					txt += (i - startDayIndex + 1) + '</div>';
				idFirstArray[idFirstArray.length] = ('date_fir_' + (i - startDayIndex + 1));
				$('internal_first_calendar').innerHTML += txt;
				
				var thisDay = secondMonth + '/' + (i - startDayIndex + 1) + '/' + secondYear;
				if(isSpecialDay(thisDay)){
					$('date_sec_' + (i - startDayIndex + 1)).style.backgroundColor = '#FFCC99';
				}
				
			} else {
				var txt = '<div class=date_style_empty></div>';
				$('internal_first_calendar').innerHTML += txt;
			}
		}
		
		$('previous_month_indicator').innerHTML = firstSelectedMonth + '  ' + firstYear;
	
		if(secondMonth == 11){
			secondMonth = 0;
			secondYear += 1;
			
		} else {
			secondMonth = (secondMonth + 1);	
		}
		
		createUpdateCalender('next',secondYear, secondMonth);
		
		var startDayIndex = secondTotalDays % 7;
		
		idSecondArray = [];
		$('internal_second_calendar').innerHTML = '';
		
		for(var i=0; i < shortDayCollection.length; i++){
			$('internal_second_calendar').innerHTML += '<div class=day_heading>' + shortDayCollection[i] + '</div>';	
		}
		
		if(startDayIndex == 0){
			startDayIndex = 7;
		}
		
		for(var i=1; i < secondNumberOfDays + startDayIndex; i++){	
			if(i >= startDayIndex){
				var txt  = '<div id=date_sec_' + i + ' class=date_style onmouseover=setEffect(id) onclick=updateDateField(id)>';
					txt += (i - startDayIndex + 1) + '</div>';
				idSecondArray[idSecondArray.length] = ('date_sec_' + (i - startDayIndex + 1));
				
				$('internal_second_calendar').innerHTML += txt;
				
				var thisDay = secondMonth + '/' + (i - startDayIndex + 1) + '/' + secondYear;
				if(isSpecialDay(thisDay)){
					$('date_sec_' + (i - startDayIndex + 1)).style.backgroundColor = '#FFCC99';
				}
				
			} else {
				var txt = '<div class=date_style_empty></div>';
				$('internal_second_calendar').innerHTML += txt;
			}
		}
		
		$('next_month_indicator').innerHTML = secondSelectedMonth + '  ' + secondYear;
	},
	
	clearDateComponets = function(){
		$(targetDateField).value = '';	
		idFirstArray  = [];
		idSecondArray = [];
	},
	
	this.killCalender = function(calenderId, frameId){
		
		thisCalenderFrame = calenderId;
		thisCalenderCover = frameId;
			
		//	updateDateField();
		$(thisCalenderCover).style.display = 'none';	
		$(thisCalenderFrame).innerHTML = '';
	}

}
