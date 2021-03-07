program drawFlowBox
	syntax, boxes(real) locations(numlist) content1(string) [content2(string) content3(string) content4(string) content5(string) content6(string)]

	/*if `boxes'>4 {
		di _newline as error "Cannot exceed four boxes"
		exit
	}
	*/
	
	local maxlines=0
	forvalues box=1/`boxes' {
		local count`box': word count `content`box''
		local maxlength`box'=0
		foreach line of local content`box' {
			local maxlength`box' = max(length(`"`line'"'), `maxlength`box'')
		}
		local location`box': word `box' of `locations'
		local lm`box' = int(`location`box'' - (`maxlength`box''+6)/2)
		local rm`box' = int(`location`box'' + (`maxlength`box''+6)/2)+1
		local maxlines = max(`maxlines', `count`box'')
	}
	
	/*draw the top line */
	forvalues box=1/`boxes' {
			if `box'==1 di _newline _col(`lm`box'') "{c TLC}{hline `=`maxlength`box''+6'}{c TRC}" _continue
			else di _col(`lm`box'') "{c TLC}{hline `=`maxlength`box''+6'}{c TRC}" _continue
	}
	
	*set trace on
	forvalues i=1/`maxlines' {
		forvalues box=1/`boxes' {
			printline `i' `box' `lm`box'' `rm`box'' `"`content`box''"'
		}
	}
		
	forvalues box=1/`boxes' {
		if `box'==1 	di _newline	_col(`lm`box'') "{c BLC}{hline `=`maxlength`box''+6'}{c BRC}" _continue
		else			di _col(`lm`box'') "{c BLC}{hline `=`maxlength`box''+6'}{c BRC}" _continue
	}
	
	
end

program printline
	args i box lm rm content
	local thisline: word `i' of `content'
	local thislineloc = 1 + int(`lm' + (`rm'-`lm'-length(`"`thisline'"'))/2)
	if `box'==1 	di _newline _col(`lm') "{c |}" _col(`thislineloc') `"`thisline'"' _col(`rm') "{c |}" _continue
	else 			di 			_col(`lm') "{c |}" _col(`thislineloc') `"`thisline'"' _col(`rm') "{c |}" _continue
end
