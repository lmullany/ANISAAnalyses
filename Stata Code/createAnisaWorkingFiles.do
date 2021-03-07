****************************************************************************
//
//  This do file processes each of the clean versions of the raw ANISA tables
//  and produces a merged file, on which the regular reporting program can 
//	be executed.
//
//	Date: August 9th, 2012
//
****************************************************************************


****************************************************************************
//
//  Update Date: October 9th, 2012
//
//	Major updates include:
//	1. 	appending all visit data (Form 3, Form 4a, Form 4b
//		and Form 5, into a single file called "AnisaCHWVisitData".  
//	2. 	saving into a small file called missingBirthDates any babies
//		for whom we do not have birth date.
//	3. 	When there are babies without birthdates, the ageAtVisit (which is
//		calculated for each row in the AnisaCHWVisitData file) is set to 
//		be equal to the mean age at this visit Number for all babies for whom
//		we do have birthDate information
//	4. 	creating a summary file called "AnisaSummaryVisitData" which
//		holds summary information about visit data for all babies - i.e.
//		this file has one row per baby
//
****************************************************************************


****************************************************************************
//
//  Update Date: October 15th, 2012
//
//	Major updates include:
//	1. 	no longer merging the lab and the physician assessment data
//	2.	we will have two separate tables - one that holds the Physician Assessment
//		data (Form 6), and one that holds the merged lab data
//
****************************************************************************


****************************************************************************
//
//  Update Date: October 16th, 2012
//
//	Minor updates
//	1. 	ensuring that each of the created tables has a variable (visitDate) that holds
//		the date and time of the visit.
//	2.  adding date of delivery to the AnisaMotherData file - this is equivalent to
//	3. 	date of birth in the other tables
//
****************************************************************************

****************************************************************************
//
// Update Date: December 1,2012
// Minor Update (Hamidul)
// Data set no longer contains identifation variables of the repondents
// take out those variables from the drop list
//
****************************************************************************

****************************************************************************
//
// Update Date: December 10,2012
// Minor Update (Luke Mullany)
// At the time of merging 7a to BacTec, we also save
// temporary variables to hold everBlood collection, or firstBlood collection
// We do something similar for 7b, and then we create the Summary Data File
// last, pulling in those variable to the SummaryFile
//
****************************************************************************

****************************************************************************
//
// Update Date: December 11,2012
// Minor Update (Luke Mullany)
// 1. Added a check to be sure that the length of childID ==8, every time we
// create childID (i.e. for each table)
// 2. Added last date of specimen collection (previously was only first date
//	of collection, to the Summary File
****************************************************************************

****************************************************************************
//
// Update Date: Feburary 14, 2013
// Minor Update (Luke Mullany)
// 1. Added ageAtRegistration (age at filling Form 3) into the SummaryVisitData
****************************************************************************

****************************************************************************
//
// Update Date: March 21, 2013
// Minor Update (Luke Mullany)
// 1. Incorporated new linkage between Form 6 and corresponding Lab Forms
****************************************************************************

****************************************************************************
//
// Update Date: May 19th, 2014
// Minor Update (Luke Mullany)
// 1. added a "Main Study" variable to the Summary File that reflects the
//		start dates for each site
****************************************************************************

****************************************************************************
//
// Update Date: September 29th, 2014
// Minor Update (Luke Mullany)
// 1. pull LMP (Form 1, Q233) from Mother table into the Summary Table
****************************************************************************

****************************************************************************
//
// Update Date: May 18th, 2015
// Minor Update (Luke Mullany)
// 1. This file now checks for dupilicates in SpecimenID in AnisaForm7b
//		but any duplicates found are ignored (message only shown)
****************************************************************************

****************************************************************************
//
// Update Date: May 20th, 2015
// Minor Update (Luke Mullany)
// 1. The start dates for India sites have now been updated to Aug 1st, 2013
****************************************************************************

****************************************************************************
//
// Update Date: September 21st, 2015
// Major Update (Luke Mullany)
// 1. We define facility births as F2Q504 = 2,3,4,or 5, and include in summary file
// 2. We now have a method to get "ever hospitalized variabel from 3,4a,4b,5, and 6
//		This new variable is derived and included in the summary file
****************************************************************************

****************************************************************************
//
// Update Date: November 20th, 015
// Minor Update (Luke Mullany)
//  - we no longer create childID in lines 321, 376, 601.. As childID already
//	exist in AnisaForm3, and AnisaForm4a, and AnisaForm4b and AnisaForm6.
****************************************************************************

****************************************************************************
//
// Update Date: November 20th, 015
// Major Update (Luke Mullany)
//  1. Corrected a problem in everHosp variable (needed to append the `hosp' tempfile 
//		from Form 6 hospitalization
//	2. I added a variable that indicates the date/time of the last Form 6. 
****************************************************************************

****************************************************************************
//
// Update Date: March 17th, 2016
// Minor Update (Luke Mullany)
//  1. Added Sex variable to the Summary Data File
****************************************************************************

****************************************************************************
//
// Update Date: May 14th, 2016
// Major Update (Sajib)
//  1. Drop other variables for single rresponse (the response/value is added in the main vaiable with new code) e.g. Other Respondent F4aQ132a
//	2. Also drop 2nd Other code when there use 2 others for multiple response and no value in 2nd other variable. e.g. Material used in umbilical cord
//	3. Sites use single code for multiple complications. We split these responses into multiple variables (single complication in a variable). 
//	   In this situation we may need to add more variables. e.g F6QQ214 (New one).
//  4. I did not delete any line. Just make copy of a line (renvars) and update there.
//	5. As Temperature collect in 2 different unit (C & F) in different site we update the value in a single unit (F) (Form 3 - Forrm 6). 
//	   Its done in ANISA Cleaned data files.original
****************************************************************************

****************************************************************************
//
// Update Date: June 18th 2016
// Minor Update (Luke)
//  1. need to correct the number of variables in the rename list for Form 5 (Q203a-Q203z is 17 variables, not 16)


//Update date:August 12th, 2016
//found a small error in the babyalive variable (fixed line 492)


//Update date:January 25th, 2017
//minor cleanup of labels

****************************************************************************
//  Set environment variables
****************************************************************************

clear
version 12.1
set more off
local path = "../Source Anisa Tables/"


