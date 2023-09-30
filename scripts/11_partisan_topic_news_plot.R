"
Plot Partisanship of Agendas
Plot over time also (for fun)

"

# Set dir
ifelse(grepl("Gaurav", getwd()), setwd(paste0(basedir, "media")), setwd("/Users/aguess/Dropbox/"))
setwd("issue_ideology")

# Load libs
library(plyr)
library(tidyr)
library(caret)
library(dplyr)
library(readr)

# Read in data
pol_pred2 <- read_csv("tabs/pol_pred/pol_topic_pred_notext.csv")

# Read in topic code
pol_topic <- read_csv("data/cong_bills/topic_code.csv")

# Create dummies and append to original data.frame
pol_pred2$min   <- as.factor(pol_pred2$min)
dummies <- predict(dummyVars(~ min, data = pol_pred2), newdata = pol_pred2)
pol_pred3 <- cbind(pol_pred2, dummies)

# Split by congress
pt <- pol_pred3[,c(2, 8:length(pol_pred3))] %>% group_by(cong, party) %>% summarise_each(funs(mean))

pt[13,] <- c("107", "Republican",  unlist(as.numeric(pt[2,3:length(pt)])/(as.numeric(pt[2,3:length(pt)]) + as.numeric(pt[1,3:length(pt)]))))
pt[14,] <- c("108", "Republican",  unlist(as.numeric(pt[4,3:length(pt)])/(as.numeric(pt[4,3:length(pt)]) + as.numeric(pt[3,3:length(pt)]))))
pt[15,] <- c("109", "Republican",  unlist(as.numeric(pt[6,3:length(pt)])/(as.numeric(pt[6,3:length(pt)]) + as.numeric(pt[5,3:length(pt)]))))
pt[16,] <- c("110", "Republican",  unlist(as.numeric(pt[8,3:length(pt)])/(as.numeric(pt[8,3:length(pt)]) + as.numeric(pt[7,3:length(pt)]))))
pt[17,] <- c("111", "Republican",  unlist(as.numeric(pt[10,3:length(pt)])/(as.numeric(pt[10,3:length(pt)]) + as.numeric(pt[9,3:length(pt)]))))
pt[18,] <- c("112", "Republican",  unlist(as.numeric(pt[12,3:length(pt)])/(as.numeric(pt[12,3:length(pt)]) + as.numeric(pt[11,3:length(pt)]))))
pt[,3:221] <- as.numeric(as.matrix(pt[,3:221]))

# Media pred
media_pred <- read_csv(file="tabs/media_pred/media_topic_pred.csv")

# Take out weird year
media_pred <- subset(media_pred, media_pred$year < 3000)

# Between 2003 and 2012
media_pred <- subset(media_pred, media_pred$year > 2002 & media_pred$year < 2013)

# Take out some channels"
media_pred <- subset(media_pred, channel_reg %in% c("CNN", "FOXNEWS", "MSNBC"))

# Create by cong
media_pred$cong <- NA
media_pred$cong[media_pred$year > 2000 & media_pred$year < 2003] <- "107"
media_pred$cong[media_pred$year > 2002 & media_pred$year < 2005] <- "108"
media_pred$cong[media_pred$year > 2004 & media_pred$year < 2007] <- "109"
media_pred$cong[media_pred$year > 2006 & media_pred$year < 2009] <- "110"
media_pred$cong[media_pred$year > 2008 & media_pred$year < 2011] <- "111"
media_pred$cong[media_pred$year > 2010 & media_pred$year < 2013] <- "112"

# Create dummies and append to original data.frame
media_pred$min   <- as.factor(media_pred$min)
dummies   <- predict(dummyVars(~ min, data = media_pred), newdata = media_pred)
med_pred3 <- cbind(media_pred, dummies)

# Split by congress
med_pred3$show_reg[grep("WOLF|Situation|SITUA", med_pred3$show_reg)] <- "Wolf Blitzer"
med_pred3$show_reg[grep("MADD|Maddow", med_pred3$show_reg)] <- "Rachel Maddow"
med_pred3$show_reg[grep("BEC|Bec", med_pred3$show_reg)] <- "Glenn Beck"
med_pred3$show_reg[grep("HANN|Hann", med_pred3$show_reg)] <- "Hannity"
med_pred3$show_reg[grep("Greta|GRETA", med_pred3$show_reg)] <- "Greta Van Susteren"
med_pred3$show_reg[grep("Keith|KEITH|COUNTDOWN", med_pred3$show_reg)] <- "Countdown Keith Olbermann"
med_pred3$show_reg[grep("OReilly|OREI", med_pred3$show_reg)] <- "O'Reilly Factor"
med_pred3$show_reg[grep("COOPER|Coop", med_pred3$show_reg)] <- "Anderson Cooper"
med_pred3$show_reg[grep("MATTH|Matt|HARD", med_pred3$show_reg)] <- "Chris Matthews"
med_pred3$show_reg[grep("ED S|Ed S", med_pred3$show_reg)] <- "Ed Show"
med_pred3$show_reg[grep("Hayes|HAYES", med_pred3$show_reg)] <- "Up W/Chris Hayes"
med_pred3$show_reg[grep("Shep|SHEP", med_pred3$show_reg)] <- "Studio B Shepard Smith"
med_pred3$show_reg[grep("Lou|LOU", med_pred3$show_reg)] <- "Lou Dobbs"

