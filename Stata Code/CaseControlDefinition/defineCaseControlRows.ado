
//STATA program to define case and control rows
//Luke C. Mullany - First Version: November 7-8th, 2013

/*********************UPDATE**************************
Date of Update - June 2014
Added indicator for inclusion in mainStudy (i.e. relative to pilot)
*****************************************************/

/*********************UPDATE**************************
Date of Update - November 2014
Major Update:
-	The algorithm has been updated to also check for CHW
	screening data in the 7 days after Physician Screening
	A row is ineligible to be a control row if in the 7
	days after physician screening, a chw visit was conducted
	and the CHW referred the child for sepsis screening
	
	Note, this functionality is now default, but can be
	removed by including the keyword "ignoreCHWAssessment"
	in the command line when the command is called
*****************************************************/


/*********************UPDATE**************************
Date of Update - January 2015
Minor Update
-	The algorithm has been updated to check for any 
	duplicates in childID and visitDate. If these
	exists, these rows are dropped from the analysis (As of 
	January 15th, 2015, there was one baby that had
	two rows on the same date)
	
-	The algorithm now includes a keyword "includeNonSpecimens"
	which allows for evaluating the algorithm on the entire
	dataset. The use of this keyword will result in the
	algorithm NOT dropping rows that do NOT have a 
	specimen. When this keyword is included, the resulting
	long and wide files are saved with a stem "_overall" to
	distinguish them from the files saved under the default
	behavior. The use of this keyword has the potential
	to change the rowStatus of rows that do have specimens
	
*****************************************************/

/*********************UPDATE**************************
Date of Update - May 2015
Minor Update
-	The algorithm has been updated to add an indicator
	variable that tells whether a baby serves as both 
	a case and control (must be case after control)
-   Tables are created that save reason for being dropped
*****************************************************/


/*********************UPDATE**************************
Date of Update - May 19th, 2015
Major Update
-	There are blood and respID in 7a and 7b that do not
	match to Form 6.. These are then not appearing in 
	the Case Control Rows output.  A keyword "updateIDs"
	has been added to this algorithm. If this keyword
	is specified, a do file will be called that pulls 
	in these orphaned IDs, using the secondary merge
	method (childID and collection date on childID and visitDate)
	
*****************************************************/


/*********************UPDATE**************************
Date of Update - June 9th, 2015
Major Update
-	Make the default to exclude fast breath only from
	all sites
*****************************************************/

/*********************UPDATE**************************
Date of Update - June 9th, 2015
Minor Update
-	uses saveold keyword to save all datasets in Stata 13 version
*****************************************************/

/*********************UPDATE**************************
Date of Update - August 26, 2015
CORRECTION
-	THERE WAS AN ERROR IN NOSOCOMIAL EXCLUSION, WHEREBY BABIES WHOSE DISCHARGED OCCURRED AFTER ASSESSMENT WERE BEING EXCLUDED!!
*****************************************************/

/*********************UPDATE**************************
Date of Update - August 31, 2015
Major Updates
-	After presenting the algorithm to the broad site groups, and external colleagues, there was a suggestion that the noso
	comial exclusion should be apply to both controls and cases. This has now being added as an optional behavior, using the
	keyword "applyNosoToControls"
	
-	We decided to override the nosocomial exlcusion completley.  The algorithm can be run with the keyword applyNoso
	in order to apply this algorithm to cases.
 	
*****************************************************/

/*********************UPDATE**************************
Date of Update - May 12th, 2016
Minor Update
-	Removed the "updateIDs" keyword, thus the ability
	to match orphaned rows from Form 6 to Lab 7a, 7b
	is no longer provided. (See May 19, 2015 update
	for more information)
	
*****************************************************/

/*********************UPDATE**************************
Date of Update - May 13th, 2016
Minor Update
-	Updated some value labels for completeness
-  	cleared the resulting files of any _dta notes
*****************************************************/

/*********************UPDATE**************************
Date of Update - May 17th, 2016
Minor Update
-	Removed the temperature scale adjustment (i.e. C vs F)
	because it has already been done in the raw Form 6
*****************************************************/


/*********************UPDATE**************************
Date of Update - May 20th, 2016
Minor Update
-	Corrected an issue where the error reporting was
	including dropped_* files, even if they had not
	been updated!
*****************************************************/


/*********************UPDATE**************************
Date of Update - Sep 2, 2016
Major Update
-	Include some hard coding to move some neither bloodID and respID to a different row
	for some children. The hard coding is executed within its own small
	program (_manuallyCorrectSpecimens)
*****************************************************/

