CompareCalls <- function () {
  calls1.file <- choose.files("", caption='select CSV 1 for call comparison', multi=F)
  calls2.file <- choose.files("", caption='select CSV 2 for call comparison', multi=F)
  calls1.name <- sub("^([^.]*).*", "\\1", basename(calls1.file))
  calls2.name <- sub("^([^.]*).*", "\\1", basename(calls2.file))
  
  calls1 <- read.csv(calls1.file, sep=';', header=T)  
  calls1 <- na.omit(calls1)
  calls2 <- read.csv(calls2.file, sep=';', header=T)
  calls2 <- na.omit(calls2)
  
  male1 <- levels(calls1[,1])
  male2 <- levels(calls2[,1])
    
  pdf(paste0('comp_', calls1.name, '_', calls2.name, '.pdf'),  width=11.69, height=6)
  par(mfrow=c(1,2))
  
  # plot for the male1 ################################################################
  #####################################################################################
  a <- rep(NA,10)
  b <- rep(NA,10)
  plot(a,b, type='l', col=alpha('grey', 0.5), lwd=10, xlim=c(-0.2,1.5), ylim=c(0,2000),
       xlab='Čas (s)', ylab='Frekvence (Hz)', main=male1, cex.main=4)
  grid (NULL,NULL, lty = 1, col = "grey")
  
  ### paint train calls
  for (i in 1:nrow(calls1)){
    a <- seq (from = 0, to = calls1[i, 2], by = calls1[i, 2]/9)
    b <- as.numeric(calls1[i, 3:12])
    lines(a,b, col=alpha('cornflowerblue', 0.2), lwd=10)
  }
  
  ### paint mean
  calls1.mean <- sapply(calls1, mean)
  a <- seq (from = 0, to = calls1.mean[2], by = calls1.mean[2]/9)
  b <- as.numeric(calls1.mean[3:12])
  lines(a,b, col=alpha('darkred', 1), lwd=5)
  
  
  
  # plot for the male2 ################################################################
  #####################################################################################
  a <- rep(NA,10)
  b <- rep(NA,10)
  plot(a,b, type='l', col=alpha('grey', 0.5), lwd=10, xlim=c(-0.2,1.5), ylim=c(0,2000),
       xlab='Čas (s)', ylab='Frekvence (Hz)', main=male2, cex.main=4)
  grid (NULL,NULL, lty = 1, col = "grey")
  
  ### paint train calls
  for (i in 1:nrow(calls2)){
    a <- seq (from = 0, to = calls2[i, 2], by = calls2[i, 2]/9)
    b <- as.numeric(calls2[i, 3:12])
    lines(a,b, col=alpha('cornflowerblue', 0.2), lwd=10)
  }
  
  ### paint mean
  calls2.mean <- sapply(calls2, mean)
  a <- seq (from = 0, to = calls2.mean[2], by = calls2.mean[2]/9)
  b <- as.numeric(calls2.mean[3:12])
  lines(a,b, col=alpha('darkred', 1), lwd=5)
  
  dev.off()
}

