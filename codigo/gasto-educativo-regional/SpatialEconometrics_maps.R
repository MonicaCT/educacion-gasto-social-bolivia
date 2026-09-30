## SPATIAL ECONOMETRICS
###### ENVIRONMENT------
rm(list = ls())
###### SETTING THE DIRECTORY-----
figures <-  paste(getwd(),sep="")
###### INSTALLING PACKAGES------
#install.packages("maptools")
#install.packages("spdep", dependencies = TRUE)
#install.packages("leaflet", dependencies = TRUE)
#install.packages("RColorBrewer", dependencies = TRUE)
#install.packages("spatialreg", dependencies = TRUE)
#install.packages("gmodels")
#install.packages("lmtest")
#install.packages(c("ggplot2", "ggfortify"))
#detach("package:lmtest", unload = TRUE)
#install.packages("lmtest", dependencies = TRUE)
#install.packages("psych")
#install.packages("usmap")
#install.packages("tidyr", dependencies = TRUE)
#install.packages("RSocrata")
#install.packages("lattice", dependencies = TRUE)
#install.packages("splm", dependencies = TRUE)
#install.packages("splm", type = "binary")
#install.packages("plm", dependencies = TRUE)
#install.packages("plm", type = "binary")
#install.packages("devtools", dependencies = TRUE)
#install.packages("marmap")
#install.packages("ggspatial")

###### UPLOADING PACKAGES------
library(spdep)
library(leaflet)
library(RColorBrewer)
library(gmodels)
library(ggplot2)
library(lmtest)
library(ggfortify)
library(psych)
library(usmap)
library(tidyr)
library(RSocrata)
library(readxl)
library(dplyr)
library(lattice)
library(splm)
library(plm)
library(tidyverse)
library(ggrepel)
library(sf)
library(marmap)
library(ggspatial)

###### OPENING DATAFRAMES-----
govern <- read_excel("SpatialEconometrics.xlsx", sheet = "Datapanela")
#View(govern)
### Shape file WORLD-------
methods(class = "sf")
st_sf(data.frame(n = world$name_long), g = world$geom)
dim(world) 

### Selecting Latinoamerican countries------
world <- world
america <- world %>%
  filter(subregion == "South America" | subregion=="Caribbean" | subregion=="Central America")

### Joining DataFrames-----
governm = left_join(america, govern)

###### EXPLORATORY DATA ANALYSIS (EDA)----
# Palettes----
monocolor <- c("#69b3a2")
bicolor <- c("#69b3a2", "#404080")
tricolor <- c("#69b3a2", "#404080","#e6b400")
NAcolor <- c("#999999")
# Filtering continent----
governm$continent[governm$continent == 'North America'] <- 'Centro America'
governm$continent[governm$continent == 'South America'] <- 'Sur America'
# Logarithmic transformation----
governm$lgdpper <- log(governm$gdpper)

### Distribucion geografica de los datos----
# Education----
governm.e1990 <- filter(governm, periodo == 1990)
ggplot(governm.e1990)+
  geom_sf(fill=NA)+
  geom_sf(data=filter(governm.e1990, !is.na(g_educacion)), aes(fill=g_educacion))+
  scale_fill_continuous(low="#69b3a2", high="#404080",limits = c(-5, 20))+
  theme(panel.background=element_blank(),
        plot.title = element_text(size = 11.5, face = "bold"),
        plot.subtitle = element_text(size = 8,face = "italic"),
        legend.title = element_blank(),
        legend.key.width = unit(0.3, "cm"),
        legend.key.height = unit(1, "cm"),
        plot.caption = element_text(hjust = 0, size = 8, margin = margin(t = 10)))+
  xlab("Longitude") + ylab("Latitude") +
  ggtitle("Social Public Expenditure on Education: 1990")+ 
  labs(fill = "Logaritmos",caption = "Data source: CEPALSTAT",
       subtitle = "(En logaritmos)")+
  theme(panel.grid.major = 
          element_line(color = gray(0.5), linetype = "dashed", size = 0.4),
        panel.background = element_rect(fill = "aliceblue"))+
  ggspatial::annotation_scale(location = "br", plot_unit = "km")+
  ggspatial::annotation_north_arrow(location = "tl", style = north_arrow_fancy_orienteering) 
ggsave(path = figures, filename = "1edu90.png",width=8, height=8)

#
governm.e1991 <- filter(governm, periodo == 1991)
ggplot(governm.e1991)+
  geom_sf(fill=NA)+
  geom_sf(data=filter(governm.e1991, !is.na(g_educacion)), aes(fill=g_educacion))+
  scale_fill_continuous(low="#69b3a2", high="#404080",limits = c(-5, 20))+
  theme(panel.background=element_blank(),
        plot.title = element_text(size = 11.5, face = "bold"),
        plot.subtitle = element_text(size = 8,face = "italic"),
        legend.title = element_blank(),
        legend.key.width = unit(0.3, "cm"),
        legend.key.height = unit(1, "cm"),
        plot.caption = element_text(hjust = 0, size = 8, margin = margin(t = 10)))+
  xlab("Longitude") + ylab("Latitude") +
  ggtitle("Social Public Expenditure on Education: 1991")+ 
  labs(fill = "Logaritmos",caption = "Data source: CEPALSTAT",
       subtitle = "(En logaritmos)")+
  theme(panel.grid.major = 
          element_line(color = gray(0.5), linetype = "dashed", size = 0.4),
        panel.background = element_rect(fill = "aliceblue"))+
  annotation_north_arrow(location = "tl", style = north_arrow_fancy_orienteering)+ 
  annotation_scale(location = "br", plot_unit = "km")
ggsave(path = figures, filename = "2edu91.png",width=8, height=8)

