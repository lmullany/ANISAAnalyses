

replace SampName=trim(SampName)

replace SampName = "B10738-TLDA" if SampName == "10738-TLDA"
replace SampName = "B13679-TLDA" if SampName == "13679-TLDA"
replace expBarCode = "85470615" if expBarCode=="8540615"
replace expBarCode = "85470101" if expBarCode=="8547010" 
replace expBarCode = "85470491" if expBarCode=="8547091" 
replace expBarCode = "85471206" if expBarCode=="8547106" 


***************************************************************
*** Drop a records that TLDA done multiple times 			***
***************************************************************
drop if SiteCode == "1" & SampName== "B10898-TLDA" & expBarCode== "91641006"
drop if SiteCode == "1" & SampName== "B11273-TLDA" & expBarCode== "85470207"
drop if SiteCode == "1" & SampName== "B11306-TLDA" & expBarCode== "85470634"
drop if SiteCode == "1" & SampName== "B12102-TLDA" & expBarCode== "91641007"
drop if SiteCode == "1" & SampName== "B12134-TLDA" & expBarCode== "91641029"
drop if SiteCode == "1" & SampName== "B12249-TLDA" & expBarCode== "91641028"
drop if SiteCode == "1" & SampName== "B12252-TLDA" & expBarCode== "91641029"
drop if SiteCode == "1" & SampName== "B12275-TLDA" & expBarCode== "91641031"
drop if SiteCode == "1" & SampName== "B12722-TLDA" & expBarCode== "91641226"
drop if SiteCode == "1" & SampName== "B12847-TLDA" & expBarCode== "91640859"
drop if SiteCode == "1" & SampName== "B13107-TLDA" & expBarCode== "91640890"
drop if SiteCode == "1" & SampName== "B13118-TLDA" & expBarCode== "91640892"
drop if SiteCode == "1" & SampName== "B13185-TLDA" & expBarCode== "91641093"
drop if SiteCode == "1" & SampName== "B13196-TLDA" & expBarCode== "91641002"
drop if SiteCode == "1" & SampName== "B13230-TLDA" & expBarCode== "91640853"
drop if SiteCode == "1" & SampName== "B13818-TLDA" & expBarCode== "91640838"
drop if SiteCode == "1" & SampName== "R10081-TLDA" & expBarCode== "91651681"
drop if SiteCode == "1" & SampName== "R10271-TLDA" & expBarCode== "85300607"
drop if SiteCode == "1" & SampName== "R10533-TLDA" & expBarCode== "91651681" 
drop if SiteCode == "1" & SampName== "R12048-TLDA" & expBarCode== "91650664"
drop if SiteCode == "1" & SampName== "R12143-TLDA" & expBarCode== "85300642"
drop if SiteCode == "1" & SampName== "R12145-TLDA" & expBarCode== "85300642"
drop if SiteCode == "1" & SampName== "R13526-TLDA" & expBarCode== "85300481"
drop if SiteCode == "1" & SampName== "R13644-TLDA" & expBarCode== "91650624"
drop if SiteCode == "1" & SampName== "R13701-TLDA" & expBarCode== "91651008"
drop if SiteCode == "1" & SampName== "R13702-TLDA" & expBarCode== "91651011"
drop if SiteCode == "1" & SampName== "R13718-TLDA" & expBarCode== "91650620"
drop if SiteCode == "1" & SampName== "R13811-TLDA" & expBarCode== "91650664"
drop if SiteCode == "1" & SampName== "R13882-TLDA" & expBarCode== "91651019"

drop if SiteCode == "3" & SampName== "B31190-TLDA" & expBarCode== "91640610"
drop if SiteCode == "3" & SampName== "B31191-TLDA" & expBarCode== "91640610"
drop if SiteCode == "3" & SampName== "B31193-TLDA" & expBarCode== "91640610"
drop if SiteCode == "3" & SampName== "B31291-TLDA" & expBarCode== "91640610"
drop if SiteCode == "3" & SampName== "B32139-TLDA" & expBarCode== "91640610"
drop if SiteCode == "3" & SampName== "B32140-TLDA" & expBarCode== "91640610"
drop if SiteCode == "4" & SampName== "B40168-TLDA" & expBarCode== "91640264"
drop if SiteCode == "4" & SampName== "B40182-TLDA" & expBarCode== "91640264"
drop if SiteCode == "4" & SampName== "B40187-TLDA" & expBarCode== "91640264"
drop if SiteCode == "4" & SampName== "B40557-TLDA" & expBarCode== "85470098"
drop if SiteCode == "4" & SampName== "B40748-TLDA" & expBarCode== "91640284"
drop if SiteCode == "4" & SampName== "B41049-TLDA" & expBarCode== "91640284"
drop if SiteCode == "4" & SampName== "B41058-TLDA" & expBarCode== "91640284"
drop if SiteCode == "4" & SampName== "B41341-TLDA" & expBarCode== "91640284"
drop if SiteCode == "4" & SampName== "B41553-TLDA" & expBarCode== "91640284"
drop if SiteCode == "4" & SampName== "B41555-TLDA" & expBarCode== "91640284"
drop if SiteCode == "4" & SampName== "B42019-TLDA" & expBarCode== "91640264"
drop if SiteCode == "4" & SampName== "B42228-TLDA" & expBarCode== "91640264"
drop if SiteCode == "4" & SampName== "B42321-TLDA" & expBarCode== "91640264"

