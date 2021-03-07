//Need to create the final file for Nong
//This means pulling the CaseControl Long File, merging to the Resp and Blood info, and then making wide

program define createFinalEtiologyAnalysisFile
	syntax, [prepareFiles] [mergeRHIVENTV]
	
qui {

    if "`prepareFiles'" != "" {
        qui run "../stata_do_files/ANISA - Blood and NP-OP file preparation.do"
    }
    
	clear
	set more off
	
	//First, we need to refine the Blood File
	tempfile bloodTemp
	_refineBloodFile `bloodTemp'
	noi di as text "Anisa Blood File Processed"

	//Second, we need to refine the Resp File
	tempfile respTemp
	noi _refineRespFile `respTemp'
	noi di as text "Anisa Resp File Processed"

	//Third, we need to grab the CaseControl Long File, merge the blood and resp information, and swing wide
	tempfile finalTemp
	_incorporateCaseControl `bloodTemp' `respTemp' `finalTemp'
	noi di as text "Case Control Data Merged with Blood and Resp Information"
	noi count
	//Finally, we need to add child level static variables from Summary File
	_grabSummaryVariables
	noi di as text "Summary Variables Added"
	
	//October 17th, create indicator indicating Form 8 merge
	_grabForm8Indicator
	noi di as text "Form 8 Indicator Added"
	
	//Save and Exit
	noi _cleanUpAndSave, `mergeRHIVENTV'
	noi di as text "Final Analytic File (Temp) cleaned up and saved ...."
	noi di as text ""
	noi di as error "You must run the combined flowchart file to filter on enrollment and create final file"
}

end

program _refineBloodFile
	args bloodtempfile useAlternative
	use LabOutputFiles/AnisaBloodFile,clear

	//drop 7a variables not needed
	drop childID
	drop BQ201- BldRecDt
	drop ReceiveDt PutDate-OutDtTm

	//drop Blood Book variables not needed

	drop TTPHr-CulGent

	//drop more Blood Book variables
	drop Serotype- Citrate3

	//drop variables from TLDA
	drop BldForTLDA 
	rename BldTLDA hasBloodTLDA
	
	
	//drop wet chemistry CT values
	drop *_CT_*

	//Make Blood Culture Status variable
	gen bc_status = inlist(Result,1,2)==1
	label var bc_status "Blood Culture Done (0=No, 1=Yes)"
	label define yesno 0"No" 1"Yes"
	label values bc_status yesno

	//Make BC Result variable using TotPath variable as guide
	//First, this is "Negative" if TotPath == 0 OR TotPath is 1,2,3, but Final Decision is "Contaminant" or Missing
	gen bc_result = 0 if bc_status==1 &  (TotPath==0 | (inlist(TotPath,1,2,3)==1 & inlist(FinalDetermination,0,.)==1))
	//Second this is "Positive" if TotPath is 1,2,3, and Final Determination is Pathogen
	replace bc_result = 1 if bc_status==1 & inlist(TotPath,1,2,3)==1 & FinalDetermination==1
	//Third, clearly this must be positive if from BCC and FinalDeterminationation ==1
	replace bc_result = 1 if bc_status==1 & FinalDetermination == 1 & FinalDeterminationFrm==1
	label var bc_result "Blood Culture Result (0=Neg, 1=Pos)"
	label def bc_result 0"Negative" 1"Positive"
	label values bc_result bc_result

	
	//lets put bc_status and bc_result into this bc_org variable
	//can never overide bc_org if FinalDetermination from BCC
	replace bc_org = "Negative" if bc_result==0 & FinalDeterminationFrm!=1
	replace bc_org = "Not Done" if bc_status==0 & FinalDeterminationFrm!=1

	label var bloodID "Blood ID"
	label var bc_org "Blood Culture Organism(s)"

	
	label var hasBloodTLDA "Blood ID was matched to a TLDA entry"
	foreach var of varlist ECSH - URUP {
			label values `var' detect 
			*recode `var' 0=2
	}
	label define detect 0"Not Detected" 1"Detected"

	//Need to change ECSH_BTAC to WCEColiShigRe if WCEColiShig!=.
	
	preserve
		//get the WetChemistryFile
		use "../../Source Anisa Tables/AnisaWetChemistryResults.dta",clear
		keep if WetChTarget==1 //keeping the e.coil targets only
		keep if substr(SampleName,1,1)=="B"
		tempfile bloodEColiWetChem
		rename SampleName bloodID
		replace bloodID = substr(bloodID,1,6)
		save `bloodEColiWetChem', replace
	restore
	
	merge 1:1 bloodID using `bloodEColiWetChem', keep(1 3) keepusing(WetChResult)
	
	replace ECSH_BTAC = WetChResult if missing(WetChResult)==0 & _merge==3
	drop _merge WetChResult
	
	
	*replace ECSH_BTAC = WCEColiShigRe if inlist(WCEColiShigRe,1,2)==1
	//drop wet chemistry variables
	*drop WC*

	keep bloodID bc_status bc_result bc_org *_BTAC hasBloodTLDA FinalPathogen
	order bloodID bc_status bc_result FinalPathogen bc_org *_BTAC hasBloodTLDA

	//drop bc_status bc_result
	
	save LabOutputFiles/AnisaBloodFile_Etiology, replace
	save `bloodtempfile', replace

end

program _refineRespFile
	args resptempfile useAlternative
	use LabOutputFiles/AnisaRespFile
	
	

	drop childID SiteCode Q201-RespColl
	drop *_CT_*


	*set trace on
	foreach var of varlist ADEV-URUP {
		label values `var' detect
		*recode `var' 0=2
	}
	label define detect 0"Not Detected" 1"Detected"


	//Need to change RECSH_RC to WCEColiShigRe if WCEColiShig!=.
	
	preserve
		//get the WetChemistryFile
		use "../../Source Anisa Tables/AnisaWetChemistryResults.dta",clear
		keep if WetChTarget==1 //keeping the e.coil targets only
		keep if substr(SampleName,1,1)=="R"
		tempfile respEColiWetChem
		rename SampleName respID
		replace respID = substr(respID,1,6)
		save `respEColiWetChem', replace
	restore
	
	merge 1:1 respID using `respEColiWetChem', keep(1 3) keepusing(WetChResult)
	noi tab ECSH_RTAC, missing
	replace ECSH_RTAC = WetChResult if missing(WetChResult)==0 & _merge==3
	noi tab ECSH_RTAC,missing
	drop _merge WetChResult

	*replace ECSH_RTAC = WCEColiShigRe if missing(WCEColiShigRe)==0
	//Drop Wet Chemistry
	*drop WC*
	
	rename RespTLDA hasRespTLDA
	keep respID *_RTAC hasRespTLDA
	order respID *_RTAC hasRespTLDA

	
	save LabOutputFiles/AnisaRespFile_Etiology, replace
	save `resptempfile', replace
end


program _incorporateCaseControl
	args bloodtempfile resptempfile finaltempfile
	
	use "../CaseControlDefinition/CaseControlOutputFiles/CaseControlRows_long_overall.dta"

	duplicates drop bloodID if bloodID!="", force
	replace bloodID = substr(bloodID, 1,6)
	merge m:1 bloodID using `bloodtempfile', keep(1 3) gen(mergeToAnisaBlood)
	assert mergeToAnisaBlood == 3 if missing(bloodID)==0
	
	replace respID = substr(respID,1,6)
	merge m:1 respID using `resptempfile', keep(1 3) gen(mergeToAnisaResp)
	assert mergeToAnisaResp==3 if missing(respID)==0

	//Now flip out the wide cases

	preserve
		keep if rowStatus==2
		bysort childID psiEpisode (visitDate): gen measure=_n
		reshape wide visitDate ageAtVisit preClass phyClass bloodID respID csfID fastBreathing-post7_psi nosocomialExcl chwVisitPrior chwVisitW7 chwVisitPost chwSepsisW7 bc_status-mergeToAnisaResp, j(measure) i(childID psiEpisode site birthDate)
		foreach var of varlist visitDate1-chwSepsisW71 bc_status1-mergeToAnisaResp1 {
			local newname = substr("`var'",1,length("`var'")-1)
			rename `var' `newname'
		}
		tempfile wideCases
		save `wideCases', replace
	restore
	keep if rowStatus!=2
	order childID birthDate site psiEpisode
	append using `wideCases'
	order rowStatus bothCaseAndControl, after(psiEpisode)
	save `finaltempfile', replace
end


program _grabSummaryVariables

	merge m:1 childID using ../AnisaSummaryData, keep(1 3) keepusing(lastKnownVS ga deathDate ageAtLastKnownVS sex) gen (mergeToSummaryData)
	label var mergeToSummaryData "Merged to Anisa Summary Data"
	assert mergeToSummaryData==3
	drop mergeToSummaryData
/*
	merge m:1 childID using ../AnisaBabyData, keepusing(F3Q205) keep(1 3) gen(mergeToBabyData)
	label var mergeToBabyData "Merged to Anisa Baby Data"
	assert mergeToBabyData==3
	drop mergeToBabyData	
	rename F3Q205 sex
	label var sex "Sex"
	label drop lsex
	label define sex 1"Male" 2"Female"
	label values sex sex
*/

	preserve
		use ../AnisaPhyData, clear
		duplicates drop childID visitDate, force
		tempfile ucv
		save `ucv', replace
	restore
	merge 1:1 childID visitDate using `ucv', keep(1 3) keepusing(F6Q702 F6Q703 F6Q403a F6Q404a)
	drop _merge
	gen hospAssocVisit = 1 if F6Q702 == 1 & F6Q703==1
	replace hospAssocVisit = 2 if F6Q702 ==1 & F6Q703==2
	replace hospAssocVisit = 3 if F6Q702==2
	replace hospAssocVisit = 4 if F6Q702==3
	replace hospAssocVisit = 5 if hospAssoc==.
	label def hav 1"Admission Accepted" 2"Admission Refused" 3"Physician Referred" 4"Home Treatment Recommended" 5"No Physican Action"
	label values hospAsso hav
	label var hospAssocVisit "Phys recommend / Caretaker acceptance of admission?"
	rename hospAssocVisit hospRec
	
	//axillary temp
	rename F6Q403a axtemp1
	rename F6Q404a axtemp2

	/*May 2016 - do not convert to centigrade*/
	//convert to centigrade if in Sylhet or in India
	/*replace axtemp1 = (axtemp1-32)*5/9 if inlist(site, "1","5","6")==1 & axtemp1!=999.9
	replace axtemp2 = (axtemp2-32)*5/9 if inlist(site, "1","5","6")==1 & axtemp2!=999.9
	*/
	replace axtemp1=. if axtemp1==999.9
	replace axtemp2=. if axtemp2==999.9
	label var axtemp1 "First Axillary Temperature Reading"
	label var axtemp2 "Second Axillary Temperature Reading"
	rename axtemp1 axtempfirst
	rename axtemp2 axtempsecond
	


end

program _cleanUpAndSave
syntax, [mergeRHIVENTV]
qui {
	//lets clean up some labels
	foreach var of varlist visitDate-mergeToAnisaResp {
		local tl: variable label `var'
		label var `var'2 `"`tl' - 2nd"'
		label var `var'3 `"`tl' - 3rd"'
		*label var `var' `"`tl' - 1st"'
		rename `var' `var'1
	}
	
	//Now, we need some code to weed out multiple visits within an episode
	//a lot of this is manual coding
	noi _collapseOverVisits
	
	//Create some final indicators.
	
	//We need an indicator as to whether or not the child had any specimen and had a result on bc_org, or on any TAC variable
	gen hasBloodCultureResult = bloodID!="" & bc_org!="Not Done"
	label var hasBloodCultureResult "Child has blood culture result"
	label values hasBloodCultureResult yn
	
	egen hasBloodTACResult = anymatch(*BTAC), values(0 1)
	label var hasBloodTACResult "Child has any blood TAC result"
	replace hasBloodTACResult =  . if missing(bloodID)==1
	label values hasBloodTACResult yn
	
	egen hasRespTACResult = anymatch(*RTAC), values(0 1)
	label var hasRespTACResult "Child has any respiratory TAC result"
	replace hasRespTACResult = . if missing(respID)==1
	label values hasRespTACResult yn
	
	gen hasAnyTestResult = anySpecimen==1 & (hasBloodCultureResult==1 | hasBloodTACResult==1 | hasRespTACResult==1)
	label var hasAnyTestResult "Child one or more results for blood culture, blood TAC, or resp TAC"
	label values hasAnyTestResult yn
	
	//Lets get the blood collection date and the resp collection date
	merge m:1 bloodID using "LabOutputFiles/AnisaBloodFile.dta", keep(1 3) keepusing(BldColDt FinalDecision BCCReviewed reasonNotReviewed)
	gen contaminant  = reasonNotReviewed=="Definite Contamination" | (bc_result==0 & FinalDecision=="Definite Contaminant")
	replace bc_org="Neg (Contaminant)" if bc_org=="Negative" & contaminant==1
	replace bc_org="Neg (True)" if bc_org=="Negative" & contaminant!=1
	drop contaminant FinalDecision BCCReviewed reasonNotReviewed
	drop _merge
	merge m:1 respID using "LabOutputFiles/AnisaRespFile.dta", keep(1 3) keepusing(RespColDt)
	label var RespColDt "Date/Time of NP/OP Collection"
	drop _merge
	
	
	//Now, we need a variable for all those that died.. So, if vital status is "2", how many of these had a specimen within 7 days of death?
	//For this, we need date of death.
	gen specWithin7DaysOfDeath = lastKnownVS==2 & hours(deathDate - visitDate)<168 & deathDate>visitDate & deathDate!=. & anySpecimen==1
	replace specWithin7DaysOfDeath = . if lastKnownVS!=2
	label var specWithin "Was specimen collected within 7 days before death?"
	label values specWithin yn
	
	//Now, Melissa wants a variable that indicates the date of last phy confirmed PSBI
	egen double lastPhyConfirmedPSBI = max(visitDate) if rowStatus==2, by(childID)
	label var lastPhyConfirmedPSBI "Date/time of last physician confirmed PSBI"
	format %tc lastPhyConfirmedPSBI
	
	rename axtempfirst axtemp1
	rename axtempsecond axtemp2
	order axtemp1 axtemp2, after(hyperthermia)
	
	//Create final summary Case/Control Variable, that utilizes both preClass and Row Status
	gen AnisaCaseControl = 1 if rowStatus==2
	replace AnisaCaseControl = 0 if rowStatus==1 & preClass==2
	label var AnisaCaseControl "Final ANISA Case Control Status for this Assessment"
	label define acc 1"Case" 0"Control"
	label values AnisaCaseControl acc
	//put this variable is an appropriate place
	order AnisaCaseControl, after(site)
	
	//drop any unnecessary merge flags
	drop mergeToAnisaBlood
	drop mergeToAnisaResp

	//rename  site variable
	rename site SiteCode
	destring SiteCode, replace
	
	
	if "`mergeRHIVENTV'"!= "" {
	/***********************************************************************************************
	//October 24th, 2016
	//Based on extensive email discussions in October, we decided to merge the RHIV and ENTV results, because it is not possible for us to 
	//distinguish between these enteroviruses.  Therefore, we are doing the following:
	*/
	//1. Rename ENTV_BTAC as RHEN_BTAC
		rename ENTV_BTAC RHEN_BTAC
		label var RHEN_BTAC "Detected in Blood: Rhino/Enterovirus" 

	//2. Merging ENTV_RTAC and RHIV_RTAC
		rename ENTV_RTAC RHEN_RTAC
		replace RHEN_RTAC = RHIV_RTAC if RHIV_RTAC == 1
		replace RHEN_RTAC = RHIV_RTAC if RHIV_RTAC == 0 & RHEN_RTAC == .
		label var RHEN_RTAC "Detected in NP-OP: Rhino/Enterovirus" 
		drop RHIV_RTAC
	/************************************************************************************************/
	}
	
	//drop notes
	notes drop _dta
	notes drop _all
	
	//compress file
	compress
	saveold LabOutputFiles/FinalEtiologyAnalyticFileTemp, replace
}
end