#
governm.e1992 <- filter(governm, periodo == 1992)
ggplot(governm.e1992)+
  geom_sf(fill=NA)+
  geom_sf(data=filter(governm.e1992, !is.na(g_educacion)), aes(fill=g_educacion))+
  scale_fill_continuous(low="#69b3a2", high="#404080",limits = c(-5, 20))+
  theme(panel.background=element_blank(),
        plot.title = element_text(size = 11.5, face = "bold"),
        plot.subtitle = element_text(size = 8,face = "italic"),
        legend.title = element_blank(),
        legend.key.width = unit(0.3, "cm"),
        legend.key.height = unit(1, "cm"),
        plot.caption = element_text(hjust = 0, size = 8, margin = margin(t = 10)))+
  xlab("Longitude") + ylab("Latitude") +
  ggtitle("Social Public Expenditure on Education: 1992")+ 
  labs(fill = "Logaritmos",caption = "Data source: CEPALSTAT",
       subtitle = "(En logaritmos)")+
  theme(panel.grid.major = 
          element_line(color = gray(0.5), linetype = "dashed", size = 0.4),
        panel.background = element_rect(fill = "aliceblue"))+
  annotation_north_arrow(location = "tl", style = north_arrow_fancy_orienteering)+ 
  annotation_scale(location = "br", plot_unit = "km")
ggsave(path = figures, filename = "3edu92.png",width=8, height=8)

#
governm.e1993 <- filter(governm, periodo == 1993)
ggplot(governm.e1993)+
  geom_sf(fill=NA)+
  geom_sf(data=filter(governm.e1993, !is.na(g_educacion)), aes(fill=g_educacion))+
  scale_fill_continuous(low="#69b3a2", high="#404080",limits = c(-5, 20))+
  theme(panel.background=element_blank(),
        plot.title = element_text(size = 11.5, face = "bold"),
        plot.subtitle = element_text(size = 8,face = "italic"),
        legend.title = element_blank(),
        legend.key.width = unit(0.3, "cm"),
        legend.key.height = unit(1, "cm"),
        plot.caption = element_text(hjust = 0, size = 8, margin = margin(t = 10)))+
  xlab("Longitude") + ylab("Latitude") +
  ggtitle("Social Public Expenditure on Education: 1993")+ 
  labs(fill = "Logaritmos",caption = "Data source: CEPALSTAT",
       subtitle = "(En logaritmos)")+
  theme(panel.grid.major = 
          element_line(color = gray(0.5), linetype = "dashed", size = 0.4),
        panel.background = element_rect(fill = "aliceblue"))+
  annotation_north_arrow(location = "tl", style = north_arrow_fancy_orienteering)+ 
  annotation_scale(location = "br", plot_unit = "km")
ggsave(path = figures, filename = "4edu93.png",width=8, height=8)

#
governm.e1994 <- filter(governm, periodo == 1994)
ggplot(governm.e1994)+
  geom_sf(fill=NA)+
  geom_sf(data=filter(governm.e1994, !is.na(g_educacion)), aes(fill=g_educacion))+
  scale_fill_continuous(low="#69b3a2", high="#404080",limits = c(-5, 20))+
  theme(panel.background=element_blank(),
        plot.title = element_text(size = 11.5, face = "bold"),
        plot.subtitle = element_text(size = 8,face = "italic"),
        legend.title = element_blank(),
        legend.key.width = unit(0.3, "cm"),
        legend.key.height = unit(1, "cm"),
        plot.caption = element_text(hjust = 0, size = 8, margin = margin(t = 10)))+
  xlab("Longitude") + ylab("Latitude") +
  ggtitle("Social Public Expenditure on Education: 1994")+ 
  labs(fill = "Logaritmos",caption = "Data source: CEPALSTAT",
       subtitle = "(En logaritmos)")+
  theme(panel.grid.major = 
          element_line(color = gray(0.5), linetype = "dashed", size = 0.4),
        panel.background = element_rect(fill = "aliceblue"))+
  annotation_north_arrow(location = "tl", style = north_arrow_fancy_orienteering)+ 
  annotation_scale(location = "br", plot_unit = "km")
ggsave(path = figures, filename = "5edu94.png",width=8, height=8)

#
governm.e1995 <- filter(governm, periodo == 1995)
ggplot(governm.e1995)+
  geom_sf(fill=NA)+
  geom_sf(data=filter(governm.e1995, !is.na(g_educacion)), aes(fill=g_educacion))+
  scale_fill_continuous(low="#69b3a2", high="#404080",limits = c(-5, 20))+
  theme(panel.background=element_blank(),
        plot.title = element_text(size = 11.5, face = "bold"),
        plot.subtitle = element_text(size = 8,face = "italic"),
        legend.title = element_blank(),
        legend.key.width = unit(0.3, "cm"),
        legend.key.height = unit(1, "cm"),
        plot.caption = element_text(hjust = 0, size = 8, margin = margin(t = 10)))+
  xlab("Longitude") + ylab("Latitude") +
  ggtitle("Social Public Expenditure on Education: 1995")+ 
  labs(fill = "Logaritmos",caption = "Data source: CEPALSTAT",
       subtitle = "(En logaritmos)")+
  theme(panel.grid.major = 
          element_line(color = gray(0.5), linetype = "dashed", size = 0.4),
        panel.background = element_rect(fill = "aliceblue"))+
  annotation_north_arrow(location = "tl", style = north_arrow_fancy_orienteering)+ 
  annotation_scale(location = "br", plot_unit = "km")
ggsave(path = figures, filename = "6edu95.png",width=8, height=8)

