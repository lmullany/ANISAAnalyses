*** This is a little ado file that will allow
*** fast labeling of variables with the very
*** common 1-yes, 0-no label

*** written July 01 03 by Luke C. Mullany
*** UPDATED MARCH 21ST, 2017 (LUKE C MULLANY) (ADDED DK OPTION TO ADD DON'T KNOW LABEL FOR 9)

version 7.0

program define phyesno
syntax varlist, [dk]

	capture label drop ph_yn

label define ph_yn 1"Yes"0"No"
if "`dk'"=="dk" label define ph_yn 9"Don't Know", modify
foreach var of local varlist {
	label values `var' ph_yn
	if "`dk'"=="" replace `var'=. if `var'!=1 & `var'!=0
}
end
