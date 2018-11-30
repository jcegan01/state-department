#Author: Jeff Cegan
#Project: State Department
#Date: 11/29/2018

#load librarie
lapply(c("tidyverse", "reshape2", "plyr"), require, character.only = TRUE)

#set working directory
setwd("C:/Users/xadmin/projects/state-department")

#table: physical security measures list
psm <- read.csv("data/physical-security-measures.csv")
save(psm,file = "rda/psm.rda")

#table: threat level and value
tlv <- read.csv("data/threat-level.csv")
tlv <- melt(tl)
tlv <- rename(tl, c("X"="type", "variable"="level"))
save(tlv,file = "rda/tlv.rda")

#table: physical security measures - deficiencies
dfs <- read.csv("data/psm-deficiencies.csv")
save(dfs,file = "rda/dfs.rda")

#table: physical security measures - conforming
cfm <- read.csv("data/psm-conforming.csv")
save(cfm,file = "rda/cfm.rda")

