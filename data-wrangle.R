library(tidyverse)
library(reshape2)
library(plyr)

setwd("C:/Users/xadmin/projects/state-department")
example <- read.csv("data/example.csv")
head(example)

psm <- read.csv("data/physical-security-measures.csv")
head(psm)

tl <- read.csv("data/threat-level.csv")
tl <- melt(tl)
tl <- rename(tl, c("X"="type", "variable"="level"))
 


#murders <- murders %>% mutate(regions = factor(region), rate = total / population * 10^5)


#save(example,file = "rda/example.rda")