program define _collapseOverVisits
qui {
	
	noi count if visitDate3!=.
	//First, we can drop all 3rd variables, if there are no respIDs or bloodIDs in these columns
	capture assert bloodID3=="" & respID3==""
	if _rc!=0 {
		//we have a problem
		noi di as error "Warning: there are data in respID3 and or bloodID3!!!
		exit
	}
	drop *3
	noi count if visitDate2!=.
	//Second, if both bloodID1 and respID1 is blank, but we have respID2 and/or bloodID2, then we will replace all the variables in 
	//visit1 with those values in visit2
	tempvar uniqID
	gen `uniqID' = _n
	noi levelsof `uniqID' if bloodID1=="" & respID1=="" & (bloodID2!="" | respID2!=""), local(myids)
	foreach myid of local myids {
		foreach var of varlist *1 {
			local stem = substr("`var'",1,length("`var'")-1)
			replace `var' = `stem'2 if `uniqID'==`myid'
			local vtype: type `var'
			if substr("`vtype'",1,3)=="str" replace `stem'2="" if `uniqID'==`myid'
			else				replace `stem'2=. if `uniqID'==`myid'
		}
	}

	//Third, of the remaining rows where we have more than one specimen in a row, there is only one case where we will prefer the 
	//second set bloodID over the first, and no cases where we prefer the 2nd respID over the first.. This special case is when bloodID1 == "B40886"
	
	levelsof `uniqID' if bloodID1!="B40886" & (bloodID2!="" | respID2!=""), local(myids)
	foreach myid of local myids {
		//now we just empty the *2 variables
		foreach var of varlist *2 {
			local vtype: type `var'
			if substr("`vtype'",1,3)=="str"	replace `var'="" if `uniqID'==`myid'
			else				replace `var'=. if `uniqID'==`myid'
		}
	}
	
	//Finally, we have our single special case, where we are going to keep the *1 values for respiratory, but replace the *1 values for blood with the *2 values
	noi list if bloodID1=="B40886"
	levelsof `uniqID' if bloodID1=="B40886", local(myids)
	foreach myid of local myids {
		//we empty the *2 variables that are respiratory
		foreach var of varlist respID2 *RTAC2 *Resp2 {
			local vtype: type `var'
			if substr("`vtype'",1,3)=="str" replace `var'="" if `uniqID'==`myid'
			else				replace `var'=. if `uniqID'==`myid'
		}
		//we replace the *1 blood values
		foreach var of varlist bloodID1 bc_org1-mergeToAnisaBlood1 {
			local stem = substr("`var'",1,length("`var'")-1)
			replace `var' = `stem'2 if `uniqID'==`myid'
			local vtype: type `var'
			if substr("`vtype'",1,3)=="str" replace `stem'2="" if `uniqID'==`myid'
			else				replace `stem'2=. if `uniqID'==`myid'
		}
	}

	assert bloodID2==""
	assert respID2==""
	*noi list childID rowStatus visitDate1 bloodID1 bc_org1 respID1 visitDate2 bloodID2 bc_org2 respID2 if bloodID2!="" | respID2!=""
	
	//Now, we have cleared all this information up, we can drop *2 variables
	drop *2
	//Lets drop the suffix from *1 variables
	renvars *1, postdrop(1)
	
}  //end quietly 
end