mp <- med_pred3[,c(1, 10, 11:length(med_pred3))] %>% group_by(cong, show_reg) %>% summarise_each(funs(mean))
mp <- as.data.frame(mp)
mp[mp==0] <- NA

pp <- mp
pp[mp$cong==108,3:length(mp)] <- mp[mp$cong==108,3:length(mp)]*ifelse(is.na(as.numeric(pt[14,names(pt)[names(pt) %in% names(mp[,-1])]])), NA, as.numeric(pt[14,names(pt)[names(pt) %in% names(mp[,-1])]]))
pp[mp$cong==109,3:length(mp)] <- mp[mp$cong==109,3:length(mp)]*ifelse(is.na(as.numeric(pt[15,names(pt)[names(pt) %in% names(mp[,-1])]])), NA, as.numeric(pt[14,names(pt)[names(pt) %in% names(mp[,-1])]]))
pp[mp$cong==110,3:length(mp)] <- mp[mp$cong==110,3:length(mp)]*ifelse(is.na(as.numeric(pt[16,names(pt)[names(pt) %in% names(mp[,-1])]])), NA, as.numeric(pt[14,names(pt)[names(pt) %in% names(mp[,-1])]]))
pp[mp$cong==111,3:length(mp)] <- mp[mp$cong==111,3:length(mp)]*ifelse(is.na(as.numeric(pt[17,names(pt)[names(pt) %in% names(mp[,-1])]])), NA, as.numeric(pt[14,names(pt)[names(pt) %in% names(mp[,-1])]]))
pp[mp$cong==112,3:length(mp)] <- mp[mp$cong==112,3:length(mp)]*ifelse(is.na(as.numeric(pt[18,names(pt)[names(pt) %in% names(mp[,-1])]])), NA, as.numeric(pt[14,names(pt)[names(pt) %in% names(mp[,-1])]]))

pp$means <- rowSums(pp[,3:length(pp)], na.rm=T)

pp1 <- subset(pp, select=c("show_reg", "cong", "means"))

shows <- c("CNN Newsroom", "Lou Dobbs", "Wolf Blitzer", "Glenn Beck", "Hannity", "Greta Van Susteren", "Countdown Keith Olbermann", "O'Reilly Factor", "Chris Matthews", "Up W/Chris Hayes")

pp2 <- subset(pp1, show_reg %in% shows)
pp3 <- pp2[,c(1,3)]  %>% group_by(show_reg) %>% summarise_each(funs(mean))

pp3$show_reg <- factor(pp3$show_reg)
pp3$show_reg <-  factor(pp3$show_reg, levels(pp3$show_reg)[order(pp3$means)])

# Load libs
library(grid)
library(scales)
library(ggplot2)

ggplot(pp3, aes(show_reg, means)) + 
geom_point() +
coord_flip() + 
theme_minimal() +
labs(y="Extent of Republican Slant of Agenda",x=NULL) +
theme(panel.grid.major.y = element_line(colour = "#e3e3e3", linetype = "dotted"),
      panel.grid.minor.x = element_blank(),
      panel.grid.major.x = element_line(colour = "#f1f1f1", linetype = "solid"),
      panel.border       = element_blank(),
      legend.position  = "bottom",
      legend.key       = element_blank(),
      legend.key.width = unit(.2,"cm"),
      title        = element_text(size=9),
      axis.title   = element_text(size=10),
      axis.text    = element_text(size=10),
      axis.ticks.y = element_blank(),
      axis.ticks.x = element_line(colour = '#f1f1f1'),
      strip.background = element_rect(fill = 'white', color='white'),
      strip.text.x =  element_text(size=9))
ggsave("figs/partisanship_of_agenda.pdf")



#  By Channel (WEIRD RESULTS --- MESSY SHOW CODING TO BLAME)
# ~~~~~~~~~~~~~~----------------------------------------------
# Media pred
media_pred <- read_csv(file="tabs/media_pred/media_topic_pred.csv")

