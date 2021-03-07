

//==========================================================================
//	Working data files 	: Lab files
//	Blood file with Culture result and Sensitivity test
//	Add the Wet chemestry and BCC result
//	Creation date		: April 7, 2013
// 	Update on			: April 7, 2015
//	Comments: 
//==========================================================================

//==========================================================================
// 	Update on			: July 31, 2016
//	Updated by			: Sajib
//	Line #				: 151 - 178
//	In previous file we use only Zone Diameter value to check Sensitivity pattern of Antibiotic against any Isolates.
//  Now we need to use the MIC value also to check it. I have keep the updated Zone Diameter file in the Dropbox location.
//==========================================================================

clear
set more off
//set memory 512m

//cd 	"D:\ANISA\DataFile\Raw Data File\"


**************************************************
***			Data  Correction in Labfile
***			Delete duplicate records from Sylhet file (information from Site)
**************************************************
use 		"../../Source Anisa Tables/AnisaBACTEC", replace
replace 	SubCul ="2" if inlist(substr(SpecimenID,1,6), "B40221", "B40798", "B41721", "B41821", "B50456", "B60883", "B60887") & SubCul==""
replace	 	BeepCul="2" if inlist(substr(SpecimenID,1,6), "B50456", "B40308", "B40408") & BeepCul==""
replace 	ICT    ="8" if inlist(substr(SpecimenID,1,6), "B30093", "B30109", "B30225") & ICT==""
replace 	ICT="" if BeepCul=="" & ICT~=""
replace		CulGent="" if CulGent~="" & ( SubCul=="1" | BeepCul=="2" | ICT~="" )
tempfile AnisaBACTEC_modify
save `AnisaBACTEC_modify', 		replace



***************************************************************************
***************************************************************************
***		Blood Isolates file 											***
***		Add the final decision from BCC Group							***
***		If decision pending then keep general decision (by LabPer)		***
***		For multiple growth if 2nd/3rd Org name is missing then drop it	***
***************************************************************************

use		"../../Source Anisa Tables/LabBloodD.dta", clear
drop 		EnDt EditUser LabID
gen			GenSp = Genus+Species
gen 		LabID = substr( SpecimenID,2,5)
replace		GenSp = "9999" if GenSp=="." | GenSp==""
sort		GenSp
merge		m:1 GenSp using "../../Source Anisa Tables/OrgName.dta"
gen 		GSName = substr( GenusName,1,4)+"."+substr( SpName ,1,4)
drop 		if _merge==2 | (GenSp=="9999" & SLNo==3)
drop 		_merge Genus Species GenusCode SpCode GenusName SpName 

reshape 	wide 	ChocolateGrowth-Citrate GenSp GenSpName GSName Type, i(SiteCode SpecimenID) j(SLNo)

for var 	GSName*: replace X="" if X=="."
gen 		GenSpName = GSName1
replace		GenSpName = GenSpName + "+" + GSName2 if GSName2~=""
replace		GenSpName = GenSpName + "+"  + GSName3 if GSName3~=""
for var 	GenSpName GenSpName1: replace X="Missing" if X=="" 
drop 		GSName1 GSName2 GSName3
replace 	SpecimenID=substr(SpecimenID,1,6)
sort 		SpecimenID 
for var 	Type*: replace X="3" if X=="Definite Contaminant" 
for var 	Type*: replace X="1" if X=="Definite Pathogen" 
for var 	Type*: replace X="2" if X=="Probable Pathogen" 
destring 	Type*, replace

merge		1:1 SpecimenID using "../../Source Anisa Tables/bloodCommitteeFinalResults.dta", gen(BCMatch) keepusing(childID BCCReviewed reasonNotReviewed FinalPathogen FinalDecision FinalDetermination bc_org)
capture assert BCMatch==3
if _rc!=0 {
	di as error "We have rows in the blood culture committee file that don't match the source"
	exit
}

drop BCMat

label var FinalDecision "Final Decision of the BBC"
label var FinalDetermination "Final Determination, after incorporating BCC"

//gen FinalDeterminationFrm variable which will indicate where the final determination came from
gen FinalDeterminationFrm = 1 if inlist(FinalDecision, "Definite Pathogen", "Definite Contaminant")==1
replace FinalDeterminationFrm = 2 if FinalDetermination!=. & FinalDeterminationFrm!=1

label var bc_org "For Pathogens, the 4-digit code for Etiology Analysis"

foreach var of varlist ChocolateGrowth1- Type3 GenSpName {
	destring `var', replace
}

gen		LabVar=0
do		"../stata_do_files/ANISA - Variable labels - Lab"

order 		SiteCode childID SpecimenID LabID GenSpName GenSp1 GenSpName1 Type1 GenSp2 GenSpName2 Type2 GenSp3 GenSpName3 Type3 BCCReviewed reasonNotReviewed FinalPathogen FinalDecision FinalDetermination FinalDeterminationFrm bc_org
save		LabOutputFiles/BldOrg, replace