****************************************************************************
//  AnisaTable1
****************************************************************************
use `"`path'/AnisaForm1.dta"' ,clear
foreach var of varlist Q121-Q600 {
	rename `var' F1`var'
}
gen F1VisitM=month(F1Q121)
label var F1VisitM "Calender month of Form1 visit"
gen F1VisitY=year(F1Q121)
label var F1VisitY "Calender year of Form1 visit"

tempfile anisaf1
saveold `anisaf1',replace

****************************************************************************
//  AnisaTable2
****************************************************************************

use `"`path'/AnisaForm2.dta"' ,clear
*drop UserId EnDt EditUser
foreach var of varlist Q121- Q600 {
	rename `var' F2`var'
}
gen F2VisitM=month(F2Q121)
label var F2VisitM "Calender month of Form2 visit"
gen F2VisitY=year(F2Q121)
label var F2VisitY "Calender year of Form2 visit"

tempfile anisaf2
saveold `anisaf2',replace

****************************************************************************
//  AnisaTable3
****************************************************************************
use `"`path'/AnisaForm3.dta"' ,clear
foreach var of varlist Q121- Q900 {
	rename `var' F3`var'
}
gen VisitM=month(F3Q121)
label var VisitM "Calender month of Form3 visit"
gen VisitY=year(F3Q121)
label var VisitY "Calender year of Form3 visit"


tempfile anisaf3
saveold `anisaf3', replace


****************************************************************************
//  AnisaTable4a
****************************************************************************
use `"`path'/AnisaForm4a.dta"' ,clear

/*
foreach var of varlist Q121- Q800 {
	rename `var' F4a`var'
}
*/
gen F4aVisitM=month(Q121)
label var F4aVisitM "Calender month of Form4a visit"
gen F4aVisitY=year(Q121)
label var F4aVisitY "Calender year of Form4a visit"


*renvars F4aQ211x1 F4aQ213x1 F4aQ303x1 F4aQ502x1 F4aQ506x1 F4aQ507x1 \ F4aQ211xi  F4aQ213xi   F4aQ303xi  F4aQ502xi   F4aQ506xi   F4aQ507xi
*renvars F4aQ211x2 F4aQ213x2 F4aQ303x2 F4aQ502x2 F4aQ506x2 F4aQ507x2 \ F4aQ211xii F4aQ213xii  F4aQ303xii F4aQ502xii  F4aQ506xii  F4aQ507xii

*reshape wide F4aQ121- F4aQ800 F4aVisitM F4aVisitY, i(CountryCode SiteCode StudyId ChildSl) j(Visit)
tempfile anisaf4a
saveold `anisaf4a',replace


****************************************************************************
//  AnisaTable4b
****************************************************************************
use `"`path'/AnisaForm4b.dta"' ,clear
*drop UserId EnDt EditUser 
/*
foreach var of varlist Q121- Q1000 {
	rename `var' F4b`var'
}
*/
gen F4bVisitM=month(Q121)
label var F4bVisitM "Calender month of Form4b visit"
gen F4bVisitY=year(Q121)
label var F4bVisitY "Calender year of Form4b visit"


	
*reshape wide F4bQ121- F4bQ1000 F4bVisitM F4bVisitY, i( CountryCode SiteCode StudyId ChildSl) j(Visit)
tempfile anisaf4b
saveold `anisaf4b',replace

****************************************************************************
//  AnisaTable5
****************************************************************************
use `"`path'/AnisaForm5.dta"' ,clear

*drop UserId EnDt EditUser 
/*foreach var of varlist Q121- q500 {
	rename `var' F5`var'Sl
}
*/
gen VisitM=month(Q121)
label var VisitM "Calender month of Form5 visit"
gen VisitY=year(Q121)
label var VisitY "Calender year of Form5 visit"

bysort CountryCode SiteCode StudyId ChildSl (Q121 Q124): gen extraVisit=_n
label var extraVisit "Extra visit number (serial)"

//Anisa Form 5 - child ID generation
gen childID = CountryCode + SiteCode + StudyId + ChildSl
capture assert length(childID)==8
if _rc!=0 {
	di as error "There are row in AnisaForm5 where one or more of CountryCode, SiteCode, StudyID, ChildSl are missing - will be dropped"
	drop if length(childID)!=8
}
label var childID "Child ID"
order childID extraVisit



rename VAge unschedAge 
label var unschedAge "Age in days noted on top of Form 5 for this unscheduled visit"

rename VStat visitType
label var visitType "Type of Visit (0=Sched-4a/b, 1=Unscheduled, 2=Revisit/Referral, 3=Initial-Form)"
label def visitType 0"Scheduled" 1"Unscheduled" 2"Revisit/Referral" 3"Initial Assessment (Form 3)"
label values visitType visitType
// Drop "Other" variables  

renvars Q121-Q152T \ visitdate visittime visitstatus resprel motheralive mothddate mothdtime babyalive babyddate babydtime
*renvars Q203a-Q203z \ notfeedwell cough coldrunnynose rapidbreath convul fever cold nomovement skinpust jaundice umbredpus defects othercomp othcomp1 othcomp2 comp_dk
 renvars Q203a-Q203z \ notfeedwell cough coldrunnynose rapidbreath convul fever cold nomovement skinpust jaundice umbredpus defects othercomp othcomp1 othcomp2 othcomp3 comp_dk

*renvars Q201-Q202z Q204a-Q204z \soughtcare scchwref scselfref sc_refdk scdoctor scnurse scmidwife scparam scchw sctba scquack schomeo scherbal scother scother1 scother2 sc_dk
 renvars Q201-Q202z Q204a-Q204z \soughtcare scchwref scselfref sc_refdk scdoctor scnurse scmidwife scparam scchw sctba scquack schomeo scherbal scother scother1 sc_dk

*renvars Q205a-Q205z \ rchosp rclevel1 rcoutreach rcdoctor rchome rcother rcother1 rcother2 rc_dk
 renvars Q205a-Q205z \ rchosp rclevel1 rcoutreach rcdoctor rchome rcother rcother1 rc_dk

 renvars Q206-Q207 \ admitted admitdur
renvars Q301-Q308 \ babypres resprate1 resprate2 respratehigh  chestindraw  auxtemp1 hightemp auxtemp2 lowtemp lethlevel movestim  convrep	convobs   poorfeedrep feedpos feedattach pcattach pcsucking poorfeedass

renvars Q311-q500 \ ex_skinpust ex_umbredpus ex_jaundice ex_othcomp ex_othcomp1 ex_othcomp2 ex_othcomp3 eligref babyreferred refplace refreas refreas1 refreas2 refreas3 acceptref refuseref1 refuseref2 intendtime

