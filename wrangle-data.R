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
  # tlv <- read.csv("data/threat-level.csv")
  # tlv <- melt(tl)
  # tlv <- rename(tl, c("X"="type", "variable"="level"))
tl1 <- read.csv("data/threat-1-level.csv")
tl2 <- read.csv("data/threat-2-level.csv")
tl3 <- read.csv("data/threat-3-level.csv")

save(tl1,file = "rda/tl1.rda")
save(tl2,file = "rda/tl2.rda")
save(tl3,file = "rda/tl3.rda")

#table: physical security measures - deficiencies
dfs <- read.csv("data/psm-deficiencies.csv")
save(dfs,file = "rda/dfs.rda")

#table: physical security measures - conforming
cfm <- read.csv("data/psm-conforming.csv")
save(cfm,file = "rda/cfm.rda")

