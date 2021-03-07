//Program to print the output of a STATA command to a pdf
//Luke C. Mullany

program define printCommand
	syntax, command(string) output(string) [fontsize(real 8) margin(real .2) landscape pagesize(string) customtranslator(string)]
	quietly {
		tempfile outputLog
		log using `outputLog', replace
		
		noi `command'
		
		log close
		
		local trnsltr "smcl2pdf"
		
		//override if a custom translator is provided
		if "`customtranslator'"!="" local trnsltr "`customtranslator'"
		
		capture translator set `trnsltr' pagesize custom
		if _rc!=0 {
		    di as error "Translator problem: You may not have `trnsltr' on this operating system; check translator query"
		    exit
		}
		
		if "`pagesize'"=="" local pagesize "letter"
		
		_getPageSettings `pagesize' `landscape'
				
		translator set `trnsltr' pagewidth `r(pwidth)'
		translator set `trnsltr' pageheight `r(pheight)'
		translator set `trnsltr' logo off

		qui translate `outputLog' "`output'.pdf", translator(`trnsltr') replace ///
		header(off) fontsize(`fontsize') lmargin(`margin') rmargin(`margin') tmargin(`margin') bmargin(`margin')


	}
end

program _getPageSettings, rclass
	args pagesize landscape
	   
	if "`pagesize'"=="letter" {
		//letter size
		scalar width=8.5
		scalar height=11.00
	}
	else if "`pagesize'"=="A4" {
		//A4 Size
		scalar width=8.27
		scalar height=11.69
	}
	else if "`pagesize'"=="A3" {
		scalar width=11.69
		scalar height=16.53
	}
	else if "`pagesize'"=="A2" {
		scalar width=16.53
		scalar height=23.4
	}
	else if "`pagesize'"=="A1" {
		scalar width=23.4
		scalar height=33.1
	}
	else {
		//set default to letter size (if pagesize indicator not found)
		noi di as error "Note: `pagesize' not a recognized papersize, defaulting to letter size"
		scalar width=8.5
		scalar height=11.0
	}
	
    
	if "`landscape'"=="" {
		return scalar pwidth=width
		return scalar pheight=height
	}
	else {
		return scalar pwidth=height
		return scalar pheight=width
	}
    
end