***********************************************************************
***		Merge with Zone Diameter file to add Sensitivity pattern	***
***		First reshape the file in Long format 						***
***********************************************************************
use 		`AnisaBACTEC_modify', replace
replace 	SpecimenID=substr(SpecimenID,1,6)
compress 	SpecimenID
sort 		SpecimenID
merge		1:1 SpecimenID using LabOutputFiles/BldOrg
gen			GenSp = GenSp1
replace		GenSp = GenSp2 if Antibiogram=="2" & GenSp2~=.
replace		GenSp = GenSp3 if Antibiogram=="3" & GenSp3~=.

gen			aa=0
for var 	*Disc: replace aa=1 if (real(X)>=0 & real(X)<=99)
replace 	Antibiogram="1" if Antibiogram=="" & aa==1
replace 	Antibiogram="8" if Antibiogram=="" & Result=="1"
drop		aa
drop 		if Antibiogram>"3"

***********************************************************************
//			Update from here for EStrip value (earlier we did not keep this variable)
***********************************************************************
keep		SpecimenID Antibiogram GenSp *Disc *EStrip

renvars 	AmikacinDisc AmoxicillinDisc AmpicillinDisc AztreonamDisc AzythromicinDisc CarbenicillinDisc CefepimeDisc CefiximeDisc CefotaximeDisc CefoxitinDisc CeftazidimeDisc ///
			CefuroximeOralDisc CefuroximeParenDisc CephalexinDisc ChloramphenicolDisc CiprofloxacinDisc ClavulanicDisc ClindamycinDisc CloxacillinDisc CotrimoxazoleDisc ///
			ErythromicinDisc FusidicDisc GentamicinDisc ImipenemDisc LevofloxacinDisc LinezolidDisc MeropenemDisc MetronidazoleDisc NalidixicDisc NetilmicinDisc OfloxacinDisc ///
			OxacillinDisc PenicillinDisc PolymyxinDisc TazobactamDisc TetracyclineDisc TobramycinDisc VancomycinDisc CeftriaxoneDisc/ Ant1 Ant36 Ant2 Ant25 Ant3 Ant30 Ant22 Ant27 Ant5 Ant37 ///
			Ant6 Ant34 Ant33 Ant8 Ant9 Ant10 Ant46 Ant35 Ant11 Ant12 Ant13 Ant38 Ant14 Ant15 Ant23 Ant39 Ant24 Ant40 Ant16 Ant17 Ant41 Ant19 Ant20 Ant42 Ant43 Ant21 Ant44 Ant32 Ant7
renvars		AmikacinEStrip AmoxicillinEStrip AmpicillinEStrip AztreonamEStrip AzythromicinEStrip CarbenicillinEStrip CefepimeEStrip CefiximeEStrip CefotaximeEStrip CefoxitinEStrip ///
			CeftazidimeEStrip CefuroximeOralEStrip CefuroximeParenEStrip CephalexinEStrip ChloramphenicolEStrip CiprofloxacinEStrip ClavulanicEStrip ClindamycinEStrip ///
			CloxacillinEStrip CotrimoxazoleEStrip ErythromicinEStrip FusidicEStrip GentamicinEStrip ImipenemEStrip LevofloxacinEStrip LinezolidEStrip MeropenemEStrip ///
			MetronidazoleEStrip NalidixicEStrip NetilmicinEStrip OfloxacinEStrip OxacillinEStrip PenicillinEStrip PolymyxinEStrip TazobactamEStrip TetracyclineEStrip ///
			TobramycinEStrip VancomycinEStrip CeftriaxoneEStrip/ Est1 Est36 Est2 Est25 Est3 Est30 Est22 Est27 Est5 Est37 Est6 Est34 Est33 Est8 Est9 Est10 Est46 Est35 Est11 Est12 Est13 Est38 ///
			Est14 Est15 Est23 Est39 Est24 Est40 Est16 Est17 Est41 Est19 Est20 Est42 Est43 Est21 Est44 Est32 Est7

tostring 	GenSp, replace
replace 	GenSp="0"+GenSp if length(trim(GenSp))==3

reshape  	long Ant Est, i(SpecimenID) j(AntCode)
replace 	Est="16.304" if Est=="16:304"
replace 	Est="1.19"   if Est=="1::19"

rename		AntCode AC
gen			AntCode = AC
tostring 	AntCode, replace
for var 	AntCode : replace X="0"+AntCode if length(AntCode)==1
drop if 	GenSp=="."
destring	Ant Est, replace

save		LabOutputFiles/AntibiogramData, replace

***********************************************************************
// 			Should check the updated file
//			replace		AntCode="80" if GenSp=="1838" & AntCode=="10" & (substr(SpecimenID,2,1)=="3" | substr(SpecimenID,2,1)=="4" )
***********************************************************************v
sort 		GenSp AntCode
merge		m:1 GenSp AntCode using "../../Source Anisa Tables/ZoneDiam.dta"

gen		SiteCode =substr(SpecimenID,2,1)
sort 		SiteCode SpecimenID
drop		if _merge==2
rename		Ant		AntValue
rename		Est		EStpValue
*next line is not necessary, already byte (not character)
//for var		RMin-SMax: replace X="" if X=="NULL"
*line not necessary, already byte (not character)
//for var		RMin-SMax: destring X, replace
***********************************************************************
// 			Need to update the following codes
//			To check the sensitivity pattern we have to use the MIC value
//			in previous "ZoneDiam" (Zone diameter) file we did not have the min max value for sensitivity/ registent
//			Now we have it 
***********************************************************************v
//gen			Sensitivity = .
//replace		Sensitivity = 1 if Sensitivity==. & inrange(AntVal,RMin,RMax)
//replace		Sensitivity = 2 if Sensitivity==. & inrange(AntVal,IMin,IMax)
//replace		Sensitivity = 3 if Sensitivity==. & inrange(AntVal,SMin,SMax)
//replace		Sensitivity = 9 if Sensitivity==. & _merge==1 & AntValue~=.
//replace		Sensitivity = 8 if Sensitivity==.

***********************************************************************
gen			Sensitivity = .
replace		Sensitivity = 1 if Sensitivity==. & inrange(AntValue,RMin,RMax) & RMin~=.
replace		Sensitivity = 2 if Sensitivity==. & inrange(AntValue,IMin,IMax) & IMin~=.
replace		Sensitivity = 3 if Sensitivity==. & inrange(AntValue,SMin,SMax) & SMin~=.

*next lines fail, because no variable called EStpValue... 
replace		Sensitivity = 1 if inrange(EStpValue,MRMin,MRMax) & MRMin~=. & inlist(Sensitivity,1,2,.) & EStpValue~=. 	
replace		Sensitivity = 2 if inrange(EStpValue,MIMin,MIMax) & MIMin~=. & inlist(Sensitivity,1,2,.) & EStpValue~=. 
replace		Sensitivity = 3 if inrange(EStpValue,MSMin,MSMax) & MSMin~=. & inlist(Sensitivity,1,2,.) & EStpValue~=. 	
replace		Sensitivity = 8 if GenCode!="" & Sensitivity==. & AntValue!=.
drop 		RMin- SMax MSMin-MRMax Comm _merge AC GenCode SpCode SiteCode
destring	AntCode, replace
***********************************************************************

///Chk the program
//reshape 	wide GenSp AntName Sensitivity RMin RMax IMin IMax SMin SMax AntValue , i(SpecimenID) j(AntCode)
reshape 	wide GenName SpName GenSp AntName AntValue EStpValue Sensitivity, i(SpecimenID) j(AntCode)
for var 	Sensitivity*: replace X=8 if X==.
drop		AntName* GenSp* GenName* SpName*

// 			++++++++++++++++++++++++++++++++++++++++++++++++
// 			Check the following variables for new data files 
//			Excel File Zone Diameter - Last Sheet 
renvars		Sensitivity*\ AmikacinSen AmpicillinSen AzythromicinSen CefotaximeSen CeftazidimeSen CeftriaxoneSen CephalexinSen ChloramphenicolSen CiprofloxacinSen CloxacillinSen CotrimoxazoleSen ErythromicinSen GentamicinSen ImipenemSen NalidixicAcidSen NetilmicinSen OxacillinSen PenicillinSen TetracyclineSen CefepimeSen LevofloxacinSen MeropenemSen AztreonamSen CefiximeSen CarbenicillinSen VancomycinSen CefuroximParenSen CefuroximeOralSen ClindamycinSen AmoxicillinSen CefoxitinSen FusidicAcidSen LinezolidSen MetronidazoleSen OfloxacinSen PolymyxinBSen TazobactamSen TobramycinSen ClavulanicAcidSen
gen			CefuroximeaxetilSen = 8 	//Sensitivity4	
gen			OptocinSen			= 8		//Sensitivity18
gen			NitrofurantoinSen	= 8		//Sensitivity26
gen			CefuroximeSen 		= 8		//Sensitivity28
gen			DoxycyclineSen 	    = 8		//Sensitivity29
gen			MethicillinSen 		= 8		//Sensitivity31
gen			CefuroximeParenSen 	= 8		//Sensitivity33
gen			PolymyxinSen		= 8		//Sensitivity42

for var		*Sen: replace X=8 if X==.
gen 		LabVar=1
do			"../stata_do_files/ANISA - Variable labels - Lab"
//drop		RMin* RMax* IMin* IMax* SMin* SMax*
sort 		SpecimenID
save 		LabOutputFiles/AntibioticSensitivityData, replace

*===================================================================*
use 		`AnisaBACTEC_modify', replace
replace 	SpecimenID=substr(SpecimenID,1,6)
compress 	*
sort 		SpecimenID
merge		1:1 SpecimenID using LabOutputFiles/BldOrg, keep(1 3)
drop 		_merge
sort 		SpecimenID
merge		1:1 SpecimenID using LabOutputFiles/AntibioticSensitivityData
drop 		_merge