program _grabForm8Indicator


	preserve
	
		keep if rowStatus==2
		assert _N==6022
		tempfile casesonly
		save `casesonly', replace
	
		//Grab Form 8 identifier
		use "../../Source Anisa Tables/AnisaForm8.dta", clear
		gen childID = CountryCode + SiteCode + StudyId + ChildSl
		keep childID Q119
		tempfile admitID
		save `admitID', replace

		use `casesonly',clear
		
		gen visitDate_Day = dofc(visitDate)
		joinby childID using `admitID'

		//drop if the date of visit(Form 6) is before admission... can't be this form!!
		drop if visitDate_Day<Q119
		gen hospMatch = 0 if visitDate_Day == Q119
		forvalues i=1/5 {
			replace hospMatch = `i' if hospMatch ==. &  visitDate_Day == (Q119+`i')
		}
		keep childID visitDate hospMatch
		keep if hospMatch!=.
		duplicates report childID visitDate
		assert r(unique_value)==r(N)
		tempfile form8indicator
		save `form8indicator', replace
		
	restore
	merge 1:1 childID visitDate using `form8indicator', nogenerate
	label var hospMatch "Match Status with Hospital Admission Form (8)"
	replace hospMatch = hospMatch+1
	label def hM 1"Hosp Admission Form on Date of Episode" 2"Admission Form: 1 day after episode" 3"Admission Form: 2 days after episode" 4"Admission Form: 3 days after episode" 5"Admission Form: 4 days after episode" 6"Admission Form: 5 days after episode"
	label values hospMatch hM
	replace hospMatch = 0 if rowStatus==2 & hospMatch==.
	label def hM 0 "No Hosp Admission Form Matched to Episode", modify
	
	
	

end
