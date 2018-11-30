#Author: Jeff Cegan
#Project: State Department
#Date: 11/29/2018

#load libraries
library(tidyverse)

#load r data files
lapply(c("rda/psm.rda", "rda/tl1.rda", "rda/tl2.rda", "rda/tl3.rda", "rda/dfs.rda", "rda/cfm.rda"), load, .GlobalEnv)

#add threat values to deficiencies and conforming tables

#1: add Threat.1.Avg.Perf & Type 1 value from tlv
dfs <- dfs %>% left_join(psm, by = "Measure.ID") %>% left_join(tl1, by = "Threat.1.Level") %>% 
  left_join(tl2, by = "Threat.2.Level") %>% left_join(tl3, by = "Threat.3.Level")

#2: multiply avg threat performace by weight & average all 3 threat values into an overall average
dfs <- dfs %>% mutate(Threat.1.Value = Threat.1.Avg.Perf * Threat.1.Weight) %>% 
  mutate(Threat.2.Value = Threat.2.Avg.Perf * Threat.2.Weight) %>% 
  mutate(Threat.3.Value = Threat.3.Avg.Perf * Threat.3.Weight) %>% 
  mutate(Threat.Avg.Value = (Threat.1.Value+Threat.2.Value+Threat.3.Value)/3)


