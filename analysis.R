#Author: Jeff Cegan
#Project: State Department
#Date: 11/29/2018

#load libraries
lapply(c("tidyverse"), require, character.only = TRUE)

#load r data files
lapply(c("rda/res.rda"), load, .GlobalEnv)

#note: at this point included both deficiencies and non-deficienies
  #res %>% group_by(Facility.ID) %>% dplyr::summarise(avg = mean(Threat.Avg.Value))
  #res %>% group_by(Facility.ID,RFA.ID) %>% dplyr::summarise(avg = mean(Threat.Avg.Value))

#deficiencies tally
p_d <- res %>% filter(Measure.Type == "Deficient") %>% group_by(Facility.ID) %>% 
  dplyr::summarise(Deficiency.Avg = mean(Threat.Avg.Value),Deficiency.Tot = sum(Threat.Avg.Value))
pb_d <- res %>% filter(Measure.Type == "Deficient") %>% group_by(Facility.ID, RFA.ID) %>% 
  dplyr::summarise(Deficiency.Avg = mean(Threat.Avg.Value),Deficiency.Tot = sum(Threat.Avg.Value))

#sufficiencies tally
p_s <- res %>% filter(Measure.Type == "Conforming") %>% group_by(Facility.ID) %>% 
  dplyr::summarise(Conforming.Avg = mean(Threat.Avg.Value),Conforming.Tot = sum(Threat.Avg.Value))
pb_s <- res %>% filter(Measure.Type == "Conforming") %>% group_by(Facility.ID, RFA.ID) %>% 
  dplyr::summarise(Conforming.Avg = mean(Threat.Avg.Value),Conforming.Tot = sum(Threat.Avg.Value))

#merge deficiencies and sufficiencies tables, calculate deficiency percentages
p_m <- merge(p_d,p_s) %>% mutate(Perc.Deficient = Deficiency.Tot / (Deficiency.Tot + Conforming.Tot))
pb_m <- merge(pb_d,pb_s) %>% mutate(Perc.Deficient = Deficiency.Tot / (Deficiency.Tot + Conforming.Tot))

#add facility and building information
p_info <- unique(res %>% select("Facility.ID","Lat","Long","Facility.type","Post.Name"))
pb_info <- unique(res %>% select("Facility.ID","Lat","Long","Facility.type","Post.Name","RFA.ID","Building.Name","RFAType"))

#final tables
p_m <- merge(p_m,p_info)
pb_m <- merge(pb_m,p_info)

#add sorting (most deficient first)
p_m %>% arrange(desc(Perc.Deficient)) 
pb_m %>% arrange(desc(Perc.Deficient))


                 