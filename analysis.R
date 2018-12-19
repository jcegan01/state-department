#Author: Jeff Cegan
#Project: State Department
#Date: 11/29/2018

#load libraries
library(tidyverse)

#load r data files
lapply(c("rda/res.rda"), load, .GlobalEnv)

#note: at this point included both deficiencies and non-deficienies
res %>% group_by(Post.ID) %>% summarise(avg = mean(Threat.Avg.Value))
res %>% group_by(Post.ID, Building.ID) %>% summarise(avg = mean(Threat.Avg.Value))

#deficiencies tally
p_d <- res %>% filter(Measure.Type == "Deficiency") %>% group_by(Post.ID) %>% 
  summarise(Deficiency.Avg = mean(Threat.Avg.Value),Deficiency.Tot = sum(Threat.Avg.Value))
pb_d <- res %>% filter(Measure.Type == "Deficiency") %>% group_by(Post.ID, Building.ID) %>% 
  summarise(Deficiency.Avg = mean(Threat.Avg.Value),Deficiency.Tot = sum(Threat.Avg.Value))

#sufficiencies tally
p_s <- res %>% filter(Measure.Type == "Sufficiency") %>% group_by(Post.ID) %>% 
  summarise(Sufficiency.Avg = mean(Threat.Avg.Value),Sufficiency.Tot = sum(Threat.Avg.Value))
pb_s <- res %>% filter(Measure.Type == "Sufficiency") %>% group_by(Post.ID, Building.ID) %>% 
  summarise(Sufficiency.Avg = mean(Threat.Avg.Value),Sufficiency.Tot = sum(Threat.Avg.Value))

#merge deficiencies and sufficiencies tables, calculate deficiency percentages
p_m <- merge(p_d,p_s) %>% mutate(Perc.Deficient = Deficiency.Tot / (Deficiency.Tot + Sufficiency.Tot))
pb_m <- merge(pb_d,pb_s) %>% mutate(Perc.Deficient = Deficiency.Tot / (Deficiency.Tot + Sufficiency.Tot))

#add sorting (most deficient first)
p_m %>% arrange(desc(Perc.Deficient))
pb_m %>% arrange(desc(Perc.Deficient))

                 