//==========================================================================
//	Creating variables for Selecting Woman
//	Creation date: November 23, 2014
//	Comments: 
//==========================================================================

//==========================================================================
//	Updated - December 3rd, 2014
//	Luke C. Mullany
//	Changes allow for running in current directory (i.e. StataCode)
//	using only AnisaMotherData and AnisaBabyData, and other key files
//==========================================================================

//==========================================================================
//	Updated - May 19, 2015
//==========================================================================

//==========================================================================
//	Updated - may 20, 2015
//	Luke C Mullany
//	Updating so mDied is only among those whose pregnancy ended during study
//==========================================================================


clear
//not needed in STATA 12.0/13.0
//set matsize 8000
//set memory 512m
set more off

//cd 		"D:\ANISA\DataFile\Working File\"
//use 	"D:\ANISA\DataFile\Working File\AnisaBabyData",clear

use 	"../AnisaBabyData",clear

keep 	motherID childID F3Q121 F3Q131 F3Q201 F3Q202
bysort 	motherID: gen OutResult=_N

/* Temporary change F3Q131 for some mothers, in order to make consistent over twins
	See email on January 13th, 2015 from Luke to Sajib re this, and associated
	Excel document that describes the rationale for the changes
*/

//First, update some F3Q131 - these are changes that eventually i think we should
//make in the actual source database

replace F3Q131 = 2 if childID=="11085662"
replace F3Q131 = 1 if childID=="11096361"
replace F3Q131 = 1 if childID=="11121271"
replace F3Q131 = 1 if childID=="11127542"
replace F3Q131 = 1 if childID=="11136762"
replace F3Q131 = 1 if childID=="11162432"
replace F3Q131 = 1 if childID=="11178182"
replace F3Q131 = 1 if childID=="11199502"
replace F3Q131 = 1 if childID=="11211243"
replace F3Q131 = 1 if childID=="11222582"
replace F3Q131 = 1 if childID=="11235732"
replace F3Q131 = 1 if childID=="11249662"
replace F3Q131 = 1 if childID=="11255042"
replace F3Q131 = 1 if childID=="11276402"
replace F3Q131 = 1 if childID=="11282093"
replace F3Q131 = 1 if childID=="11282092"
replace F3Q131 = 1 if childID=="11282922"
replace F3Q131 = 1 if childID=="11358722"
replace F3Q131 = 1 if childID=="25015141"
replace F3Q131 = 1 if childID=="33007622"
replace F3Q131 = 1 if childID=="33090182"
replace F3Q131 = 1 if childID=="26098242"


//third - handle if one of multiple babies is refused - this is NOT a change we should make in the database, 
//but is being made here temporarily to enable the creation of the flowchart
//Note that this refusal is a baby-specific variable; since the two women who
//refused for one baby, allowed the other baby to go forward and be enrolled, these
//pregnancies must have the "Enrolled/complete" status in the flowchart (as long
//as the date of course fits in the Main Study (not pilot) phase)

//drop if childID=="26098242"
drop if childID=="33315162"
drop if childID=="33040122"

//We have to update some cases where Form 2 indicates 2 births (live or still) and
//there are 2 Form 3s, but one of them is refused

//replace F3Q202 = 1 if motherID=="2609824"
replace F3Q202 = 1 if motherID=="3304012"
replace F3Q202 = 1 if motherID=="3331516"




*****************************************************************************************************************
gen			LB = F3Q201==1 | (F3Q201==2 & F3Q202==1) | (F3Q201==. & F3Q202==1)			// LB
gen			SB = LB==0 & ( (F3Q201==2 & F3Q202==2) | (F3Q201==. & F3Q202==2) )				// SB


for var 	LB SB : bysort motherID : egen	TX=sum(X)

gen	TCh=TLB+TSB

//for var 	LB SB TSB TLB TCh: replace X=. if F3Q131>2
*****************************************************************************************************************

