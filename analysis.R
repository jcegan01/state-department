#Author: Jeff Cegan
#Project: State Department
#Date: 11/29/2018

#load libraries
library(tidyverse)

#load r data files
lapply(c("rda/psm.rda", "rda/tlv.rda","rda/dfs.rda", "rda/cfm.rda"), load)

#add threat values to deficiencies and conforming tables