#
governm.e1996 <- filter(governm, periodo == 1996)
ggplot(governm.e1996)+
  geom_sf(fill=NA)+
  geom_sf(data=filter(governm.e1996, !is.na(g_educacion)), aes(fill=g_educacion))+
  scale_fill_continuous(low="#69b3a2", high="#404080",limits = c(-5, 20))+
  theme(panel.background=element_blank(),
        plot.title = element_text(size = 11.5, face = "bold"),
        plot.subtitle = element_text(size = 8,face = "italic"),
        legend.title = element_blank(),
        legend.key.width = unit(0.3, "cm"),
        legend.key.height = unit(1, "cm"),
        plot.caption = element_text(hjust = 0, size = 8, margin = margin(t = 10)))+
  xlab("Longitude") + ylab("Latitude") +
  ggtitle("Social Public Expenditure on Education: 1996")+ 
  labs(fill = "Logaritmos",caption = "Data source: CEPALSTAT",
       subtitle = "(En logaritmos)")+
  theme(panel.grid.major = 
          element_line(color = gray(0.5), linetype = "dashed", size = 0.4),
        panel.background = element_rect(fill = "aliceblue"))+
  annotation_north_arrow(location = "tl", style = north_arrow_fancy_orienteering)+ 
  annotation_scale(location = "br", plot_unit = "km")
ggsave(path = figures, filename = "7edu96.png",width=8, height=8)

#
governm.e1997 <- filter(governm, periodo == 1997)
ggplot(governm.e1997)+
  geom_sf(fill=NA)+
  geom_sf(data=filter(governm.e1997, !is.na(g_educacion)), aes(fill=g_educacion))+
  scale_fill_continuous(low="#69b3a2", high="#404080",limits = c(-5, 20))+
  theme(panel.background=element_blank(),
        plot.title = element_text(size = 11.5, face = "bold"),
        plot.subtitle = element_text(size = 8,face = "italic"),
        legend.title = element_blank(),
        legend.key.width = unit(0.3, "cm"),
        legend.key.height = unit(1, "cm"),
        plot.caption = element_text(hjust = 0, size = 8, margin = margin(t = 10)))+
  xlab("Longitude") + ylab("Latitude") +
  ggtitle("Social Public Expenditure on Education: 1997")+ 
  labs(fill = "Logaritmos",caption = "Data source: CEPALSTAT",
       subtitle = "(En logaritmos)")+
  theme(panel.grid.major = 
          element_line(color = gray(0.5), linetype = "dashed", size = 0.4),
        panel.background = element_rect(fill = "aliceblue"))+
  annotation_north_arrow(location = "tl", style = north_arrow_fancy_orienteering)+ 
  annotation_scale(location = "br", plot_unit = "km")
ggsave(path = figures, filename = "8edu97.png",width=8, height=8)

#
governm.e1998 <- filter(governm, periodo == 1998)
ggplot(governm.e1998)+
  geom_sf(fill=NA)+
  geom_sf(data=filter(governm.e1998, !is.na(g_educacion)), aes(fill=g_educacion))+
  scale_fill_continuous(low="#69b3a2", high="#404080",limits = c(-5, 20))+
  theme(panel.background=element_blank(),
        plot.title = element_text(size = 11.5, face = "bold"),
        plot.subtitle = element_text(size = 8,face = "italic"),
        legend.title = element_blank(),
        legend.key.width = unit(0.3, "cm"),
        legend.key.height = unit(1, "cm"),
        plot.caption = element_text(hjust = 0, size = 8, margin = margin(t = 10)))+
  xlab("Longitude") + ylab("Latitude") +
  ggtitle("Social Public Expenditure on Education: 1998")+ 
  labs(fill = "Logaritmos",caption = "Data source: CEPALSTAT",
       subtitle = "(En logaritmos)")+
  theme(panel.grid.major = 
          element_line(color = gray(0.5), linetype = "dashed", size = 0.4),
        panel.background = element_rect(fill = "aliceblue"))+
  annotation_north_arrow(location = "tl", style = north_arrow_fancy_orienteering)+ 
  annotation_scale(location = "br", plot_unit = "km")
ggsave(path = figures, filename = "9edu98.png",width=8, height=8)

#
governm.e1999 <- filter(governm, periodo == 1999)
ggplot(governm.e1999)+
  geom_sf(fill=NA)+
  geom_sf(data=filter(governm.e1999, !is.na(g_educacion)), aes(fill=g_educacion))+
  scale_fill_continuous(low="#69b3a2", high="#404080",limits = c(-5, 20))+
  theme(panel.background=element_blank(),
        plot.title = element_text(size = 11.5, face = "bold"),
        plot.subtitle = element_text(size = 8,face = "italic"),
        legend.title = element_blank(),
        legend.key.width = unit(0.3, "cm"),
        legend.key.height = unit(1, "cm"),
        plot.caption = element_text(hjust = 0, size = 8, margin = margin(t = 10)))+
  xlab("Longitude") + ylab("Latitude") +
  ggtitle("Social Public Expenditure on Education: 1999")+ 
  labs(fill = "Logaritmos",caption = "Data source: CEPALSTAT",
       subtitle = "(En logaritmos)")+
  theme(panel.grid.major = 
          element_line(color = gray(0.5), linetype = "dashed", size = 0.4),
        panel.background = element_rect(fill = "aliceblue"))+
  annotation_north_arrow(location = "tl", style = north_arrow_fancy_orienteering)+ 
  annotation_scale(location = "br", plot_unit = "km")
ggsave(path = figures, filename = "10edu99.png",width=8, height=8)

