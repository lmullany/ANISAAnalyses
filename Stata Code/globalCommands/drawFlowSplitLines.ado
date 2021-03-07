program drawFlowSplitLines
	syntax, locations(numlist) Middle(real) [Depth(real 0)]
	*args startloc depth splits left right
	/*
		startloc is the center of the non-split box (i.e. the box above)
		depth is the depth of the line before split
		splits is the number of splits
		left is the left location of the split
		rigth is the right location of the split
	*/
	
	forvalues i=1/`depth' {
		di _newline _col(`middle') "{c |}" _continue
	}
	
	local splits: word count `locations'
	local left: word 1 of `locations'
	local right: word `splits' of `locations'
	
	//if splits = 2, then this is easy
	if `splits' == 2 {
		di _newline _col(`left') "{c TLC}" _dup(`=`right'-`left'-1') "{c -}" _col(`right') "{c TRC}" _continue
		exit
	}
	
	//if splits>2, then this is a bit complicated
	local numt = `splits'-2
	local splitl = int(((`right'-`left') - `numt') / (`numt'+1))
	
	di _newline _col(`left') "{c TLC}" _continue
	forvalues i=1/`numt' {
		di			_dup(`splitl') "{c -}" _continue
		di			"{c +}" _continue
	}
	di			_dup(`splitl') "{c -}" _continue
	di			_col(`right') "{c TRC}" _continue
end