duplicates drop motherID F3Q131, force
duplicates tag motherID, gen(dup)
capture assert dup==0
if _rc!=0 {
	sort motherID childID
	list if dup!=0, sepby(motherID)
	tab dup
	noi di as error "There are duplicates - check for variation in F3Q131 within twins/triplets"
	list if dup==1 & F3Q131!=1
	drop if dup==1 & F3Q131!=1
}
//			This line is written as outcome result in Form 3 does not match with Form 2

tempfile varsFromBabyData
saveold `varsFromBabyData', replace

//Lets also save a version with Q201 split wide
use 	"../AnisaBabyData",clear
keep motherID childID F3Q131 F3Q201 F3Q202
gen order = substr(childID,length(childID),.)
drop childID
reshape wide F3Q131 F3Q201 F3Q202, i(motherID) j(order) string
tempfile wideBabyStatus
save `wideBabyStatus', replace

use 	"../AnisaMotherData",clear

replace F2Q501=1 if inlist(F2Q501,4,5,6) 

// Update the Baby's status in Form 2 (Q503) same as Form 3
// This value may bee corrected by the site.

replace F2Q503a=2 if motherID=="3301249"
replace F2Q503b=1 if motherID=="3301249"
replace F2Q503c=2 if motherID=="3301249"

replace F2Q503a=1 if motherID=="3402474"
replace F2Q503b=2 if motherID=="3402474"
replace F2Q503c=2 if motherID=="3402474"

***************************************************************




***************************************************************

merge 1:1 motherID using `varsFromBabyData'
capture assert _merge!=2
if _rc!=0 {
	di as error "There are mothers in baby file that don't match motherID in mother file!
	exit
}
rename _merge hasForm3
label var hasForm3 "Merged with one or more Form 3"
label def merge3stat 1"No Form 3" 3"Has Form 3"
label values hasForm3 merge3stat

merge 1:1 motherID using `wideBabyStatus'
capture assert _merge!=2
if _rc!=0 {
	di as error "There are mothers in wide baby file that don't match motherID in mother file!
	exit
}
rename _merge hasForm3Wide
label var hasForm3Wide "Merged with one or more Form 3"
label def merge3statw 1"No Form 3" 3"Has Form 3"
label values hasForm3Wide merge3statw


gen		MinDt 	= min(F1Q233+270, F2Q121-59, F3Q121-59)
gen		EDD		= F1Q233+270
format  MinDt EDD	%d

gen		delDateType	=	cond(delivDate~=.,1,2)
label 	define DDTL		1 "Actual delivery date" 2 "Estimated delivery date"
label 	var	delDateType	"Delivery date - Actual / Estimated"
label 	val delDateType	DDTL

//This replacement is not correct, and I have commented it out
*replace delivDate=dhms(MinDt,0,0,0) if delivDate==.


//The delivDate should be MinDt only if the status on Form 2 or 3 is not met for 59 days, otherwise the 
//estimated delivDate should be EDD
replace delivDate=dhms(MinDt,0,0,0) if delivDate==. & (F2Q131==4 | F3Q131==4)
replace delivDate=dhms(EDD,0,0,0) if delivDate==.

*****************************************************************************************************************
// Correction of Outcome type

//Manual correction for special cases (LB + SB, but the SB is refused on Form 3)
replace TSB = 1 if inlist(motherID,"3304012","3331516")==1


replace F2Q503b=2  if F2Q503b==1 & TSB==0 & inlist(TLB,1,2,3) & inlist(motherID,"3304012","3331516")==0
replace F2Q503a=1  if F2Q503a==2 & TSB==0 & inlist(TLB,1,2,3) 

replace F2Q503a=2  if F2Q503a==1 & TLB==0 & inlist(TSB,1,2,3)
replace F2Q503b=1  if F2Q503b==2 & TLB==0 & inlist(TSB,1,2,3) 

replace F2Q501=TCh if F2Q501~=TCh & F2Q503c==2 & TCh~=. & inlist(motherID,"3304012","3331516")==0


*****************************************************************************************************************

// NEED TO CHECK THE CREATED VARIABLES BY TAKING
// CROSS TABLES