# Take out weird year
media_pred <- subset(media_pred, media_pred$year < 3000)

# Between 2003 and 2012
media_pred <- subset(media_pred, media_pred$year > 2002 & media_pred$year < 2013)

# Take out some channels"
media_pred <- subset(media_pred, channel_reg %in% c("ABC", "CBS", "CNBC", "CNN", "FOXNEWS", "MSNBC"))

# Create by cong
media_pred$cong <- NA
media_pred$cong[media_pred$year > 2000 & media_pred$year < 2003] <- "107"
media_pred$cong[media_pred$year > 2002 & media_pred$year < 2005] <- "108"
media_pred$cong[media_pred$year > 2004 & media_pred$year < 2007] <- "109"
media_pred$cong[media_pred$year > 2006 & media_pred$year < 2009] <- "110"
media_pred$cong[media_pred$year > 2008 & media_pred$year < 2011] <- "111"
media_pred$cong[media_pred$year > 2010 & media_pred$year < 2013] <- "112"

# Create dummies and append to original data.frame
media_pred$min   <- as.factor(media_pred$min)
dummies   <- predict(dummyVars(~ min, data = media_pred), newdata = media_pred)
med_pred3 <- cbind(media_pred, dummies)
# Split by congress
med_pred3$show_reg[grep("WOLF|Situation|SITUA", med_pred3$show_reg)] <- "Wolf Blitzer"
med_pred3$show_reg[grep("MADD|Maddow", med_pred3$show_reg)] <- "Rachel Maddow"
med_pred3$show_reg[grep("BEC|Bec", med_pred3$show_reg)] <- "Glenn Beck"
med_pred3$show_reg[grep("HANN|Hann", med_pred3$show_reg)] <- "Hannity"
med_pred3$show_reg[grep("Greta|GRETA", med_pred3$show_reg)] <- "Greta Van Susteren"
med_pred3$show_reg[grep("Keith|KEITH|COUNTDOWN", med_pred3$show_reg)] <- "Countdown Keith Olbermann"
med_pred3$show_reg[grep("OReilly|OREI", med_pred3$show_reg)] <- "O'Reilly Factor"
med_pred3$show_reg[grep("COOPER|Coop", med_pred3$show_reg)] <- "Anderson Cooper"
med_pred3$show_reg[grep("MATTH|Matt|HARD", med_pred3$show_reg)] <- "Chris Matthews"
med_pred3$show_reg[grep("ED S|Ed S|THEEDSHOW", med_pred3$show_reg)] <- "Ed Show"
med_pred3$show_reg[grep("Hayes|HAYES", med_pred3$show_reg)] <- "Up W/Chris Hayes"
med_pred3$show_reg[grep("Shep|SHEP", med_pred3$show_reg)] <- "Studio B Shepard Smith"
med_pred3$show_reg[grep("Lou|LOU", med_pred3$show_reg)] <- "Lou Dobbs"


med_pred3$channel_reg <- paste0(med_pred3$channel_reg, ":", med_pred3$show_reg)
mp <- med_pred3[,c(2, 10, 11:length(med_pred3))] %>% group_by(cong, channel_reg) %>% summarise_each(funs(mean))
mp <- as.data.frame(mp)
mp[mp==0] <- NA

pp <- mp
pp[mp$cong==108,3:length(mp)] <- mp[mp$cong==108,3:length(mp)]*ifelse(is.na(as.numeric(pt[14,names(pt)[names(pt) %in% names(mp[,-1])]])), NA, as.numeric(pt[14,names(pt)[names(pt) %in% names(mp[,-1])]]))
pp[mp$cong==109,3:length(mp)] <- mp[mp$cong==109,3:length(mp)]*ifelse(is.na(as.numeric(pt[15,names(pt)[names(pt) %in% names(mp[,-1])]])), NA, as.numeric(pt[14,names(pt)[names(pt) %in% names(mp[,-1])]]))
pp[mp$cong==110,3:length(mp)] <- mp[mp$cong==110,3:length(mp)]*ifelse(is.na(as.numeric(pt[16,names(pt)[names(pt) %in% names(mp[,-1])]])), NA, as.numeric(pt[14,names(pt)[names(pt) %in% names(mp[,-1])]]))
pp[mp$cong==111,3:length(mp)] <- mp[mp$cong==111,3:length(mp)]*ifelse(is.na(as.numeric(pt[17,names(pt)[names(pt) %in% names(mp[,-1])]])), NA, as.numeric(pt[14,names(pt)[names(pt) %in% names(mp[,-1])]]))
pp[mp$cong==112,3:length(mp)] <- mp[mp$cong==112,3:length(mp)]*ifelse(is.na(as.numeric(pt[18,names(pt)[names(pt) %in% names(mp[,-1])]])), NA, as.numeric(pt[14,names(pt)[names(pt) %in% names(mp[,-1])]]))