#
governm.e2000 <- filter(governm, periodo == 2000)
ggplot(governm.e2000)+
  geom_sf(fill=NA)+
  geom_sf(data=filter(governm.e2000, !is.na(g_educacion)), aes(fill=g_educacion))+
  scale_fill_continuous(low="#69b3a2", high="#404080",limits = c(-5, 20))+
  theme(panel.background=element_blank(),
        plot.title = element_text(size = 11.5, face = "bold"),
        plot.subtitle = element_text(size = 8,face = "italic"),
        legend.title = element_blank(),
        legend.key.width = unit(0.3, "cm"),
        legend.key.height = unit(1, "cm"),
        plot.caption = element_text(hjust = 0, size = 8, margin = margin(t = 10)))+
  xlab("Longitude") + ylab("Latitude") +
  ggtitle("Social Public Expenditure on Education: 2000")+ 
  labs(fill = "Logaritmos",caption = "Data source: CEPALSTAT",
       subtitle = "(En logaritmos)")+
  theme(panel.grid.major = 
          element_line(color = gray(0.5), linetype = "dashed", size = 0.4),
        panel.background = element_rect(fill = "aliceblue"))+
  annotation_north_arrow(location = "tl", style = north_arrow_fancy_orienteering)+ 
  annotation_scale(location = "br", plot_unit = "km")
ggsave(path = figures, filename = "11edu00.png",width=8, height=8)

#
governm.e2001 <- filter(governm, periodo == 2001)
ggplot(governm.e2001)+
  geom_sf(fill=NA)+
  geom_sf(data=filter(governm.e2001, !is.na(g_educacion)), aes(fill=g_educacion))+
  scale_fill_continuous(low="#69b3a2", high="#404080",limits = c(-5, 20))+
  theme(panel.background=element_blank(),
        plot.title = element_text(size = 11.5, face = "bold"),
        plot.subtitle = element_text(size = 8,face = "italic"),
        legend.title = element_blank(),
        legend.key.width = unit(0.3, "cm"),
        legend.key.height = unit(1, "cm"),
        plot.caption = element_text(hjust = 0, size = 8, margin = margin(t = 10)))+
  xlab("Longitude") + ylab("Latitude") +
  ggtitle("Social Public Expenditure on Education: 2001")+ 
  labs(fill = "Logaritmos",caption = "Data source: CEPALSTAT",
       subtitle = "(En logaritmos)")+
  theme(panel.grid.major = 
          element_line(color = gray(0.5), linetype = "dashed", size = 0.4),
        panel.background = element_rect(fill = "aliceblue"))+
  annotation_north_arrow(location = "tl", style = north_arrow_fancy_orienteering)+ 
  annotation_scale(location = "br", plot_unit = "km")
ggsave(path = figures, filename = "12edu01.png",width=8, height=8)

#
governm.e2002 <- filter(governm, periodo == 2002)
ggplot(governm.e2002)+
  geom_sf(fill=NA)+
  geom_sf(data=filter(governm.e2002, !is.na(g_educacion)), aes(fill=g_educacion))+
  scale_fill_continuous(low="#69b3a2", high="#404080",limits = c(-5, 20))+
  theme(panel.background=element_blank(),
        plot.title = element_text(size = 11.5, face = "bold"),
        plot.subtitle = element_text(size = 8,face = "italic"),
        legend.title = element_blank(),
        legend.key.width = unit(0.3, "cm"),
        legend.key.height = unit(1, "cm"),
        plot.caption = element_text(hjust = 0, size = 8, margin = margin(t = 10)))+
  xlab("Longitude") + ylab("Latitude") +
  ggtitle("Social Public Expenditure on Education: 2002")+ 
  labs(fill = "Logaritmos",caption = "Data source: CEPALSTAT",
       subtitle = "(En logaritmos)")+
  theme(panel.grid.major = 
          element_line(color = gray(0.5), linetype = "dashed", size = 0.4),
        panel.background = element_rect(fill = "aliceblue"))+
  annotation_north_arrow(location = "tl", style = north_arrow_fancy_orienteering)+ 
  annotation_scale(location = "br", plot_unit = "km")
ggsave(path = figures, filename = "13edu02.png",width=8, height=8)

#
governm.e2003 <- filter(governm, periodo == 2003)
ggplot(governm.e2003)+
  geom_sf(fill=NA)+
  geom_sf(data=filter(governm.e2003, !is.na(g_educacion)), aes(fill=g_educacion))+
  scale_fill_continuous(low="#69b3a2", high="#404080",limits = c(-5, 20))+
  theme(panel.background=element_blank(),
        plot.title = element_text(size = 11.5, face = "bold"),
        plot.subtitle = element_text(size = 8,face = "italic"),
        legend.title = element_blank(),
        legend.key.width = unit(0.3, "cm"),
        legend.key.height = unit(1, "cm"),
        plot.caption = element_text(hjust = 0, size = 8, margin = margin(t = 10)))+
  xlab("Longitude") + ylab("Latitude") +
  ggtitle("Social Public Expenditure on Education: 2003")+ 
  labs(fill = "Logaritmos",caption = "Data source: CEPALSTAT",
       subtitle = "(En logaritmos)")+
  theme(panel.grid.major = 
          element_line(color = gray(0.5), linetype = "dashed", size = 0.4),
        panel.background = element_rect(fill = "aliceblue"))+
  annotation_north_arrow(location = "tl", style = north_arrow_fancy_orienteering)+ 
  annotation_scale(location = "br", plot_unit = "km")
ggsave(path = figures, filename = "14edu03.png",width=8, height=8)

