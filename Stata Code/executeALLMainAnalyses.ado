//Try to write an overall program that will produce the main datasets, and then 
//collate them for sharing to others:

/*The steps are as follows
1. execute the createAnisaWorkingFiles do file
2. execute the CaseControlDefinition ado file
3. execute the createEtiologyFile, with option to run do file
4. exectue the drawCombinedFlowchart File, with re-run option 
*/
program define executeALLMainAnalyses
	syntax, [includeCreation] [prepareFiles]
	qui {

	* run setup to ensure access to global commands
	qui do "stata_do_files/setup.do"

	************************************
	****	STEP 1 - Creation (if requested)
	************************************
	
	if "`includeCreation'"!="" {
		noi di _continue as text "Running base creation code (takes time)..."
		do "stata_do_files/createAnisaWorkingFiles"
		noi di as result "...complete"
	}
	
	************************************
	****	STEP 2 - Case Control Algorithm
	************************************
	capture mkdir "CaseControlDefinition"
	capture mkdir "CaseControlDefinition/CaseControlOutputFiles"
	capture cd "CaseControlDefinition/"
	
	noi di _continue as text "Running Case Control Algorithm..."
	noi defineCaseControlRows, includeNonSpecimens
	noi di as result "...complete"
	capture cd ..
	
	************************************
	****	STEP 3 - EtiologyTempFile
	************************************
	capture mkdir "Lab Working File"
	capture mkdir "Lab Working File/LabOutputFiles"
	capture cd "Lab Working File/"
	noi di _continue as text "Preparing Lab and Etiology Files..."
	qui createFinalEtiologyAnalysisFile, `prepareFiles'
	noi di as result "...complete"
	capture cd ..
	
	************************************
	****	STEP 4 - Execute Flowchart Files
	************************************
	capture mkdir "Flowcharts"
	capture cd "Flowcharts/"
	noi di _continue as text "Executing Flowchart Process..."
	qui drawCombinedFlowchart, rerun
	qui do "../stata_do_files/createPLF.do"
	qui do "../stata_do_files/createBLF.do"
	noi generateAllFlowchartPDFs
	noi di as result "...complete"
	capture cd ..
	
	************************************
	****	STEP 5 - copy all files to a final folder for sharing
	************************************
	if c(os)=="Unix" {
		shell "./copyFilesForSharing.sh"
	}
	else {
		//assume Windows
		shell "copyFilesForSharing.bat"	
	}
	
	
	cd "../Stata Code"
	
	noi di as result "All files copied to sharing folder. Work Done."
	
	} // end quietly
end
