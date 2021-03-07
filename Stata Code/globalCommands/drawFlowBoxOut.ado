program drawFlowBoxOut
	args content1 location1 content2 location2 direc armlength
	/* 
	content1 and content2 are the content macros of the first and second box, respectively
	location1 and location2 are the location macros of the first and second box, respectively
	direc is the direc (right, left, or both)
	armlength is the length of the arm out in direction
	*/
	
	/* note, if direc is not "both", then content1 and location1 will be assumed to carry the values */

	if "`direc'" == "right" {
		drawFlowBoxOutRight `content1' `location1' `armlength'
		exit
	}
	if "`direc'" == "left"	{
		drawFlowBoxOutLeft `content1' `location1' `armlength' {
		exit
	}
	
	
	//get count and maxwidth of each box
	local maxlines=0
	forvalues box = 1/2 {
		local count`box': word count `content`box''
		local maxwidth`box'=0
		foreach line of local content`box' {
			local maxwidth`box' = max(`maxwidth`box'', length(`"`line'"'))
		}
		getMargin `box' `maxwidth`box'' `location`box'' `armlength'
		local rm`box' = r(rm)
		local lm`box' = r(lm)
		local maxlines = max(`maxlines',`count`box'')
		local midline`box' = int(`count`box''/2)+1
	}
	local midline=max(`midline1',`midline2') 
	
	drawTopLine `lm1' `maxwidth1' `location1' `lm2' `maxwidth2' `location2'

	
	//draw each line
	forvalues i=1/`maxlines' {
		forvalues box=1/2 {
			printline `i' `midline' `armlength' `box' `location`box'' `lm`box'' `rm`box'' `"`content`box''"'
		}
	}
	
	drawBottomLine `lm1' `maxwidth1' `location1' `lm2' `maxwidth2' `location2'

	

end

program getMargin, rclass
	args box maxwidth location armlength
	
	if `box'==2 {
		return scalar rm = (`location' + `armlength' + 1) + `maxwidth' + 6+1
		return scalar lm = `location' + `armlength' + 1
		exit
	}
	else {
		return scalar rm = `location' - `armlength' - 1
		return scalar lm = (`location'-`armlength' - 1) - `maxwidth' - 6 - 1
		exit
	}
end

	
program drawTopLine
	args lm1 maxwidth1 location1 lm2 maxwidth2 location2
	di _newline _col(`lm1') "{c TLC}{hline `=`maxwidth1'+6'}{c TRC}" _col(`location1') "{c |}" _continue
	di 			_col(`location2') "{c |}" _col(`lm2') "{c TLC}{hline `=`maxwidth2'+6'}{c TRC}" _continue
end

program drawBottomLine
	args lm1 maxwidth1 location1 lm2 maxwidth2 location2
	di _newline _col(`lm1') "{c BLC}{hline `=`maxwidth1'+6'}{c BRC}" _col(`location1') "{c |}" _continue
	di 			_col(`location2') "{c |}" _col(`lm2') "{c BLC}{hline `=`maxwidth2'+6'}{c BRC}" _continue
end


program printline
	args i midline armlength box location lm rm content
	local thisline: word `i' of `content'
	local thislineloc = 1 + int(`lm' + (`rm'-`lm'-length(`"`thisline'"'))/2)
	
	//if this is a left line (i.e. box==1), then we must end in continue....
	//if this is a right line (i.e. box==2), then we must not start in newline
	
	if `box'==1 {
		//this is a left line
		if `i'==`midline' {
			di _newline _col(`lm') "{c |}" _col(`thislineloc') `"`thisline'"' _col(`rm') "{c LT}" _dup(`=`armlength'') "{c -}" _col(`location') "{c RT}" _continue
		}
		else {
			di _newline	_col(`lm') "{c |}" _col(`thislineloc') `"`thisline'"' _col(`rm') "{c |}" _col(`location') "{c |}"  _continue
		}
	}
	else {
		//this is a right line
		if `i'==`midline' {
			di 			_col(`location') "{c LT}" _dup(`=`armlength'') "{c -}" _col(`lm') "{c RT}" _col(`thislineloc') `"`thisline'"' _col(`rm') "{c |}" _continue
		}
		else {
			di  		_col(`location') "{c |}" _col(`lm') "{c |}" _col(`thislineloc') `"`thisline'"' _col(`rm') "{c |}" _continue
		}
	}

end