#
governm.e2004 <- filter(governm, periodo == 2004)
ggplot(governm.e2004)+
  geom_sf(fill=NA)+
  geom_sf(data=filter(governm.e2004, !is.na(g_educacion)), aes(fill=g_educacion))+
  scale_fill_continuous(low="#69b3a2", high="#404080",limits = c(-5, 20))+
  theme(panel.background=element_blank(),
        plot.title = element_text(size = 11.5, face = "bold"),
        plot.subtitle = element_text(size = 8,face = "italic"),
        legend.title = element_blank(),
        legend.key.width = unit(0.3, "cm"),
        legend.key.height = unit(1, "cm"),
        plot.caption = element_text(hjust = 0, size = 8, margin = margin(t = 10)))+
  xlab("Longitude") + ylab("Latitude") +
  ggtitle("Social Public Expenditure on Education: 2004")+ 
  labs(fill = "Logaritmos",caption = "Data source: CEPALSTAT",
       subtitle = "(En logaritmos)")+
  theme(panel.grid.major = 
          element_line(color = gray(0.5), linetype = "dashed", size = 0.4),
        panel.background = element_rect(fill = "aliceblue"))+
  annotation_north_arrow(location = "tl", style = north_arrow_fancy_orienteering)+ 
  annotation_scale(location = "br", plot_unit = "km")
ggsave(path = figures, filename = "15edu04.png",width=8, height=8)

#
governm.e2005 <- filter(governm, periodo == 2005)
ggplot(governm.e2005)+
  geom_sf(fill=NA)+
  geom_sf(data=filter(governm.e2005, !is.na(g_educacion)), aes(fill=g_educacion))+
  scale_fill_continuous(low="#69b3a2", high="#404080",limits = c(-5, 20))+
  theme(panel.background=element_blank(),
        plot.title = element_text(size = 11.5, face = "bold"),
        plot.subtitle = element_text(size = 8,face = "italic"),
        legend.title = element_blank(),
        legend.key.width = unit(0.3, "cm"),
        legend.key.height = unit(1, "cm"),
        plot.caption = element_text(hjust = 0, size = 8, margin = margin(t = 10)))+
  xlab("Longitude") + ylab("Latitude") +
  ggtitle("Social Public Expenditure on Education: 2005")+ 
  labs(fill = "Logaritmos",caption = "Data source: CEPALSTAT",
       subtitle = "(En logaritmos)")+
  theme(panel.grid.major = 
          element_line(color = gray(0.5), linetype = "dashed", size = 0.4),
        panel.background = element_rect(fill = "aliceblue"))+
  annotation_north_arrow(location = "tl", style = north_arrow_fancy_orienteering)+ 
  annotation_scale(location = "br", plot_unit = "km")
ggsave(path = figures, filename = "16edu05.png",width=8, height=8)

#
governm.e2006 <- filter(governm, periodo == 2006)
ggplot(governm.e2006)+
  geom_sf(fill=NA)+
  geom_sf(data=filter(governm.e2006, !is.na(g_educacion)), aes(fill=g_educacion))+
  scale_fill_continuous(low="#69b3a2", high="#404080",limits = c(-5, 20))+
  theme(panel.background=element_blank(),
        plot.title = element_text(size = 11.5, face = "bold"),
        plot.subtitle = element_text(size = 8,face = "italic"),
        legend.title = element_blank(),
        legend.key.width = unit(0.3, "cm"),
        legend.key.height = unit(1, "cm"),
        plot.caption = element_text(hjust = 0, size = 8, margin = margin(t = 10)))+
  xlab("Longitude") + ylab("Latitude") +
  ggtitle("Social Public Expenditure on Education: 2006")+ 
  labs(fill = "Logaritmos",caption = "Data source: CEPALSTAT",
       subtitle = "(En logaritmos)")+
  theme(panel.grid.major = 
          element_line(color = gray(0.5), linetype = "dashed", size = 0.4),
        panel.background = element_rect(fill = "aliceblue"))+
  annotation_north_arrow(location = "tl", style = north_arrow_fancy_orienteering)+ 
  annotation_scale(location = "br", plot_unit = "km")
ggsave(path = figures, filename = "17edu06.png",width=8, height=8)

#
governm.e2007 <- filter(governm, periodo == 2007)
ggplot(governm.e2007)+
  geom_sf(fill=NA)+
  geom_sf(data=filter(governm.e2007, !is.na(g_educacion)), aes(fill=g_educacion))+
  scale_fill_continuous(low="#69b3a2", high="#404080",limits = c(-5, 20))+
  theme(panel.background=element_blank(),
        plot.title = element_text(size = 11.5, face = "bold"),
        plot.subtitle = element_text(size = 8,face = "italic"),
        legend.title = element_blank(),
        legend.key.width = unit(0.3, "cm"),
        legend.key.height = unit(1, "cm"),
        plot.caption = element_text(hjust = 0, size = 8, margin = margin(t = 10)))+
  xlab("Longitude") + ylab("Latitude") +
  ggtitle("Social Public Expenditure on Education: 2007")+ 
  labs(fill = "Logaritmos",caption = "Data source: CEPALSTAT",
       subtitle = "(En logaritmos)")+
  theme(panel.grid.major = 
          element_line(color = gray(0.5), linetype = "dashed", size = 0.4),
        panel.background = element_rect(fill = "aliceblue"))+
  annotation_north_arrow(location = "tl", style = north_arrow_fancy_orienteering)+ 
  annotation_scale(location = "br", plot_unit = "km")
ggsave(path = figures, filename = "18edu07.png",width=8, height=8)

#
governm.e2008 <- filter(governm, periodo == 2008)
ggplot(governm.e2008)+
  geom_sf(fill=NA)+
  geom_sf(data=filter(governm.e2008, !is.na(g_educacion)), aes(fill=g_educacion))+
  scale_fill_continuous(low="#69b3a2", high="#404080",limits = c(-5, 20))+
  theme(panel.background=element_blank(),
        plot.title = element_text(size = 11.5, face = "bold"),
        plot.subtitle = element_text(size = 8,face = "italic"),
        legend.title = element_blank(),
        legend.key.width = unit(0.3, "cm"),
        legend.key.height = unit(1, "cm"),
        plot.caption = element_text(hjust = 0, size = 8, margin = margin(t = 10)))+
  xlab("Longitude") + ylab("Latitude") +
  ggtitle("Social Public Expenditure on Education: 2008")+ 
  labs(fill = "Logaritmos",caption = "Data source: CEPALSTAT",
       subtitle = "(En logaritmos)")+
  theme(panel.grid.major = 
          element_line(color = gray(0.5), linetype = "dashed", size = 0.4),
        panel.background = element_rect(fill = "aliceblue"))+
  annotation_north_arrow(location = "tl", style = north_arrow_fancy_orienteering)+ 
  annotation_scale(location = "br", plot_unit = "km")
