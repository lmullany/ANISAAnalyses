************************************************************************************************************
****	ID Update in Form 6 from Form 7a/b after matching with visit date and collection date
************************************************************************************************************

if	Up == 1 {
		format	Q121 %dD_m_Y
		// Update missing Specimen ID
		replace Q611a="B10610-FORM" if SiteCode=="1" & StudyId=="01192" & ChildSl=="1" & Q121==mdy(10,02,2011) & Q611a==""
		replace Q611a="B10790-FORM" if SiteCode=="1" & StudyId=="08195" & ChildSl=="2" & Q121==mdy(10,21,2011) & Q611a==""
		replace Q611a="B10515-FORM" if SiteCode=="1" & StudyId=="09264" & ChildSl=="1" & Q121==mdy(06,23,2012) & Q611a==""
		replace Q611a="B12816-FORM" if SiteCode=="1" & StudyId=="09292" & ChildSl=="1" & Q121==mdy(02,09,2013) & Q611a==""
		replace Q611a="B10104-FORM" if SiteCode=="1" & StudyId=="09586" & ChildSl=="2" & Q121==mdy(01,10,2012) & Q611a==""
		replace Q611a="B10536-FORM" if SiteCode=="1" & StudyId=="16425" & ChildSl=="2" & Q121==mdy(07,07,2012) & Q611a==""
		replace Q611a="B11277-FORM" if SiteCode=="1" & StudyId=="19291" & ChildSl=="1" & Q121==mdy(09,05,2012) & Q611a==""
		replace Q611a="B61339-FORM" if SiteCode=="6" & StudyId=="00536" & ChildSl=="1" & Q121==mdy(04,01,2015) & Q611a==""
		replace Q611a="B61363-FORM" if SiteCode=="6" & StudyId=="00756" & ChildSl=="1" & Q121==mdy(05,15,2015) & Q611a==""
		replace Q611a="B61367-FORM" if SiteCode=="6" & StudyId=="01202" & ChildSl=="1" & Q121==mdy(05,24,2015) & Q611a==""
		replace Q611a="B61369-FORM" if SiteCode=="6" & StudyId=="01332" & ChildSl=="1" & Q121==mdy(05,27,2015) & Q611a==""
		replace Q611a="B61370-FORM" if SiteCode=="6" & StudyId=="02194" & ChildSl=="1" & Q121==mdy(05,30,2015) & Q611a==""
		replace Q611a="B60339-FORM" if SiteCode=="6" & StudyId=="03721" & ChildSl=="1" & Q121==mdy(08,25,2014) & Q611a==""
		replace Q611a="B60095-FORM" if SiteCode=="6" & StudyId=="03748" & ChildSl=="1" & Q121==mdy(03,06,2014) & Q611a==""
		replace Q611a="B60545-FORM" if SiteCode=="6" & StudyId=="03893" & ChildSl=="1" & Q121==mdy(06,09,2014) & Q611a==""
		replace Q611a="B60584-FORM" if SiteCode=="6" & StudyId=="04073" & ChildSl=="1" & Q121==mdy(07,17,2014) & Q611a==""
		replace Q611a="B60354-FORM" if SiteCode=="6" & StudyId=="04147" & ChildSl=="1" & Q121==mdy(09,03,2014) & Q611a==""
		replace Q611a="B60399-FORM" if SiteCode=="6" & StudyId=="04219" & ChildSl=="1" & Q121==mdy(10,01,2014) & Q611a==""
		replace Q611a="B60385-FORM" if SiteCode=="6" & StudyId=="04780" & ChildSl=="1" & Q121==mdy(09,24,2014) & Q611a==""
		replace Q611a="B60367-FORM" if SiteCode=="6" & StudyId=="04780" & ChildSl=="1" & Q121==mdy(09,13,2014) & Q611a==""
		replace Q611a="B60097-FORM" if SiteCode=="6" & StudyId=="04892" & ChildSl=="1" & Q121==mdy(03,06,2014) & Q611a==""
		replace Q611a="B60020-FORM" if SiteCode=="6" & StudyId=="05758" & ChildSl=="1" & Q121==mdy(01,08,2014) & Q611a==""
		replace Q611a="B60098-FORM" if SiteCode=="6" & StudyId=="06752" & ChildSl=="1" & Q121==mdy(03,06,2014) & Q611a==""
		replace Q611a="B60345-FORM" if SiteCode=="6" & StudyId=="06970" & ChildSl=="1" & Q121==mdy(08,29,2014) & Q611a==""
		replace Q611a="B60062-FORM" if SiteCode=="6" & StudyId=="07024" & ChildSl=="1" & Q121==mdy(02,13,2014) & Q611a==""
		replace Q611a="B60350-FORM" if SiteCode=="6" & StudyId=="07091" & ChildSl=="1" & Q121==mdy(09,02,2014) & Q611a==""
		replace Q611a="B60560-FORM" if SiteCode=="6" & StudyId=="07393" & ChildSl=="1" & Q121==mdy(06,27,2014) & Q611a==""
		replace Q611a="B60094-FORM" if SiteCode=="6" & StudyId=="07632" & ChildSl=="1" & Q121==mdy(03,04,2014) & Q611a==""
		replace Q611a="B60381-FORM" if SiteCode=="6" & StudyId=="07900" & ChildSl=="1" & Q121==mdy(09,22,2014) & Q611a==""
		replace Q611a="B60362-FORM" if SiteCode=="6" & StudyId=="08376" & ChildSl=="1" & Q121==mdy(09,10,2014) & Q611a==""
		replace Q611a="B60358-FORM" if SiteCode=="6" & StudyId=="08763" & ChildSl=="1" & Q121==mdy(09,04,2014) & Q611a==""
		replace Q611a="B60681-FORM" if SiteCode=="6" & StudyId=="09053" & ChildSl=="1" & Q121==mdy(04,28,2014) & Q611a==""
		replace Q611a="B61344-FORM" if SiteCode=="6" & StudyId=="09107" & ChildSl=="1" & Q121==mdy(04,07,2015) & Q611a==""
		replace Q611a="B61359-FORM" if SiteCode=="6" & StudyId=="09211" & ChildSl=="1" & Q121==mdy(05,06,2015) & Q611a==""
		replace Q611a="B61352-FORM" if SiteCode=="6" & StudyId=="09320" & ChildSl=="1" & Q121==mdy(04,22,2015) & Q611a==""
		replace Q611a="B60374-FORM" if SiteCode=="6" & StudyId=="09385" & ChildSl=="1" & Q121==mdy(09,18,2014) & Q611a==""
		replace Q611a="B60373-FORM" if SiteCode=="6" & StudyId=="09386" & ChildSl=="1" & Q121==mdy(09,18,2014) & Q611a==""
		replace Q611a="B61345-FORM" if SiteCode=="6" & StudyId=="10334" & ChildSl=="1" & Q121==mdy(04,10,2015) & Q611a==""
		replace Q611a="B61355-FORM" if SiteCode=="6" & StudyId=="10474" & ChildSl=="1" & Q121==mdy(04,27,2015) & Q611a==""
		replace Q611a="B61349-FORM" if SiteCode=="6" & StudyId=="10590" & ChildSl=="1" & Q121==mdy(04,18,2015) & Q611a==""
		replace Q611a="B61343-FORM" if SiteCode=="6" & StudyId=="10598" & ChildSl=="1" & Q121==mdy(04,05,2015) & Q611a==""
		replace Q611a="B60341-FORM" if SiteCode=="6" & StudyId=="11147" & ChildSl=="1" & Q121==mdy(08,28,2014) & Q611a==""
		replace Q611a="B61347-FORM" if SiteCode=="6" & StudyId=="11197" & ChildSl=="1" & Q121==mdy(04,13,2015) & Q611a==""
		replace Q611a="B61366-FORM" if SiteCode=="6" & StudyId=="11281" & ChildSl=="1" & Q121==mdy(05,18,2015) & Q611a==""
		replace Q611a="B61341-FORM" if SiteCode=="6" & StudyId=="11303" & ChildSl=="1" & Q121==mdy(04,03,2015) & Q611a==""
		replace Q611a="B61358-FORM" if SiteCode=="6" & StudyId=="11363" & ChildSl=="1" & Q121==mdy(05,03,2015) & Q611a==""
		replace Q611a="B61362-FORM" if SiteCode=="6" & StudyId=="11425" & ChildSl=="1" & Q121==mdy(05,14,2015) & Q611a==""
		replace Q611a="B61368-FORM" if SiteCode=="6" & StudyId=="11442" & ChildSl=="1" & Q121==mdy(05,25,2015) & Q611a==""
		replace Q611a="B61354-FORM" if SiteCode=="6" & StudyId=="11547" & ChildSl=="1" & Q121==mdy(04,25,2015) & Q611a==""
		replace Q611a="B61351-FORM" if SiteCode=="6" & StudyId=="12008" & ChildSl=="1" & Q121==mdy(04,21,2015) & Q611a==""
		replace Q611a="B61350-FORM" if SiteCode=="6" & StudyId=="12013" & ChildSl=="1" & Q121==mdy(04,20,2015) & Q611a==""
		replace Q611a="B61364-FORM" if SiteCode=="6" & StudyId=="12075" & ChildSl=="1" & Q121==mdy(05,17,2015) & Q611a==""
		replace Q611a="B61361-FORM" if SiteCode=="6" & StudyId=="12081" & ChildSl=="1" & Q121==mdy(05,07,2015) & Q611a==""
		replace Q611a="B61360-FORM" if SiteCode=="6" & StudyId=="12106" & ChildSl=="1" & Q121==mdy(05,06,2015) & Q611a==""
		replace Q611a="B61346-FORM" if SiteCode=="6" & StudyId=="12161" & ChildSl=="1" & Q121==mdy(04,12,2015) & Q611a==""
		replace Q611a="B61342-FORM" if SiteCode=="6" & StudyId=="12223" & ChildSl=="1" & Q121==mdy(04,05,2015) & Q611a==""
		replace Q611a="B61340-FORM" if SiteCode=="6" & StudyId=="12829" & ChildSl=="1" & Q121==mdy(04,02,2015) & Q611a==""
		replace Q611a="B61356-FORM" if SiteCode=="6" & StudyId=="12982" & ChildSl=="1" & Q121==mdy(04,29,2015) & Q611a==""
		replace Q611a="B61353-FORM" if SiteCode=="6" & StudyId=="13011" & ChildSl=="1" & Q121==mdy(04,24,2015) & Q611a==""
		replace Q611a="B61357-FORM" if SiteCode=="6" & StudyId=="13848" & ChildSl=="1" & Q121==mdy(05,02,2015) & Q611a==""
		replace Q611a="B61348-FORM" if SiteCode=="6" & StudyId=="14437" & ChildSl=="1" & Q121==mdy(04,17,2015) & Q611a==""
		replace Q611a="B61365-FORM" if SiteCode=="6" & StudyId=="14522" & ChildSl=="1" & Q121==mdy(05,18,2015) & Q611a==""
		replace Q611a="B60035-FORM" if SiteCode=="6" & StudyId=="06810" & ChildSl=="1" & Q121==mdy(01,22,2014) & Q611a==""
		replace Q611a="B10758-FORM" if SiteCode=="1" & StudyId=="00325" & ChildSl=="1" & Q121==mdy(09,25,2011) & Q611a==""
		replace Q611a="B10738-FORM" if SiteCode=="1" & StudyId=="00350" & ChildSl=="1" & Q121==mdy(10,06,2011) & Q611a==""
		replace Q611a="B10603-FORM" if SiteCode=="1" & StudyId=="04198" & ChildSl=="1" & Q121==mdy(09,26,2011) & Q611a==""
		replace Q611a="B11296-FORM" if SiteCode=="1" & StudyId=="09821" & ChildSl=="1" & Q121==mdy(09,09,2012) & Q611a==""
		replace Q611a="B11065-FORM" if SiteCode=="1" & StudyId=="13057" & ChildSl=="2" & Q121==mdy(11,11,2012) & Q611a==""
		replace Q611a="B51037-FORM" if SiteCode=="5" & StudyId=="05601" & ChildSl=="1" & Q121==mdy(03,24,2014) & Q611a==""
		replace Q611a="B61144-FORM" if SiteCode=="6" & StudyId=="00996" & ChildSl=="1" & Q121==mdy(08,18,2014) & Q611a==""
		replace Q611a="B60670-FORM" if SiteCode=="6" & StudyId=="05248" & ChildSl=="2" & Q121==mdy(04,23,2014) & Q611a==""
		replace Q611a="B60064-FORM" if SiteCode=="6" & StudyId=="05317" & ChildSl=="1" & Q121==mdy(02,14,2014) & Q611a==""
		replace Q611a="B60096-FORM" if SiteCode=="6" & StudyId=="06810" & ChildSl=="1" & Q121==mdy(03,06,2014) & Q611a==""
		replace Q611a="B60688-FORM" if SiteCode=="6" & StudyId=="05166" & ChildSl=="1" & Q121==mdy(04,09,2014) & Q611a==""

		replace Q621a="R12336-FORM" if SiteCode=="1" & StudyId=="01924" & ChildSl=="1" & Q121==mdy(07,07,2013) & Q621a==""
		replace Q621a="R11438-FORM" if SiteCode=="1" & StudyId=="02242" & ChildSl=="1" & Q121==mdy(01,11,2013) & Q621a==""
		replace Q621a="R13295-FORM" if SiteCode=="1" & StudyId=="03144" & ChildSl=="1" & Q121==mdy(06,12,2013) & Q621a==""
		replace Q621a="R12529-FORM" if SiteCode=="1" & StudyId=="05326" & ChildSl=="1" & Q121==mdy(02,09,2013) & Q621a==""
		replace Q621a="R11393-FORM" if SiteCode=="1" & StudyId=="08195" & ChildSl=="2" & Q121==mdy(10,21,2011) & Q621a==""
		replace Q621a="R10103-FORM" if SiteCode=="1" & StudyId=="09586" & ChildSl=="2" & Q121==mdy(01,10,2012) & Q621a==""
		replace Q621a="R10222-FORM" if SiteCode=="1" & StudyId=="14109" & ChildSl=="1" & Q121==mdy(11,19,2012) & Q621a==""
		replace Q621a="R10323-FORM" if SiteCode=="1" & StudyId=="16425" & ChildSl=="2" & Q121==mdy(07,07,2012) & Q621a==""
		replace Q621a="R11299-FORM" if SiteCode=="1" & StudyId=="18185" & ChildSl=="2" & Q121==mdy(03,29,2012) & Q621a==""
		replace Q621a="R11117-FORM" if SiteCode=="1" & StudyId=="18613" & ChildSl=="2" & Q121==mdy(06,22,2012) & Q621a==""
		replace Q621a="R11675-FORM" if SiteCode=="1" & StudyId=="19291" & ChildSl=="1" & Q121==mdy(09,05,2012) & Q621a==""
		replace Q621a="R12939-FORM" if SiteCode=="1" & StudyId=="21538" & ChildSl=="1" & Q121==mdy(05,27,2013) & Q621a==""
		replace Q621a="R12916-FORM" if SiteCode=="1" & StudyId=="25752" & ChildSl=="1" & Q121==mdy(05,20,2013) & Q621a==""
		replace Q621a="R12155-FORM" if SiteCode=="1" & StudyId=="27232" & ChildSl=="1" & Q121==mdy(08,25,2013) & Q621a==""
		replace Q621a="R61135-FORM" if SiteCode=="6" & StudyId=="00536" & ChildSl=="1" & Q121==mdy(04,01,2015) & Q621a==""
		replace Q621a="R61159-FORM" if SiteCode=="6" & StudyId=="00756" & ChildSl=="1" & Q121==mdy(05,15,2015) & Q621a==""
		replace Q621a="R60740-FORM" if SiteCode=="6" & StudyId=="00996" & ChildSl=="1" & Q121==mdy(08,18,2014) & Q621a==""
		replace Q621a="R61163-FORM" if SiteCode=="6" & StudyId=="01202" & ChildSl=="1" & Q121==mdy(05,24,2015) & Q621a==""
		replace Q621a="R61165-FORM" if SiteCode=="6" & StudyId=="01332" & ChildSl=="1" & Q121==mdy(05,27,2015) & Q621a==""
		replace Q621a="R60905-FORM" if SiteCode=="6" & StudyId=="01898" & ChildSl=="1" & Q121==mdy(10,17,2014) & Q621a==""
		replace Q621a="R61166-FORM" if SiteCode=="6" & StudyId=="02194" & ChildSl=="1" & Q121==mdy(05,30,2015) & Q621a==""
		replace Q621a="R60539-FORM" if SiteCode=="6" & StudyId=="03721" & ChildSl=="1" & Q121==mdy(08,25,2014) & Q621a==""
		replace Q621a="R60293-FORM" if SiteCode=="6" & StudyId=="03748" & ChildSl=="1" & Q121==mdy(03,06,2014) & Q621a==""
		replace Q621a="R60145-FORM" if SiteCode=="6" & StudyId=="03893" & ChildSl=="1" & Q121==mdy(06,09,2014) & Q621a==""
		replace Q621a="R60184-FORM" if SiteCode=="6" & StudyId=="04073" & ChildSl=="1" & Q121==mdy(07,17,2014) & Q621a==""
		replace Q621a="R60554-FORM" if SiteCode=="6" & StudyId=="04147" & ChildSl=="1" & Q121==mdy(09,03,2014) & Q621a==""
		replace Q621a="R60599-FORM" if SiteCode=="6" & StudyId=="04219" & ChildSl=="1" & Q121==mdy(10,01,2014) & Q621a==""
		replace Q621a="R60220-FORM" if SiteCode=="6" & StudyId=="05758" & ChildSl=="1" & Q121==mdy(01,08,2014) & Q621a==""
		replace Q621a="R60296-FORM" if SiteCode=="6" & StudyId=="06752" & ChildSl=="1" & Q121==mdy(03,06,2014) & Q621a==""
		replace Q621a="R60234-FORM" if SiteCode=="6" & StudyId=="06810" & ChildSl=="1" & Q121==mdy(01,22,2014) & Q621a==""
		replace Q621a="R60545-FORM" if SiteCode=="6" & StudyId=="06970" & ChildSl=="1" & Q121==mdy(08,29,2014) & Q621a==""
		replace Q621a="R60260-FORM" if SiteCode=="6" & StudyId=="07024" & ChildSl=="1" & Q121==mdy(02,13,2014) & Q621a==""
		replace Q621a="R60550-FORM" if SiteCode=="6" & StudyId=="07091" & ChildSl=="1" & Q121==mdy(09,02,2014) & Q621a==""
		replace Q621a="R60160-FORM" if SiteCode=="6" & StudyId=="07393" & ChildSl=="1" & Q121==mdy(06,27,2014) & Q621a==""
		replace Q621a="R60292-FORM" if SiteCode=="6" & StudyId=="07632" & ChildSl=="1" & Q121==mdy(03,04,2014) & Q621a==""
		replace Q621a="R60581-FORM" if SiteCode=="6" & StudyId=="07900" & ChildSl=="1" & Q121==mdy(09,22,2014) & Q621a==""
		replace Q621a="R60562-FORM" if SiteCode=="6" & StudyId=="08376" & ChildSl=="1" & Q121==mdy(09,10,2014) & Q621a==""
		replace Q621a="R60558-FORM" if SiteCode=="6" & StudyId=="08763" & ChildSl=="1" & Q121==mdy(09,04,2014) & Q621a==""
		replace Q621a="R60480-FORM" if SiteCode=="6" & StudyId=="09053" & ChildSl=="1" & Q121==mdy(04,28,2014) & Q621a==""
		replace Q621a="R61140-FORM" if SiteCode=="6" & StudyId=="09107" & ChildSl=="1" & Q121==mdy(04,07,2015) & Q621a==""
		replace Q621a="R61155-FORM" if SiteCode=="6" & StudyId=="09211" & ChildSl=="1" & Q121==mdy(05,06,2015) & Q621a==""
		replace Q621a="R61148-FORM" if SiteCode=="6" & StudyId=="09320" & ChildSl=="1" & Q121==mdy(04,22,2015) & Q621a==""
		replace Q621a="R60574-FORM" if SiteCode=="6" & StudyId=="09385" & ChildSl=="1" & Q121==mdy(09,18,2014) & Q621a==""
		replace Q621a="R60573-FORM" if SiteCode=="6" & StudyId=="09386" & ChildSl=="1" & Q121==mdy(09,18,2014) & Q621a==""
		replace Q621a="R61141-FORM" if SiteCode=="6" & StudyId=="10334" & ChildSl=="1" & Q121==mdy(04,10,2015) & Q621a==""
		replace Q621a="R61151-FORM" if SiteCode=="6" & StudyId=="10474" & ChildSl=="1" & Q121==mdy(04,27,2015) & Q621a==""
		replace Q621a="R61145-FORM" if SiteCode=="6" & StudyId=="10590" & ChildSl=="1" & Q121==mdy(04,18,2015) & Q621a==""
		replace Q621a="R61139-FORM" if SiteCode=="6" & StudyId=="10598" & ChildSl=="1" & Q121==mdy(04,05,2015) & Q621a==""
		replace Q621a="R60541-FORM" if SiteCode=="6" & StudyId=="11147" & ChildSl=="1" & Q121==mdy(08,28,2014) & Q621a==""
		replace Q621a="R61143-FORM" if SiteCode=="6" & StudyId=="11197" & ChildSl=="1" & Q121==mdy(04,13,2015) & Q621a==""	
		replace Q621a="R61162-FORM" if SiteCode=="6" & StudyId=="11281" & ChildSl=="1" & Q121==mdy(05,18,2015) & Q621a==""
		replace Q621a="R61137-FORM" if SiteCode=="6" & StudyId=="11303" & ChildSl=="1" & Q121==mdy(04,03,2015) & Q621a==""
		replace Q621a="R61154-FORM" if SiteCode=="6" & StudyId=="11363" & ChildSl=="1" & Q121==mdy(05,03,2015) & Q621a==""
		replace Q621a="R61158-FORM" if SiteCode=="6" & StudyId=="11425" & ChildSl=="1" & Q121==mdy(05,14,2015) & Q621a==""
		replace Q621a="R61164-FORM" if SiteCode=="6" & StudyId=="11442" & ChildSl=="1" & Q121==mdy(05,25,2015) & Q621a==""		
		replace Q621a="R61150-FORM" if SiteCode=="6" & StudyId=="11547" & ChildSl=="1" & Q121==mdy(04,25,2015) & Q621a==""
		replace Q621a="R60374-FORM" if SiteCode=="6" & StudyId=="11956" & ChildSl=="1" & Q121==mdy(12,17,2014) & Q621a==""
		replace Q621a="R61147-FORM" if SiteCode=="6" & StudyId=="12008" & ChildSl=="1" & Q121==mdy(04,21,2015) & Q621a==""
		replace Q621a="R61146-FORM" if SiteCode=="6" & StudyId=="12013" & ChildSl=="1" & Q121==mdy(04,20,2015) & Q621a==""
		replace Q621a="R61160-FORM" if SiteCode=="6" & StudyId=="12075" & ChildSl=="1" & Q121==mdy(05,17,2015) & Q621a==""
		replace Q621a="R61157-FORM" if SiteCode=="6" & StudyId=="12081" & ChildSl=="1" & Q121==mdy(05,07,2015) & Q621a==""
		replace Q621a="R61156-FORM" if SiteCode=="6" & StudyId=="12106" & ChildSl=="1" & Q121==mdy(05,06,2015) & Q621a==""
		replace Q621a="R61142-FORM" if SiteCode=="6" & StudyId=="12161" & ChildSl=="1" & Q121==mdy(04,12,2015) & Q621a==""
		replace Q621a="R61138-FORM" if SiteCode=="6" & StudyId=="12223" & ChildSl=="1" & Q121==mdy(04,05,2015) & Q621a==""
		replace Q621a="R61136-FORM" if SiteCode=="6" & StudyId=="12829" & ChildSl=="1" & Q121==mdy(04,02,2015) & Q621a==""
		replace Q621a="R61152-FORM" if SiteCode=="6" & StudyId=="12982" & ChildSl=="1" & Q121==mdy(04,29,2015) & Q621a==""
		replace Q621a="R61149-FORM" if SiteCode=="6" & StudyId=="13011" & ChildSl=="1" & Q121==mdy(04,24,2015) & Q621a==""
		replace Q621a="R61153-FORM" if SiteCode=="6" & StudyId=="13848" & ChildSl=="1" & Q121==mdy(05,02,2015) & Q621a==""
		replace Q621a="R61144-FORM" if SiteCode=="6" & StudyId=="14437" & ChildSl=="1" & Q121==mdy(04,17,2015) & Q621a==""
		replace Q621a="R61161-FORM" if SiteCode=="6" & StudyId=="14522" & ChildSl=="1" & Q121==mdy(05,18,2015) & Q621a==""
		replace Q621a="R11361-FORM" if SiteCode=="1" & StudyId=="00325" & ChildSl=="1" & Q121==mdy(09,25,2011) & Q621a==""
		replace Q621a="R11338-FORM" if SiteCode=="1" & StudyId=="00350" & ChildSl=="1" & Q121==mdy(10,06,2011) & Q621a==""
		replace Q621a="R11914-FORM" if SiteCode=="1" & StudyId=="04198" & ChildSl=="1" & Q121==mdy(09,26,2011) & Q621a==""
		replace Q621a="R11596-FORM" if SiteCode=="1" & StudyId=="13057" & ChildSl=="2" & Q121==mdy(11,11,2012) & Q621a==""
		replace Q621a="R11094-FORM" if SiteCode=="1" & StudyId=="13180" & ChildSl=="1" & Q121==mdy(08,17,2011) & Q621a==""
		replace Q621a="R13711-FORM" if SiteCode=="1" & StudyId=="27907" & ChildSl=="1" & Q121==mdy(12,26,2013) & Q621a==""
		replace Q621a="R50463-FORM" if SiteCode=="5" & StudyId=="02227" & ChildSl=="1" & Q121==mdy(06,28,2014) & Q621a==""
		replace Q621a="R51037-FORM" if SiteCode=="5" & StudyId=="05601" & ChildSl=="1" & Q121==mdy(03,24,2014) & Q621a==""
		replace Q621a="R60567-FORM" if SiteCode=="6" & StudyId=="04780" & ChildSl=="1" & Q121==mdy(09,13,2014) & Q621a==""
		replace Q621a="R60585-FORM" if SiteCode=="6" & StudyId=="04780" & ChildSl=="1" & Q121==mdy(09,24,2014) & Q621a==""
		replace Q621a="R60295-FORM" if SiteCode=="6" & StudyId=="04892" & ChildSl=="1" & Q121==mdy(03,06,2014) & Q621a==""
		replace Q621a="R60487-FORM" if SiteCode=="6" & StudyId=="05166" & ChildSl=="1" & Q121==mdy(04,09,2014) & Q621a==""
		replace Q621a="R60262-FORM" if SiteCode=="6" & StudyId=="05317" & ChildSl=="1" & Q121==mdy(02,14,2014) & Q621a==""
		replace Q621a="R60294-FORM" if SiteCode=="6" & StudyId=="06810" & ChildSl=="1" & Q121==mdy(03,06,2014) & Q621a==""
		replace Q621a="R60997-FORM" if SiteCode=="6" & StudyId=="12932" & ChildSl=="1" & Q121==mdy(02,02,2015) & Q621a==""
		replace Q621a="R13295-FORM" if SiteCode=="1" & StudyId=="03144" & ChildSl=="1" & Q121==mdy(06,12,2013)  
		replace Q621a="R60525-FORM" if SiteCode=="6" & StudyId=="06508" & ChildSl=="1" & Q121==mdy(08,19,2014)  
		replace Q621a="R61419-FORM" if SiteCode=="6" & StudyId=="02756" & ChildSl=="1" & Q121==mdy(01,19,2014)  
		replace Q621a="R60457-FORM" if SiteCode=="6" & StudyId=="07452" & ChildSl=="1" & Q121==mdy(04,14,2014)  & Q621a==""
		replace Q621a="R60487-FORM" if SiteCode=="6" & StudyId=="05166" & ChildSl=="1" & Q121==mdy(04,09,2014)  & Q621a==""

		replace Q631a="C50073-FORM" if SiteCode=="5" & StudyId=="00058" & ChildSl=="1" & Q121==mdy(02,28,2014) & Q631a==""
		replace Q631a="C50092-FORM" if SiteCode=="5" & StudyId=="01467" & ChildSl=="1" & Q121==mdy(10,24,2014) & Q631a==""
		replace Q631a="C50070-FORM" if SiteCode=="5" & StudyId=="01666" & ChildSl=="1" & Q121==mdy(01,27,2014) & Q631a==""
		replace Q631a="C50066-FORM" if SiteCode=="5" & StudyId=="03056" & ChildSl=="1" & Q121==mdy(10,12,2013) & Q631a==""
		replace Q631a="C50074-FORM" if SiteCode=="5" & StudyId=="05601" & ChildSl=="1" & Q121==mdy(03,24,2014) & Q631a==""
		replace Q631a="C50089-FORM" if SiteCode=="5" & StudyId=="06552" & ChildSl=="1" & Q121==mdy(10,06,2014) & Q631a==""
		replace Q631a="C60007-FORM" if SiteCode=="6" & StudyId=="05309" & ChildSl=="1" & Q121==mdy(10,07,2014) & Q631a==""
		replace Q631a="C60004-FORM" if SiteCode=="6" & StudyId=="06419" & ChildSl=="1" & Q121==mdy(06,03,2014) & Q631a==""
		replace Q631a="C60005-FORM" if SiteCode=="6" & StudyId=="06464" & ChildSl=="1" & Q121==mdy(06,17,2014) & Q631a==""
		replace Q631a="C60011-FORM" if SiteCode=="6" & StudyId=="06700" & ChildSl=="1" & Q121==mdy(01,22,2015) & Q631a==""
		replace Q631a="C60006-FORM" if SiteCode=="6" & StudyId=="08276" & ChildSl=="1" & Q121==mdy(08,05,2014) & Q631a==""
		replace Q631a="C60003-FORM" if SiteCode=="6" & StudyId=="09538" & ChildSl=="1" & Q121==mdy(04,11,2014) & Q631a==""
		replace Q631a="C60009-FORM" if SiteCode=="6" & StudyId=="11101" & ChildSl=="1" & Q121==mdy(01,21,2015) & Q631a==""
		replace Q631a="C60012-FORM" if SiteCode=="6" & StudyId=="11943" & ChildSl=="1" & Q121==mdy(01,22,2015) & Q631a==""
		replace Q631a="C60008-FORM" if SiteCode=="6" & StudyId=="06930" & ChildSl=="1" & Q121==mdy(01,02,2015) & Q631a==""
		replace Q631a="C60010-FORM" if SiteCode=="6" & StudyId=="06930" & ChildSl=="1" & Q121==mdy(12,09,2014) & Q631a==""

		// Drop duplicate IDs for missing information/ wrong entry
		drop if SiteCode=="3" & StudyId=="04655" & ChildSl=="1" & real(AssType)==2 & Q121==mdy(02,27,2012)
		drop if SiteCode=="6" & StudyId=="00183" & ChildSl=="1" & real(AssType)==2 & Q121==mdy(11,23,2013)
		drop if SiteCode=="6" & StudyId=="00262" & ChildSl=="1" & real(AssType)==2 & Q121==mdy(10,08,2013)
		drop if SiteCode=="6" & StudyId=="00673" & ChildSl=="1" & real(AssType)==2 & Q121==mdy(11,25,2013)
		drop if SiteCode=="6" & StudyId=="00685" & ChildSl=="1" & real(AssType)==2 & Q121==mdy(11,13,2013)
		drop if SiteCode=="6" & StudyId=="00816" & ChildSl=="1" & real(AssType)==2 & Q121==mdy(11,01,2013)
		drop if SiteCode=="6" & StudyId=="00903" & ChildSl=="1" & real(AssType)==2 & Q121==mdy(11,14,2013)
		drop if SiteCode=="6" & StudyId=="01466" & ChildSl=="1" & real(AssType)==2 & Q121==mdy(01,26,2014)
		drop if SiteCode=="6" & StudyId=="01846" & ChildSl=="1" & real(AssType)==2 & Q121==mdy(11,14,2013)
		drop if SiteCode=="6" & StudyId=="02122" & ChildSl=="1" & real(AssType)==2 & Q121==mdy(11,04,2013)
		drop if SiteCode=="6" & StudyId=="03442" & ChildSl=="1" & real(AssType)==3 & Q121==mdy(05,23,2014)
		drop if SiteCode=="6" & StudyId=="03757" & ChildSl=="1" & real(AssType)==3 & Q121==mdy(05,21,2014)
		drop if SiteCode=="6" & StudyId=="08821" & ChildSl=="1" & real(AssType)==2 & Q121==mdy(11,05,2014)
		drop if SiteCode=="6" & StudyId=="04096" & ChildSl=="1" & real(AssType)==3 & Q121==mdy(05,15,2014)

		// Drop duplicate IDs Odisha site only havin only identification information
		drop 	if SiteCode=="6" & StudyId=="00018" & Q121==mdy(10,11,2014)
		drop 	if SiteCode=="6" & StudyId=="00323" & Q121==mdy(10,08,2014)
		drop 	if SiteCode=="6" & StudyId=="00674" & Q121==mdy(02,16,2014)
		drop 	if SiteCode=="6" & StudyId=="01269" & Q121==mdy(11,09,2013)
		drop 	if SiteCode=="6" & StudyId=="01559" & Q121==mdy(11,24,2014)
		drop 	if SiteCode=="6" & StudyId=="01645" & Q121==mdy(11,02,2014)
		drop 	if SiteCode=="6" & StudyId=="01866" & Q121==mdy(12,26,2013)
		drop 	if SiteCode=="6" & StudyId=="03225" & ChildSl=="1" & Q121==mdy(01,11,2014)
		drop 	if SiteCode=="6" & StudyId=="03442" & Q121==mdy(05,23,2014) //2 Records
		drop 	if SiteCode=="6" & StudyId=="03757" & Q121==mdy(05,21,2014) //2 Records
		drop 	if SiteCode=="6" & StudyId=="04151" & Q121==mdy(01,28,2014) //1
		drop 	if SiteCode=="6" & StudyId=="05243" & Q121==mdy(11,10,2014) //1
		drop 	if SiteCode=="6" & StudyId=="05712" & Q121==mdy(09,11,2014)
		drop 	if SiteCode=="6" & StudyId=="06733" & Q121==mdy(01,14,2014) //1
		drop 	if SiteCode=="6" & StudyId=="02681" & Q121==mdy(01,12,2014)
		drop 	if SiteCode=="6" & StudyId=="02756" & Q121==mdy(01,18,2014) 
		drop 	if SiteCode=="6" & StudyId=="03165" & Q121==mdy(09,23,2014) 
		drop 	if SiteCode=="6" & StudyId=="08821" & Q121==mdy(11,05,2014) //2 Records
		drop 	if SiteCode=="6" & StudyId=="09135" & Q121==mdy(07,25,2014) 
		drop 	if SiteCode=="6" & StudyId=="11456" & Q121==mdy(02,14,2015)
		
		// Form 3 not available
		drop 	if SiteCode=="3" & StudyId=="07720" 
		//Forcely dropped as not match with 7a
		drop	if SiteCode=="1" & StudyId=="25686" & Q121==mdy(11,22,2013)
		
		replace Q121=mdy(8,19,2014) 	if SiteCode=="6" & StudyId=="06508" 
		replace Q611a="B60325-FORM" 	if SiteCode=="6" & StudyId=="06508" & ChildSl=="1" 
		replace Q621a="R60525-FORM" 	if SiteCode=="6" & StudyId=="06508" & ChildSl=="1" 
		replace Q611a="B60024-FORM" 	if SiteCode=="6" & StudyId=="07543" & ChildSl=="1" & Q121==mdy(1,11,2014)
		replace AssType="2" if SiteCode=="6" & StudyId=="10013" 
		replace Q120="2" 	if SiteCode=="6" & StudyId=="10013" 
		replace Q513="1" 	if SiteCode=="6" & StudyId=="10013" 
		
		destring Q601 Q602 Q611 Q621 Q631, replace
		replace Q601=1 if Q601!=1 & (Q611a!="" | Q621a!="" | Q631a!="" )
		replace Q602=1 if Q602!=1 & (Q611a!="" | Q621a!="" | Q631a!="" )
		replace Q611=1 if trim(Q611a)!="" 
		replace Q621=1 if trim(Q621a)!="" 
		replace Q631=1 if trim(Q631a)!="" 
		
		for var Q6*: destring X, replace
		replace Q611=2 if Q611==1 & Q611a==""
		replace Q612=9 if Q611==2 & Q612 ==.
		replace Q621=2 if Q621==1 & Q621a==""
		replace Q622=9 if Q621==2 & Q622 ==.
		replace Q631=2 if Q631==1 & Q631a==""
		replace Q632=9 if Q631==2 & Q632 ==.
		
		replace Q612=. if Q611a!=""
		replace Q622=. if Q621a!=""
		replace Q632=. if Q631a!=""
		// Drop 110 IDs from Form 6 and Lab files
		
		drop if SiteCode=="1" & inlist(StudyId, "02247", "02306", "02711", "06426", "05850", "13255", "10650", "06453", "10372") //2
		drop if SiteCode=="1" & inlist(StudyId, "07008", "08059", "08163", "08819", "12094", "12532", "12770", "13031", "25675") //2
		drop if SiteCode=="1" & inlist(StudyId, "13980", "16862", "19402", "22588", "22612", "19386","28613","28767","32785")
		drop if SiteCode=="1" & inlist(StudyId, "00976", "03058", "06449", "07754", "08578", "13957","01486","28996")
		
		drop if SiteCode=="3" & inlist(StudyId, "10550", "03755", "04171", "06409", "07044", "51966", "52282", "51856", "50869")
		drop if SiteCode=="3" & inlist(StudyId, "07709", "07720", "07745", "07783", "07848", "08506", "09841", "52598", "50961")
		drop if SiteCode=="3" & inlist(StudyId, "11157", "11721", "11838", "20192", "22127", "53749", "24101", "51670", "51469")
		drop if SiteCode=="3" & inlist(StudyId, "30202", "30477", "30997", "31150", "31698", "33350", "34296", "40315", "50572")
		drop if SiteCode=="3" & inlist(StudyId, "40380", "40408", "40510", "40513", "40611", "40626", "40736", "40814", "50535")
		drop if SiteCode=="3" & inlist(StudyId, "41150", "41418", "41462", "41935", "41936", "42059", "42174", "42191", "50533")
		drop if SiteCode=="3" & inlist(StudyId, "42199", "42203", "42337", "42620", "43159", "43330", "43610", "43632", "50485")
		drop if SiteCode=="3" & inlist(StudyId, "51516", "43816", "50279", "50477", "07434", "00872")
		drop if SiteCode=="3" & inlist(StudyId, "10380", "22613", "51516", "05742") // Have Specimen 
		drop if SiteCode=="6" & inlist(StudyId, "05725","06782","06108")

		replace 	ChildSl="2" if SiteCode=="3" & inlist(StudyId,"01484", "06108","06782")
		replace 	ChildSl="2" if SiteCode=="4" & inlist(StudyId,"40688")
		
		replace 	Q206="1" if SiteCode=="6" & inlist(StudyId,"10013")
		replace 	Q132="1" if Q132!="1" & AssType=="2"
***************************************************************************************************************************************		
		** Site 1 StudyID 03820 Update in SQL
		}
		
