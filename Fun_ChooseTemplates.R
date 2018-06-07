ChooseTemplates <- function () {  
  folder <- tk_choose.dir(default = "", caption = "Select directory")
  #setwd(folder)
  template.files <- list.files(path=folder, pattern=".wav")
  templaten <- length(template.files)
  template.name <- rep(NA, templaten)
  
  cutoff <- 20 # threshold for accepting template detection - higher is more strict
  
  for (i in 1:templaten) {template.name[i] <- paste0("template", i)}
  
  temp1 <- makeBinTemplate(paste0(folder, '/', template.files[1]),frq.lim = c(0.5,12),amp.cutoff = -40, score.cutoff = cutoff, name = template.name[1])
  temp2 <- makeBinTemplate(paste0(folder, '/', template.files[2]),frq.lim = c(0.5,12),amp.cutoff = -40, score.cutoff = cutoff, name = template.name[2])
  list_templates<-combineBinTemplates(temp1, temp2)
  for (i in 3:templaten) {
    tempi <- makeBinTemplate(paste0(folder, '/', template.files[i]),frq.lim = c(0.5,12),amp.cutoff = -40, score.cutoff = cutoff, name = template.name[i])
    list_templates<-combineBinTemplates(list_templates, tempi)
  }
  
  #list_templates
  #plot(list_templates)
  return(list_templates)
}