gen double visitDate = cofd(visitdate) + msofhours(real(substr(visittime,1,2))) + msofminutes(real(substr(visittime,4,2))) 
label var visitDate "Date/Time of Visit"
format visitDate %tc

label define CountL 	1 "Bangladesh" 2 "India" 3 "Pakistan"
label define SiteL		1 "Sylhet" 3 "Karachi" 4 "Matiari" 5 "Vellore" 6 "Odisha"
destring CountryCode, replace
destring SiteCode, replace
label values CountryCode CountL
label values SiteCode SiteL

compress
notes: childID and extraVisit comprise primary key
saveold AnisaExtraVisitData, replace

****************************************************************************
//  AnisaTable6
****************************************************************************
use `"`path'/AnisaForm6.dta"' ,clear
*drop UserId EnDt EditUser 
foreach var of varlist Q121-Q800 {
	rename `var' F6`var'
}
gen VisitM=month(F6Q121)
gen VisitY=year(F6Q121)
sort CountryCode SiteCode StudyId ChildSl AssType F6Q121 
bysort CountryCode SiteCode StudyId ChildSl AssType VisitY VisitM: gen Vsl=_n
tostring AssType,replace
tempfile anisaf6

bysort CountryCode SiteCode StudyId ChildSl (F6Q121): gen visit=_n

gen childID = CountryCode + SiteCode + StudyId + ChildSl
capture assert length(childID)==8
if _rc!=0 {
	di as error "There are row in AnisaForm6 where one or more of CountryCode, SiteCode, StudyID, ChildSl are missing - will be dropped"
	drop if length(childID)!=8
}
label var childID "Child ID"
label var visit "Order of Physician visit for this baby"  							// Corrected
notes: childID and visit make up the primary key
notes: Form 6 data only
order childID visit

gen double visitDate = cofd(F6Q121) + msofhours(real(substr(F6Q124,1,2))) + msofminutes(real(substr(F6Q124,4,2))) 
label var visitDate "Date/Time of visit"

*assert missing(SpecimenID)==1
*drop SpecimenID ///(This field is not used)

//May 30th, 2013 - 7 rows have SpecimenID included - all bloods - am shifting them to F6Q611a (which is empty)
//replace F6Q611a = SpecimenID if SpecimenID!="" & missing(F6Q611a)==1
rename SpecimenID linkToPriorBloodID



//Rename the specimen fields
rename F6Q611a bloodID
rename F6Q621a respID
rename F6Q631a csfID
label define CountL 	1 "Bangladesh" 2 "India" 3 "Pakistan"
label define SiteL		1 "Sylhet" 3 "Karachi" 4 "Matiari" 5 "Vellore" 6 "Odisha"
destring CountryCode, replace
destring SiteCode, replace
label values CountryCode CountL
label values SiteCode SiteL


format visitDate %tc
saveold AnisaPhyData, replace 

****************************************************************************
//  Merge temporary files, and save dataset for monitoring report
****************************************************************************
use `anisaf1'
merge  CountryCode SiteCode StudyId  using `anisaf2',sort unique _merge(f2)
drop f2
gen motherID=CountryCode+SiteCode+StudyId
order motherID
label var motherID "Mother ID: This is the primary key" 
notes: combines data from Forms 1 and 2
gen double visitDate = cofd(F1Q121) + msofhours(real(substr(F1Q122,1,2))) + msofminutes(real(substr(F1Q122,4,2)))
label var visitDate "Date/Time of Visit" 
format visitDate %tc

//create delivery date/time variable
//Note: create variable of type "double" to deal with extra precision needed to store STATA clock values
gen double delivDate = cofd(F2Q502D) + msofhours(real(substr(F2Q502T,1,2))) + msofminutes(real(substr(F2Q502T,4,2)))
format delivDate %tc
label var delivDate "Date and Time of Birth/Delivery for this mother (equiv to birthDate variable)"

label define CountL 	1 "Bangladesh" 2 "India" 3 "Pakistan"
label define SiteL		1 "Sylhet" 3 "Karachi" 4 "Matiari" 5 "Vellore" 6 "Odisha"
destring CountryCode, replace
destring SiteCode, replace
label values CountryCode CountL
label values SiteCode SiteL

//January 25th, 2017 - replace Wid = 0 if Wid==""
replace Wid = "0" if Wid!="0"

compress
saveold AnisaMotherData, replace

