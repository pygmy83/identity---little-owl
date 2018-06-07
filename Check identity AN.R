### PACKAGES NEEDED ######################################################################
##########################################################################################

packages.needed <- c("seewave", "signal", "tuneR", "monitoR","warbleR", "tcltk2", "scales", "testit")

out <- lapply(packages.needed, function(y) {
  if(!y %in% installed.packages()[,"Package"])  install.packages(y)
  require(y, character.only = T) 
})



### MAIN CODE ############################################################################
##########################################################################################

list_templates <- ChooseTemplates() # choose folder with templates (at least 3 files required in current version)
#templateCutoff(list_templates) <- rep(20,length(templateCutoff(list_templates)))

DetectCalls(list_templates) # detect sound events (calls) with the templates selected in previous step
AnalyzeCalls() # automatic analysis of detected sound events; spectrograms along with measurements are plotted and user enters "y" (measurements are ok) or "n" (there is no call or measurements do not track call properly)
CompareCalls() # plot the measurments from two males / localities in one figure for comparison
PlotCalls()

