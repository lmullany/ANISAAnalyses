# ANISA Stata Code to Create Analytic Files and Flowcharts

This repo provides Stata do and ado files that will create numerous analtyic files. At the outset, there are three main folders:
- AnalyticFilesForExternalSharing: this subfolder is empty initially, but will receive a set of created analytic files
- Source Anisa Tables: this subfolder contains only .dta (Stata) files that are the source/raw tables from which analytic files are derived
- Stata Code: this subfolder contains all the analytic code that will generate files from the source .dta file

It is the last folder (Stata Code) where all the action lies. In this folder, there are initally two subfolders that contain `.do` files (`stata_do_files/`) and `.ado/.mo` (`stata_source_files/`) that are the workhorses of this repo. All the code can be run with one stata command line call, using the "executeALLMainAnalyses.ado" file.

### Requirements:
- Stata 13 or above
- Maintainence of the file structure from this repo. That is, the structure and names of folders as presented in this repo must be maintained
- Write access to this structure: during the process of running `executeALLMainAnalyses` a number of sub-folders will created using Stata's `mkdir` command; these will fail (quietly) if the running user/process does not have write access. Even on quiet failure of the `mkdir` commands, subsequent calls by the various `.ado/.do/.mo` files will call these newly created directories, and thus will fail without write access. 
- You must have rights to update the adopath in Stata. The very first task of the `executeALLMainAnalyses` file is to call `stata_do_files/setup.do`, which simply ensures that all subsequent code will have access to `.ado/.mo` files in `stata_source_files/` subfolder. Without adding this to the adopath, the code will not be able to find the numerous user-written commands that facilitate the derivation of these analytic files.

### Excecution:
- clone the repo
- open your version of Stata
- navigate to `<your repo location>/Stata Code/`
- type `executeALLMainAnalyses, includeCreation prepareFiles`

### Output:
- Within the `Stata Code/` subfolder (i.e. the working directory from which `executeALLMainAnalyses` is called, three new subfolders will be created:
  - **CaseControlDefinition and CaseControlDefinition/CaseControlOutputFiles/**: This is where files related to Case Control Definition will be created and stored
  - **Flowcharts**: This is where pregnancy and baby level flowchart files are created, along with a PDF version of site-specific and overall flowcharts 
  - **Lab Working File and Lab Working File/LabOutputFiles**: This is where the lab output files will be created.

