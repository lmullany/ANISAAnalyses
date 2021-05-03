clear
set more off

use "../../AnalyticFilesForExternalSharing/AnisaEtiologyAnalyticFile.dta"

//lets find out something about these children whose assessments were never case nor control
egen everCaseControl = max(rowStatus), by(childID)
keep if everCaseControl==0
codebook childID

//Create Hierarchical reason why neither control or case
label define rea 1"PSI Met, but Fast Breather Only"
label define rea 2"PSI Met, but Hospitalized Previous 7 days", modify
label define rea 3"Not PSI, but was PSI in the prior 7 days", modify
label define rea 4"Not PSI, but was PSI in the post 7 days", modify
label define rea 5"Not PSI, but CHW referred for PSI in post 7 days", modify
label define rea 6"Not PSI, but was hospitalized in prior 7 days", modify
label define rea 7"Not PSI, but died within 7 days", modify

gen rea=.
replace rea = 1 if rea==. & psi==1 & fastBreathOnly==1
replace rea = 2 if rea==. & psi==1 & prior7_hosp==1
assert psi==0 if rea==.
replace rea = 5 if rea==. & psi==0 & chwSepsisW7!=0
replace rea = 4 if rea==. & psi==0 & post7_psi == 1
replace rea = 3 if rea==. & psi==0 & prior7_psi == 1
replace rea = 7 if rea==. & psi==0 & hours(deathDate-visitDate)<168
replace rea = 6 if rea==. & psi==0 & prior7_hosp==1
label values rea rea
tab rea Site
gen signs = inlist(rea,1,2)
tab signs Site
