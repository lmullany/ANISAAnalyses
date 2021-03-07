//Program to print all flowcharts to PDF
//Luke C. Mullany

program define generateAllFlowchartPDFs
	syntax

	printCommand, command(drawCombinedFlowchart, site(1) showReaNotReg) output(Sylhet_flowchart_10_24_2016) landscape fontsize(6)
	printCommand, command(drawCombinedFlowchart, site(3) showReaNotReg) output(Karachi_flowchart_10_24_2016) landscape fontsize(6)
	printCommand, command(drawCombinedFlowchart, site(4) showReaNotReg) output(Matiari_flowchart_10_24_2016) landscape fontsize(6)
	printCommand, command(drawCombinedFlowchart, site(5) showReaNotReg) output(Vellore_flowchart_10_24_2016) landscape fontsize(6)
	printCommand, command(drawCombinedFlowchart, site(6) showReaNotReg) output(Odisha_flowchart_10_24_2016) landscape fontsize(6)
	printCommand, command(drawCombinedFlowchart, showReaNotReg) output(Overall_flowchart_10_24_2016) landscape fontsize(6)

end