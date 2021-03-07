//file that creates a very simple version of PregnancyLevelFlowchart

clear
set more off

use ANISAPregLevelFlowchart

gen Pregnant = AppWoman==1 & NotPreg==0
replace Pregnant = . if AppWoman==. | NotPreg==.
label var Pregnant "Approached Woman was Pregnant?"
phyesno Pregnant
drop NotPreg




//Now, need total LiveBirths, total Stillbirths, total Miscarriage
replace TLB = 1 if TLB==0 & LiveBirths==1 & F2Q501==0 & F2Q503a==1
gen totLiveBirths = TLB
replace totLiveBirths = F2Q501 if LiveBirths==1 & Form3Missing==1
replace totLiveBirths = . if OutKnown!=1
label var totLiveBirths "Total Live Births"

gen StillBirths = TSB if otherOutcomes==1 | LiveBirths==1
replace StillBirths = F2Q501 if Form3Missing==1 & F2Q503b==1
replace StillBirths = . if OutKnown!=1
label var StillBirths "Total Stillbirths"

replace StillBirths = 0 if LiveBirths==1 & Form3Missing==1
replace totLiveBirths = 0 if Form3Missing==1 & F2Q503b==1

drop LiveBirths
rename totLiveBirths LiveBirths

gen Miscarriages = otherOutcomes==2
replace Miscarriages = . if OutKnown!=1
label var Miscarriages "Total Miscarriages"
replace LiveBirths = 0 if LiveBirths==. & OutKnown==1
replace StillBirths = 0 if StillBirths==.  & OutKnown==1

order motherID AppWoman Pregnant Consent DelivStatu OutKnown ReaOutNKnown LiveBirths StillBirths Miscarriage 
keep motherID AppWoman Pregnant Consent DelivStatu OutKnown ReaOutNKnown LiveBirths StillBirths Miscarriage
 
label var Rea "Reason that Pregnancy Outcome is Not Known"

//Check: are my special mums ok?
list if inlist(motherID,"3304012","3331516")==1
list if inlist(motherID,"2607749","2604703")==1

notes drop _all
compress
saveold AnisaPregnancyFlowchart, version(12) replace