gen 		AppWoman	= cond(trim(motherID)~="" ,1 ,0)
label var	AppWoman	"Woman approached for Form 1"

//Was this a false pregnancy?
gen 		NotPreg 	= AppWoman==1 & F2Q131==5
replace 	NotPreg 	= . if AppWoman==0
label var	NotPreg		"Not Pregnant"

//Did the woman refuse to be in the study?
gen 		Refused    	= NotPreg==0 & F2Q502D==. & (F1Q123==2 | (inlist(F1Q123,3,4) & F1Q124==99))
replace 	Refused 	= . if NotPreg==1
label var	Refused		"Refused or Consent not given"
	
//If the woman was approach, was pregnant, and agreed, then this is consented
gen		Consent		= cond(AppWoman==1 & NotPreg==0 & Refused==0, 1, 0)
replace Consent 	= . if NotPreg==1
label var	Consent	"Women gave consent or woman had pregnancy outcome"

//Now, among Consenting women, lets figure out if they are out because their pregnancy ended prior to study start?
gen		DelBefStDate= 	(SiteCode==1 & delivDate<tc(01nov2011 00:00:00)) | ///
						(SiteCode==3 & delivDate<tc(01jan2012 00:00:00)) | ///
						(SiteCode==4 & delivDate<tc(01mar2012 00:00:00)) | ///
						(SiteCode==5 & delivDate<tc(01aug2013 00:00:00)) | ///
						(SiteCode==6 & delivDate<tc(01aug2013 00:00:00))
replace DelBefStDate = . if Consent!=1
label var	DelBefStDate	"Delivery before start date of Main phase of the Study"

//Now, among those that Delivery Date (actual or predicted) is after the start of the study, lets see if it ended after the study

gen		DelAftEnDate= 	(SiteCode==1 & delivDate>=tc(01jan2014 00:00:00)) | ///
						(SiteCode==3 & delivDate>=tc(01jan2014 00:00:00)) | ///
						(SiteCode==4 & delivDate>=tc(01jan2014 00:00:00)) | ///
						(SiteCode==5 & delivDate>=tc(01mar2015 00:00:00)) | ///
						(SiteCode==6 & delivDate>=tc(01mar2015 00:00:00)) 
replace DelAftEnDate = . if DelBefStDate!=0
label var	DelAftEnDate	"Delivery after end date of the Study"

//Lets make a variable that summarizes Pregnancy Ended During Study Period
gen			DelivStatus = 1 if DelAftEnDate==0
replace 	DelivStatus = 2 if DelBefStDate==1 & DelivStatus==.
replace 	DelivStatus = 3 if DelAftEnDate==1 & DelivStatus==.
replace 	DelivStatus = . if Consent!=1
label var 	DelivStatus "Status of Timing of Delivery - Before/During/After Study"
label def 	delivstatus 1 "During Study" 2"Before Study" 3"After Study"
label 		values DelivStatus delivstatus


//Migrated
gen 		Migrate	= cond(Consent==1 & DelivStatus==1 & F2Q131==7, 1 ,0)
replace 	Migrate = . if DelivStatus~=1
label var	Migrate		"Migrated out during the Study"

//Maternal Death
gen			MDied =cond(DelivStatus==1 & F2Q131==6, 1, 0)
replace 	MDied = . if DelivStatus!=1

//Absent for 59 Days
gen			Abs59 =cond(DelivStatus==1 & (F2Q131==4 | F3Q131==4) & MDied==0 & Migrate==0, 1, 0)
replace 	Abs59 =. if DelivStatus!=1

gen			OutKnown 	= (F2Q503a~=. | F2Q503b~=. | F2Q503c~=.) & (MDied==0 & Abs59==0 & Migrate==0)
replace 	OutKnown 	= . if DelivStatus!=1
label var	OutKnown	"Known outcome status"

//Refused Outcome Assessment
gen 		RefusedOA = OutKnown==0 & F2Q131==3
replace		RefusedOA = . if DelivStatus!=1
label var RefusedOA "Refused Outcome Assessment (i.e. F2Q131==3)"