pp$means <- rowSums(pp[,3:length(pp)], na.rm=T)

pp1 <- subset(pp, select=c("channel_reg", "cong", "means"))

pp3 <- pp1[,c(1,3)]  %>% group_by(channel_reg) %>% summarise_each(funs(mean))

pp3$channel_reg1 <- sapply(strsplit(pp3$channel_reg, ":"), "[", 1)
#pp3$show_reg <- factor(pp3$show_reg)
#pp3$show_reg <-  factor(pp3$show_reg, levels(pp3$show_reg)[order(pp3$means)])

# Take out nonsense shows
pp4 <- pp3[!(pp3$channel_reg1=="CNN" & pp3$means < .3),]
pp4 <- pp4[!(pp4$channel_reg1=="CNN" & pp4$means > .6),]
pp4 <- pp4[!(pp4$channel_reg1=="MSNBC" & pp4$means < .3),]
pp4 <- pp4[!(pp4$channel_reg1=="MSNBC" & pp4$means > .57),]
pp4 <- pp4[!(pp4$channel_reg1=="FOXNEWS" & pp4$means < .35),]


#pp3 <- subset(pp3, pp3$channel_reg1=="CNN" & pp3$means < .4 & pp3$means > .6,]
#pp3 <- subset(pp3, pp3$channel_reg1=="CNN" & pp3$means < .4 & pp3$means > .6,]

# Load libs
library(grid)
library(scales)
library(ggplot2)

ggplot(pp4, aes(channel_reg1, means)) + 
geom_boxplot() +
coord_flip() + 
theme_minimal() +
labs(y="Extent of Republican Slant of Agenda",x=NULL) +
theme(panel.grid.major.y = element_line(colour = "#e3e3e3", linetype = "dotted"),
      panel.grid.minor.x = element_blank(),
      panel.grid.major.x = element_line(colour = "#f1f1f1", linetype = "solid"),
      panel.border       = element_blank(),
      legend.position  = "bottom",
      legend.key       = element_blank(),
      legend.key.width = unit(.2,"cm"),
      title        = element_text(size=9),
      axis.title   = element_text(size=10),
      axis.text    = element_text(size=10),
      axis.ticks.y = element_blank(),
      axis.ticks.x = element_line(colour = '#f1f1f1'),
      strip.background = element_rect(fill = 'white', color='white'),
      strip.text.x =  element_text(size=9))
ggsave("figs/partisanship_of_agenda.pdf")








# Plot
# Stacked bar plot 
topic_channel <- ddply(media_pred, c("channel_reg", "show_reg"), summarise,    
                                                                macro = mean(pred==1),
                                                                civil = mean(pred==2),
                                                                health = mean(pred==3),
                                                                agri = mean(pred==4),
                                                                labor = mean(pred==5),
                                                                educ = mean(pred==6),
                                                                env = mean(pred==7),
                                                                energy = mean(pred==8),
                                                                imm = mean(pred==9),
                                                                trans = mean(pred==10),
                                                                law = mean(pred==12),
                                                                welfare = mean(pred==13),
                                                                housing = mean(pred==14),
                                                                banking = mean(pred==15),
                                                                defense = mean(pred==16),
                                                                science = mean(pred==17),
                                                                trade = mean(pred==18),
                                                                aid = mean(pred==19),
                                                                govops = mean(pred==20),
                                                                lands = mean(pred==21)
                                                                ) 


partisan_channel     <- cbind(channel=topic_channel[,1], show = topic_channel[,2], partisan=rowMeans(sweep(as.matrix(topic_channel[,3:22]), MARGIN=2, as.numeric(pt[4,2:21]),`*`)))
partisan_channel     <- as.data.frame(partisan_channel)
partisan_channel[,3] <- round(as.numeric(partisan_channel[,3]),5)

# Plot
ggplot(pp1, aes(x=cong, y=means)) +
geom_line() +
scale_y_continuous() + 
coord_flip() +
theme_bw() +
ylab("Distribution of Partisanship of Shows' Agenda Partisanship By Channel") +
xlab('') +
    theme(legend.position='none',
        panel.border = element_blank(),
        axis.ticks.y=element_blank(),
        panel.grid = element_blank())
ggsave("figs/partisan_agenda.pdf", width=6.5)
