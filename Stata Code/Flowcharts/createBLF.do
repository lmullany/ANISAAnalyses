clear
use AnisaPregnancyFlowchart

gen TB = LiveBirths+StillBirths+Miscarriages
keep if TB!=.
expand TB
keep motherID LiveBirths StillBirths Miscarriages TB
*assert _N==75061
assert _N==74968

//deal with miscarriage separately - should never have a Form 3, so no child is expected
//and a quick merge to AnisaBabyData proves this is so
preserve
	keep if Miscarriage==1
	assert TB==1
	merge 1:m motherID using "../AnisaBabyData", keep(1 3) keepusing(motherID)
	assert _merge==1 //even though we kept if 3!
	//so, we can make a synthetic babyID here (add"M") to the motherID
	gen childID = motherID + "M"
	duplicates report childID
	gen outcome = 3
	drop _merge
	tempfile syntheticBabyLevel_miscarriage
	save `syntheticBabyLevel_miscarriage', replace
	
restore
drop if Miscarriage==1

//lets deal with singleton births first
preserve
	keep if TB==1
	count
	local ct=r(N)
	merge 1:m motherID using "../AnisaBabyData", keep(1 3) keepusing(childID)
	assert _N == `ct'
	replace childID = motherID + "S" if _merge==1 & StillBirths==1
	replace childID = motherID + "L" if _merge==1 & LiveBirths==1
	duplicates report childID
	gen outcome=1
	replace outcome=2 if substr(reverse(childID),1,1)=="S"
	replace outcome=2 if StillBirths==1
	drop _merge
	tempfile syntheticBabyLevel_singleton
	save `syntheticBabyLevel_singleton', replace
restore

drop if TB==1
count
total LiveBirths StillBirths Mis
//lets deal with multiples - stillbirths only, first
preserve
	keep if LiveBirths==0
	merge m:m motherID using "../AnisaBabyData", keep(1 3) keepusing(livebirth childID)
	assert _merge==3
	drop _merge
	duplicates report childID
	assert r(unique_value) == r(N)
	gen outcome=2
	drop livebirth
	tempfile syntheticBabyLevel_multiple_s
	save `syntheticBabyLevel_multiple_s', replace
restore
drop if LiveBirths==0

//lets deal with mulitples, livebirths only, second
preserve
	keep if StillBirths==0
	merge m:m motherID using "../AnisaBabyData", keep(1 3) keepusing(livebirth childID)
	assert _merge==3
	drop _merge
	duplicates report childID
	assert r(unique_value) == r(N)
	gen outcome=1
	drop livebirth
	tempfile syntheticBabyLevel_multiple_l
	save `syntheticBabyLevel_multiple_l', replace
restore
drop if StillBirths==0

//Now we have mixed (Stillbirth and Livebirth) multiples remaining
	merge m:m motherID using "../AnisaBabyData", keep(1 3) keepusing(livebirth childID)
	assert _merge==3
	gen outcome = 2 if livebirth!=1
	replace outcome= 1 if livebirth==1
	drop livebirth
	drop _merge
	duplicates report childID
	assert r(unique_value) == r(N)
	tempfile syntheticBabyLevel_multiple_m
	save `syntheticBabyLevel_multiple_m', replace
	
//append

append using `syntheticBabyLevel_multiple_l'
append using `syntheticBabyLevel_multiple_s'
append using `syntheticBabyLevel_singleton'
append using `syntheticBabyLevel_miscarriage'


duplicates report childID
assert r(unique_value) == r(N)

assert _N==74968

merge 1:m childID using "ANISABabyLevelFlowchart.dta", keep(1 3)
drop _merge
replace ReaNotReg = 7 if outcome==1 & registration==0 & Rea==.
replace ReaNotReg = 6 if outcome==1 & registration==. & Rea==.
assert substr(reverse(childID),1,1) == "L" if ReaNotReg==6
label def ReaL 6 "No Form 3 Available" 7"Refused to Provide Registration Information", modify

order childID motherID SiteCode mainStudy

replace mainStudy=1
replace SiteCode = real(substr(childID,2,1)) if missing(SiteCode)==1
replace registration=0 if ReaNotReg==6
replace registration=. if outcome!=1


merge 1:1 childID using "../AnisaSummaryData.dta", keep(1 3) keepusing(everReferred)
drop _merge
replace everReferred=. if registration!=1
rename inEtiology PhyAssessed
label var PhyAssessed "Child was ever assessed by Physician"
replace PhyAssessed = . if registration!=1

gen EtiologyStatus = 0 if CaseCont==0
replace EtiologyStatus=1 if inlist(CaseCont,1,2,3)
label var EtiologyStatus "Child Contributes 1 or more rows to Etiology Analysis"
label values EtiologyStatus yesno

order childID motherID SiteCode main outcome registration ReaNotReg PhyAssessed EtiologyStatus
keep childID motherID SiteCode outcome registration ReaNotReg PhyAssessed EtiologyStatus

label define outcome 1"Livebirth" 2"Stillbirth" 3"Miscarriage"
label values outcome outcome
label var outcome "Birth Outcome Status"

notes drop _all
compress
saveold AnisaBabyFlowchart, replace version(12)

//now, we should update AnisaSummary information with the correct description of livebirth/stillbirth
use "../AnisaSummaryData"
capture confirm new variable outcome
if _rc!=0 {
	noi di as error "Warning, variable outcome already exists in AnisaSummaryData, will NOT be updated.. Must rerun createAnisaWorkingFile to recreate Anisa Summary Data"
	exit
}
else {
	merge 1:1 childID using AnisaBabyFlowchart, keepusing(outcome) keep(1 3)
	replace livebirth = 0 if outcome==2 & livebirth==.
	replace livebirth = 1 if outcome==1 & livebirth==.
	replace livebirth = 2 if livebirth == . 
	drop outcome
	drop _merge
	rename livebirth outcome
	label var outcome "Outcome (Still, Live, Other)"
	label define lb 0 "Stillbirth" 1"Livebirth" 2"Other/Unknown (see Preg Flowchart)", modify
	save "../AnisaSummaryData", replace
}