ggsave(path = figures, filename = "19edu08.png",width=8, height=8)

#
governm.e2009 <- filter(governm, periodo == 2009)
ggplot(governm.e2009)+
  geom_sf(fill=NA)+
  geom_sf(data=filter(governm.e2009, !is.na(g_educacion)), aes(fill=g_educacion))+
  scale_fill_continuous(low="#69b3a2", high="#404080",limits = c(-5, 20))+
  theme(panel.background=element_blank(),
        plot.title = element_text(size = 11.5, face = "bold"),
        plot.subtitle = element_text(size = 8,face = "italic"),
        legend.title = element_blank(),
        legend.key.width = unit(0.3, "cm"),
        legend.key.height = unit(1, "cm"),
        plot.caption = element_text(hjust = 0, size = 8, margin = margin(t = 10)))+
  xlab("Longitude") + ylab("Latitude") +
  ggtitle("Social Public Expenditure on Education: 2009")+ 
  labs(fill = "Logaritmos",caption = "Data source: CEPALSTAT",
       subtitle = "(En logaritmos)")+
  theme(panel.grid.major = 
          element_line(color = gray(0.5), linetype = "dashed", size = 0.4),
        panel.background = element_rect(fill = "aliceblue"))+
  annotation_north_arrow(location = "tl", style = north_arrow_fancy_orienteering)+ 
  annotation_scale(location = "br", plot_unit = "km")
ggsave(path = figures, filename = "20edu09.png",width=8, height=8)

#
governm.e2010 <- filter(governm, periodo == 2010)
ggplot(governm.e2010)+
  geom_sf(fill=NA)+
  geom_sf(data=filter(governm.e2010, !is.na(g_educacion)), aes(fill=g_educacion))+
  scale_fill_continuous(low="#69b3a2", high="#404080",limits = c(-5, 20))+
  theme(panel.background=element_blank(),
        plot.title = element_text(size = 11.5, face = "bold"),
        plot.subtitle = element_text(size = 8,face = "italic"),
        legend.title = element_blank(),
        legend.key.width = unit(0.3, "cm"),
        legend.key.height = unit(1, "cm"),
        plot.caption = element_text(hjust = 0, size = 8, margin = margin(t = 10)))+
  xlab("Longitude") + ylab("Latitude") +
  ggtitle("Social Public Expenditure on Education: 2010")+ 
  labs(fill = "Logaritmos",caption = "Data source: CEPALSTAT",
       subtitle = "(En logaritmos)")+
  theme(panel.grid.major = 
          element_line(color = gray(0.5), linetype = "dashed", size = 0.4),
        panel.background = element_rect(fill = "aliceblue"))+
  annotation_north_arrow(location = "tl", style = north_arrow_fancy_orienteering)+ 
  annotation_scale(location = "br", plot_unit = "km")
ggsave(path = figures, filename = "21edu10.png",width=8, height=8)

#
governm.e2011 <- filter(governm, periodo == 2011)
ggplot(governm.e2011)+
  geom_sf(fill=NA)+
  geom_sf(data=filter(governm.e2011, !is.na(g_educacion)), aes(fill=g_educacion))+
  scale_fill_continuous(low="#69b3a2", high="#404080",limits = c(-5, 20))+
  theme(panel.background=element_blank(),
        plot.title = element_text(size = 11.5, face = "bold"),
        plot.subtitle = element_text(size = 8,face = "italic"),
        legend.title = element_blank(),
        legend.key.width = unit(0.3, "cm"),
        legend.key.height = unit(1, "cm"),
        plot.caption = element_text(hjust = 0, size = 8, margin = margin(t = 10)))+
  xlab("Longitude") + ylab("Latitude") +
  ggtitle("Social Public Expenditure on Education: 2011")+ 
  labs(fill = "Logaritmos",caption = "Data source: CEPALSTAT",
       subtitle = "(En logaritmos)")+
  theme(panel.grid.major = 
          element_line(color = gray(0.5), linetype = "dashed", size = 0.4),
        panel.background = element_rect(fill = "aliceblue"))+
  annotation_north_arrow(location = "tl", style = north_arrow_fancy_orienteering)+ 
  annotation_scale(location = "br", plot_unit = "km")
ggsave(path = figures, filename = "22edu11.png",width=8, height=8)

#
governm.e2012 <- filter(governm, periodo == 2012)
ggplot(governm.e2012)+
  geom_sf(fill=NA)+
  geom_sf(data=filter(governm.e2012, !is.na(g_educacion)), aes(fill=g_educacion))+
  scale_fill_continuous(low="#69b3a2", high="#404080",limits = c(-5, 20))+
  theme(panel.background=element_blank(),
        plot.title = element_text(size = 11.5, face = "bold"),
        plot.subtitle = element_text(size = 8,face = "italic"),
        legend.title = element_blank(),
        legend.key.width = unit(0.3, "cm"),
        legend.key.height = unit(1, "cm"),
        plot.caption = element_text(hjust = 0, size = 8, margin = margin(t = 10)))+
  xlab("Longitude") + ylab("Latitude") +
  ggtitle("Social Public Expenditure on Education: 2012")+ 
  labs(fill = "Logaritmos",caption = "Data source: CEPALSTAT",
       subtitle = "(En logaritmos)")+
  theme(panel.grid.major = 
          element_line(color = gray(0.5), linetype = "dashed", size = 0.4),
        panel.background = element_rect(fill = "aliceblue"))+
  annotation_north_arrow(location = "tl", style = north_arrow_fancy_orienteering)+ 
  annotation_scale(location = "br", plot_unit = "km")