drop if SiteCode == "4" & SampName== "R30035-TLDA" & expBarCode== "91651402" 
drop if SiteCode == "3" & SampName== "R30035-TLDA" & expBarCode== "91651405"
drop if SiteCode == "3" & SampName== "R30370-TLDA" & expBarCode== "91650080"
drop if SiteCode == "4" & SampName== "R31121-TLDA" & expBarCode== "85300468" 
drop if SiteCode == "4" & SampName== "R31211-TLDA" & expBarCode== "85300468" 
drop if SiteCode == "4" & SampName== "R31319-TLDA" & expBarCode== "85300468" 
drop if SiteCode == "3" & SampName== "R31322-TLDA" & expBarCode== "91651405"
drop if SiteCode == "4" & SampName== "R31541-TLDA" & expBarCode== "85300468"    
drop if SiteCode == "4" & SampName== "R31543-TLDA" & expBarCode== "85300468"    
drop if SiteCode == "3" & SampName== "R31901-TLDA" & expBarCode== "91650080"
drop if SiteCode == "3" & SampName== "R32457-TLDA" & expBarCode== "91650852"
drop if SiteCode == "3" & SampName== "R40269-TLDA" & expBarCode== "91650452"   
drop if SiteCode == "3" & SampName== "R40271-TLDA" & expBarCode== "91650452"   
drop if SiteCode == "3" & SampName== "R40283-TLDA" & expBarCode== "91650452"   

drop if SiteCode == "4" & SampName== "R40376-TLDA" & expBarCode== "85300879"
drop if SiteCode == "4" & SampName== "R40582-TLDA" & expBarCode== "91650689"
drop if SiteCode == "4" & SampName== "R41077-TLDA" & expBarCode== "91651490"
drop if SiteCode == "4" & SampName== "R41194-TLDA" & expBarCode== "91650656"
drop if SiteCode == "4" & SampName== "R41573-TLDA" & expBarCode== "85300281"
drop if SiteCode == "4" & SampName== "R41649-TLDA" & expBarCode== "91651816"
drop if SiteCode == "4" & SampName== "R41784-TLDA" & expBarCode== "91651249"
drop if SiteCode == "4" & SampName== "R41788-TLDA" & expBarCode== "91650047"
drop if SiteCode == "3" & SampName== "R41835-TLDA" & expBarCode== "91650452"    
drop if SiteCode == "3" & SampName== "R41836-TLDA" & expBarCode== "91650452"    
drop if SiteCode == "4" & SampName== "R41891-TLDA" & expBarCode== "91650074"


//Luke adding a row regarding 

drop if expBarCode == "71260207" & SampName=="B40384-TLDA"

***************************************************************
*** Drop wrong Specimen IDs from TLDA file - Karachi Sites	***
***************************************************************

drop if SiteCode=="3" & substr( SampName,1,2)=="B4"
drop if SiteCode=="3" & substr( SampName,1,2)=="R4"
drop if SiteCode=="4" & substr( SampName,1,2)=="B3"
drop if SiteCode=="4" & substr( SampName,1,2)=="R3"

drop if SiteCode == "3" & SampName== "R30006-TLDA" 
drop if SiteCode == "3" & SampName== "R30017-TLDA"    
drop if SiteCode == "3" & SampName== "R30018-TLDA" 
drop if SiteCode == "3" & SampName== "R30062-TLDA" 
drop if SiteCode == "3" & SampName== "R30064-TLDA" 
drop if SiteCode == "3" & SampName== "R30140-TLDA" 
drop if SiteCode == "3" & SampName== "R30161-TLDA" 
drop if SiteCode == "3" & SampName== "R30420-TLDA" 
drop if SiteCode == "3" & SampName== "R30521-TLDA" 
drop if SiteCode == "3" & SampName== "R30821-TLDA" 
drop if SiteCode == "3" & SampName== "R31102-TLDA" 
drop if SiteCode == "3" & SampName== "R31703-TLDA" 
drop if SiteCode == "3" & SampName== "R31714-TLDA" 

drop if SiteCode == "4" & SampName== "R41139-TLDA" 
drop if SiteCode == "3" & SampName== "B30006-TLDA" 
drop if SiteCode == "3" & SampName== "B30017-TLDA" 
drop if SiteCode == "3" & SampName== "B30018-TLDA" 
drop if SiteCode == "3" & SampName== "B30062-TLDA" 
drop if SiteCode == "3" & SampName== "B30064-TLDA" 
drop if SiteCode == "3" & SampName== "B30140-TLDA" 
drop if SiteCode == "3" & SampName== "B30161-TLDA" 
drop if SiteCode == "3" & SampName== "B31003-TLDA" 
drop if SiteCode == "3" & SampName== "B31288-TLDA" 
drop if SiteCode == "3" & SampName== "B31418-TLDA" 
drop if SiteCode == "4" & SampName== "B41489-TLDA" 

***************************************************