//Study Area (Karachi) closed early
gen			StudyAreaClosed = OutKnown==0 & F2Q131==8 & SiteCode==3
replace		StudyAreaClosed = . if DelivStatus!=1
label var	StudyAreaClosed "Study sub-area in Karachi closed early"

//Form 2 Missing
gen			Form2Missing = OutKnown==0 & (F2Q131==. | (F2Q131==8 & SiteCode!=3))
replace		Form2Missing= . if DelivStatus!=1
label var	Form2Missing "Form 2 is Missing"

//Form 3 Missing
gen			Form3Missing = OutKnown==1 & hasForm3Wide==1
replace		Form3Missing= . if DelivStatus!=1
label var	Form3Missing "Form 3 is Missing"


/*
gen 		LostFollowup = DelivStatus==1 & (MDied==1 | Abs59==1 | Migrate==1 | RefusedOA==1)	
replace 	LostFollowup = . if DelivStatus!=1
//0 if DelivStatus==1 & Migrate==0 & LostFollowup==.
label var	LostFollowup	"Lost to follow-up"
*/

gen			ReaOutNKnown=.
replace		ReaOutNKnown=1 if ReaOutNKnown==. & OutKnown==0 & Migrate==1
replace		ReaOutNKnown=2 if ReaOutNKnown==. & OutKnown==0 & MDied==1
replace		ReaOutNKnown=3 if ReaOutNKnown==. & OutKnown==0 & Abs59==1
replace		ReaOutNKnown=4 if ReaOutNKnown==. & OutKnown==0 & RefusedOA==1
replace		ReaOutNKnown=5 if ReaOutNKnown==. & OutKnown==0 & StudyAreaClosed==1
replace		ReaOutNKnown=6 if ReaOutNKnown==. & OutKnown==0 & Form2Missing==1
replace		ReaOutNKnown=7 if ReaOutNKnown==. & OutKnown==0 & Form3Missing==1
replace		ReaOutNKnown=8 if ReaOutNKnown==. & OutKnown==0

label define ReaONKL 1 "Migrated Out" 5 "Sub Area Closed (Karachi)" 6 "Form 2 missing" ///
		7 "Form 3 Missing" 2"Woman Died before Delivery" 3"Absent for 59 Days" 4"Refused Outcome Assessment" ///
		8 "Unknown Reason"
label value ReaOutNKnown ReaONKL

gen			LiveBirths = 1 if OutKnown==1 & F2Q503a==1
replace		LiveBirths = 0 if OutKnown==1 & (F2Q503a~=1 & (F2Q503b==1 | F2Q503c==1))
label 		define  OutL 1 "Woman had at least one Live birth" 0 "No Live Births"
label		val LiveBirths OutL
label 		var LiveBirths "Type of outcome of the woman"

capture assert missing(LiveBirths)==0 if OutKnown==1
if _rc!=0 {
	noi list if OutKnown==1 & missing(LiveBirths)==1
	foreach var of varlist F2Q503* {
		noi tab `var' if OutKnown==1
	}
}

gen otherOutcomes=.
replace otherOutcomes = 1 if otherOutcomes==. & LiveBirths==0 & F2Q503b==1 & F2Q503c==2
replace otherOutcomes = 2 if otherOutcomes==. & LiveBirths==0 & F2Q503b==2 & F2Q503c==1
replace otherOutcomes = 3 if otherOutcomes==. & LiveBirths==0 & F2Q503b==1 & F2Q503c==1
label define otherOut 1"Stillbirth(s) only" 2"Miscarriage/Abortion Only" 3"Stillbirth(s) and Miscarriage/Abortion(s) only"
label values otherOutcomes otherOut 


keep StudyId motherID SiteCode AppWoman-otherOut LB TLB TSB hasForm3 hasForm3Wide F2Q501 F2Q503a F2Q503b F2Q503c
compress
notes drop _all
notes drop _dta
saveold		ANISAPregLevelFlowchart, replace
