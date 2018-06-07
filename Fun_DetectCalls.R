DetectCalls <- function (list_templates) {
  recording.name <- choose.files("", caption='select original recording for call detection', multi=F) 
  recording <- readWave(recording.name)
  cscores <- binMatch(recording.name,list_templates)
  cdetects <- findPeaks(cscores)
  tabl_detect<-data.frame(getDetections(cdetects))
  #plot(cdetects)
  tabl_detect<- tabl_detect[order(tabl_detect[,3]),]
  index<-c(1:nrow(tabl_detect))
  tabl_detect<-cbind(tabl_detect,index)
  #write.csv2(tabl_detect, paste0('test_rec_detect','.csv'))
  
  ### Now we have table with times of detection for each template; We need to combine detection of all templates
  ### into songs; Detections of each template will be merged if the interval between peaks does not exceed
  ### 'songtolerance' threshold
  temp <- c(NA, tabl_detect$time[1:nrow(tabl_detect)-1])
  tabl_detect$intervals <- tabl_detect$time-temp
  
  tabl_detect$song_number <- rep(NA, nrow(tabl_detect))
  songn <- 1
  songtolerance <- 1 # threshold interval between peaks for a new song detection
  for (j in 2:length(tabl_detect$intervals)) {  
    if (tabl_detect$intervals[j] < songtolerance) {
      tabl_detect$song_number[j] <- songn
    } else{
      songn <- songn+1
      tabl_detect$song_number[j] <- songn
    } 
  }
  tabl_detect <- tabl_detect[complete.cases(tabl_detect), ] #first line always produces NA due to missing interval
  
  sound.files = rep(basename(recording.name), max(tabl_detect$song_number))
  song_number = rep(NA, max(tabl_detect$song_number))
  song_start = rep(NA, max(tabl_detect$song_number))
  song_end = rep(NA, max(tabl_detect$song_number))
  song_margin <- 1
  
  for (j in 1:max(tabl_detect$song_number)) { # this loop finds start and end for each song event
    song<-subset(tabl_detect$time, tabl_detect$song_number == j)
    #song_event<-c((min(song)-0.6),(1+max(song))) #change to mean value +- 1s
    song_event <- c(mean(song)-song_margin, mean(song)+song_margin)
    song_number[j] = j
    song_start[j] = song_event[1]
    song_end[j] = song_event[2]
  }
  
  tabl_event <- data.frame(sound.files, song_number, song_start, song_end)
  rec_duration <- length(recording)/recording@samp.rate
  tabl_event$song_start[tabl_event$song_start < 0] <- 0 #check negative values
  tabl_event$song_end[tabl_event$song_end < 0] <- 0 #check negative values
  tabl_event$song_start[tabl_event$song_start > rec_duration] <- rec_duration #check maximum values
  tabl_event$song_end[tabl_event$song_end > rec_duration] <- rec_duration #check maximum values
  #write.csv2(tabl_event, paste0('tabl_event','.csv'), row.names=F)
  
  
  ### now split the recording into several files using start and end times from tabl_event and save it to separate directory in /cut recordings/ 
  ### 
  
  tabl_event <- tabl_event[complete.cases(tabl_event), ]
  nbcalls=nrow(tabl_event)
  recording.name.nopath <- sub("^([^.]*).*", "\\1", basename(recording.name))
  dir.create(paste0(getwd(),'/cut recordings'))
  dest.dir <- paste0(getwd(), '/cut recordings/',recording.name.nopath, '/')
  dir.create(dest.dir)
  
  for(i in 1:nbcalls)
  {		
    print(i)
    call <- cutWave(recording, from=tabl_event$song_start[i], to=tabl_event$song_end[i])
    savewav(call, f = 44100, filename=paste0(dest.dir, recording.name.nopath, '_', tabl_event$song_number[i], ".wav" ), rescale = NULL)
  }
  
  ### now save the long spectrogram with detected events for a visual check of detection
  #The Wav file need to be on the working directory 
  names(tabl_event) <- c('sound.files', 'selec', 'start', 'end')
  workdir <- getwd()
  tempworkdir <- dirname(recording.name)
  setwd(tempworkdir)
  lspec(tabl_event, flim = c(0.5,10), sxrow = 15, rows = 8, collev = seq(-40, 0, 1), ovlp = 50, parallel = 1, wl = 512, gr = FALSE, pal = reverse.gray.colors.2, cex = 1, it = "jpeg")
  setwd(workdir)
  
}