ggsave(path = figures, filename = "23edu12.png",width=8, height=8)

#
governm.e2013 <- filter(governm, periodo == 2013)
ggplot(governm.e2013)+
  geom_sf(fill=NA)+
  geom_sf(data=filter(governm.e2013, !is.na(g_educacion)), aes(fill=g_educacion))+
  scale_fill_continuous(low="#69b3a2", high="#404080",limits = c(-5, 20))+
  theme(panel.background=element_blank(),
        plot.title = element_text(size = 11.5, face = "bold"),
        plot.subtitle = element_text(size = 8,face = "italic"),
        legend.title = element_blank(),
        legend.key.width = unit(0.3, "cm"),
        legend.key.height = unit(1, "cm"),
        plot.caption = element_text(hjust = 0, size = 8, margin = margin(t = 10)))+
  xlab("Longitude") + ylab("Latitude") +
  ggtitle("Social Public Expenditure on Education: 2013")+ 
  labs(fill = "Logaritmos",caption = "Data source: CEPALSTAT",
       subtitle = "(En logaritmos)")+
  theme(panel.grid.major = 
          element_line(color = gray(0.5), linetype = "dashed", size = 0.4),
        panel.background = element_rect(fill = "aliceblue"))+
  annotation_north_arrow(location = "tl", style = north_arrow_fancy_orienteering)+ 
  annotation_scale(location = "br", plot_unit = "km")
ggsave(path = figures, filename = "24edu13.png",width=8, height=8)

#
governm.e2014 <- filter(governm, periodo == 2014)
ggplot(governm.e2014)+
  geom_sf(fill=NA)+
  geom_sf(data=filter(governm.e2014, !is.na(g_educacion)), aes(fill=g_educacion))+
  scale_fill_continuous(low="#69b3a2", high="#404080",limits = c(-5, 20))+
  theme(panel.background=element_blank(),
        plot.title = element_text(size = 11.5, face = "bold"),
        plot.subtitle = element_text(size = 8,face = "italic"),
        legend.title = element_blank(),
        legend.key.width = unit(0.3, "cm"),
        legend.key.height = unit(1, "cm"),
        plot.caption = element_text(hjust = 0, size = 8, margin = margin(t = 10)))+
  xlab("Longitude") + ylab("Latitude") +
  ggtitle("Social Public Expenditure on Education: 2014")+ 
  labs(fill = "Logaritmos",caption = "Data source: CEPALSTAT",
       subtitle = "(En logaritmos)")+
  theme(panel.grid.major = 
          element_line(color = gray(0.5), linetype = "dashed", size = 0.4),
        panel.background = element_rect(fill = "aliceblue"))+
  annotation_north_arrow(location = "tl", style = north_arrow_fancy_orienteering)+ 
  annotation_scale(location = "br", plot_unit = "km")
ggsave(path = figures, filename = "25edu14.png",width=8, height=8)

#
governm.e2015 <- filter(governm, periodo == 2015)
ggplot(governm.e2015)+
  geom_sf(fill=NA)+
  geom_sf(data=filter(governm.e2015, !is.na(g_educacion)), aes(fill=g_educacion))+
  scale_fill_continuous(low="#69b3a2", high="#404080",limits = c(-5, 20))+
  theme(panel.background=element_blank(),
        plot.title = element_text(size = 11.5, face = "bold"),
        plot.subtitle = element_text(size = 8,face = "italic"),
        legend.title = element_blank(),
        legend.key.width = unit(0.3, "cm"),
        legend.key.height = unit(1, "cm"),
        plot.caption = element_text(hjust = 0, size = 8, margin = margin(t = 10)))+
  xlab("Longitude") + ylab("Latitude") +
  ggtitle("Social Public Expenditure on Education: 2015")+ 
  labs(fill = "Logaritmos",caption = "Data source: CEPALSTAT",
       subtitle = "(En logaritmos)")+
  theme(panel.grid.major = 
          element_line(color = gray(0.5), linetype = "dashed", size = 0.4),
        panel.background = element_rect(fill = "aliceblue"))+
  annotation_north_arrow(location = "tl", style = north_arrow_fancy_orienteering)+ 
  annotation_scale(location = "br", plot_unit = "km")
ggsave(path = figures, filename = "26edu15.png",width=8, height=8)

#
governm.e2016 <- filter(governm, periodo == 2016)
ggplot(governm.e2016)+
  geom_sf(fill=NA)+
  geom_sf(data=filter(governm.e2016, !is.na(g_educacion)), aes(fill=g_educacion))+
  scale_fill_continuous(low="#69b3a2", high="#404080",limits = c(-5, 20))+
  theme(panel.background=element_blank(),
        plot.title = element_text(size = 11.5, face = "bold"),
        plot.subtitle = element_text(size = 8,face = "italic"),
        legend.title = element_blank(),
        legend.key.width = unit(0.3, "cm"),
        legend.key.height = unit(1, "cm"),
        plot.caption = element_text(hjust = 0, size = 8, margin = margin(t = 10)))+
  xlab("Longitude") + ylab("Latitude") +
  ggtitle("Social Public Expenditure on Education: 2016")+ 
  labs(fill = "Logaritmos",caption = "Data source: CEPALSTAT",
       subtitle = "(En logaritmos)")+
  theme(panel.grid.major = 
          element_line(color = gray(0.5), linetype = "dashed", size = 0.4),
        panel.background = element_rect(fill = "aliceblue"))+
  annotation_north_arrow(location = "tl", style = north_arrow_fancy_orienteering)+ 
  annotation_scale(location = "br", plot_unit = "km")
