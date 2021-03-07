program drawFlowBoxOutRight
	syntax, locations(numlist) armlengths(numlist) content1(string) [content2(string) content3(string)]
	*args content1 location1 armlength1 content2 location2 armlength2 content3 location3 armlength3

	local boxes: word count `locations'
	
	//get count and maxwidth of each box
	local maxlines=0
	local midline=0
	forvalues box = 1/`boxes' {
		local count`box': word count `content`box''
		local maxwidth`box'=0
		foreach line of local content`box' {
			local maxwidth`box' = max(`maxwidth`box'', length(`"`line'"'))
		}
		getMargin, box(`box') maxwidth(`maxwidth`box'') locations(`locations') armlengths(`armlengths')
		local rm`box' = r(rm)
		local lm`box' = r(lm)
		
		local maxlines = max(`maxlines',`count`box'')
		local midline`box' = int(`count`box''/2)+1
		local location`box': word `box' of `locations'
		local armlength`box': word `box' of `armlengths'
		local midline=max(`midline',`midline`box'') 
	
		drawTopLine `box' `lm`box'' `maxwidth`box'' `location`box''
	}
	
	//find midline: for now, lets alwayss set midline to  int(count/2) + 1
	local midline = int(`maxlines'/2) + 1
	
	
	forvalues i=1/`maxlines' {
		forvalues box=1/`boxes' {
			printline `box' `i' `midline' `location`box'' `armlength`box'' `lm`box'' `rm`box'' `"`content`box''"'
		}
	}
	
	forvalues box=1/`boxes' {
		drawBottomLine `box' `lm`box'' `maxwidth`box'' `location`box''
	}
	
end


program printline
	args box i midline location armlength lm rm content
	local thisline: word `i' of `content'
	local thislineloc = 1 + int(`lm' + (`rm'-`lm'-length(`"`thisline'"'))/2)
	if `box'==1 di _newline _continue
	if `i'==`midline' 	di _col(`location') "{c LT}" _dup(`=`armlength'') "{c -}" _col(`lm') "{c RT}" _col(`thislineloc') `"`thisline'"' _col(`rm') "{c |}" _continue
	else 				di _col(`location') "{c |}" _col(`lm') "{c |}" _col(`thislineloc') `"`thisline'"' _col(`rm') "{c |}" _continue
end

program getMargin, rclass
	syntax, box(real) maxwidth(real) locations(numlist) armlengths(numlist)
	local location: word `box' of `locations'
	local armlength: word `box' of `armlengths'
	return scalar rm = (`location' + `armlength' + 1) + `maxwidth' + 6+1
	return scalar lm = `location' + `armlength' + 1
	
end

program drawTopLine
	args box lm maxwidth location
	if `box'==1 di _newline _continue
	di 			_col(`location') "{c |}" _col(`lm') "{c TLC}{hline `=`maxwidth'+6'}{c TRC}" _continue
end

program drawBottomLine
	args box lm maxwidth location
	if `box'==1 di _newline _continue
	di 			_col(`location') "{c |}" _col(`lm') "{c BLC}{hline `=`maxwidth'+6'}{c BRC}" _continue
end
