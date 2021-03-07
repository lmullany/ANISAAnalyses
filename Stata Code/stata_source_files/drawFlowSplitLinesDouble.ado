program drawFlowSplitLinesDouble
	syntax, locations1(numlist) Middle1(real) locations2(numlist) Middle2(real) [Depth(real 0)] direction(string)

	if "`direction'"=="T" {
		forvalues i=1/`depth' {
			di _newline _col(`middle1') "{c |}" _col(`middle2') "{c |}" _continue
		}
	}
	
	local splits1: word count `locations1'
	local left1: word 1 of `locations1'
	local right1: word `splits1' of `locations1'

	local splits2: word count `locations2'
	local left2: word 1 of `locations2'
	local right2: word `splits2' of `locations2'
	
	//if splits1 = 2, then this is easy
	if `splits1' == 2 {
		di _newline _col(`left1') "{c `direction'LC}" _dup(`=`right1'-`left1'-1') "{c -}" _col(`right1') "{c `direction'RC}" _continue
	}
	else {
		//if splits>2, then this is a bit complicated
		local numt = `splits1'-2
		local splitl = int(((`right1'-`left1') - `numt') / (`numt'+1))
		
		di _newline _col(`left1') "{c `direction'LC}" _continue
		forvalues i=1/`numt' {
			di			_dup(`splitl') "{c -}" _continue
			di			"{c +}" _continue
		}
		di			_dup(`splitl') "{c -}" _continue
		di			_col(`right1') "{c `direction'RC}" _continue
	}
	
	//if splits2 = 2, then this is easy
	if `splits2' == 2 {
		di _col(`left2') "{c `direction'LC}" _dup(`=`right2'-`left2'-1') "{c -}" _col(`right2') "{c `direction'RC}" _continue
	}
	else {
		//if splits>2, then this is a bit complicated
		local numt = `splits2'-2
		local splitl = int(((`right2'-`left2') - `numt') / (`numt'+1))
		
		di _col(`left2') "{c `direction'LC}" _continue
		forvalues i=1/`numt' {
			di			_dup(`splitl') "{c -}" _continue
			di			"{c +}" _continue
		}
		di			_dup(`splitl') "{c -}" _continue
		di			_col(`right2') "{c `direction'RC}" _continue
	}

	if "`direction'"=="B" {
		forvalues i=1/`depth' {
			di _newline _col(`middle1') "{c |}" _col(`middle2') "{c |}" _continue
		}
	}

	
end