drop 		ChName Diagnosis *EStrip
replace 	Result="1" if SubCul=="1"
gen			aa=0
for var 	PenicillinDisc- ClavulanicDisc: replace aa=1 if (real(X)>=0 & real(X)<=99)
replace 	Antibiogram="1" if Antibiogram=="" & aa==1
replace 	Antibiogram="8" if Antibiogram=="" & Result=="1"

//========================================================================================*
//***	Generate date time variables
//========================================================================================*
generate 	double PutDtTm  = 	dhms(PutDate,  real(substr(PutTime,1,2)),  real(substr(PutTime,4,2)), 0)
generate 	double BeepDtTm = 	dhms(BeepDate, real(substr(BeepTime,1,2)), real(substr(BeepTime,4,2)), 0)
generate 	double OutDtTm  = 	dhms(OutDate,  real(substr(OutTime,1,2)),  real(substr(OutTime,4,2)), 0)

for var		PutTime BeepTime OutTime: replace X="" if X=="__:__"
for var 	PutDtTm BeepDtTm OutDtTm: format X %tc

gen			TTPHr = int((OutDtTm -  PutDtTm)/(1000*60*60))
gen			TTPDy = int((OutDtTm -  PutDtTm)/(1000*60*60*24))
for var 	TTPHr TTPDy : replace X=999 if OutDate==.
//=======================================================================*

for var 	SiteCode Age-Antibiogram AmikacinDisc-ClavulanicDisc Sex- Antibiogram API: destring X, replace
gen			OrgAntibiogram = ""
replace		OrgAntibiogram = GenSpName1 if Antibiogram==1
replace		OrgAntibiogram = GenSpName2 if Antibiogram==2
replace		OrgAntibiogram = GenSpName3 if Antibiogram==3

for   var 	*Sen: replace X=. 	if GenSpName==""
drop 		EnteroScore* NonEnteroScore* EditUser Reported  Isolate1- Isolate3   
replace		LabVar=2
do			"../stata_do_files/ANISA - Variable labels - Lab"