use `anisaf3'
gen childID = CountryCode + SiteCode + StudyId + ChildSl
capture assert length(childID)==8
if _rc!=0 {
	di as error "There are row in AnisaForm3 where one or more of CountryCode, SiteCode, StudyID, ChildSl are missing - will be dropped"
	drop if length(childID)!=8
}
gen motherID = CountryCode + SiteCode + StudyId
label var motherID "Mother ID: Use this to link to mother level data"
order childID motherID
label var childID "Child ID: This is the primary key"
compress


****************************************************************************
//  Because birth date is such a critical variable, I am moving it now
//	from Mother level form to Baby level form
****************************************************************************

	merge m:1 motherID  using AnisaMotherData, keepusing(delivDate) keep(1 3)
	drop _merge //note, here I am dropping merge indicator - perhaps it could be renamed and saved, if later we need it

	rename delivDate birthDate
	label var birthDate "Date and Time of Birth/Delivery for this baby"

	//Now, we can create an date/time variable for the visit, 
	gen double visitDate = cofd(F3Q121) + msofhours(real(substr(F3Q124,1,2))) + msofminutes(real(substr(F3Q124,4,2)))
	format visitDate %tc
	label var visitDate "Date and Time of Visit"

	//and then a "time" (or current age) since delivery for this visit.
	gen double ageAtVisit = hours(visitDate-birthDate)
	label var ageAtVisit "Age at Visit (or Time between delivery and visit), in hours"
	
	//is this baby a live birth? Yes, if F3Q201==1 (alive now) OR (F3Q201==2 (dead) & F3Q202==1 (born alive))
	gen livebirth = F3Q201==1 | (F3Q201==2 & F3Q202==1)
	//Added on Sep 26th, 2016
	replace livebirth = . if missing(F3Q201)==1
	label var livebirth "Baby born alive"
	label def lb 0"Not born alive" 1"Born alive"
	label values livebirth lb
	
	//First save the list of babies for whom there is no birthdate
	capture assert birthDate!=.
	local missingBirthDates=_rc!=0
	if _rc!=0 {
		preserve
		keep if birthDate==.
		keep childID
		saveold "missingBirthDates.dta", replace
		restore
	}

label define CountL 	1 "Bangladesh" 2 "India" 3 "Pakistan", modify
label define SiteL		1 "Sylhet" 3 "Karachi" 4 "Matiari" 5 "Vellore" 6 "Odisha", modify
destring CountryCode, replace
destring SiteCode, replace
label values CountryCode CountL
label values SiteCode SiteL
	
saveold AnisaBabyData, replace

****************************************************************************
//  GATHER ALL THE VISIT FORMS TOGETHER INTO A SINGLE FILE (FORM 4A, B, 5)
****************************************************************************

	****************************************************************************
	//  ZERO, GRAB THE VISIT DATA FROM FORM 3 (THE INITIAL ASSESSMENT VISIT) AND SAVE IN A TEMPORARY FILE
	****************************************************************************


	use AnisaBabyData.dta ,clear
	generate motheralive=1
	replace motheralive=2 if F3Q133==1
	generate babyalive=1 if F3Q201==1
	replace babyalive=2  if F3Q201==2 //& F3Q201==1
	generate registration=2
	replace registration=1 if F3Q206==1 & inlist(F3Q131,1,2)
	label var registration "Baby was eligible (i.e. F3Q206==1) and visit was complete/partially complete (i.e. F3Q131==1,2)"


****************************************************************************
//  Sajib: I need to Modify some lines below for others
// 	Add/ drop some variables
****************************************************************************
	*renvars F3Q121-F3Q132 F3Q134 F3Q203d F3Q203t\visitdate visittime visitstatus resprel respother mothddate babyddate babydtime
	renvars F3Q121-F3Q132 F3Q134 F3Q203d F3Q203t\visitdate visittime visitstatus resprel mothddate babyddate babydtime
	replace visitstatus=5 if F3Q133==2 & F3Q700!=1

	*renvars F3Q501-F3Q502z \ babycompl notfeedwell cough coldrunnynose rapidbreath convul fever cold nomovement skinpust jaundice umbredpus defects othercomp othcomp1 othcomp2 comp_dk
	renvars F3Q501-F3Q502z \ babycompl notfeedwell cough coldrunnynose rapidbreath convul fever cold nomovement skinpust jaundice umbredpus defects othercomp othcomp1 othcomp2 othcomp3 comp_dk
	*renvars F3Q503-F3Q504z \ soughtcare  scdoctor scnurse scmidwife scparam scchw sctba scquack schomeo scherbal scother scother1 scother2 sc_dk
	renvars F3Q503-F3Q504z \ soughtcare  scdoctor scnurse scmidwife scparam scchw sctba scquack schomeo scherbal scother scother1 sc_dk
	*renvars F3Q505a-F3Q505z\ rchosp rclevel1 rcoutreach rcdoctor rchome rcother rcother1 rcother2 rc_dk
	renvars F3Q505a-F3Q505z\ rchosp rclevel1 rcoutreach rcdoctor rchome rcother rcother1 rc_dk
	renvars F3Q511-F3Q522d3\ rchospyes studyhosp hospname admitted admitdate admitdur medsrecd medname1 medcont1 meddur1 medname2 medcont2 meddur2 medname3 medcont3 meddur3 medname4 medcont4 meddur4
	renvars F3Q700 F3Q702-F3Q708c2 \ babypres respratehigh resprate1 resprate2 chestindraw hightemp auxtemp1 lowtemp auxtemp2 movestim lethlevel convobs convrep poorfeedass poorfeedrep feedpos feedattach pcattach pcsucking
	*renvars F3Q711-F3Q713 F3Q715-F3Q900\ ex_skinpust ex_umbredpus ex_jaundice ex_othcomp ex_othcomp1 ex_othcomp2 eligref babyreferred refplace refreas refreas1 refreas2 acceptref refuseref1 refuseref2 intendtime
	renvars F3Q711-F3Q713 F3Q715-F3Q900\ ex_skinpust ex_umbredpus ex_jaundice ex_othcomp ex_othcomp1 ex_othcomp2 ex_othcomp3 eligref babyreferred refplace refreas refreas1 refreas2 refreas3 acceptref refuseref1 refuseref2 intendtime

	//add some other key variables
	gen formSource = 0
	gen visitType=.

	keep childID registration livebirth formSource visitType CountryCode-ChildSl visitdate-resprel mothddate babyddate babydtime babycompl-meddur4  babypres respratehigh- ex_jaundice ex_othcomp- intendtime  motheralive babyalive VisitM VisitY
	tempfile AnisaForm3VisitData
	saveold `AnisaForm3VisitData', replace

	****************************************************************************
	//  FIRST, CLEAN ANISA4A
	****************************************************************************


	use `anisaf4a'

	*execute for Anisa4b (same names)
	*renvars Q121-Q152T \  visitdate visittime visitstatus resprel respother motheralive mothddate mothdtime babyalive babyddate babydtime
	*drop Q132X
	renvars Q121-Q152T \  visitdate visittime visitstatus resprel motheralive mothddate mothdtime babyalive babyddate babydtime
	renvars Q301 \ bfstill
	renvars Q501-Q502z \ babycompl notfeedwell cough coldrunnynose rapidbreath convul fever cold nomovement skinpust jaundice umbredpus defects othercomp othcomp1 othcomp2 othcomp3 comp_dk
	renvars Q503-Q506z \ babyrefer soughtcare scchwref scselfref sc_refdk scdoctor scnurse scmidwife scparam scchw sctba scquack schomeo scherbal scother scother1 sc_dk
	renvars Q507a-Q507z \ rchosp rclevel1 rcoutreach rcdoctor rchome rcother rcother1 rc_dk
	renvars Q508-Q514d3 \ rchospyes studyhosp hospname admitted admitdate admitdur medsrecd medname1 medcont1 meddur1 medname2 medcont2 meddur2 medname3 medcont3 meddur3 medname4 medcont4 meddur4

	*execute for Anisa4b (Q201-Q203)
	*renvars Q212-Q214 \ massgiven mass_must mass_coco mass_bukwa mass_olive mass_sso mass_unk mass_other mass_oth1 mass_oth2 mass_dk mass_perday
	renvars Q212-Q214 \ massgiven mass_must mass_coco mass_bukwa mass_olive mass_sso mass_unk mass_other mass_oth1 mass_dk mass_perday
	*execute for Anisa4b (Q302a-Q303
	*renvars Q303a-Q304 \ bfwater bfsugar bfformula bfanimmilk bftea bfothliq bfsolid bfopiate bfother bfother1 bfother2 bfonly bfdk bfinstr
	renvars Q303a-Q304 \ bfwater bfsugar bfformula bfanimmilk bftea bfothliq bfsolid bfopiate bfother bfother1 bfonly bfdk bfinstr
	*execute for Anisa4b (Q402-Q404)
	renvars Q401-Q403 \ smokes  smokefreq cookbabypl
	*execute for Anisa4b (Q801-Q808c2)
	renvars Q601-Q608c2 \ babypres respratehigh resprate1 resprate2 chestindraw hightemp auxtemp1 lowtemp auxtemp2 movestim lethlevel convobs convrep poorfeedass poorfeedrep feedpos feedattach pcattach pcsucking
	*execute for Anisa4b (Q811-Q1000)
	renvars Q611-Q800 \ ex_skinpust ex_umbredpus ex_jaundice ex_othcomp ex_othcomp1 ex_othcomp2 ex_othcomp3 eligref babyreferred refplace refreas refreas1 refreas2 refreas3 acceptref refuseref1 refuseref2 intendtime


	*add to Anisa4b
	*renvars Q201-Q211z \ visit2_6 bathfirsttime bathwatertemp umbapp umb_antib umb_antis umb_turme umb_must umb_rice umb_coco umb_ash umb_dung umb_oth umb_oth1 umb_oth2 umb_dk
	renvars Q201-Q211z \ visit2_6 bathfirsttime bathwatertemp umbapp umb_antib umb_antis umb_turme umb_must umb_rice umb_coco umb_ash umb_dung umb_oth umb_oth1 umb_dk
	rename Q302 excbf
	rename Q400 sameday_f3_4a

	*new VARS for 4a
	gen isDay27=.
	label def ld27visit 1"Day 27 Visit" 2"Other Visit"
	label values isDay27 ld27visit
	move isDay27 same
	local vaxvars = "isDay59 muacmom weightmom anyvax showvaxcard bcgdate opv0date opv1date dptdate pcvdate"
	foreach vaxvar of local vaxvars {
		gen `vaxvar'=.
		order `vaxvar', before(babypres)
	}

	local form4aVarCt = `c(k)'

	rename F4aVisitM VisitM
	rename F4aVisitY VisitY

	saveold `anisaf4a', replace

	clear

	****************************************************************************
	//  SECOND, CLEAN ANISA4B
	****************************************************************************


	use `anisaf4b'
	renvars Q121-Q152T \ visitdate visittime visitstatus resprel motheralive mothddate mothdtime babyalive babyddate babydtime
	renvars Q301 \ bfstill
	renvars Q501-Q502z \ babycompl notfeedwell cough coldrunnynose rapidbreath convul fever cold nomovement skinpust jaundice umbredpus defects othercomp othcomp1 othcomp2 othcomp3 comp_dk

	renvars Q503-Q506z \ babyrefer soughtcare scchwref scselfref sc_refdk scdoctor scnurse scmidwife scparam scchw sctba scquack schomeo scherbal scother scother1 sc_dk
	renvars Q507a-Q507z \ rchosp rclevel1 rcoutreach rcdoctor rchome rcother rcother1 rc_dk
	renvars Q508-Q514d3 \ rchospyes studyhosp hospname admitted admitdate admitdur medsrecd medname1 medcont1 meddur1 medname2 medcont2 meddur2 medname3 medcont3 meddur3 medname4 medcont4 meddur4
	*execute for Anisa4b (Q201-Q203)
	*renvars Q201-Q203 \ massgiven mass_must mass_coco mass_bukwa mass_olive mass_sso mass_unk mass_other mass_oth1 mass_oth2 mass_dk mass_perday
	renvars Q201-Q203 \ massgiven mass_must mass_coco mass_bukwa mass_olive mass_sso mass_unk mass_other mass_oth1 mass_dk mass_perday
	*execute for Anisa4b (Q302a-Q303)
	*renvars Q302a-Q303 \ bfwater bfsugar bfformula bfanimmilk bftea bfothliq bfsolid bfother bfother1 bfother2 bfonly bfdk bfinstr
	renvars Q302a-Q303 \ bfwater bfsugar bfformula bfanimmilk bftea bfothliq bfsolid bfother bfother1 bfonly bfdk bfinstr
	*execute for Anisa4b (Q402-Q404)
	renvars Q402-Q404 \ smokes  smokefreq cookbabypl
	*execute for Anisa4b (Q801-Q808c2)
	renvars Q801-Q808c2 \ babypres respratehigh resprate1 resprate2 chestindraw hightemp auxtemp1 lowtemp auxtemp2 movestim lethlevel convobs convrep poorfeedass poorfeedrep feedpos feedattach pcattach pcsucking
	*execute for Anisa4b (Q811-Q1000)
	renvars Q811-Q1000 \ ex_skinpust ex_umbredpus ex_jaundice ex_othcomp ex_othcomp1 ex_othcomp2 ex_othcomp3 eligref babyreferred refplace refreas refreas1 refreas2 refreas3 acceptref refuseref1 refuseref2 intendtime

	* add to Anisa4a
	rename Q401 isDay27
	renvars Q601-Q703e \ isDay59 muacmom weightmom anyvax showvaxcard bcgdate opv0date opv1date dptdate pcvdate

	**New VARS for 4b
	gen bfopiate=.
	move bfopiate bfsolid
	*local newvars "visit2_6 bathfirsttime bathwatertemp umbapp umb_antib umb_antis umb_turme umb_must umb_rice umb_coco umb_ash umb_dung umb_oth umb_oth1 umb_oth2 umb_dk"
	local newvars "visit2_6 bathfirsttime bathwatertemp umbapp umb_antib umb_antis umb_turme umb_must umb_rice umb_coco umb_ash umb_dung umb_oth umb_oth1 umb_dk"
	foreach newvar of local newvars {
		gen `newvar'=.
		move `newvar' babydtime
	}


	gen excbf=.
	move excbf bfstill

	gen sameday_f3_4a=.
	move sameday_f3_4a bfinstr


	local form4bVarCt = `c(k)'
	capture assert `form4aVarCt' == `form4bVarCt'
	di _rc
	if _rc!=0 {
		noi di as error "Form 4a variable count (`form4aVarCt') not equal to Form 4b variable count (`form4bVarCt')"
		exit
	}
	rename F4bVisitM VisitM
	rename F4bVisitY VisitY

	saveold `anisaf4b', replace

	//need to grab some variable labels from 4b that will be lost on the append
	//this is true for any variable that is added to 4a, because previously not existing


	local newvars = "isDay27 isDay59 muacmom weightmom anyvax showvaxcard bcgdate opv0date opv1date dptdate pcvdate"
	foreach newvar of local newvars {
		local label_`newvar': variable label `newvar'
	}
	
	****************************************************************************
	//  THIRD EXECUTE THE APPEND, 
	****************************************************************************

	use `anisaf4a'
	gen formSource=1
	append using `anisaf4b'
	replace formSource=2 if formSource==.
	label def formsource 0"3" 1"4a" 2"4b" 3"5"
	label values formSource formsource
	label var formSource "Source of Scheduled Visit Data: 0=Form 3, 1=Form 4a, 2=Form 4b, 3=Form 5"

	foreach newvar of local newvars {
		label var `newvar' `"`label_`newvar''"'
	}

	****************************************************************************
	//  FOURTH, CREATE THE UNIQUE IDENTIFY VARIABLE
	****************************************************************************

	gen childID = CountryCode + SiteCode + StudyId + ChildSl
	capture assert length(childID)==8
	if _rc!=0 {
		di as error "There are row in AnisaForm4a where one or more of CountryCode, SiteCode, StudyID, ChildSl are missing - will be dropped"
		drop if length(childID)!=8
	}
	label var childID "Child ID"
	rename Visit visit
	label var visit "Visit (Day of scheduled visit)"
	
	destring CountryCode, replace
	destring SiteCode, replace
	
	****************************************************************************
	//  FIFTH, APPEND EXTRA VISIT DATA
	****************************************************************************

	append using AnisaExtraVisitData

	
	****************************************************************************
	//  SIXTH, APPEND INITIAL VISITDATA
	****************************************************************************

	append using `AnisaForm3VisitData'
	replace formSource=3 if formSource==.
	
	
	****************************************************************************
	//  SEVENTH, GRAB THE DATE OF BIRTH VARIABLE
	****************************************************************************

	merge m:1 childID using AnisaBabyData, keepusing(birthDate F3Q201 F3Q202 F3Q206 F3Q605) keep(1 3)
	assert _merge!=2
	drop _merge
	rename F3Q201 babyaliveatForm3
	label var babyaliveatForm3 "Baby was alive at the time of Form 3 - F3Q201"
	rename F3Q202 babyaliveatBirth
	label var babyaliveatBirth "Baby was alive at birth - Form 3 - F3Q202"
	rename F3Q605 form3Control 
	label var form3Control "Baby was selected as Control at time of registration/Form3"
	order childID birthDate babyaliveatForm3 babyaliveatBirth visit formSource

	****************************************************************************
	//  CLEAN AND CREATE SET OF VISIT META VARIABLES
	****************************************************************************
	//Now, create a date/time variable for this visit
	capture drop visitDate
	gen double visitDate = cofd(visitdate) + msofhours(real(substr(visittime,1,2))) + msofminutes(real(substr(visittime,4,2)))
	format visitDate %tc
	label var visitDate "Date and Time of Visit"

	//and then a "time" (or current age) since delivery for this visit.
	gen double ageAtVisit = hours(visitDate-birthDate)
	label var ageAtVisit "Age at Visit (or Time between delivery and visit), in hours"
	

	//We need an indicator for day of visit. This is usually recorded using two digits
	//at the top of Form 4a, 4b, or 5.  For Form 3 (i.e. the initial visit, this is not recorded, but
	//we can assign "00" for that day
	
	rename visit visitDay
	label values visitDay
	tostring visitDay, replace
	replace visitDay="" if visitDay=="."
	assert visitDay=="" if formSource==0
	replace visitDay="0" if formSource==0
	assert unschedAge==. | visitDay==""
	replace visitDay = string(unschedAge) if unschedAge!=.
	drop unschedAge
	replace visitDay="0"+visitDay if real(visitDay)<10
	label var visitDay "Age/Day Number of Visit - Top of Form 4a/b/5"
	
	//lets fill age at visit for those situations where there is no birthDate
	//lets fill the age at the visit as the mean of the age for that visitNumber
	
	if `missingBirthDates'==1 {
		gen birthDateStatus=1
		label define birthDateStatus 1"Exists - ages directly estimated" 2"Missing - ages indirectly estimated"
		label values birthDateStatus birthDateStatus
		replace birthDateStatus=2 if birthDate==.
		
		levelsof visitDay, local(mydays)
			foreach day of local mydays {
			qui sum ageAtVisit if visitDay=="`day'"
			replace ageAtVisit = r(mean) if ageAtVisit==. & visitDay=="`day'"
		}
	}

	
	bysort childID (ageAtVisit): gen visitNum =  _n
	label var visitNum "Visit number, by order of age"
	
	replace visitType = 3 if formSource==0
	replace visitType = 0 if inlist(formSource,1,2)
	
	*fill registration and live birth information
	
	bysort childID (visitDay formSource): replace registration=registration[_n-1] if _n!=1 & registration==.
	bysort childID (visitDay formSource): replace livebirth=livebirth[_n-1] if _n!=1 & livebirth==.
	
	order childID visitNum ageAtVisit visitDay visitdate visittime formSource visitType
	
	
	
	*drop rows if the baby was not eligible to have a row
	//drop if visitDay!="00" & F3Q206!=1

	*Replace babyalive status if deathDate
	replace babydtime = "12:00" if babydtime=="99:99"
	gen double deathDate = cofd(babyddate) + msofhours(real(substr(babydtime,1,2))) + msofminutes(real(substr(babydtime,4,2)))
	label var deathDate "Date/Time of Death"
	format deathDate %tc
	replace babyalive=2 if deathDate!=.
	
	****************************************************************************
	//  COMPRESS, ADD NOTES, AND SAVE
	****************************************************************************

	label define CountL 	1 "Bangladesh" 2 "India" 3 "Pakistan", modify
	label define SiteL		1 "Sylhet" 3 "Karachi" 4 "Matiari" 5 "Vellore" 6 "Odisha", modify
	label values CountryCode CountL
	label values SiteCode SiteL
	
	format %dD_m_Y opv0date opv1date dptdate pcvdate

	compress
	notes: childID and visit make up the primary key
	notes: combines data from Form 4a and 4b
	notes: includes data from Form 5
	notes: includes assessment data from Form 3
	notes: includes date of birth from Form 3, and F3Q201/F3Q203
	
	saveold AnisaCHWVisitData, replace

