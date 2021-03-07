program drawFlowLine
	syntax, lengths(numlist) locations(numlist)


	local numlines: list sizeof locations
	if `numlines'<1 exit
	
	local length=0
	forvalues i=1/`numlines' {
		local length=max(`length',`:word `i' of `lengths'')
	 }

	numlist "`locations'", sort
	local locations `"`r(numlist)'"'

	forvalues i=1/`length' {
		di _newline 	_col(`:word 1 of `locations'') "{c |}" _continue
		forvalues j=2/`numlines' {
			di _col(`:word `j' of `locations'') "{c |}" _continue
		}
	}
end
