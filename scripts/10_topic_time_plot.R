"
Plot Coverage of Issues Over Time Across Channels

"

# Set dir
ifelse(grepl("Gaurav", getwd()), setwd(paste0(basedir, "media")), setwd("/Users/aguess/Dropbox/"))
setwd("issue_ideology")

# Load libs
library(readr)
library(plyr)
library(tidyr)
library(dplyr)
library(caret)

# Load data
# Get predicted media topic + date + channel info.
cnn_pred     <- read.csv("tabs/media_pred/cnn_pred_vw.csv")
lacc_pred    <- read.csv("tabs/media_pred/lacc_pred_vw.csv")
archive_pred <- read.csv("tabs/media_pred/archive_pred_vw.csv")
cnnfn_pred   <- read.csv("tabs/media_pred/cnnfn_pred_vw.csv")
msnbc_pred   <- read.csv("tabs/media_pred/msnbc_pred_vw.csv")
stfox_pred   <- read.csv("tabs/media_pred/stfox_pred_vw.csv")
fox_pred     <- read.csv("tabs/media_pred/fox_pred_vw.csv")

# Stack it all
media_pred <-  rbind(cnn_pred, lacc_pred, archive_pred, cnnfn_pred, msnbc_pred, stfox_pred, fox_pred)
write.csv(media_pred, file="tabs/media_pred/media_topic_pred.csv", row.names=F)

# Take out weird year
media_pred <- subset(media_pred, media_pred$year < 3000)

# Between 2003 and 2012
media_pred <- subset(media_pred, media_pred$year > 2002 & media_pred$year < 2012)

# table(media_pred$channel_reg)

# Take out some channels"
media_pred2 <- subset(media_pred, channel_reg %in% c("CNN", "FOXNEWS", "MSNBC"))

# Create dummies and append to original data.frame
media_pred2$min   <- as.factor(media_pred2$min)
dummies <- predict(dummyVars(~ min, data = media_pred2), newdata =media_pred2)
media_pred3 <- cbind(media_pred2, dummies)

media_pred4 <- media_pred3[,c(2, 10:length(media_pred3))] %>% group_by(channel_reg) %>% summarise_each(funs(mean))
pts <- media_pred4[, 1:8]
data_long  <- gather(pts, topic, topicmean, min.100:min.108)
data_long$topicmean <- as.numeric(data_long$topicmean)

# Get better labels
pol_topic <- read_csv("data/cong_bills/topic_code.csv")
nums <- as.numeric(unlist(lapply(strsplit(as.character(data_long$topic), "min."), "[", 2)))
data_long$topict <- as.factor(pol_topic$topic[match(nums, pol_topic$code)])

# Plot
# Plot
library(grid)
library(scales)
library(ggplot2)
ggplot(data_long, aes(x=topict, y=topicmean, fill=channel_reg)) +
    geom_bar(stat='identity') +
    geom_hline(yintercept=.5, linetype = 'dashed', size=.1) +
    coord_flip() +
    theme_minimal() +
    ylab('Share of Issue Related Speech') +
    xlab(NULL) +
    scale_fill_manual(values=c("#aaaaee", '#eeaaaa')) +
    theme(panel.grid.major.y = element_line(colour = "#e3e3e3", linetype = "dotted"),
      panel.grid.minor.x = element_blank(),
      panel.grid.major.x = element_line(colour = "#f1f1f1", linetype = "solid"),
      panel.border       = element_blank(),
      panel.margin = unit(1.1, "lines"),
      plot.margin = unit(c(0,0,0,0), "mm"),
      legend.position  = "none",
      legend.key       = element_blank(),
      legend.key.width = unit(1,"cm"),
      title        = element_text(size=8),
      axis.title   = element_text(size=7),
      axis.text    = element_text(size=7),
      axis.ticks.y = element_blank(),
      axis.ticks.x = element_line(colour = '#f1f1f1'),
      strip.text.x =  element_text(size=9),
      legend.text=element_text(size=8)) 