//========================================================================================*
//***		Seperate the Growth
//========================================================================================*

	foreach x in "0113" "0216" "0235" "0244" "0249" "0432" "0438" "0444" "0501" "0512" "0544" "0621" "0644" "0726" "0744" "0829" "0844" "0850" "0931" "0944" "1004" "1040" "1044" "1045" "1118" "1137" "1144" "1244" "1246" "1305" "1344" "1423" "1444" "1542" "1544" "1644" "1707" "1719" "1741" "1744" "1803" "1838" "1839" "1844" "1944" "2230" "2244" "2422" "2427" "2502" "2544" "2644" "2724" "2734" "2744" "2944" "3044" "3651" "3798" "1755" "1855" "1857" "2044" "2144" "2336" "2344" "2625" "3153" "3244" "3344" "3352" "3444" "3554" "3898" "3944" "4044" "4144" "9999"{
		gen Org`x'=2 if Result==1
		for var  GenSp1 GenSp2 GenSp3: replace 	Org`x'=1 if (X)==`x'
		}

renvars		Org0113- Org9999\ EschColi SalmEnter SalmPTyphi SalmSp SalmTyphi KlebOxyt KlebPneu KlebSp EnteAerog EnteCloa EnteSp CitrFreun CitrSp SerrMarc SerrSp ProtMirab ProtSp ProtVulg MorgMorg MorgSp ProvAlcal ProvRett ProvSp ProvStuar YersEnter YersPest YersSp EdwaSp EdwaTarda HafnAlvei HafnSp AeroHydr AeroSp PlesShigel PlesSp VibrSp StapAureus StapEpider StapSapr StapSp StreAgal StrePneu StrePyog StreSp EntercSp ListMono ListSp NeisGonor NeisMenin PseuAerug PseuSp CampSp HaemInfl HaemPInfl HaemSp AcinSp FlavSp MoreCatar AnaeNone StapCoagNeg StrepCoagNeg StrepOral BacilSp CorynSp ClostPerf ClostSp CampJej AlclFaecal BrevSp BurkSp BurkCep MicroSp StenMalt GrmNegEntr KocSp RhodSp DipthSp Miss
replace 	LabVar=3
do			"../stata_do_files/ANISA - Variable labels - Lab"
compress 	*
renvars		AntValue*	\ AmikacinAVal AmpicillinAVal AzythromicinAVal CefotaximeAVal CeftazidimeAVal CeftriaxoneAVal CephalexinAVal ChloramphenicolAVal CiprofloxacinAVal CloxacillinAVal CotrimoxazoleAVal ErythromicinAVal GentamicinAVal ImipenemAVal NalidixicAcidAVal NetilmicinAVal OxacillinAVal PenicillinAVal TetracyclineAVal CefepimeAVal LevofloxacinAVal MeropenemAVal AztreonamAVal CefiximeAVal CarbenicillinAVal VancomycinAVal CefuroximParenAVal CefuroximeOralAVal ClindamycinAVal AmoxicillinAVal CefoxitinAVal FusidicAcidAVal LinezolidAVal MetronidazoleAVal OfloxacinAVal PolymyxinBAVal TazobactamAVal TobramycinAVal ClavulanicAcidAVal
renvars		EStpValue*	\ AmikacinEVal AmpicillinEVal AzythromicinEVal CefotaximeEVal CeftazidimeEVal CeftriaxoneEVal CephalexinEVal ChloramphenicolEVal CiprofloxacinEVal CloxacillinEVal CotrimoxazoleEVal ErythromicinEVal GentamicinEVal ImipenemEVal NalidixicAcidEVal NetilmicinEVal OxacillinEVal PenicillinEVal TetracyclineEVal CefepimeEVal LevofloxacinEVal MeropenemEVal AztreonamEVal CefiximeEVal CarbenicillinEVal VancomycinEVal CefuroximParenEVal CefuroximeOralEVal ClindamycinEVal AmoxicillinEVal CefoxitinEVal FusidicAcidEVal LinezolidEVal MetronidazoleEVal OfloxacinEVal PolymyxinBEVal TazobactamEVal TobramycinEVal ClavulanicAcidEVal
sort 		LabID
save 		LabOutputFiles/BldLabBook, replace

***************************************************************************
***************************************************************************
****	Merge LabBook with Form 7a
**********************************************************************************************
clear
use 		"../../Source Anisa Tables/AnisaForm7a.dta", clear
label var	Q118E	"Diagnosis"
destring 	Q205*, replace
for 		var Q205* : replace X=0 if X==.
gen 		BldCol 	 = 2
replace 	BldCol 	 = 1 if Q2053>0 & Q2053<.
generate 	double BldColDt = 	dhms(Q202D,  real(substr(Q202T,1,2)), real(substr(Q202T,4,2)), 0)
generate 	double BldRecDt = 	dhms(Q233D,  real(substr(Q233T,1,2)), real(substr(Q233T,4,2)), 0)
generate 	double BAliqDt  = 	dhms(Q2322D, real(substr(Q2322T,1,2)), real(substr(Q2322T,4,2)), 0)
format 		BldColDt BldRecDt BAliqDt %tc

label 		var BldColDt 	"Date/Time of Blood Collection"
label 		var BldRecDt 	"Date/Time of Blood received "
label 		var BAliqDt 	"Date/Time of Blood Aliquotion "
label 		var BldCol	"Ever Blood Specimen Collected"
destring 	SiteCode, replace
sort 		LabID
**** Check the Duplicate records in master file
merge 		1:1 LabID using LabOutputFiles/BldLabBook.dta, gen(hasBacTec) keep(1 3)