use `"`path'/AnisaForm7a.dta"' ,clear
capture tostring SiteCode, replace
capture rename BLabID LabID
merge 1:1 LabID using `"`path'/AnisaBACTEC.dta"', gen(hasBacTec)
*rename BLabID LabID
label var hasBacTec "Form 7a and BacTec Merge Status"
label def hasBacTec 1"Form 7a does not have corresponding BacTec" 2"Bac Tec row does not have Form 7a" 3"Form 7a has a BacTec Row"
label values hasBacTec hasBacTec
gen double collectionDate = cofd(Q202D) + msofhours(real(substr(Q202T,1,2))) + msofminutes(real(substr(Q202T,4,2)))
gen double receiveDate = cofd(Q233D) + msofhours(real(substr(Q233T,1,2))) + msofminutes(real(substr(Q233T,4,2)))
gen double beepPositiveDate= cofd(BeepDate) + msofhours(real(substr(BeepTime,1,2))) + msofminutes(real(substr(BeepTime,4,2)))
format collectionDate receiveDate beepPositiveDate %tc
capture tostring CountryCode, replace force
gen childID = CountryCode + SiteCode + StudyId + ChildSl
capture assert length(childID)==8
if _rc!=0 {
	di as error "There are rows in AnisaForm7a where one or more of CountryCode, SiteCode, StudyID, ChildSl are missing - NOT dropped"
	drop if length(childID)!=8
}
rename LabID bloodID
replace bloodID = "B"+bloodID+"-FORM"

