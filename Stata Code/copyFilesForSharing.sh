#!/bin/bash
rm ../AnalyticFilesForExternalSharing/*.dta -f
cp *.dta ../AnalyticFilesForExternalSharing/
rm ../AnalyticFilesForExternalSharing/missingBirthDates.dta
rm ../AnalyticFilesForExternalSharing/AnisaLab7aBacTec.dta
rm ../AnalyticFilesForExternalSharing/AnisaLab7bData.dta
rm ../AnalyticFilesForExternalSharing/AnisaExtraVisitData.dta

cp "Lab Working File/LabOutputFiles/AnisaBloodFile.dta" ../AnalyticFilesForExternalSharing/
cp "Lab Working File/LabOutputFiles/AnisaRespFile.dta" ../AnalyticFilesForExternalSharing/
cp "Lab Working File/LabOutputFiles/FinalEtiologyAnalyticFile.dta" ../AnalyticFilesForExternalSharing/AnisaEtiologyAnalyticFile.dta
cp "Lab Working File/WetChem/AnisaWetChemistryResults.dta" ../AnalyticFilesForExternalSharing/
cp "Flowcharts/ANISABabyFlowchart.dta" ../AnalyticFilesForExternalSharing/
cp "Flowcharts/ANISAPregnancyFlowchart.dta" ../AnalyticFilesForExternalSharing/
