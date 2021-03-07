del "..\AnalyticFilesForExternalSharing\*.dta"
copy *.dta "..\AnalyticFilesForExternalSharing\" /Y
del "..\AnalyticFilesForExternalSharing\missingBirthDates.dta"
del "..\AnalyticFilesForExternalSharing\AnisaLab7aBacTec.dta"
del "..\AnalyticFilesForExternalSharing\AnisaLab7bData.dta"
del "..\AnalyticFilesForExternalSharing\AnisaExtraVisitData.dta"

copy "Lab Working File\LabOutputFiles\AnisaBloodFile.dta" "..\AnalyticFilesForExternalSharing\" /Y
copy "Lab Working File\LabOutputFiles\AnisaRespFile.dta" "..\AnalyticFilesForExternalSharing\" /Y
copy "Lab Working File\LabOutputFiles\FinalEtiologyAnalyticFile.dta" "..\AnalyticFilesForExternalSharing\AnisaEtiologyAnalyticFile.dta" /Y
copy "Lab Working File\WetChem\AnisaWetChemistryResults.dta" "..\AnalyticFilesForExternalSharing\" /Y
copy "Flowcharts\ANISABabyFlowchart.dta" "..\AnalyticFilesForExternalSharing\" /Y
copy "Flowcharts\ANISAPregnancyFlowchart.dta" "..\AnalyticFilesForExternalSharing\" /Y