order childID bloodID
compress
notes: contains data from 7a and BacTec
saveold AnisaLab7aBacTec, replace

	gen everBloodSpecimenCollect=0
	destring Q2053, replace
	replace everBloodSpecimenCollect=1 if Q2053>0 & Q2053<.
	gen double bloodCollectionDate = cofd(Q202D) + msofhours(real(substr(Q202T,1,2))) + msofminutes(real(substr(Q202T,4,2))) 
	label var bloodCollectionDate "Date/Time of Blood Collection"
	
	
	collapse	(sum) bloodSpecimens = everBloodSpecimenCollect ///
				(min) firstBloodCollDate=bloodCollectionDate ///
				(max) lastBloodCollDate=bloodCollectionDate , by(childID)
	tempfile anisaBloodCollectionData
	saveold `anisaBloodCollectionData', replace


use `"`path'/AnisaForm7b.dta"', clear
gen childID = CountryCode + SiteCode + StudyId + ChildSl
rename SpecimenID respID
capture assert length(childID)==8
if _rc!=0 {
	di as error "There are row in AnisaForm7b where one or more of CountryCode, SiteCode, StudyID, ChildSl are missing - will be dropped"
	drop if length(childID)!=8
}
label var childID "Child ID Number (Country + Site + StudyId + ChildSl)
order childID respID
//check for duplicates in respID
duplicates report respID
capture assert r(unique_value)== r(N)
if _rc!=0 {
	di as error "There are duplicate respiratory ID (SpecimenID in AnisaForm7b is renamed respID) in AnisaForm7b...Problem is ignored."
}