label var 	hasBacTec 	"Form 7a and BacTec Merge Status"
label def	hasBacTec 	1 "Form 7a does not have corresponding BacTec" 2 "Bac Tec row does not have Form 7a" 3"Form 7a has a BacTec Row"
label 		values hasBacTec hasBacTec
replace 	childID = string(CountryCode) + string(SiteCode) + StudyId + ChildSl
renvars		Q2051 Q2052 Q2053/ VolBACTEC VolEDTA TotBldVol

for var Vol*: destring X, replace
recode		VolBACTEC (0.00=0 "Not Collected") (0.01/0.49=1  ".1-.4") (0.50/.99=2 ".5-<1.0") (1.00/4.00=3 "1.0-4.0"), gen(VolBACTACCat)
recode		VolEDTA   (0.00=0 "Not Collected") (0.01/0.49=1  ".1-.4") (0.50/.99=2 ".5-<1.0") (1.00/2.00=3 "1.0-2.0"), gen(VolEDTACat)

recode		VolBACTEC (0.00=0 "Not Collected") (0.01/0.49=1  ".1-.4") (0.50/4.00=2 ">=.5"), 	gen(VolBACTACCat1)
recode		VolEDTA   (0.00=0 "Not Collected") (0.01/0.99=1  ".1-<1.0") (1.00/2.00=2 "1.0-2.0"), gen(VolEDTACat1)
capture assert length(childID)==8

if _rc!=0 {
	di as error "There are row(s) in AnisaForm7a where one or more of CountryCode, SiteCode, StudyID, ChildSl are missing - will be dropped"
	drop if length(childID)!=8
	exit
}

destring 		SiteCode CountryCode, replace
destring 		CaseCon, replace
label define 	CntL			1 "Bangladesh" 2 "India" 3 "Pakistan"
label define 	SiteL			1 "Sylhet" 2 "Lucknow" 3 "Karachi" 4 "Matiari" 5 "Vellore" 6 "Odisha"
label define 	CaConL			1 "Suspected Case" 2 "Healthy Control" 3 "2nd Blood Collection"
label value		SiteCode		SiteL
label value		CountryCode		CntL
label value		CaseCon			CaConL
for   var 		Q202D  ReceiveDt PutDate BeepDate OutDate Q2322D Q233D: format X %dD_m_Y

//			Check the following variables
replace 	Q204="0.5" if Q204=="1/2"
replace		Q204=substr(Q204,1,strpos(Q204,":")-1)+"."+substr(Q204,strpos(Q204,":")+1, length(Q204)-strpos(Q204,":")) if substr(Q204,strpos(Q204,":"),1)==":"
destring 	Q204, replace
drop 		Q118C Q118D Q118E Age Sex
rename		LabID BldLabID
order 		childID SpecimenID
save 		LabOutputFiles/AnisaBldLabBk, replace
**********************************************************************************************
*-*-*-**-*-*-**-*-*-**-*-*-**-*-*-**-*-*-**-*-*-**-*-*-**-*-*-**-*-*-**-*-*-**-*-**-*-*-**-*-*-**-*-**-*-*-**-*-*-**

