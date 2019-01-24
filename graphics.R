#Author: Jeff Cegan
#Project: State Department
#Date: 11/29/2018

#load libraries
lapply(c("tidyverse","ggplot2","maps","scales","ggpubr"), require, character.only = TRUE)

#load r data files
lapply(c("rda/p_m.rda","rda/pb_m.rda"), load, .GlobalEnv)



#Get the world map country border points
world_map <- map_data("world")
usa <- world_map %>% subset(region=="USA" & !(subregion %in% c("Hawaii","Alaska")))
unique(usa$subregion)


#Creat a base plot with gpplot2
p <- ggplot() + coord_fixed() +
  xlab("") + ylab("")

#Add map to base plot
base_world_messy <- p + geom_polygon(data=usa, aes(x=long, y=lat, group=group), 
                                     colour="cornsilk", fill="cornsilk")

#Remove grid lines
cleanup <- 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
        panel.background = element_rect(fill = 'light blue', colour = 'light blue'), 
        axis.line = element_line(colour = "white"), 
        axis.ticks=element_blank(), axis.text.x=element_blank(),
        axis.text.y=element_blank())

base_world <- base_world_messy + cleanup

#data points
map_data <- 
  base_world +
  geom_point(data=p_m, 
             aes(x=Long, y=Lat), colour="Deep Pink", 
             fill="Pink",pch=21, size=2, alpha=I(0.7))

map_data

#sized data
p_m$Deficiency <- p_m$Deficiency.Tot
map_data_sized <- 
  base_world +
  geom_point(data=p_m, 
             aes(x=Long, y=Lat, size=Deficiency), colour="Black", 
             fill="Grey",pch=21, alpha=I(0.7))

map_data_sized

#Add data points to map with value affecting colour
map_data_coloured <- 
  base_world +
  geom_point(data=p_m, 
             aes(x=Long, y=Lat, colour=100*Perc.Deficient), size=5, alpha=I(0.7)) + 
  scale_colour_gradient(low = "green", high = "red",name="Percent\nDeficient")  


map_data_coloured


  ################
 ### PROFILES ###
################
 

rw<-1
groupnames <-  c("PVThreat","TThreat","CThreat")
df <- data.frame(
  group = groupnames,
  value = unlist(p_m[rw,colnames(p_m) %in% paste0(groupnames,".Weight")]),
  title = p_m$Post.Name[rw]
)

#df <- df %>% group_by(group) %>% mutate(pos = cumsum(value)- value/2)


pie <- ggplot(df,aes("", value, fill=group)) +
  geom_bar(width = 1, stat = "identity") + 
  coord_polar("y", start=0) 

blank_theme <- theme_minimal()+
  theme(
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    panel.border = element_blank(),
    panel.grid=element_blank(),
    axis.ticks = element_blank(),
    plot.title=element_text(size=14, face="bold")
  )

post_pie <- pie + blank_theme +
  theme(axis.text.x=element_blank()) + 
  ggtitle(paste(df$title, "-       Percent Rank: ",p_m$perc_rank[rw],"       Absolute Rank: ",p_m$abs_rank[rw])) +
  theme(legend.title=element_blank())

post_map <-  
  base_world +
  geom_point(data=p_m[rw,], 
             aes(x=Long, y=Lat), size=5, alpha=I(0.7)) 


ggarrange(post_pie, post_map,
          ncol = 1, nrow = 2, label.x = 0)


#+ scale_fill_brewer(type="seq", palette=5) 


# ggplot(data=df, aes(x=factor(1), y=value, fill=factor(prod))) +
#   geom_bar(stat="identity") +
#   geom_text(aes(x= factor(1), y=pos, label = value), size=10) +  # note y = pos
#   facet_grid(facets = .~group, labeller = label_value) +
#   coord_polar(theta = "y")