# Load libs
library(plyr)
library(tidyr)
library(caret)
library(dplyr)
# Stacked bar plot 
topic_channel <- ddply(media_pred, c("channel_reg"), summarise,    
																imm   = mean(pred==9, na.rm=T),
																educ  = mean(pred==6, na.rm=T),
																econ  = mean(pred==1, na.rm=T))

# Convert to long to subplot by topic
data_long      <- gather(topic_channel, topic, topicmean, imm:econ)
levels(data_long$topic) <- c("Immigration", "Education", "Macroeconomics")

# Plot
library(grid)
library(scales)
library(ggplot2)

ggplot(data_long, aes(x=channel_reg, y=topicmean, fill=topic)) + 
geom_bar(stat='identity') + 
scale_y_continuous("", labels = percent_format(), expand=c(0,0))  + 
coord_flip() + 
ylab('') +
xlab('') + 
theme_minimal() +
theme(panel.grid.major.y = element_line(colour = "#e3e3e3", linetype = "dotted"),
      panel.grid.minor.x = element_blank(),
	  panel.grid.major.x = element_line(colour = "#f1f1f1", linetype = "solid"),
	  panel.border       = element_blank(),
	  legend.position  = "bottom",
	  legend.key.width = unit(.3,"cm"),
	  title        = element_text(size=8),
	  axis.title   = element_text(size=8),
	  axis.text    = element_text(size=8),
	  axis.ticks.y = element_blank(),
	  axis.ticks.x = element_line(colour = '#f1f1f1'),
	  strip.background = element_rect(fill = 'white', color='white'),
	  strip.text.x =  element_text(size=9)) 
ggsave("figs/topic_channel.pdf", width=6.5)

# Plot
# x-axis: time
# groups: channels
# type: stacked area plot
# Each issue in a separate subplot
# How to: 
# Start by producing summary: proportion topic by yrmonth, channel

# Load dat
#media_pred <- read.csv("tabs/media_pred/media_topic_pred.csv")

# Load libs
library(grid)
library(scales)
library(ggplot2)
library(lubridate)

# Summarize
# Smaller unique issues volumes db
# Separate col. by topic
topic_month_channel <- ddply(media_pred2, c("channel_reg", "month", "year"), summarize, 
																	imm   = mean(pred==9, na.rm=T),
																	def   = mean(pred==15, na.rm=T),
																	econ   = mean(pred==1, na.rm=T))

# Convert to long to subplot by topic
data_long      <- gather(topic_month_channel, topic, topicmean, imm:econ)
data_long$date <- as.Date(ymd(paste0(data_long$year, month.name[data_long$month], "01")))
levels(data_long$topic) <- c("Immigration", "Defense", "Macroeconomics")

# Plot
ggplot(data_long, aes(date, topicmean)) + 
geom_area(aes(colour = channel_reg, fill= channel_reg), position = 'stack') +
scale_fill_brewer("Channel Name", palette="Set2") + 
labs(x="", y="Proportion of Coverage") + 
scale_colour_hue(guide = "none") + 
scale_x_date() + 
theme_minimal() +
theme(panel.grid.major.y = element_line(colour = "#e3e3e3", linetype = "dotted"),
      panel.grid.minor.x = element_blank(),
	  panel.grid.major.x = element_line(colour = "#f1f1f1", linetype = "solid"),
	  panel.border       = element_blank(),
	  legend.position  = "bottom",
	  legend.key       = element_blank(),
	  legend.key.width = unit(.2,"cm"),
	  title        = element_text(size=8),
	  axis.title   = element_text(size=8),
	  axis.text    = element_text(size=8),
	  axis.ticks.y = element_blank(),
	  axis.ticks.x = element_line(colour = '#f1f1f1'),
	  strip.background = element_rect(fill = 'white', color='white'),
	  strip.text.x =  element_text(size=9))   +
facet_wrap(~ topic, ncol=1, drop = TRUE, scales = "free_y") 

ggsave("figs/topic_channel_time.pdf", width=6.5)
