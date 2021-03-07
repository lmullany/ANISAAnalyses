//Program to create baby level flowchart
//Luke C. Mullany

program drawCombinedFlowchart
	syntax, [site(real 0)] [rerun] [india] [bangpak] [showReaNotReg]
	qui {
	
	//temporariliy add subfolder to ado path
	adopath + ".\flowchartCode"



	//keep if site is specified, otherwise
	capture assert inlist(`site',0, 1, 3, 4, 5, 6)==1
	if _rc!=0 {
		di as error "Site incorrectly specified, must be 1,3,4,5, or 6"
		exit
	}
	
	
	//preserve
		clear
		set more off
		//We need to rerun the do file to create the source, if rerun has been specified
		if "`rerun'"!= "" {
			qui run createPregnancyLevelFlowchart
			qui run createBabyLevelFlowchart
		}
		
		if inlist(`site',1,3,4,5,6)==1 {
			local titlestem " (Site: `site')"
		}
		else {
			local titlestem " (All Sites)"
		}
		
		//Next we need to grab the source file
		use ANISAPregLevelFlowchart, clear

		//We only need this one temporarily, so lets just limit to the selected site and 
		//do some counting

		if inlist(`site',1,3,4,5,6)==1 {
			keep if SiteCode==`site'
		}
		else {
			//check is india or non-india specified?
			if "`india'"!="" {
				keep if inlist(SiteCode,5,6)==1
			}
			else {
				if "`bangpak'"!="" {
					keep if inlist(SiteCode,1,3,4)==1
				}
			}
		}

		
		//Get total number of pregnancies that end during study
		qui keep if DelivStatus==1 
		local ctDelivStatus: di trim("`:di %-9.0gc `=_N''")
		qui count if OutKnown==0
		local ctLFU: di trim("`:di %-9.0gc `r(N)''")
		qui count if OutKnown==1
		local ctPregWithBirth: di trim("`:di %-9.0gc `r(N)''")
		keep if OutKnown==1
		
		//Now we have to count total births among these pregnancies
		//1. Total Livebirths - this equals TLB among LiveBirths==1 PLUS F2Q501 among those where LiveBirth==1 & Form3 Missing==1
		//We have a bunch of mothers that have TLB==0, but this is only because they refused on Form 3.. Here F2Q501=0, but F2Q503a==1, and F3Q131 = Refused
		//Wil for the purposes of the flowchart replace these TLB to 1
		replace TLB = 1 if TLB==0 & LiveBirths==1 & F2Q501==0 & F2Q503a==1
		qui sum TLB if LiveBirths==1
		local ct1 = r(sum)
		qui sum F2Q501 if LiveBirths==1 & Form3Missing==1
		local totalLiveBirths = r(sum) + `ct1'
		
		//2. Total Stillbirths - this equals TSB among otherOutcomes==1 PLUS TSB among those where LiveBirths==1 PLUS F2Q503b where Form3 is Missing
		sum TSB if otherOutcomes==1 | LiveBirths==1
		local ct1 = r(sum)
		sum F2Q501 if Form3Missing==1 & F2Q503b==1
		local totalStillBirths = r(sum) + `ct1'
		
		//3. Total Miscarriage - this equals count if otherOutcomes==2
		count if otherOutcomes==2
		local totalMiscarriage = r(N)
		
		local totBirths = `totalLiveBirths' + `totalStillBirths' + `totalMiscarriage'
		
		
		
		use ANISABabyLevelFlowchart,clear
		capture drop _merge
		//merge with AnisaSummaryData
		merge m:1 childID using ../AnisaSummaryData, keep(1 3)
		capture drop _merge
		
		if inlist(`site',1,3,4,5,6)==1 {
			keep if SiteCode==`site'
		}
		else {
			//check is india or non-india specified?
			if "`india'"!="" {
				keep if inlist(SiteCode,5,6)==1
			}
			else {
				if "`bangpak'"!="" {
					keep if inlist(SiteCode,1,3,4)==1
				}
			}
		}
	
		
		//start drawing Flowchart
		
		local cloc = 80
		local splitw = 40
		local splite_1 = 60
		local splite_2 = 100
		
		
		//Header Information
		mata: flowIns =	J(0,1,"")
		mata: flowIns = addFlowInstruction(flowIns,`" display as text _col(60) "{hi: ANISA Flowchart`titlestem'}" "')
		mata: flowIns = addFlowInstruction(flowIns,`" display as text "" "')
		mata: flowIns = addFlowInstruction(flowIns,`" di as text _newline "Pregnancy-Level Information  {hline}" "')
		
		//Number of pregnancies under surveillance
		mata: flowIns = addFlowInstruction(flowIns,`" drawFlowBox, boxes(1) locations(`cloc') content1(`""Number of Surveilled Pregnancies Ending During Study" "`ctDelivStatus'" "') "')

		//LFU - out to the right
		mata: flowIns = addFlowInstruction(flowIns,`" drawFlowBoxOutRight, armlengths(20) locations(`cloc') content1(`" "LFU / Died / Moved / Withdrew" "`ctLFU'" "') "')
		
		//Known outcomes (pregnancies) and Known Births
		local ct: di trim("`:di %-9.0gc `totBirths''")
		mata: flowIns = addFlowInstruction(flowIns,`" drawFlowBox, boxes(1) locations(`cloc') content1(`" "Pregnancies with Known Outcomes (`ctPregWithBirth')" "Total Births (`ct')" "') "')

		//Can we add a dotted line here?
		mata: flowIns = addFlowInstruction(flowIns,`" drawFlowLine, lengths(1) locations(`cloc') "')
		mata: flowIns = addFlowInstruction(flowIns,`" di as text _newline _continue "Baby-Level Information  {hline}" "')
		mata: flowIns = addFlowInstruction(flowIns,`" drawFlowLine, lengths(1) locations(`cloc') "')
		
		//Stillbirths and Miscarriages out to the right
		local cts: di trim("`:di %-9.0gc `totalStillBirths''")
		local ctm: di trim("`:di %-9.0gc `totalMiscarriage''")
		mata: flowIns = addFlowInstruction(flowIns,`" drawFlowBoxOutRight, armlengths(20) locations(`cloc') content1(`" "Stillbirths (`cts')" "Miscarriages (`ctm')" "') "')

		//Known outcomes (pregnancies) and Known Births
		local ct: di trim("`:di %-9.0gc `totalLiveBirths''")
		mata: flowIns = addFlowInstruction(flowIns,`" drawFlowBox, boxes(1) locations(`cloc') content1(`" "Live Births" "`ct'" "') "')

		replace Rea=6 if missingForm3==1
		replace Rea=7 if hasForm3==1 & refusedForm3==1 & inlist(motherID,"2609824","3331516")!=1
		label def ReaL 6 "No Form 3 Available" 7"Refused to Provide Registration Information", modify
		
		//Reasons for not registration
		qui count if (birthOutcome==1 & registration==0) | inlist(Rea,6,7)==1
		local ctn = r(N)
		local ctnr: di trim("`:di %-9.0gc `ctn''")
		if "`showReaNotReg'" != "" {
			_getContent Rea
			mata: flowIns = addFlowInstruction(flowIns,`" drawFlowBoxOutRight, armlengths(20) locations(`cloc') content1(`" "{hilite:Not Registered (n=`ctnr')}" `r(strRet)'"') "')
		}
		else {
			mata: flowIns = addFlowInstruction(flowIns,`" drawFlowBoxOutRight, armlengths(20) locations(`cloc') content1(`" "Not Registered (n=`ctnr')" "') "')
		}
		//Registered (middle)
		qui count if birthOutcome==1 & registration==1
		local testval = r(N)
		local ct: di trim("`:di %-9.0gc `testval''")
		mata: flowIns = addFlowInstruction(flowIns,`" drawFlowBox, boxes(1) locations(`cloc') content1(`" "Registered in Surveillance" "`ct'" "') "')
		

		capture assert `testval' == `totalLiveBirths'-`ctn'
		if _rc!=0 {
			noi di as error "WARNING - there is an error in the total number of birth, total live births, and total registered.. numbers don't add"
		}
		keep if birthOutcome==1 & registration==1
		
		//draw flowbox out right for no Physician Assessment
		
		qui count if missing(CaseCont)==1
		local ct1: di trim("`:di %-9.0gc `r(N)''")
		
		//Lets split these never assessed between those that were everReferred and those that were not
		
		//1. Never Referred
		qui count if missing(CaseCont)==1 & everReferred==0
		local ct1_a: di trim("`:di %-9.0gc `r(N)''")
		qui count if missing(CaseCont)==1 & everReferred==0 & lastKnownVS==2 & ageAtLastK<(60*24)
		local ct1_b: di trim("`:di %-9.0gc `r(N)''")
		
		//2. Ever Referred
		qui count if missing(CaseCont)==1 & everReferred==1
		local ct2_a: di trim("`:di %-9.0gc `r(N)''")
		qui count if missing(CaseCont)==1 & everReferred==1 & lastKnownVS==2 & ageAtLastK<(60*24)
		local ct2_b: di trim("`:di %-9.0gc `r(N)''")

		//mata: flowIns = addFlowInstruction(flowIns,`" drawFlowBoxOutRight, armlengths(20) locations(`cloc') content1(`" "Never Assessed by Physician (`ct1')" "Never Referred By CHW (`ct1_a')" "Referred By CHW (`ct2_a')"  "') "')
		mata: flowIns = addFlowInstruction(flowIns,`" drawFlowBoxOutRight, armlengths(20) locations(`cloc') content1(`" "Never Assessed by Physician (`ct1')" "Never Referred By CHW (`ct1_a')" " - Died: `ct1_b'" "Referred By CHW (`ct2_a')" " - Died: `ct2_b'"  "') "')

		
		//Defined by Algorithm
		qui count if missing(CaseCont)==0
		local ct1: di trim("`:di %-9.0gc `r(N)''")
		mata: flowIns = addFlowInstruction(flowIns,`" drawFlowBox, boxes(1) locations(`cloc') content1(`" "Assessed by Physician" "`ct1'" "') "')

		keep if missing(CaseCont)==0
		
		qui count if CaseCont==0
		local ct1: di trim("`:di %-9.0gc `r(N)''")
		//count how  many of these died
		qui count if CaseCont==0 & lastKnownVS==2 & ageAtLastK<(60*24)
		local ct2: di trim("`:di %-9.0gc `r(N)''")
		//count how  many of these "neither" rows have specimens!!\
		qui count if CaseCont==0 & ((bloodSpecimens!=. & bloodSpecimens>0) | (respSpecimens!=. & respSpecimens>0))
		local ct3: di trim("`:di %-9.0gc `r(N)''")
		mata: flowIns = addFlowInstruction(flowIns,`" drawFlowBoxOutRight, armlengths(20) locations(`cloc') content1(`" "Neither Case nor Possible Control (`ct1')" "') "')
		
		
		//Ever Case, Cont, Both status
	
		qui count if CaseCont==1
		local ct1_1: di trim("`:di %-9.0gc `r(N)''")
		qui count if CaseCont==3
		local ct1_2: di trim("`:di %-9.0gc `r(N)''")
		qui count if CaseCont==2
		local ct1_3: di trim("`:di %-9.0gc `r(N)''")

		**Uncomment the below three lines, if we want to see the split at the child level for case and non-case, etc.
		
/*	
		mata: flowIns = addFlowInstruction(flowIns, `" drawFlowSplitLines, locations(`=`cloc'-`splitw'' `cloc' `=`cloc'+`splitw'') middle(`cloc') depth(2) "')
		mata: flowIns = addFlowInstruction(flowIns, `" drawFlowBox, boxes(3) locations(`=`cloc'-`splitw'' `cloc' `=`cloc'+`splitw'') content1(`" "Non-Case Row" "`ct1_1'" "') content2(`" "Both Case and Non-Case Rows" "`ct1_2'" "') content3(`" "Case Row(s)" "`ct1_3'" "') "')
		mata: flowIns = addFlowInstruction(flowIns, `" drawFlowSplitLinesDouble, locations1(`=`cloc'-`splitw'' `cloc') middle1(`=`cloc'-`=`splitw'/2'') locations2(`cloc' `=`cloc'+`splitw'') middle2(`=`cloc'+`=`splitw'/2'')  direction(B) depth(1) "')
*/
		
		//Can we add a dotted line here?
		mata: flowIns = addFlowInstruction(flowIns,`" di as text _newline _continue "Case/Control Information  {hline}" "')
		mata: flowIns = addFlowInstruction(flowIns,`" drawFlowLine, lengths(1 1) locations(`=`cloc'-`=`splitw'/2'' `=`cloc'+`=`splitw'/2'') "')

		//saveoldoldold tempFlow, replace
		//Now, we are going to get some information from the Case Control Status
		
		//Updated! - August 11th, 2015 - I will now use the final Etiology File
		
		merge 1:m childID using "../Lab Working File/LabOutputFiles/FinalEtiologyAnalyticFileTemp.dta", keep(1 2 3)
		preserve 
			keep if _merge==2
			keep childID visitDate
			tempfile removeFromEtiology
			saveold `removeFromEtiology', replace
		restore
		drop if _merge==2
		keep if rowStatus!=0
		
		qui count if rowStatus==1
		local ct1: di trim("`:di %-9.0gc `r(N)''")
		qui count if rowStatus==2
		local ct2: di trim("`:di %-9.0gc `r(N)''")
		mata: flowIns = addFlowInstruction(flowIns,`" drawFlowBox, boxes(2) locations(`=`cloc'-`=`splitw'/2'' `=`cloc'+`=`splitw'/2'') content1(`" "Meets Control Definition" "`ct1'" "') content2(`" "Meets Case Definition" "`ct2'" "') "')


		//draw flowboxes out for non cases that are not SMS selected
		
		qui count if rowStatus==1 & preClass!=2
		local ct1: di trim("`:di %-9.0gc `r(N)''")
		//no need to count anything for cases (ie. for rowStatus==2)
		mata: flowIns = addFlowInstruction(flowIns,`" drawFlowBoxOut `" "Not pre-Selected as Control" "`ct1'" "' `splite_1' `" "N/A" "0" "' `splite_2' both 10 "')

		drop if rowStatus==1 & preClass!=2
		
		qui count if rowStatus==1
		local ct1: di trim("`:di %-9.0gc `r(N)''")
		qui count if rowStatus==2
		local ct2: di trim("`:di %-9.0gc `r(N)''")
		mata: flowIns = addFlowInstruction(flowIns,`" drawFlowBox, boxes(2) locations(`=`cloc'-`=`splitw'/2'' `=`cloc'+`=`splitw'/2'') content1(`" "Pre-Selected Controls" "`ct1'" "') content2(`" "Case Episodes" "`ct2'" "') "')
		
	
		//draw flowboxes out (Right and Left) for no Specimen
		
		qui count if rowStatus==1 & anySpecimen==0
		local ct1: di trim("`:di %-9.0gc `r(N)''")
		qui count if rowStatus==2 & anySpecimen==0
		local ct2: di trim("`:di %-9.0gc `r(N)''")
		mata: flowIns = addFlowInstruction(flowIns,`" drawFlowBoxOut `" "No Specimen Collected" "`ct1'" "' `splite_1' `" "No Specimen Collected" "`ct2'" "' `splite_2' both 10 "')

		qui count if rowStatus==1 & anySpecimen==1
		local ct1 = r(N)
		local ct1_s: di trim("`:di %-9.0gc `ct1''")
		qui count if rowStatus==2 & anySpecimen==1
		local ct2 = r(N)
		local ct2_s: di trim("`:di %-9.0gc `ct2''")
		
		mata: flowIns = addFlowInstruction(flowIns,`" drawFlowBox, boxes(2) locations(`splite_1' `splite_2') content1(`" "Controls with Specimens" "`ct1_s'" "') content2(`" "Case Episodes with Specimens" "`ct2_s'" "') "')
		
		//Mid-August 2015 - now have the actual etiology file result - so this is real data
		qui count if rowStatus==1 & hasRespTACResult==1
		local ctrt1: di trim("`:di %-9.0gc `r(N)''")
		qui count if rowStatus==1 & hasBloodTACResult==1
		local ctbt1: di trim("`:di %-9.0gc `r(N)''")
		qui count if rowStatus==1 & hasBloodCultureResult==1
		local ctbc1: di trim("`:di %-9.0gc `r(N)''")


		qui count if rowStatus==2 & hasRespTACResult==1
		local ctrt2: di trim("`:di %-9.0gc `r(N)''")
		qui count if rowStatus==2 & hasBloodTACResult==1
		local ctbt2: di trim("`:di %-9.0gc `r(N)''")
		qui count if rowStatus==2 & hasBloodCultureResult==1
		local ctbc2: di trim("`:di %-9.0gc `r(N)''")
		
		mata: flowIns = addFlowInstruction(flowIns, `" drawFlowLine, lengths(2 2) locations(`splite_1' `splite_2') "')
		mata: flowIns = addFlowInstruction(flowIns,`" drawFlowBox, boxes(2) locations(`splite_1' `splite_2') content1(`" "Resp TAC Results: `ctrt1'" "Blood TAC Results: `ctbt1'" "Blood Cx Results: `ctbc1'" "') content2(`" "Resp TAC Results: `ctrt2'" "Blood TAC Results: `ctbt2'" "Blood Cx Results: `ctbc2'" "') "')
		

		//Print Flowchart to Screen
		noi mata: printFlowChart(flowIns)
		
		//Lets quietly split EtiologyFile into two..
		clear
		use `removeFromEtiology'
		
		merge 1:1 childID visitDate using "../Lab Working File/LabOutputFiles/FinalEtiologyAnalyticFileTemp.dta"
		assert inlist(_merge,2,3)
		//if _merge==1, then we need to remove these from FinalEtiologyFile, right?
		preserve
			keep if _merge==2
			drop _merge
			saveold "../Lab Working File/LabOutputFiles/FinalEtiologyAnalyticFile.dta", replace
		restore
		preserve
			keep if _merge==3
			drop _merge
			saveold "../Lab Working File/LabOutputFiles/FinalEtiologyAnalyticFile_Removed.dta", replace
		restore


		//Remove from ado path
		adopath - ".\flowchartCode"

	}	
end


program _getContent, rclass
	version 12.0
	syntax varlist (max=1 min=1 numeric)
	qui {
		levelsof `varlist', local(mylocallist)
		foreach num of local mylocallist {
			local thislabel:label (`varlist') `num'
			qui count if `varlist'==`num'
			local ct: di rtrim(ltrim("`:di %9.0gc `r(N)''"))
			local strRet `"`strRet'"`thislabel'=`ct'" "'
		}
		return local strRet "`strRet'"
	}
end