ggsave(path = figures, filename = "27edu16.png",width=8, height=8)

#
governm.e2017 <- filter(governm, periodo == 2017)
ggplot(governm.e2017)+
  geom_sf(fill=NA)+
  geom_sf(data=filter(governm.e2017, !is.na(g_educacion)), aes(fill=g_educacion))+
  scale_fill_continuous(low="#69b3a2", high="#404080",limits = c(-5, 20))+
  theme(panel.background=element_blank(),
        plot.title = element_text(size = 11.5, face = "bold"),
        plot.subtitle = element_text(size = 8,face = "italic"),
        legend.title = element_blank(),
        legend.key.width = unit(0.3, "cm"),
        legend.key.height = unit(1, "cm"),
        plot.caption = element_text(hjust = 0, size = 8, margin = margin(t = 10)))+
  xlab("Longitude") + ylab("Latitude") +
  ggtitle("Social Public Expenditure on Education: 2017")+ 
  labs(fill = "Logaritmos",caption = "Data source: CEPALSTAT",
       subtitle = "(En logaritmos)")+
  theme(panel.grid.major = 
          element_line(color = gray(0.5), linetype = "dashed", size = 0.4),
        panel.background = element_rect(fill = "aliceblue"))+
  annotation_north_arrow(location = "tl", style = north_arrow_fancy_orienteering)+ 
  annotation_scale(location = "br", plot_unit = "km")
ggsave(path = figures, filename = "28edu17.png",width=8, height=8)

#
governm.e2018 <- filter(governm, periodo == 2018)
ggplot(governm.e2018)+
  geom_sf(fill=NA)+
  geom_sf(data=filter(governm.e2018, !is.na(g_educacion)), aes(fill=g_educacion))+
  scale_fill_continuous(low="#69b3a2", high="#404080",limits = c(-5, 20))+
  theme(panel.background=element_blank(),
        plot.title = element_text(size = 11.5, face = "bold"),
        plot.subtitle = element_text(size = 8,face = "italic"),
        legend.title = element_blank(),
        legend.key.width = unit(0.3, "cm"),
        legend.key.height = unit(1, "cm"),
        plot.caption = element_text(hjust = 0, size = 8, margin = margin(t = 10)))+
  xlab("Longitude") + ylab("Latitude") +
  ggtitle("Social Public Expenditure on Education: 2018")+ 
  labs(fill = "Logaritmos",caption = "Data source: CEPALSTAT",
       subtitle = "(En logaritmos)")+
  theme(panel.grid.major = 
          element_line(color = gray(0.5), linetype = "dashed", size = 0.4),
        panel.background = element_rect(fill = "aliceblue"))+
  annotation_north_arrow(location = "tl", style = north_arrow_fancy_orienteering)+ 
  annotation_scale(location = "br", plot_unit = "km")
ggsave(path = figures, filename = "29edu18.png",width=8, height=8)

#
governm.e2019 <- filter(governm, periodo == 2019)
ggplot(governm.e2019)+
  geom_sf(fill=NA)+
  geom_sf(data=filter(governm.e2019, !is.na(g_educacion)), aes(fill=g_educacion))+
  scale_fill_continuous(low="#69b3a2", high="#404080",limits = c(-5, 20))+
  theme(panel.background=element_blank(),
        plot.title = element_text(size = 11.5, face = "bold"),
        plot.subtitle = element_text(size = 8,face = "italic"),
        legend.title = element_blank(),
        legend.key.width = unit(0.3, "cm"),
        legend.key.height = unit(1, "cm"),
        plot.caption = element_text(hjust = 0, size = 8, margin = margin(t = 10)))+
  xlab("Longitude") + ylab("Latitude") +
  ggtitle("Social Public Expenditure on Education: 2019")+ 
  labs(fill = "Logaritmos",caption = "Data source: CEPALSTAT",
       subtitle = "(En logaritmos)")+
  theme(panel.grid.major = 
          element_line(color = gray(0.5), linetype = "dashed", size = 0.4),
        panel.background = element_rect(fill = "aliceblue"))+
  annotation_north_arrow(location = "tl", style = north_arrow_fancy_orienteering)+ 
  annotation_scale(location = "br", plot_unit = "km")
ggsave(path = figures, filename = "30edu19.png",width=8, height=8)

#
governm.e2020 <- filter(governm, periodo == 2020)
ggplot(governm.e2020)+
  geom_sf(fill=NA)+
  geom_sf(data=filter(governm.e2020, !is.na(g_educacion)), aes(fill=g_educacion))+
  scale_fill_continuous(low="#69b3a2", high="#404080",limits = c(-5, 20))+
  theme(panel.background=element_blank(),
        plot.title = element_text(size = 11.5, face = "bold"),
        plot.subtitle = element_text(size = 8,face = "italic"),
        legend.title = element_blank(),
        legend.key.width = unit(0.3, "cm"),
        legend.key.height = unit(1, "cm"),
        plot.caption = element_text(hjust = 0, size = 8, margin = margin(t = 10)))+
  xlab("Longitude") + ylab("Latitude") +
  ggtitle("Social Public Expenditure on Education: 2020")+ 
  labs(fill = "Logaritmos",caption = "Data source: CEPALSTAT",
       subtitle = "(En logaritmos)")+
  theme(panel.grid.major = 
          element_line(color = gray(0.5), linetype = "dashed", size = 0.4),
        panel.background = element_rect(fill = "aliceblue"))+
  annotation_north_arrow(location = "tl", style = north_arrow_fancy_orienteering)+ 
  annotation_scale(location = "br", plot_unit = "km")
ggsave(path = figures, filename = "31edu20.png",width=8, height=8)



