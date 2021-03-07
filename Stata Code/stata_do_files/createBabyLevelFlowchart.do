//_____________________________________________________________________
//	Baby Level Flowchart
//	Date: May 20, 2015
//_____________________________________________________________________

//cd 			"D:\Dropbox\Monitoring Code and Reports\Stata Code\Flowcharts"


use 		ANISAPregLevelFlowchart, clear
drop 		hasForm3
//Grab the mother ID information
merge		1:m motherID using "../AnisaSummaryData", keepusing(motherID childID registration mainStudy)
//merge cannot be 2 here..
capture assert _merge!=2
if _rc!=0 {
	di as error "Problem merging to AnisaBaby Data - found mother ID in baby file that is not in AnisaPregLevelFlowchart file"
	exit
}

//We have to check that no babies are "registered" if their
//mothers' status from Flowchart is not "LiveBirths"

capture count if registration==1 & LiveBirths==0
if r(N)!=0 {
	//error
	di as error "We have babies that are registered according to Summary Data, whose mothers did not have a Live Birth as defined by Mother Flowchart!"
	exit
}

//Let's also see what about mothers with Live Births, that don't appear in the Summary Table.. We will need
//a reason for these
count if LiveBirths==1 & _merge==1
local 	extraMothersWithLiveBirths = r(N)
rename _merge MergeMotherLevelToSummaryData
label var MergeMotherLevelToSummaryData "Mother flowchart information merged to Baby Level Information"
qui count if MergeMotherLevelToSummaryData==3
local babyct = r(N) 
keep if LiveBirths==1

//Lets merge with Baby Data so that we can get some critical fields to explain these 111
merge m:1 childID using ../AnisaBabyData, keepusing(F3Q131 F3Q201 F3Q202 F3Q206 F3Q605)
tab _merge

//assert that we still have all the Baby Rows
di `babyct'
capture assert _N == `=`babyct' + `extraMothersWithLiveBirths''
if _rc!=0 {
	di as error "Pregnancy Flowchart merged with Summary Data (1:m, `babyct' ) PLUS extra mothers with LiveBirths, but no rows in AnisaBabyData (`extraMothersWithLiveBirths') does not match current count"
	exit
}

//lets keep if LiveBirths==1 (ok to do this because we are not dropping any babies here that are registered, have checked this above)
keep if LiveBirths==1

//gen missing F3 variable

gen missingForm3 = _merge==1
label var missingForm3 "Form 3 is missing for Pregnancy"

gen hasForm3 = _merge==3
label var hasForm3 "Form 3 is available"

drop _merge

gen refusedForm3 = hasForm3==1 & F3Q131 == 3
replace refusedForm3 = . if hasForm3!=1
label var refusedForm3 "Form 3 Available, but Refused to Provide Information"

//gen birth Outcome
//outcome is 1 (Live Birth) if the baby is still alive on F3, or if the baby is dead, but was born alive
gen birthOutcome = 1 if F3Q201==1 | (F3Q201==2 & F3Q202==1)
replace birthOutcome = 2 if F3Q201==2 & F3Q202==2
label def bout 1"LiveBirth" 2"Stillbirth"
label val birthOutcome bout
label var birthOutcome "Outcome of birth (live vs still)"
assert birthOutcome!=. if hasForm3==1 & refusedForm3==0

//Now, we need to describe registration, status, among all the live births
//We already have registration status (i.e. registration variable), 
//we just need to create a reason Not registered variable

gen		ReaNotRegis     = F3Q206
replace ReaNotRegis     = 5 if F3Q201==2 & F3Q202==1
replace ReaNotRegis     = . if registration!=0 //make this missing if baby's registration status is not "NO"
replace ReaNotRegis		= . if birthOutcome!=1 //make this missing if the baby was not a live birth.. only interested in reason for not registration if baby was born alive

label 	define ReaL 		1  "Eligible" 2 "Baby is absent beyond first 7 days" 3 "Baby has out migrated" 4 "Baby's age is more than 7 days" 5 "Baby Died"
label 	val ReaNotRegis  ReaL
label 	var ReaNotRegis "Reason a live born baby was not registered"


//Now we need to define the SMS selection status for this baby at the time of F3
gen	   	smsSelection	=	cond(F3Q605==1,1,0)
replace smsSelection   	= . if !(registration==1 & birthOutcome==1)
label var smsSelection "At Registration, Baby was SMS-Selected as Control"
label	define  smsSel   1 "Baby selected as Control" 0 "Baby not selected as control"
label 	values	smsSelection smsSel

tempfile tempBabyFlow
save	`tempBabyFlow', replace

use "../CaseControlDefinition/CaseControlOutputFiles/CaseControlRows_wide_overall", clear
//create variables that indicate if everCase or everControl
//Sajib: Need to update in control definition
gen everCase	=	rowStatus==2
gen everCont	=	rowStatus==1
collapse (max) everCase everCont, by(childID bothCaseAndControl)

gen		CaseCont=0  
replace	CaseCont=3 if  both==1
replace	CaseCont=2 if  both==0 & everCase==1
replace	CaseCont=1 if  both==0 & everCont==1

label var CaseCont "Overall Case Control Status"

label 	define CasConL 1 "Control" 2 "Case" 3 "Both Case and Control" 0 "Neither Case nor Control"
label 	val CaseCont CasConL

keep childID CaseCont
tempfile ccStatus
save	`ccStatus', replace

use  	`tempBabyFlow', clear
merge	m:1 childID using `ccStatus'
capture assert _merge!=2 
if _rc!= 0 {
	qui count if _merge==2
	di as error "Warning: there are `r(N)' rows from the Case Control Definition that do not exist among registered Live Births!
	noi list if _merge==2
	drop if _merge==2
	
}
gen hasCaseControlStatus = _merge==3
label var hasCaseControlStatus "Child is defined by Case Control Algorithm"
capture label def yesno 0"No" 1"Yes"
label values hasCaseControlStatus yesno

*************************************************
drop F3Q*
keep childID motherID SiteCode registration mainStudy MergeMother missingForm3-hasCaseControl

//gen inEtiologyFile variable
gen inEtiology = hasCaseCont==1 & registration==1
replace inEtiology = . if registration!=1
label var inEtiology "Child is in FinalEtiologyFile"
label values inEtiology yesno

drop _merge
compress
notes drop _all
notes drop _dta
saveold ANISABabyLevelFlowchart, replace