if 	Up == 3 {
		replace SampName=trim(SampName)
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

		drop if SiteCode == "1" & SampName== "B11012-TLDA" & expBarCode== "85470865"
		drop if SiteCode == "1" & SampName== "B11144-TLDA" & expBarCode== "91641225"
		drop if SiteCode == "1" & SampName== "B11145-TLDA" & expBarCode== "91640887"
		drop if SiteCode == "1" & SampName== "B11916-TLDA" & expBarCode== "91641220"
		drop if SiteCode == "3" & SampName== "B31473-TLDA" & expBarCode== "85470090"
		drop if SiteCode == "5" & SampName== "B50463-TLDA" & expBarCode== "B04710496"
		drop if SiteCode == "6" & SampName== "B60036-TLDA" & expBarCode== "B04710236"
		drop if SiteCode == "6" & SampName== "B60153-TLDA" & expBarCode== "91641609"
		
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
		drop if SiteCode == "4" & SampName== "B42321-TLDA" & expBarCode== "91640264"
		drop if SiteCode == "6" & SampName== "B60428-TLDA" & expBarCode== "B04710061"

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
		drop if SiteCode == "3" & SampName== "R30509-TLDA" & expBarCode== "71270436"   

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
		drop if SiteCode == "6" & SampName== "R60027-TLDA" & expBarCode== "B04700206"

		//Dr Luke adding a row regarding 

		drop if expBarCode == "71260207" & SampName=="B40384-TLDA"

		***************************************************************
		*** Drop wrong Specimen IDs from TLDA file - Karachi Sites	***
		***************************************************************

		drop if SiteCode=="3" & substr(SampName,1,2)=="B4"
		drop if SiteCode=="3" & substr(SampName,1,2)=="R4"
		drop if SiteCode=="4" & substr(SampName,1,2)=="B3"
		drop if SiteCode=="4" & substr(SampName,1,2)=="R3"

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

		*************************************************************
		replace SampName = "B10738-TLDA" 	if SampName == "10738-TLDA"
		//replace SampName = "B13679-TLDA" if SampName == "13679-TLDA"
		replace expBarCode = "85470615" 	if expBarCode=="8540615"
		replace expBarCode = "85470101" 	if expBarCode=="8547010" 
		replace expBarCode = "85470491" 	if expBarCode=="8547091" 
		replace expBarCode = "85471206" 	if expBarCode=="8547106" 
		replace SampName="R41653-TLDA" 		if SampName=="R 41653-TLDA"
		replace SampName="B32346-TLDA" 		if SampName=="B332346-TLDA"
		replace SampName="R11138-TLDA" 		if SampName=="R11138"
		*************************************************************
		//drop 	if expRunDate==mdy(12,30,2013) & SiteCode==3 & respID=="R31588"
		//drop	if expRunDate==mdy(01,01,2014) & SiteCode==3 & respID=="R30693"
		
		drop if inlist(SampName,"B11622-TLDA","B10196-TLDA","B11996-TLDA","B12231-TLDA","B11119-TLDA","B11574-TLDA")
		drop if inlist(SampName,"B11737-TLDA","B13223-TLDA","B13171-TLDA","B12281-TLDA","B12137-TLDA")
		  
		drop if inlist(SampName,"R11044-TLDA","R10191-TLDA","R11468-TLDA","R13889-TLDA","R12322-TLDA","R12827-FORM","R10474-TLDA")
		drop if inlist(SampName,"R10833-TLDA","R11138-TLDA","R13608-TLDA","R12872-TLDA","R13688-TLDA","R12873-FORM")

		// Need to check these IDs
		drop if inlist(SampName,"B60091-TLDA","B60402-TLDA","B60403-TLDA","B60404-TLDA","B60414-TLDA","B60610-TLDA","B60742-TLDA")
		drop if inlist(SampName,"R10979-TLDA","R11534-TLDA","R12385-TLDA","R12622-TLDA","R12623-TLDA","R12827-TLDA","R12873-TLDA","R13700-TLDA")
		drop if inlist(SampName,"R13706-TLDA","R13719-TLDA","R13898-TLDA","R30582-TLDA","R31713-TLDA","R60001-TLDA","R60002-TLDA")
		drop if inlist(SampName,"R60003-TLDA","R60006-TLDA","R60013-TLDA","R60235-TLDA","R60289-TLDA","R60410-TLDA","R61339-TLDA")
		
		// Drop IDs in Pilot phase
		drop if inlist(SampName,"R10827-TLDA","R10828-TLDA","R10829-TLDA","R10830-TLDA","R10832-TLDA","R10838-TLDA","R11011-TLDA")
		drop if inlist(SampName,"R11018-TLDA","R11024-TLDA","R11025-TLDA","R11026-TLDA","R11027-TLDA","R11028-TLDA","R11029-TLDA")
		drop if inlist(SampName,"R11031-TLDA","R11094-TLDA","R11305-TLDA","R11311-TLDA","R11047-TLDA","R11301-TLDA","R11306-TLDA")
		drop if inlist(SampName,"R11042-TLDA","R11043-TLDA","R11046-TLDA","R11327-TLDA","R11314-TLDA","R11302-TLDA","R11307-TLDA")
		drop if inlist(SampName,"R11317-TLDA","R11303-TLDA","R11336-TLDA","R11315-TLDA","R11310-TLDA","R11319-TLDA","R11307-TLDA")
		drop if inlist(SampName,"R11312-TLDA","R11325-TLDA","R11313-TLDA","R11326-TLDA","R11322-TLDA","R11316-TLDA","R11318-TLDA")
		drop if inlist(SampName,"R11333-TLDA","R11338-TLDA","R11352-TLDA","R11366-TLDA","R11356-TLDA","R11321-TLDA","R11340-TLDA")
		drop if inlist(SampName,"R11308-TLDA","R11337-TLDA","R11344-TLDA","R11355-TLDA","R11349-TLDA","R11365-TLDA","R11334-TLDA")
		drop if inlist(SampName,"R11309-TLDA","R11335-TLDA","R11346-TLDA","R11372-TLDA","R11351-TLDA","R11365-TLDA","R11328-TLDA")
		drop if inlist(SampName,"R11350-TLDA","R11329-TLDA","R11345-TLDA","R11364-TLDA","R11341-TLDA","R11367-TLDA","R11323-TLDA")
		drop if inlist(SampName,"R11342-TLDA","R11373-TLDA","R11395-TLDA","R11387-TLDA","R11390-TLDA","R11393-TLDA","R11388-TLDA")
		drop if inlist(SampName,"R11370-TLDA","R11901-TLDA","R11385-TLDA","R11904-TLDA","R11905-TLDA","R11389-TLDA","R11384-TLDA")
		drop if inlist(SampName,"R11382-TLDA","R11371-TLDA","R11380-TLDA","R11907-TLDA","R11915-TLDA","R11392-TLDA","R11386-TLDA")
		drop if inlist(SampName,"R11375-TLDA","R11381-TLDA","R11912-TLDA","R11909-TLDA","R11920-TLDA","R11394-TLDA")
		drop if inlist(SampName,"R11916-TLDA","R11938-TLDA","R11930-TLDA","R11975-TLDA","R11929-TLDA","R11936-TLDA","R30141-TLDA")
		drop if inlist(SampName,"R11917-TLDA","R11932-TLDA","R11935-TLDA","R11977-TLDA","R11940-TLDA","R11943-TLDA","R11947-TLDA")
		drop if inlist(SampName,"R11942-TLDA","R11928-TLDA","R40362-TLDA","R11931-TLDA","R11946-TLDA","R11925-TLDA","R11977-TLDA")
		drop if inlist(SampName,"R11974-TLDA","R40341-TLDA","R11934-TLDA","R11931-TLDA","R11922-TLDA","R11944-TLDA","R11927-TLDA")



}


