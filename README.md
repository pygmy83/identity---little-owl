# identity---little-owl

This is R projet that allows semi automatic analysis of little owl calls. THe aim is to compare fine acoustic features of the calls and decide about whether the calls are from same individuals.

Workflow
The sequence of steps is in the file 'Check identity AN.R'.
1) Instal and load packages needed
2) Open .R files with functions and lead them in the project
3) ChooseTemplates. Select call examples that will serve as templates (minimum of three templates required). Save the result of function into an object that will be used as an argument for subsequent function.
4) DetectCalls. This function will search for selected templates in a given recording. The result of detection can be checked graphically in generated spectrogram files. Additionally, each detected call will be saved into a separate file in 'cut recordings' folder.
5) AnalyzeCalls. This function will go through all cut recordings and will measure the frequency modulation in each file. The function plots each call and measurements and allows user to check measurment results. User can decide whether the call was measured correctly or not. Results will be saved into CSV table in 'result csv' folder
6) Compare calls. User can select two result files with recording measurments and the function will plot measurments of each call and average values of calls across whole recording. Pictures are saved in a single PDF. User can visually check whther the calls from two recordings are similar or different, what is the variation in measurments, etc.
