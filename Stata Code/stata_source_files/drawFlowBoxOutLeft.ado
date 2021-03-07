program drawFlowBoxOutLeft
	args content location armlength
	*set trace on
	//get total number of lines
	local count: word count `content'
	
	//get maxwidth of line
	local maxwidth=0
	foreach line of local content {
		local maxwidth = max(`maxwidth',length(`"`line'"'))
	}
	
	//we already know where each line starts (location), and we know the arm length
	//therefore, we know the right margin of the left split box
	local rm = `location' - `armlength' - 1
	//the left margin is then right margin - the maxwidth - 6 - 1
	local lm = `rm' - `maxwidth' - 6-1
		
	//draw top line
	di _newline _col(`lm') "{c TLC}{hline `=`maxwidth'+6'}{c TRC}" _col(`location') "{c |}" _continue
	
	//find midline: for now, lets alwayss set midline to  int(count/2) + 1
	local midline = int(`count'/2) + 1
	forvalues i=1/`count' {
		printline `i' `midline' `location' `armlength' `lm' `rm' `"`content'"'
	}
	
	//draw bottom line
	di _newline _col(`lm') "{c BLC}{hline `=`maxwidth'+6'}{c BRC}" _col(`location') "{c |}" 
	
	
end


program printline
	args i midline location armlength lm rm content
	local thisline: word `i' of `content'
	local thislineloc = 1 + int(`lm' + (`rm'-`lm'-length(`"`thisline'"'))/2)
	if `i'==`midline' 	di _newline _col(`lm') "{c |}" _col(`thislineloc') `"`thisline'"' _col(`rm') "{c LT}" _dup(`=`armlength'') "{c -}" _col(`location') "{c RT}" _continue
	else 				di _newline	_col(`lm') "{c |}" _col(`thislineloc') `"`thisline'"' _col(`rm') "{c |}" _col(`location') "{c |}"  _continue
end