/*********************UPDATE**************************
Date of Update - Sep 6, 2016
Major Update
-	Added another exclusion criteria for control rows. A row
	cannot be a control row if the child dies within 7
	days of the visit
*****************************************************/


/*****************************************************
Main Program
*****************************************************/

program define defineCaseControlRows
	syntax, [ignoreCHWAssessment] [includeNonSpecimens] [applyNosoToControls] [applyNoso]

quietly {

	if "`applyNosoToControls'"!="" & "`applyNoso'"=="" {
		di as error "Cannot apply Noso Exclusion to Controls, because applyNoso option has not been supplied"
		exit
	}

	//set up
		dccr_setup
	
	//grab the needed source files and merge
		dccr_fileInput 
	
	//create PSI definition related variables
		dccr_psiDefinitions
		
	//prepare other required variables, and shrink dataset to only required
		dccr_prepareDataSet
		
	// generate indicator variables
		dccr_IndicatorVars, `applyNoso'
		
	if "`ignoreCHWAssessment'"=="" {
	//get additional indicator variables on CHW Visits before and after this Physician Visit
		dccr_getCHWVisitInformation
	}

	//drop any rows without specimens
	if "`includeNonSpecimens'"=="" {
		count if any==0
		if r(N)>0 {
			noi di as error "Warning: dropping `r(N)' rows because they do not have any associated specimen (i.e. this row did not lead to specimen collection)"
		}
		drop if any==0
		drop any
	}

	
	//Define control rows
		dccr_defineControlRows, `ignoreCHWAssessment' `applyNosoToControls'
		
	//Define case rows, and make indicator for multiple rows
		dccr_defineCaseRows, `applyNoso'
		
	//Clean up and save wide and long versions of file
		dccr_cleanUp, `ignoreCHWAssessment' `includeNonSpecimens'
		
	//Create Summary Error File
		dccr_errorSummary, `ignoreCHWAssessment' `includeNonSpecimens'


} //end quietly	
end

/*****************************************************
Set up STATA
*****************************************************/
program dccr_setup
	clear
	clear mata
	set more off

	*May 20th, 2016
	*clear any previous error files
	foreach mf of local myfiles {
		rm `"`mf'"'
	}
end


