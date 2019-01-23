#Author: Jeff Cegan
#Project: State Department
#Date: 11/29/2018


##############
### setup ###
############

#load libraries
lapply(c("tidyverse", "reshape2", "plyr"), require, character.only = TRUE)

#set working directory
setwd("C:/Users/xadmin/projects/state-department")


#############
### read ###
###########

#table: physical security measures list
psm <- read.csv("data/physical-security-measures_title.csv",as.is = TRUE)

#table: threat level and weight
#tlv<-read.csv("data/threat-level.csv")#tlv<-melt(tl) #tlv<-rename(tl, c("X"="type", "variable"="level"))
tl1 <- read.csv("data/threat-1-level_titles.csv",as.is = TRUE)
tl2 <- read.csv("data/threat-2-level_titles.csv",as.is = TRUE)
tl3 <- read.csv("data/threat-3-level_titles.csv",as.is = TRUE)

#table: physical security measures - deficiencies
dfs <- read.csv("data/psm-deficiencies.csv",as.is = TRUE)

#table: physical security measures - conforming
cfm <- read.csv("data/psm-conforming.csv",as.is = TRUE)


################
### wrangle ###
##############

#remane measure id column in deficiencies and conforming tables
dfs<-rename(dfs, c("Tthreat"="TThreat","Cthreat"="CThreat","Physical.Security.Measure.ID.."="ID"))
cfm<-rename(cfm, c("Tthreat"="TThreat","Cthreat"="CThreat","Physical.Security.Measure.ID.."="ID"))
psm<-rename(psm, c("PVTreat.Perf"="PVThreat.Perf","Description"="Measure.Description","Description.1"="Measure.Description.Short"))

#delete descriptions from cfm and dfs tables since this data is referenced on psm
drop.cols <- c("Description",	"Description_Short")
dfs<- dfs %>% select(-drop.cols)
cfm<- cfm %>% select(-drop.cols)

#join threat weights and values
dfs <- dfs %>% left_join(psm, by = "Measure.ID") %>% left_join(tl1, by = "PVThreat") %>% 
  left_join(tl2, by = "TThreat") %>% left_join(tl3, by = "CThreat")

cfm <- cfm %>% left_join(psm, by = "Measure.ID") %>% left_join(tl1, by = "PVThreat") %>% 
  left_join(tl2, by = "TThreat") %>% left_join(tl3, by = "CThreat")

#multiply avg threat performace by weight & average threat values 
dfs <- dfs %>% mutate(PVThreat.Value = PVThreat.Perf * PVThreat.Weight) %>% 
  mutate(TThreat.Value = TThreat.Perf * TThreat.Weight) %>% 
  mutate(CThreat.Value = CThreat.Perf * CThreat.Weight) %>% 
  mutate(Threat.Avg.Value = (PVThreat.Value+TThreat.Value+CThreat.Value)/3)  
  #%>% select(-"Deficiency.ID..") %>% mutate(Measure.Type = "Deficiency") 

cfm <- cfm %>% mutate(PVThreat.Value = PVThreat.Perf * PVThreat.Weight) %>% 
  mutate(TThreat.Value = TThreat.Perf * TThreat.Weight) %>% 
  mutate(CThreat.Value = CThreat.Perf * CThreat.Weight) %>% 
  mutate(Threat.Avg.Value = (PVThreat.Value+TThreat.Value+CThreat.Value)/3) 
  #%>% select(-"Conforming.ID..") %>% mutate(Measure.Type = "Sufficiency") 

#combine tables
res <- rbind(dfs,cfm)

#############
### save ###
###########

save(res,file = "rda/res.rda")