**********************************************************************************************
***	Anisa: TLDA Resuilt file preparation
**********************************************************************************************
use 	"../../Source Anisa Tables/TLDAM.dta", clear
drop  	expFileName expName expUserName excelFileName- EnDt EditUser
drop 	if expBarCode=="." | expBarCode==""
sort 	SiteCode expBarCode
tempfile TM
save 	`TM', replace

**********************************************************************************************
***	Form-TLDA
**********************************************************************************************
use 	"../../Source Anisa Tables/TLDAD.dta", clear
drop 		Well WellPos BaseStart BaseEnd  CTThro


//get the type
gen 		TType = 9
replace 	TType = 1 if substr(trim(SampName),1,1) == "B"
replace 	TType = 2 if substr(trim(SampName),1,1) == "R"
replace 	TType = 3 if substr(trim(SampName),1,1) == "C"
replace 	TType = 4 if substr(trim(SampName),1,1) == "N"
replace 	TType = 5 if substr(trim(SampName),1,1) == "P"
replace 	TType = 6 if substr(trim(SampName),1,1) == "E"

//keep if type == Blood or Resp
keep if inlist(TType,1,2)

//replace 	CT="9999.99" if CT=="Undetermined"
replace 	expBarCode="99999999" 	if expBarCode=="" |expBarCode=="."


//drop the duplicates records, according to CDC
//Sajib has moved this do file so that it is run when "Clean Anisa Tables" are created.
//do		"AncillaryDoFiles/ANISA - Drop records from TLDA"


//replace ENTV1 and ENTV2 into the same values
replace TarName = "ENTV_1" if TarName=="ENTV_1"
replace TarName = "ENTV_1" if TarName=="ENTV_2"
//fix up some other names
replace TarName = "IPGA_1"  if TarName=="IPCO_1/GADH"
replace TarName = "STPN_1"  if TarName=="STPN2_1"
replace TarName = "GBST_1"  if TarName=="GBS2_1"
replace TarName = "PIV1_1"  if TarName=="HPV1_1"
replace TarName = "PIV2_1"  if TarName=="HPV2_1"
replace TarName = "PIV3_1"  if TarName=="HPV3_1"

compress

//grab the expRunDate from TLDAM
merge m:1 SiteCode expBarCode using "../../Source Anisa Tables/TLDAM.dta", keepusing(expRunEndTime) keep(1 3)
tab _merge
drop _merge
preserve
	//separately for Blood and Resp
	keep if TType==1
	//only keep the targets we are interested in 
	keep if inlist(TarName,"ECSH_1", "ENTV_1", "GAST_1", "GBST_1", "HIAT_1", "KLPN_1") == 1 | inlist(TarName, "NMEN_1", "PSAE_1", "SALS_1", "STAU_1", "STPN_1", "URUP_1")==1

	//Now, we need to drop if not done for any sample

	//drop if missing(Comm)==1

	//now get mean CT values, for when positive
	replace 	CT="." if CT=="Undetermined"
	destring CT, replace
	replace Comm = "Negative" if TarName == "RUBV_1" & CT>35 & CT!=. 

	//Now, create negative or positive for each
	gen positive = Comm=="Positive" 
	//note, by definition, if not positive, this value will be 0, so need to replace to missing if Comm==missing
	noi tab TarName Comm
	save beforeReplaceMissingComm_Blood, replace
	
	replace positive=. if missing(Comm)==1

	//fix some SampName value
	//replace SampName = "B32346-TLDA" if SampName=="B332346-TLDA"
	//replace SampName = "B32355-TLDA" if SampName=="B32355-TLDA8"
	//replace SampName = SampName + "-TLDA" if length(SampName)==6
	//replace SampName = substr(SampName,1,6) + "-TLDA" if length(SampName)==10
	//replace SampName = substr(SampName,1,6) + "-TLDA" if substr(SampName,7,.)!="-TLDA"

	assert length(SampName)==11
	assert substr(SampName,1,1)=="B"
	assert substr(SampName,7,.)=="-TLDA"


	//Now, collapse (max) postive, and mean CT for each Samp and TarName
	collapse (max) positive (mean) CT, by(SampName TarName)

	replace TarName = substr(TarName,1,4)
	rename positive p

	reshape wide p CT, i(SampName) j(TarName) string
	renvars p*, predrop(1)
	renvars CT*, postfix("_CT")
	renvars *_CT, predrop(2)
	//drop CT*
	rename SampName bloodID
	replace bloodID = substr(bloodID,1,6)
	renvars ECSH-URUP_CT, suffix("_BTAC")
	label var ECSH_BTAC "Detected in Blood: Escherichia coli (all), Shigella spp. (except S. dysenteriae "
	label var ENTV_BTAC "Detected in Blood: Enterovirus 2"
	label var GAST_BTAC "Detected in Blood: Streptococus pyogenes"
	label var GBST_BTAC "Detected in Blood: Group B Streptococcus (all serotypes: IA, IB, II, III, IV, V,"
	label var HIAT_BTAC "Detected in Blood: Haemophilus infuluenzae"
	label var KLPN_BTAC "Detected in Blood: Klebsiella pneumoniae"
	label var NMEN_BTAC "Detected in Blood: Neisseria meningitidis"
	label var PSAE_BTAC "Detected in Blood: Pseudomonas aeruginosa"
	label var SALS_BTAC "Detected in Blood: Salmonella spp"
	label var STAU_BTAC "Detected in Blood: Staphylococcus aureus"
	label var STPN_BTAC "Detected in Blood: Streptococcus pneumoniae"
	label var URUP_BTAC "Detected in Blood: U. parvum (biovar 1; serovars 1, 3, 6, 14), U. urealyticum (b"
	
	///6 manual updates at this point!!!
	merge 1:1 bloodID using "../../Source Anisa Tables/change_ESCH_BTAC_toPositive.dta", keepusing(bloodID)
	assert inlist(_merge,1,3)==1
	replace ECSH_BTAC =1 if _merge==3
	drop _merge

	save LabOutputFiles/BloodTLDA, replace
restore

//Now for respiratory


	keep if TType==2
	//only keep the targets we are interested in 
	keep if inlist(TarName, "ADEV_1","BOP1_1","CHPN_1","CHTR_1","CYMV_1") == 1 ///
		| inlist(TarName,"ECSH_1","ENTV_1","FLUA_1","FLUB_1","GBST_1","HIAT_1")==1 ///
		| inlist(TarName,"HMPV_1","HPEV_1","KLPN_1","MYPN_1","PIV1_1","PIV2_1")==1 ///
		| inlist(TarName,"PIV3_1","RESV_1","RHIV_1","RUBV_1","STPN_1","URUP_1")==1



	//Now, we need to drop if not done for any sample

	//drop if missing(Comm)==1

	//now get mean CT values, for when positive
	replace 	CT="." if CT=="Undetermined"
	destring CT, replace
	replace Comm = "Negative" if TarName == "RUBV_1" & CT>35 & CT!=.

	//Now, create negative or positive for each
	gen positive = Comm=="Positive" 
	//note, by definition, if not positive, this value will be 0, so need to replace to missing if Comm==missing
	noi tab TarName Comm
	save beforeReplaceMissingComm_Resp, replace
	replace positive=. if missing(Comm)==1
	
	//replace SampName = SampName + "-TLDA" if length(SampName)==6
	//replace SampName = substr(SampName,1,6) + "-TLDA" if length(SampName)==10 | length(SampName)==12
	//replace SampName = substr(SampName,1,6) + "-TLDA" if substr(SampName,7,.)!="-TLDA"

	assert length(SampName)==11
	assert substr(SampName,1,1)=="R"
	assert substr(SampName,7,.)=="-TLDA"


	//Now, collapse (max) postive, and mean CT for each Samp and TarName
	collapse (max) positive (mean) CT, by(SampName TarName)

	replace TarName = substr(TarName,1,4)
	rename positive p

	reshape wide p CT, i(SampName) j(TarName) string
	renvars p*, predrop(1)
	renvars CT*, postfix("_CT")
	renvars *_CT, predrop(2)
	//drop CT*
	rename SampName respID
	replace respID = substr(respID,1,6)
	renvars ADEV-URUP_CT, suffix("_RTAC")
	label var ADEV_RTAC "Detected in NP-OP: Adenovirus"
	label var BOP1_RTAC "Detected in NP-OP: Bordetella pertussis, Bordetella holmesii"
	label var CHPN_RTAC "Detected in NP-OP: Chlamydophila pneumoniae"
	label var CHTR_RTAC "Detected in NP-OP: Chlamydia trachomatis"
	label var CYMV_RTAC "Detected in NP-OP: Cytomegalovirus"
	label var ECSH_RTAC "Detected in NP-OP: Escherichia coli (all), Shigella spp. (except S. dysenteriae" 
	label var ENTV_RTAC "Detected in NP-OP: Enterovirus 2"
	label var FLUA_RTAC "Detected in NP-OP: Influenza type A"
	label var FLUB_RTAC "Detected in NP-OP: Influenza type B"
	label var GBST_RTAC "Detected in NP-OP: Group B Streptococcus (all serotypes: IA, IB, II, III, IV, V,"
	label var HMPV_RTAC "Detected in NP-OP: Human Metapneumovirus"
	label var HPEV_RTAC "Detected in NP-OP: Parechovirus"
	label var KLPN_RTAC "Detected in NP-OP: Klebsiella pneumoniae"
	label var MYPN_RTAC "Detected in NP-OP: Mycoplasma pneumoniae"
	label var PIV1_RTAC "Detected in NP-OP: Parainfluenza virus-1"
	label var PIV2_RTAC "Detected in NP-OP: Parainfluenza virus-2"
	label var PIV3_RTAC "Detected in NP-OP: Parainfluenza virus-3"
	label var RESV_RTAC "Detected in NP-OP: Respiratory Syncytial Virus"
	label var RHIV_RTAC "Detected in NP-OP: Rhinovirus"
	label var RUBV_RTAC "Detected in NP-OP: Rubella virus"
	label var STPN_RTAC "Detected in NP-OP: Streptococcus pneumoniae"
	label var URUP_RTAC "Detected in NP-OP: U. parvum (biovar 1; serovars 1, 3, 6, 14), U. urealyticum (b"
	
	
	///171 manual updates at this point!!!
	merge 1:1 respID using "../../Source Anisa Tables/change_ESCH_RTAC_toPositive.dta", keepusing(respID)
	assert inlist(_merge,1,3)==1
	replace ECSH_RTAC =1 if _merge==3
	drop _merge
	

	save LabOutputFiles/RespTLDA, replace


**************************************************************************
**************************************************************************
**************************************************************************

**************************************************************************
****	Merge Blood file and TLDA file
**************************************************************************
use 	LabOutputFiles/AnisaBldLabBk, clear
move 	SiteCode SpecimenID
replace SpecimenID = substr(SpecimenID,1,6)
rename SpecimenID bloodID	

*** Check the duplicate records in master file & not availabel Form 7a

merge 	1:1 bloodID using LabOutputFiles/BloodTLDA, gen(BldTLDA) keep(1 3)
label 	define MatL 1 "TLDA File Not available"  3 "TLDA File available"
label	var	BldTLDA "Availability of TLDA file compare with Form 7a"
label 	val	BldTLDA MatL
for var PenicillinDisc- ClavulanicDisc: destring X, replace

for var 	GenSpName1 GenSpName: replace X="Missing" if (X=="" | X==".")  & (SubCul==1 | SubCul==3)

replace		SubCul=2 if Result==1 & SubCul==.
for var 	PenicillinDisc- ClavulanicDisc: replace aa=1 if (X>=0 & X<=99)
replace 	Antibiogram=9 if SubCul==2 | GenSpName1=="Missing"
replace 	Antibiogram=1 if (Antibiogram==. | Antibiogram>2) & aa==1
replace 	Antibiogram=8 if (Antibiogram==. | Antibiogram>2) & (SubCul==1 | SubCul==3)
for var 	*Sen: replace X=. if GenSpName1=="Missing"
for var 	*Sen: replace X=9 if Antibiogram<3 & X==.
replace		TTPHr = int((BldRecDt -  PutDtTm)/(1000*60*60)) if TTPHr==.
replace		TTPDy = int((BldRecDt -  PutDtTm)/(1000*60*60*24)) if TTPHr==.
gen		TotPath=0
for var GenSpName1 GenSpName2 GenSpName3: replace TotPath=TotPath+1 if X~="" & X~="Missing"
*drop 	if (SiteCode==1 & Q202D<mdy(11,1,2011) ) | (SiteCode==3 & Q202D<mdy(1,1,2012) ) | (SiteCode==4 & Q202D<mdy(3,1,2012) )
drop	aa
gen		BldForTLDA=2
replace BldForTLDA=1 if VolEDTA>0 & VolEDTA<3
gen		BldForBACTAC=2
replace BldForBACTAC=1 if VolBACTEC>0 & VolBACTEC<6
for var Q2*: rename X BX

/*
//			Add Wet Chemistry files
rename bloodID BarCode
merge		m:1 BarCode using WetChem/WetChemistry, gen(WCDone)
drop		if WCDone==2
rename BarCode bloodID
*/
drop CountryCode StudyId ChildSl
drop CaseCon

order 	childID SiteCode bloodID BQ201 BQ202D BQ202T BldColDt BQ203 BQ204 VolBACTEC VolBACTACCat VolBACTACCat1 VolEDTA VolEDTACat VolEDTACat1 /*
		*/ TotBldVol BQ211-BQ2322T BAliqDt BQ2323- BQ233T BldRecDt BldCol BldForBACTAC hasBacTec ReceiveDt Result PutDate PutTime PutDtTm BeepDate BeepTime BeepDtTm OutDate OutTime /*
		*/ OutDtTm TTPHr TTPDy BeepGSType- CulGent GenSp1- Type3 TotPath GenSpName BCCReviewed - bc_org Serotype DetecMethod Antibiogram OrgAntibiogram Penicillin* Oxacillin* /*
		*/ Ampicillin* Cephalexin* Cefotaxime* Ceftazidime* Ceftriaxone* Cotrimoxazole* Amikacin* Tetracycline* Chloramphenicol* Erythromicin* Gentamicin* Ciprofloxacin* Netilmicin* /*
		*/ Imipenem* Aztreonam* Azythromicin* Cloxacillin* Vancomycin* Clindamycin* CefuroximeParen* CefuroximeOral* Ofloxacin* Cefepime* Linezolid* Tobramycin* Nalidixic* Tazobactam* /*
		*/ Fusidic* Metronidazole* Polymyxin* Cefoxitin* Amoxicillin* Cefixime* Levofloxacin* Meropenem* Carbenicillin* Clavulanic* CefuroximParenSen CefuroximeaxetilSen OptocinSen /*
		*/ NitrofurantoinSen CefuroximeSen DoxycyclineSen MethicillinSen API- NonEnteroName ChocolateGrowth1- Citrate3 BldForTLDA BldForTLDA BldTLDA /*
		*/ ECSH_BTAC - URUP_CT_BTAC

		
*drop 		Q116 - SampleName
drop 		Q116 - Miss

// Should update in the raw database for missing value
for var 	BQ201: replace X=9 if X==.
replace 	BQ211=2 if BQ211  ==.
replace		BQ223B="153.72" if BQ223B=="153.72."
destring 	BQ223B, replace

label 	define	BldL		1  "Blood collected for culture" 2 "Blood not collected"
*label 	define	WCL		3  "Wet Chemistry done" 1 "Not done"
label 	val		BldCol 	BldL
*label 	val		WCDone	WCL
label	var 	BldCol 			"Whether Blood collected for culture"
*label	var 	WCDone			"Wet Chemistry done for blood"
label	var 	BldForTLDA		"Blood collected for TLDA (from blood volume>0)"
label	var 	BldForBACTAC		"Blood collected for BACTEC (from blood volume>0)"
label	var 	TotPath			"Total number of pathogen isolates from culture"
for var BldForTLDA BldForBACTAC: label val X YNL
   
sort	 	childID bloodID
save		LabOutputFiles/AnisaBloodFile, replace

**************************************************************************
****	Merge NP-OP file and TLDA file
**************************************************************************
use 		"../../Source Anisa Tables/AnisaForm7b.dta",clear

for var		CaseCon- Q234: destring X, replace

  gen double RespColDt = dhms(Q203D,  real(substr(Q203T,1,2)), real(substr(Q203T,4,2)), 0)
//gen double RespColDt = Q203D  + msofhours(real(substr(Q203T,1,2))) + msofminutes(real(substr(Q203T,4,2))) 
gen double 	RespRecDt = Q233D  + msofhours(real(substr(Q233T,1,2))) + msofminutes(real(substr(Q233T,4,2)))
gen 		RespColl= cond(Q201==1 | Q202==1, 1, 2)

label var	RespColDt 	"Collection date of NP /OP"
label var	RespRecDt 	"Receive date of NP /OP at Lab"
move		RespRecDt	Q102
move		RespColl 	RespColDt
format		RespColDt %tc

label 		define ColL 1 "NP/OP  Collected" 2 "Not collected"
label 		value	RespColl ColL
destring 	SiteCode, replace
replace 	SpecimenID = substr(SpecimenID,1,6)
rename		SpecimenID respID
bysort 		respID: gen aa=_n
drop 		if aa>1
merge		1:m respID using LabOutputFiles/RespTLDA, gen(RespTLDA)
/*
drop 		if expRunDate==mdy(12,30,2013) & SiteCode==3 & respID=="R31588"
drop		if expRunDate==mdy(01,01,2014) & SiteCode==3 & respID=="R30693"
*/

drop 		if RespTLDA ==2
label 		define MatL 1 "TLDA File Not available"  3 "TLDA File available"
label		var	RespTLDA "Availability of TLDA file compare with Form 7a"
label 		val	RespTLDA MatL

*for var 	CaseCon Q201-Q234 expRunDate - CTURUPCat_RTAC: rename X RX
tostring 	CountryCode  SiteCode, replace
gen 		childID = CountryCode + SiteCode + StudyId + ChildSl
destring 	SiteCode, replace

/*
rename 	respID BarCode
merge		m:1 BarCode using WetChem/WetChemistry, gen(WCDone) keep(1 3)
rename		BarCode respID
*/

drop CountryCode StudyId ChildSl CaseCon

order 		childID SiteCode respID Q201 Q202 Q203D Q203T RespColDt Q211- Q233T RespRecDt RespColl RespTLDA RespTLDA ADEV_RTAC- URUP_CT_RTAC

drop	Q102-aa
label 	define	NPL		1  "NP-OP collected" 2 "Not collected"
*label 	define	WCL		3  "Wet Chemistry done" 1 "Not done"
*label 	val	WCDone 	WCL

label	var 	RespColl		"Whether NP-OP collected for culture"
*label	var 	WCDone			"Wet Chemistry done for NP-OP"
label	var 	RespTLDA		"Blood collected for TLDA (from blood volume>0)"
for var RespColl: label val X YNL
sort	childID respID
save	LabOutputFiles/AnisaRespFile, replace