/*****************************************************
get the source files
*****************************************************/
program dccr_fileInput
	syntax
	//grab the appropriate AnisaPhyFile
	
	use ../AnisaPhyData.dta, clear
	count
	
	
	//Manual correction (See above for update September 2nd, 2016)
	//_manuallyCorrectSpecimens
	
	
	noi di as error "There are `r(N)' rows from From 6"
	
	//lets drop if childID visitDate is not unique
	duplicates tag childID visitDate, gen(dup)
	capture assert dup==0
	if _rc!=0 {
		count if dup!=0
		noi di as error "Warning: dropping `r(N)' rows from Form 6 because childID visitDate is not unique
		noi list childID visitDate if dup!=0, clean noobs sepby(childID)
		preserve
			keep if dup!=0
			keep childID visitDate
			gen errorType=1
			save dropped_childVisitDateNotUnique, replace
		restore
		drop if dup!=0
		
	}
	drop dup
		
	

	//grab information about child
	merge m:1 childID using ../AnisaSummaryData, keepusing(birthDate mainStudy deathDate ageAtLastKnownVS) keep(1 3)
	count if _merge==1
	if r(N)>0 {
		noi di as error "Warning: dropping `r(N)' rows from Form 6 that do not belong to a matching child in Summary File"
		preserve
			keep if _merge==1
			keep childID visitDate
			gen errorType=2
			save dropped_Form6RowNotInSummary, replace
		restore
		drop if _merge==1
	}
	drop _merge
	
	//grab information about facility birth (From Mother Data File)
	gen motherID = substr(childID,1,length(childID)-1)
	merge m:1 motherID using ../AnisaMotherData, keepusing(F2Q504 F2Q505D F2Q505H) keep(1 3)
	count if _merge==1
	if r(N)>0 {
		noi di as error "Warning: dropping `r(N)' rows from Form 6 that do not have a corresponding mother in the MotherDataFile"
		preserve
			keep if _merge==1
			keep childID visitDate
			gen errorType=3
			save dropped_NoMotherinMotherFile, replace
		restore
		drop if _merge==1
	}
	
	//gen facility birth
	gen facility = inlist(F2Q504,2,3,4,5)
	label var facility "Child was born in a facility"
	
	//gen age at discharge, for facility births
	gen ageDischarge=F2Q505D*24+F2Q505H
	replace ageDischarge=. if facility!=1
	label var ageDischarge "Age at discharge (hours) from facility after birth; for facility births only"
	

	//gen ageAtVisit
	gen ageAtVisit = hours(visitDate-birthDate)
	label var ageAtVisit "Age at visit in hours"
	
	//gen hoursSinceDischarge, for facility births that stayed more than 48 hours
	//	We are going to use this variable to exclude from cases any row
	//  that occurs within 96 hours of postfacility discharage (if the baby was at least 2 days old when
	// 	originally discharge from facility after birth in that facility
	
	gen hoursSinceDischarge = ageAtVisit - ageDischarge if ageDischarge>=48 & missing(ageDischarge)==0 & ageAtVisit>ageDischarge
	assert hoursSinceDischarge==. if missing(ageAtVisit)==1
	label var hoursSinceDischarge "Hours since postnatal facility discharge"
	
	//generate if child died within infant period
	gen died = deathDate!=. & ageAtLastKnownVS < (24*60)
	label var died "Baby died prior to reaching 60 days of age"
	

	
	count if mainStudy!=1
	local notmain=r(N)
	if `notmain'>0 {
		count if mainStudy==0
		local pilot=r(N)
		count if mainStudy==2
		local missdob=r(N)
		noi di as error "Warning: Dropping `notmain' rows in Form 6 because these were collected during pilot period (`pilot') or missing dob (`missdob')"
	}
	preserve
		keep if mainStudy!=1
		keep childID visitDate
		gen errorType=4
		saveold dropped_NotInMainStudyORNotDOB, replace
	restore
	keep if mainStudy==1
	
	//drop if age at visit is greater than 59 days
	count if ageAtVisit>=60*24
	noi di as error "Warning: dropping `r(N)' rows where the age at visit is >=60 days"
	preserve
		keep if ageAtVisit>=60*24
		keep childID visitDate
		gen errorType=5
		saveold dropped_BabyOver60DaysAtVisit, replace
	restore
	drop if ageAtVisit>=60*24
	

	
end


program _manuallyCorrectSpecimens
	//In this section, there are some children who are cases, but who don't have a specimen on the 
	//date of their case assessment, but do have a specimen on a subsequent assessment within 7
	//days. We are taking the specimen information from that subsequent asessment...


	replace bloodID = "" if childID == "11015051" & visitDate == tc(03dec2013 12:30:00)
	replace bloodID = "B12245-FORM" if childID == "11015051" & visitDate == tc(06dec2013 19:00:00)
	replace bloodID = "" if childID == "11057291" & visitDate == tc(20jun2013 12:55:00)
	replace bloodID = "B13606-FORM" if childID == "11057291" & visitDate == tc(23jun2013 13:30:00)
	replace bloodID = "" if childID == "11139541" & visitDate == tc(11jan2012 14:05:00)
	replace bloodID = "B10209-FORM" if childID == "11139541" & visitDate == tc(16jan2012 12:54:00)
	replace bloodID = "" if childID == "11140881" & visitDate == tc(12oct2012 17:30:00)
	replace bloodID = "B11495-FORM" if childID == "11140881" & visitDate == tc(18oct2012 13:50:00)
	replace bloodID = "" if childID == "11184701" & visitDate == tc(03may2012 19:00:00)
	replace bloodID = "B10444-FORM" if childID == "11184701" & visitDate == tc(07may2012 17:10:00)
	replace bloodID = "" if childID == "11193161" & visitDate == tc(11nov2012 13:00:00)
	replace bloodID = "B10038-FORM" if childID == "11193161" & visitDate == tc(12nov2012 14:30:00)
	replace bloodID = "" if childID == "11226681" & visitDate == tc(07sep2012 13:05:00)
	replace bloodID = "B11387-FORM" if childID == "11226681" & visitDate == tc(08sep2012 16:00:00)
	replace bloodID = "" if childID == "11258541" & visitDate == tc(05oct2013 12:15:00)
	replace bloodID = "B13120-FORM" if childID == "11258541" & visitDate == tc(12oct2013 11:10:00)
	replace bloodID = "" if childID == "11271771" & visitDate == tc(21jul2013 13:40:00)
	replace bloodID = "B13671-FORM" if childID == "11271771" & visitDate == tc(24jul2013 15:16:00)
	replace bloodID = "" if childID == "11289721" & visitDate == tc(20aug2013 14:20:00)
	replace bloodID = "B13295-FORM" if childID == "11289721" & visitDate == tc(22aug2013 15:15:00)
	replace bloodID = "" if childID == "11298671" & visitDate == tc(24nov2013 13:40:00)
	replace bloodID = "B13198-FORM" if childID == "11298671" & visitDate == tc(30nov2013 12:20:00)
	replace bloodID = "" if childID == "11306261" & visitDate == tc(14oct2013 10:20:00)
	replace bloodID = "B12779-FORM" if childID == "11306261" & visitDate == tc(16oct2013 16:52:00)
	replace bloodID = "" if childID == "33307751" & visitDate == tc(22sep2012 12:45:00)
	replace bloodID = "B30888-FORM" if childID == "33307751" & visitDate == tc(25sep2012 11:55:00)
	replace bloodID = "" if childID == "33333201" & visitDate == tc(01jul2013 11:45:00)
	replace bloodID = "B32246-FORM" if childID == "33333201" & visitDate == tc(04jul2013 13:25:00)
	replace bloodID = "" if childID == "33409511" & visitDate == tc(10oct2012 12:45:00)
	replace bloodID = "B30549-FORM" if childID == "33409511" & visitDate == tc(12oct2012 12:00:00)
	replace bloodID = "" if childID == "33430221" & visitDate == tc(10oct2013 12:45:00)
	replace bloodID = "B32327-FORM" if childID == "33430221" & visitDate == tc(12oct2013 15:30:00)
	replace bloodID = "" if childID == "33531231" & visitDate == tc(08oct2013 11:48:00)
	replace bloodID = "B31698-FORM" if childID == "33531231" & visitDate == tc(10oct2013 14:15:00)
	replace bloodID = "" if childID == "34306631" & visitDate == tc(22mar2012 10:25:00)
	replace bloodID = "B40521-FORM" if childID == "34306631" & visitDate == tc(27mar2012 10:45:00)
	replace bloodID = "" if childID == "11006971" & visitDate == tc(03sep2012 12:35:00)
	replace bloodID = "B11358-FORM" if childID == "11006971" & visitDate == tc(05sep2012 13:45:00)


	replace respID = "" if childID == "11015051" & visitDate == tc(03dec2013 12:30:00)
	replace respID = "R12816-FORM" if childID == "11015051" & visitDate == tc(06dec2013 19:00:00)
	replace respID = "" if childID == "11057291" & visitDate == tc(20jun2013 12:55:00)
	replace respID = "R13914-FORM" if childID == "11057291" & visitDate == tc(23jun2013 13:30:00)
	replace respID = "" if childID == "11139541" & visitDate == tc(11jan2012 14:05:00)
	replace respID = "R11207-FORM" if childID == "11139541" & visitDate == tc(16jan2012 12:54:00)
	replace respID = "" if childID == "11140881" & visitDate == tc(12oct2012 17:30:00)
	replace respID = "R11524-FORM" if childID == "11140881" & visitDate == tc(18oct2012 13:50:00)
	replace respID = "" if childID == "11184701" & visitDate == tc(03may2012 19:00:00)
	replace respID = "R10729-FORM" if childID == "11184701" & visitDate == tc(07may2012 17:10:00)
	replace respID = "" if childID == "11192661" & visitDate == tc(03nov2012 12:50:00)
	replace respID = "R10061-FORM" if childID == "11192661" & visitDate == tc(04nov2012 14:09:00)
	replace respID = "" if childID == "11226681" & visitDate == tc(07sep2012 13:05:00)
	replace respID = "R10596-FORM" if childID == "11226681" & visitDate == tc(08sep2012 16:00:00)
	replace respID = "" if childID == "11258541" & visitDate == tc(05oct2013 12:15:00)
	replace respID = "R12044-FORM" if childID == "11258541" & visitDate == tc(12oct2013 11:10:00)
	replace respID = "" if childID == "11271771" & visitDate == tc(21jul2013 13:40:00)
	replace respID = "R13982-FORM" if childID == "11271771" & visitDate == tc(24jul2013 15:16:00)
	replace respID = "" if childID == "11289721" & visitDate == tc(20aug2013 14:20:00)
	replace respID = "R13511-FORM" if childID == "11289721" & visitDate == tc(22aug2013 15:15:00)
	replace respID = "" if childID == "11298671" & visitDate == tc(24nov2013 13:40:00)
	replace respID = "R13642-FORM" if childID == "11298671" & visitDate == tc(30nov2013 12:20:00)
	replace respID = "" if childID == "33307751" & visitDate == tc(22sep2012 12:45:00)
	replace respID = "R30892-FORM" if childID == "33307751" & visitDate == tc(25sep2012 11:55:00)
	replace respID = "" if childID == "33333201" & visitDate == tc(01jul2013 11:45:00)
	replace respID = "R32246-FORM" if childID == "33333201" & visitDate == tc(04jul2013 13:25:00)
	replace respID = "" if childID == "33409511" & visitDate == tc(10oct2012 12:45:00)
	replace respID = "R30394-FORM" if childID == "33409511" & visitDate == tc(12oct2012 12:00:00)
	replace respID = "" if childID == "33430221" & visitDate == tc(10oct2013 12:45:00)
	replace respID = "R32368-FORM" if childID == "33430221" & visitDate == tc(12oct2013 15:30:00)
	replace respID = "" if childID == "33531231" & visitDate == tc(08oct2013 11:48:00)
	replace respID = "R31817-FORM" if childID == "33531231" & visitDate == tc(10oct2013 14:15:00)
	replace respID = "" if childID == "34306631" & visitDate == tc(22mar2012 10:25:00)
	replace respID = "R40452-FORM" if childID == "34306631" & visitDate == tc(27mar2012 10:45:00)
	replace respID = "R10565-FORM" if childID == "11006971" & visitDate == tc(05sep2012 13:45:00)
	replace respID = "" if childID == "11006971" & visitDate == tc(03sep2012 12:35:00)

end


/*****************************************************
generate the variables needed to define PSI on any day
*****************************************************/
program dccr_psiDefinitions

	//respiratory rate
	rename F6Q401a respr1
	rename F6Q401b respr2

	gen fastBreathing = respr1>=60 & respr1!=. & respr2>=60 & respr2!=.
	label var fastBreathing "Two measures greater than 60 per minute"

	//severe chest indrawing
	rename F6Q402 chestIndr
	label var chestIndr "Chest Indrawing"
	recode chestIndr 2=0

	//axillary temp
	rename F6Q403a axtemp1
	rename F6Q404a axtemp2

	replace axtemp1=. if axtemp1==999.9
	replace axtemp2=. if axtemp2==999.9

	//hypothermia
	gen hypothermia = axtemp1<95.9 & axtemp2<95.9
	label var hypothermia "Hypothermia (<35.5, 95.9)

	//hyperthermia
	gen hyperthermia = axtemp1>=100.4 & axtemp1!=. & axtemp2>=100.4 & axtemp2!=.
	label var hyperthermia "Hyperthermia (>=38.0, 100.4)

	//level of consciousness
	gen lethargic = inlist(F6Q405a,2,3)
	label var lethargic "No movement or only when stimulated"

	//convulsions
	gen convulsions = inlist(F6Q406a,1,2)
	label var convulsions "Reported or observed convulsions"

	//poor feeding
	gen poorFeeding = F6Q407==1
	label var poorFeeding "Poor feeding even after assistance"
	
	
end

/*****************************************************
Use to label yes/no variables
*****************************************************/
program dccr_labelyn
	syntax varlist
	capture label drop yn
	label define yn 0"No" 1"Yes", modify
	foreach var of local varlist {
		label values `var' yn
	}
end

/*****************************************************
Prepare the dataset for generating case/control rows
*****************************************************/
program dccr_prepareDataSet

	keep childID mainStudy visitDate birthDate ageAtVisit AssType F6Q120 bloodID respID csfID F6Q501 ///
			poorFeeding convulsions lethargic hyperthermia hypothermia chestIndr fastBreathing ///
			facility ageDischarge hoursSinceDischarge died deathDate

	//get a site variable
	gen site = substr(childID,2,1)
	label var site "Site Code"

	//clean up the specimen label variables
	label var bloodID "Blood specimen label"
	label var respID "Resp specimen label"
	label var csfID "CSF specimen label"
	
	//generate indicator variable for if this row has any specimen or not
	gen anySpecimen = missing(bloodID)==0 | missing(respID)==0 | missing(csfID)==0
	label var anySpecimen "Visit resulted in >=1 specimens"

	//clean up the pre assessment (i.e. upon presentation to clinic) and the post-assessment (i.e. after physician) classification variables
	rename AssType preClass
	label var preClass "Presenting (i.e. pre-assessment) classification"
	destring preClass, replace
	label def preCl 1"Case" 2"Control" 3"2nd Blood Collection"
	label values preClass preCl
	rename F6Q120 phyClass
	label var phyClass "Physcian classification as sepsis/control/neither - F6Q120"

end

/*****************************************************
Generate the indicators variables for prior/post PSI and
hospitalitzation
*****************************************************/
program dccr_IndicatorVars
	syntax, [applyNoso]

	//generate indicator variables
	//we have the following that need to be created
	//	1. Did the child meet the PSI definition on this visit?
		gen psi = fastBreathing==1 | chestIndr ==1 | hypothermia==1 | hyperthermia==1 | lethargic==1 | convulsions==1 | poorFeeding==1
		label var psi "Probable severe infection definition met"
	
		gen fastBreathOnly = fastBreathing==1 & inlist(1, chestIndr, hypothermia, hyperthermia, lethargic, convulsions, poorFeeding)==0
		label var fastBreathOnly "Met PSI / fast breathing was only sign (Not a case in Karachi)"


	//	2. Did the child meet the PSI definition within seven days prior to this visit?
	// 	3. Did the child meet the PSI definition within seven days after this visit?
	
		destring childID, gen(id)
		mata: prePostPSIIndicators()
		drop id
		
		gen prior7_psi = hours(visitDate-prior)<=168
		label var prior7_psi "Indicator: Classified as PSI within prior 7 days"
		gen post7_psi = hours(post-visitDate)<=168
		label var post7_psi "Indicator: Classified as PSI within the post 7 days"
		drop prior post
		
		
	//	4. Was the child hospitalized in the past seven days
		rename F6Q501 prior7_hosp
		recode prior7_hosp 2=0
		label var prior7_hosp "Indicator: Hospitalized within last 7 days"
		
	//  5. Was the child born in a hospital, stayed for more than 2 days, and is being assessed within 96 hours of that discharge?
	//			OR, born in hospital, being assessed after 48hrs of age, and not yet discharged
		gen nosocomialExcl = facility==1 & (ageDischarge>=48 & ageDischarge!=.) & hoursSinceDischarge<96.0
		replace nosocomialExcl = 1 if nosocomialExcl==0 & facility==1 & ageAtVisit>=48 & ageAtVisit!=. & ageAtVisit<ageDischarge & ageDischarge!=.
		label var noso "Hospital born with >2d stay, assessed within  4 days"
		
		//If don't applyNoso, we can replace all of these to zero
		//if "`applyNoso'"=="" replace noso=0
		
	//  6. Did the child die in the 7 days after this visit?
		gen diedWithin7 = died==1 & hours(deathDate-visitDate)<168
		label var diedWithin7 "Baby died within 7 days of this visit"
		
		
		
			
end


/*****************************************************
Define the Control Rows
*****************************************************/
program dccr_defineControlRows
	syntax, [ignoreCHWAssessment] [applyNosoToControls]
	// Next step is to define control rows:
	/*
	A row is a control row, if
	a.	The child does not meet the sign-based PSI definition on this visit, AND
	b.	The child does not have an earlier row with PSI definition, AND
	c.	The child does not have a later row with PSI definition, AND
	d.	The child does not have a CHW assessment within 7 days of this physician assessment with a referral for screening
	e.	The child was not hospitalized in the prior 7 days, AND
	f.	The child does not have an earlier row that has already been defined as a control row
	g.  The child did not die within 7 days of this visit.
	*/

	if "`ignoreCHWAssessment'" == "" {
		gen controlRow = psi==0 & prior7_psi==0 & post7_psi==0 & prior7_hosp==0 & diedWithin7==0 & chwSepsisW7==0
	}
	else {
		gen controlRow = psi==0 & prior7_psi==0 & post7_psi==0 & prior7_hosp==0 & diedWithin7==0
	}
	
	if "`applyNosoToControls'"!="" {
		replace controlRow = 0 if controlRow==1 & noso==1
	}
		
	tempvar minControlRow
	egen double `minControlRow' = min(visitDate) if controlRow==1, by(childID)
	replace controlRow = 0 if controlRow==1 & visitDate!=`minControlRow'
	label var controlRow "This row is a control row?"

end

/*****************************************************
Define the Case Rows
*****************************************************/
program dccr_defineCaseRows
	syntax, [applyNoso]
	/*
	A row is a case row, if
	a.	It is not a control row, AND
	b.	The child meets the sign-based PSI definition on this visit AND
			fastbreathing is NOT the only sign OR
			fastbreathing is the only sign, but died within 7 days
	c.	The child was not hospitalized in the prior 7 days 
	d. 	(If specified) the child is not a post-birth nosocomial risk (unless overridden)
	*/

	gen caseRow = 	controlRow==0 & psi==1 & inlist(1,lethargic, poorFeeding, hypothermia, convulsion, hyperthermia, chestIndr)==1 & (prior7_hosp==0)
	replace caseRow = 1 if caseRow!=1 & controlRow==0 & psi==1 & (prior7_hosp==0) & fastBreathOnly==1 & died==1 & hours(deathDate-visitDate)<168.0
	//apply noso?
	if "`applyNoso'"!= "" replace caseRow = 0 if caseRow ==1 & noso==1
	label var caseRow "This row is a case row"
	
	//Next, look at babies with multiple case rows.. Need to make an indicator of episode

	//temporarily replace caseRow with its negative to allow sorting
	replace caseRow = -1*caseRow
	//generate a case number based on order of caseRows
	bysort childID (caseRow visitDate): gen caseNum = _n if caseRow==-1
	//convert caseNum to the caseNum in prior row, if the difference between this caseRow and the prior is 7 days (168 hours)
	bysort childID (caseRow visitDate): replace caseNum=caseNum[_n-1] if hours(visitDate-visitDate[_n-1])<168 & caseNum>1 & caseNum!=.
	//adjust any gaps in caseNum
	bysort childID (caseRow visitDate): replace caseNum=caseNum[_n-1]+1 if caseNum-caseNum[_n-1]>1 & caseNum>1 & caseNum!=.
	//return caseRow back to its positive
	replace caseRow = -1*caseRow
	rename caseNum psiEpisode
	label var psiEpisode "PSI Episode Number"

end

/*****************************************************
Clean up and save the dataset
*****************************************************/
program dccr_cleanUp
	syntax, [ignoreCHWAssessment] [includeNonSpecimens]
	
	if "`includeNonSpecimens'"!="" {
		local filestem "_overall"
	}
	//Classify all rows
		gen rowStatus 		= 0 if controlRow==0 & caseRow==0
		replace rowStatus 	= 1 if controlRow==1 & caseRow==0
		replace rowStatus	= 2 if controlRow==0 & caseRow==1
		label var rowStatus "Case/Non-Case Status of this Row"
		label def rStatus 0"Not elig for case/control" 1"Eligible for Control" 2"Eligible for Case"
		label values rowStatus rStatus
		
	//generate an indicator variable that says whether a baby is both case and Control
	tempvar eCase eCont eCase_e eCont_e
	gen `eCase' = rowStatus==2
	gen `eCont' = rowStatus==1
	egen `eCase_e' = max(`eCase'), by(childID)
	egen `eCont_e' = max(`eCont'), by(childID)
	gen bothCaseAndControl = `eCase_e'==1 & `eCont_e'==1
	label var bothCaseAndControl "Child contributes as both Case and Control"
	drop `eCase' `eCont' `eCase_e' `eCont_e'



	order childID visitDate birthDate ageAtVisit site preClass phyClass bloodID respID csfID ///
		fastBreathing chestIndr hypothermia hyperthermia lethargic convulsions poorFeeding psi fastBreathOnly

	drop caseRow controlRow died deathDate diedWithin7
	
	//label yes no variables
	dccr_labelyn psi fastBreathing chestIndr hypothermia hyperthermia lethargic convulsions	///
			poorFeeding prior7_hosp prior7_psi post7_psi facility anySpecimen nosocomialExcl fastBreathOnly bothCaseAndControl
	
	order childID birthDate site psiEpisode
	count
	noi di as error "Case Control Rows Long Format Saved (n=`r(N)')"
	notes drop _all
	notes drop _dta
	saveold CaseControlOutputFiles/CaseControlRows_long`filestem', replace
	preserve
		keep if rowStatus==2
		bysort childID psiEpisode (visitDate): gen measure=_n
		if "`ignoreCHWAssessment'"== "" {
			reshape wide visitDate ageAtVisit preClass phyClass bloodID respID csfID fastBreathing-post7_psi chwVisitPrior chwVisitW7 chwVisitPost chwSepsisW7 rowStatus nosocomialExcl, j(measure) i(childID psiEpisode site birthDate)
		}
		else {
			reshape wide visitDate ageAtVisit preClass phyClass bloodID respID csfID fastBreathing-post7_psi rowStatus nosocomialExcl, j(measure) i(childID psiEpisode site birthDate)
		}
		foreach var of varlist visitDate1-rowStatus1 {
			local newname = substr("`var'",1,length("`var'")-1)
			rename `var' `newname'
		}
		tempfile wideCases
		save `wideCases', replace
	restore
	keep if rowStatus!=2
	order childID birthDate site psiEpisode
	append using `wideCases'
	notes drop _all
	notes drop _dta
	saveold CaseControlOutputFiles/CaseControlRows_wide`filestem', replace	
	count
	noi di as error "Case Control Rows Wide Format Saved (n=`r(N)')"

end

/*****************************************************
Generate error Summary File
*****************************************************/
program dccr_errorSummary
	syntax, [ignoreCHWAssessment] [includeNonSpecimens]
	
	//* all of the error files have stem "dropped", so we should grab a file list of these
	clear
	local myfiles: dir  "." files "dropped*"
	append using `myfiles'

	if "`includeNonSpecimens'"!="" {
		local filestem "_overall"
	}

	label define errorType 1 ""
	label define errorType 1 "ChildID and VisitDate NOT unique in Form 6", modify
	label define errorType 2 "Form 6 ChildID not in Anisa Summary Data", modify
	label define errorType 3 "Mother not in AnisaMotherData", modify
	label define errorType 4 "ChildID not in Main Study Period (or DOB Missing)", modify
	label define errorType 5 "Form 6 Visit - DOB > 1440 Hours", modify
	
	label values errorType errorType

	notes drop _all
	notes drop _dta
	save CaseControlOutputFiles/errorSummary`filestem', replace
	
end


/*****************************************************
Incorporate the CHW Visit Information around this Row
*****************************************************/
program dccr_getCHWVisitInformation
	preserve
		rename ageAtVisit ageAtPhyVisit
		joinby childID using ../AnisaCHWVisitData, unmatched(master)
	//Is this CHW Visit more than 7 days before Physician Visit?
		gen chwVisitPrior = ageAtVisit < (ageAtPhyVisit-7*24)
	//Is this CHW Visit within 7 days of the Physician Visit?
		gen chwVisitW7 = abs(ageAtVisit - ageAtPhyVisit) <(7*24)
	//Is this CHW Visit more than 7 days after the Physician Visit?
		gen chwVisitPost = ageAtVisit >= ((ageAtPhyVisit)+(7*24)) 
	//Is this CHW Visit within 7 days and resulting in a referral for sepsis screening?
		gen chwSepsisW7 = chwVisitW7==1 & eligref==1
	
		collapse (sum) chwVisitPrior chwVisitW7 chwVisitPost chwSepsisW7 , by(childID visitDate)
		label var chwVisitPrior "# CHW visits before Phy Assmt"
		label var chwVisitW7 "# CHW visits w/in 7d of Phy Assmt"
		label var chwSepsisW7 "# of CHW Referral w/in 7 d of Phy Assmt"
		label var chwVisitPost "# CHW visits >7d after Phy Assmt"
		tempfile chwIndicators
		save `chwIndicators', replace
	restore
	merge 1:1 childID visitDate using `chwIndicators'
	assert _merge==3
	drop _merge
	noi di as error "Incorporated indicators for CHW Visits around each Row"

end



/*****************************************************
MATA Module
*****************************************************/
mata:


/*****************************************************
Mata function returns a vector of values indicating
the date of the most recent (or most proximal next) 
PSI episode
*****************************************************/
real vector hisPSI(real matrix v, real scalar flip) {
	if(flip==1) {
		v=v[(rows(v)::1),.]
	}
	his = J(rows(v),1,.)
	if(rows(v)>1) {
		for(i=rows(v);i>1;i--) {
			priorRows=v[1::i-1,.]
			priorPSIs = select(priorRows,priorRows[.,3]:==1)
			if(rows(priorPSIs)>0) {
				if(flip==0) {
					his[i] = max(priorPSIs[.,2])
				}
				else {
					his[i] = min(priorPSIs[.,2])
				}
			}
			else {
				his[i]=0
			}
		}
	}
	his[1]=0
	if(flip==1) {
		his[1]=.
		his=revorder(his)
	}
	return(his)	
}

/*****************************************************
MATA void function that loops through each child
calling another function that will examine the pre/post
status of PSI
*****************************************************/
void prePostPSIIndicators() {

	childID=st_sdata(.,"childID")
	childID=uniqrows(childID)
	
	psiData = st_data(.,("id","visitDate","psi"))
	
	for(i=1;i<=rows(childID);i++) {
		thisChild 		= strtoreal(childID[i])
		thisChildData	= select(psiData, psiData[.,1]:==thisChild)
		if(i==1) {
			psiHistory = hisPSI(thisChildData,0), hisPSI(thisChildData,1)
		}
		else {
			psiHistory = psiHistory \ hisPSI(thisChildData,0), hisPSI(thisChildData,1)
		}
	}
	//add the information to the STATA dataset
	st_addvar("double", ("prior", "post"))
	st_store(.,("prior","post"),psiHistory)
}

end