compress
notes: primary key is respID
saveold AnisaLab7bData,replace

	gen everRespSpecimenCollect=0
	destring Q201, replace
	destring Q202, replace
	replace everRespSpecimenCollect=1 if Q201==1 | Q202==1
	gen double respCollectionDate = cofd(Q203D) + msofhours(real(substr(Q203T,1,2))) + msofminutes(real(substr(Q203T,4,2))) 
	label var respCollectionDate "Date/Time of Resp Collection"

	collapse 	(sum) respSpecimens = everRespSpecimenCollect ///
				(min) firstRespCollDate=respCollectionDate ///
				(max) lastRespCollDate=respCollectionDate, by(childID)
	tempfile anisaRespCollectionData
	saveold `anisaRespCollectionData', replace


	****************************************************************************
	//  FINALLY, LETS CREATE A TABLE THAT SUMMARIZES INFORMATION ABOUT VISITS; ONE ROW PER BABY
	****************************************************************************
	use AnisaCHWVisitData,clear
	
	gen double ageAtRegistration = ageAtVisit if registration==1 & formSource==0
	egen double ageAtLastKnownVS = max(ageAtVisit) if missing(babyalive)==0, by(childID)
	replace ageAtLastKnownVS = hours(deathDate-birthDate) if deathDate!=.
	gen lastKnownVS = babyalive if ageAtVisit == ageAtLastKnownVS
	replace lastKnownVS=2 if deathDate!=.
	gen complSchedVisit = babypres==1 & visitstatus==1 & inlist(visitType,0,3)==1
	gen complAnyVisit = babypres==1 & visitstatus==1
	gen everReferred = inlist(babyreferred,1,2)
	 
	collapse (max) birthDate birthDateStatus registration ageAtRegistration  livebirth lastKnownVS everReferred form3Control (min) ageAtLastKnownVS deathDate (sum) complSchedVisit complAnyVisit, by(childID SiteCode)
	label var birthDate "Date/time of birth"
	label var birthDateStatus "Status of birth date information"
	capture label def birthDateStatus 1"Exists" 2"Missing"
	label values birthDateStatus birthDateStatus
	label var ageAtRegistration "Age at Registration/Form 3 (hours)"
	label var everReferred "Baby was ever Referred by the CHW"
	label var complSchedVisit "Number of baby assessments in scheduled visits"
	label var complAnyVisit "Number of baby assessments in any visits"
	label var lastKnownVS "Vital Status at maximum Age when Vital Status is known"
	label var ageAtLastKnownVS "Maximum age when vital status is known (hours)"
	label var registration "Baby was registered (i.e. F3Q206==1 and inlist(F3Q131,1,2))"
	label var livebirth "Baby was born alive"
	capture label def lb 0"Not born alive" 1"Born alive"
	label values livebirth lb
	label var deathDate "Date and Time of Death for this Baby"
	label var form3Control "Baby was selected as Control at time of registration/Form3"
	capture label def yesno 1"Yes" 0"No", modify
	
	recode registration 2=0
	recode form3Control 2=0
	
	label values registration form3Control yesno

	//grab everBlood, everResp from the lab data
	
	merge 1:1 childID using `anisaBloodCollectionData',keep(1 3) gen(hasAnyForm7a)
	replace  bloodSpecimens=0 if bloodSpecimens==.
	label var bloodSpecimens "Number of blood specimens collected"
	label var firstBlood "Date/time of first blood specimen"
	label var lastBlood "Date/time of last blood specimen"
	label var hasAnyForm7a "Baby has one or more 7a forms"
	recode hasAnyForm7a 1=0 3=1
    
	
	
	merge 1:1 childID using `anisaRespCollectionData',keep(1 3) gen(hasAnyForm7b)
	replace  respSpecimens=0 if respSpecimens==. 
	label var respSpecimens "Number of NP/Throat specimens collected"
	label var firstResp "Date/time of first NP/Throat specimen"
	label var lastResp "Date/time of last NP/Throat specimen"
	label var hasAnyForm7b "Baby has one or more 7b forms"
	recode hasAnyForm7b 1=0 3=1
	
	label values hasAnyForm7a hasAnyForm7b yesno
	
	
	format firstBlood lastBloodCollDate  %tc
	format firstResp  lastRespCollDate %tc
	
	//Update March 16th, 2015 - Get sex variable from Form 3
	capture drop _merge
	merge 1:1 childID using AnisaBabyData, keepusing(F3Q204 F3Q205)
	assert _merge==3
	//gen sex variable
	gen sex = F3Q205
	replace sex = F3Q204 if missing(sex)==1 & missing(F3Q204)==0
	label var sex "Sex"
	label def sex 1"Male" 2"Female"
	label values sex sex
	drop F3Q204 F3Q205
	
	
	//Update May 19th, 2014 - Added "Main Study" variable to reflect default start dates
	gen 	mainStudy =	1 if (SiteCode==1 & dofc(birthDate)>=d(01nov2011) & dofc(birthDate)<d(01jan2014))
	replace	mainStudy = 1 if (SiteCode==3 & dofc(birthDate)>=d(01jan2012) & dofc(birthDate)<d(01jan2014))
	replace	mainStudy = 1 if (SiteCode==4 & dofc(birthDate)>=d(01mar2012) & dofc(birthDate)<d(01jan2014))
	replace	mainStudy = 1 if (SiteCode==5 & dofc(birthDate)>=d(01aug2013) & dofc(birthDate)<d(01mar2015))
	replace	mainStudy = 1 if (SiteCode==6 & dofc(birthDate)>=d(01aug2013) & dofc(birthDate)<d(01mar2015))
	
	replace mainStudy = 2 if birthDateStatus==2
	replace mainStudy = 0 if mainStudy==.
	label define mainStudy 0"Pilot" 1"Main" 2"Undefined (DOB==.)"
	label var mainStudy "Main Study=1, Pilot Data=0, Undefined=2"
	label values mainStudy mainStudy
	
	//Update September 29th 2014 - pull gestational age at birth for each baby
	//This data comes from the date of birth/delivery, and the LMP from women
	
	//Update September 21st, 2015 - also pulling F2Q504, and making facility variable

	capture drop _merge
	gen motherID = substr(childID, 1, 7)
	label var  motherID "Study ID for Mother (first seven digits of childID)"
	merge m:1 motherID using AnisaMotherData, keepusing(F1Q233 F2Q504) keep(1 3)
	rename F1Q233 lmp
	replace lmp = . if lmp==d(01jan3000)
	label var lmp "LMP reported by woman on Form 1 (Q233)
	gen ga = (dofc(birthDate)-lmp)/7.0
	
	label var ga "Gestational age at birth, days"
	assert inlist(_merge,3)==1
	drop _merge
	gen facilitybirth = inlist(F2Q504,2,3,4,5,10,11,12,13)==1
	replace facilitybirth=. if missing(F2Q504)==1
	drop F2Q504
	label var facilitybirth "Baby born in facility (F2Q504=2,3,4,5,10,11,12,13)"
	
	preserve

		use AnisaPhyData,clear
		keep childID F6Q501
		keep if F6==1
		keep childID
		duplicates drop
		tempfile hosp6
		save `hosp6', replace
		clear
		use AnisaCHWVisitData
		keep childID visitdate visittime birthDate admitted admitdate
		keep if admitted==1
		gen ageAtAdmit = admitdate-dofc(birthDate)

		//note, I'm only going to keep admit dates that are within 0-60 days. This
		//means that negative admit ages or missing admit ages, will be dropped.
		keep if ageAtAdmit>=0 & ageAtAdmit<60
		//later, if ageAtAdmit is 0, and facilityborn==1, then I'll consider those as non-hospitalized

		//get facility-born
		gen motherID = substr(childID, 1, length(childID)-1)
		merge m:1 motherID using AnisaMotherData, keep(1 3) keepusing(F2Q504)
		gen facility = inlist(F2Q504,2,3,4,5)==1
		drop F2
		drop if ageAtAdmit==0 & facility==1
		//okay, now make baby-level
		keep childID
		append using `hosp6'
		duplicates drop
		tempfile hospkids
		save `hospkids', replace
	restore

	merge 1:1 childID using `hospkids', gen(everHosp)
	recode everHosp 3=1 1=0
	label values everHosp yesno
	label var everHosp "Ever hospitalized, according to Forms 3,4a,4b,5,6"

	
	//Need to also create a variable which is maxAgeAtForm6
	preserve
		use AnisaPhyData,clear
		keep childID visitDate
		collapse (max) visitDate, by(childID)
		rename visitDate lastPhyAssessment
		label var lastPhyAssessment "Date/time of last Form 6"
		tempfile maxForm6Date
		save `maxForm6Date', replace
	restore
	merge 1:1 childID using `maxForm6Date', keep(1 3)
	drop _merge
	
	
	//Final value labeling
	label def lastKVS 1"Alive" 2"Dead"
	label values lastKnownVS lastKVS
	label values everReferred facilitybirth yesno

	label define CountL 	1 "Bangladesh" 2 "India" 3 "Pakistan", modify
	label define SiteL		1 "Sylhet" 3 "Karachi" 4 "Matiari" 5 "Vellore" 6 "Odisha", modify
	label values SiteCode SiteL

	

	notes drop _all
	compress
	saveold AnisaSummaryData, replace





