AnalyzeCalls <- function() {
  folder <- tk_choose.dir(default = "", caption = "Select directory with calls for analysis")
  calls.files <- list.files(path=folder, pattern=".wav")
  callsn <- length(calls.files)
  thresholdDetect <- 40
  sampleF.file <- (f=44100)
  sampleF.analyze <- (f=4000)
  i <- 4 #34 
  res.table <- NULL
  
  id <- rep(NA, callsn) 
  startt <- rep(NA, callsn)
  endt <- rep(NA, callsn)
  dur <- rep(NA, callsn)
  f1 <- rep(NA, callsn)
  f2 <- rep(NA, callsn)
  f3 <- rep(NA, callsn)
  f4 <- rep(NA, callsn)
  f5 <- rep(NA, callsn)
  f6 <- rep(NA, callsn)
  f7 <- rep(NA, callsn)
  f8 <- rep(NA, callsn)
  f9 <- rep(NA, callsn)
  f10 <- rep(NA, callsn)
  usecall <- rep(NA, callsn)
  
  for (i in 1:callsn) {
    #preparation of call
    call.analyze <- readWave(paste0(folder, '/', calls.files[i]))
    call.analyze2 <- resamp(call.analyze, sampleF.file, sampleF.analyze, output="Wave") #file is resampled to show better the
    call.analyze2 <- ffilter(call.analyze2, from = 500, to = 1800, bandpass = TRUE, custom = NULL, wl = 1024, ovlp = 75, wn = "hanning", fftw = FALSE, output="wave")  
  
    # detect call boundaries
    calldetecterror <- has_error(
    note_time <- timer(call.analyze2, sampleF.analyze, threshold = thresholdDetect, dmin = 0.3, envt="abs",
          power = 1, msmooth = c(100,10), ksmooth = NULL,
          ssmooth = NULL, tlim = NULL, plot = TRUE, plotthreshold = TRUE,
          col = "black", colval = "red",
          xlab = "Time (s)", ylab = "Amplitude")
    )
  
      if (calldetecterror==F) {
      note_time <- timer(call.analyze2, sampleF.analyze, threshold = thresholdDetect, dmin = 0.25, envt="abs",
                         power = 1, msmooth = c(100,10), ksmooth = NULL,
                         ssmooth = NULL, tlim = NULL, plot = TRUE, plotthreshold = TRUE,
                         col = "black", colval = "red",
                         xlab = "Time (s)", ylab = "Amplitude")
  
      # measure and plot measurements
      note_dfreq<-dfreq(call.analyze2, f=sampleF.analyze, wl=256,  
                        bandpass = c(500,2000), at=seq(note_time$s.start[1], note_time$s.end[1],len=12),  
                        col=2, plot=T) # threshold = 40, ovlp=75,  
      
      spectro.name <- paste0('call ',i , ' / ', callsn)
      spectro(call.analyze2, wn = 'flattop', wl=256, f=sampleF.analyze, ovlp=75, norm=T,
              osc=F, scale=F, palette=reverse.gray.colors.2,
              main=spectro.name)
      points(note_dfreq[3:12, 1], note_dfreq[3:12,2],col=2, pch=16, cex=3)

      #ask user if measurments are within calls
      usecall[i] <- readline("Is there a call and all all of the measurements within the call?")
  
      #save measurements
      id[i] <-  basename(folder)
      startt[i] <- note_dfreq[3]
      endt[i] <- note_dfreq[12]
      dur[i] <- endt[i]-startt[i]
      f1[i] <- 1000* note_dfreq[3,2]
      f2[i] <- 1000* note_dfreq[4,2]
      f3[i] <- 1000* note_dfreq[5,2]
      f4[i] <- 1000* note_dfreq[6,2]
      f5[i] <- 1000* note_dfreq[7,2]
      f6[i] <- 1000* note_dfreq[8,2]
      f7[i] <- 1000* note_dfreq[9,2]
      f8[i] <- 1000* note_dfreq[10,2]
      f9[i] <- 1000* note_dfreq[11,2]
      f10[i] <- ifelse(usecall[i]=='y', 1000* note_dfreq[12,2], NA)
      
    } else {
      usecall[i] <- 'n'
    }
  
  }
  
  # save table with measurements
  res.table <- data.frame(id, dur, f1, f2, f3, f4, f5, f6, f7, f8, f9, f10)

  dir.create(paste0(getwd(),'/result csv'))
  res.dir <- paste0(getwd(),'/result csv')
  res.table.filename <- paste0(res.dir, '/', basename(folder), '.csv')
  
  write.table(res.table, res.table.filename, sep=';', row.names=F)
}
