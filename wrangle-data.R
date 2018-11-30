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
psm <- read.csv("data/physical-security-measures.csv")

#table: threat level and weight
  # tlv <- read.csv("data/threat-level.csv")
  # tlv <- melt(tl)
  # tlv <- rename(tl, c("X"="type", "variable"="level"))
tl1 <- read.csv("data/threat-1-level.csv")
tl2 <- read.csv("data/threat-2-level.csv")
tl3 <- read.csv("data/threat-3-level.csv")

#table: physical security measures - deficiencies
dfs <- read.csv("data/psm-deficiencies.csv")

#table: physical security measures - conforming
cfm <- read.csv("data/psm-conforming.csv")


################
### wrangle ###
##############

#join threat weights and values
dfs <- dfs %>% left_join(psm, by = "Measure.ID") %>% left_join(tl1, by = "Threat.1.Level") %>% 
  left_join(tl2, by = "Threat.2.Level") %>% left_join(tl3, by = "Threat.3.Level")

cfm <- cfm %>% left_join(psm, by = "Measure.ID") %>% left_join(tl1, by = "Threat.1.Level") %>% 
  left_join(tl2, by = "Threat.2.Level") %>% left_join(tl3, by = "Threat.3.Level")

#multiply avg threat performace by weight & average threat values 
dfs <- dfs %>% mutate(Threat.1.Value = Threat.1.Avg.Perf * Threat.1.Weight) %>% 
  mutate(Threat.2.Value = Threat.2.Avg.Perf * Threat.2.Weight) %>% 
  mutate(Threat.3.Value = Threat.3.Avg.Perf * Threat.3.Weight) %>% 
  mutate(Threat.Avg.Value = (Threat.1.Value+Threat.2.Value+Threat.3.Value)/3)

cfm <- cfm %>% mutate(Threat.1.Value = Threat.1.Avg.Perf * Threat.1.Weight) %>% 
  mutate(Threat.2.Value = Threat.2.Avg.Perf * Threat.2.Weight) %>% 
  mutate(Threat.3.Value = Threat.3.Avg.Perf * Threat.3.Weight) %>% 
  mutate(Threat.Avg.Value = (Threat.1.Value+Threat.2.Value+Threat.3.Value)/3)


#############
### save ###
###########

save(dfs,file = "rda/dfs.rda")
save(cfm,file = "rda/cfm.rda")

