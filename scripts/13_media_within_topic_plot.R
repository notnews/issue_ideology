"

Media Within Topic Plot

@authors: Gaurav Sood and Andy Guess


"

# Set dir
ifelse(grepl("Gaurav", getwd()), setwd(paste0(basedir, "media")), setwd("/Users/aguess/Dropbox/"))
setwd("issue_ideology")

# Load data
# Get predicted media topic + date + channel info.
cnn_pred     <- read.csv("tabs/civil_pred/cnn_pred_vw.csv")
lacc_pred    <- read.csv("tabs/civil_pred/lacc_pred_vw.csv")
archive_pred <- read.csv("tabs/civil_pred/archive_pred_vw.csv")
cnnfn_pred   <- read.csv("tabs/civil_pred/cnnfn_pred_vw.csv")
msnbc_pred   <- read.csv("tabs/civil_pred/msnbc_pred_vw.csv")
stfox_pred   <- read.csv("tabs/civil_pred/stfox_pred_vw.csv")
fox_pred     <- read.csv("tabs/civil_pred/fox_pred_vw.csv")

# Stack it all
media_pred <-  rbind(cnn_pred, lacc_pred, archive_pred, cnnfn_pred, msnbc_pred, stfox_pred, fox_pred)
write.csv(media_pred, file="tabs/civil_pred/civil_pred.csv", row.names=F)

# Between 2003 and 2012
med_pred <- subset(media_pred, media_pred$year > 2002 & media_pred$year < 2012)

# Split by congress
med_pred$show_reg[grep("WOLF|Situation|SITUA", med_pred$show_reg)] <- "Wolf Blitzer"
med_pred$show_reg[grep("MADD|Maddow", med_pred$show_reg)] <- "Rachel Maddow"
med_pred$show_reg[grep("BEC|Bec", med_pred$show_reg)] <- "Glenn Beck"
med_pred$show_reg[grep("HANN|Hann", med_pred$show_reg)] <- "Hannity"
med_pred$show_reg[grep("Greta|GRETA", med_pred$show_reg)] <- "Greta Van Susteren"
med_pred$show_reg[grep("Keith|KEITH|COUNTDOWN", med_pred$show_reg)] <- "Countdown Keith Olbermann"
med_pred$show_reg[grep("OReilly|OREI", med_pred$show_reg)] <- "O'Reilly Factor"
med_pred$show_reg[grep("COOPER|Coop", med_pred$show_reg)] <- "Anderson Cooper"
med_pred$show_reg[grep("MATTH|Matt|HARD", med_pred$show_reg)] <- "Chris Matthews"
med_pred$show_reg[grep("ED S|Ed S|THEEDSHOW", med_pred$show_reg)] <- "Ed Show"
med_pred$show_reg[grep("Hayes|HAYES", med_pred$show_reg)] <- "Up W/Chris Hayes"
med_pred$show_reg[grep("Shep|SHEP", med_pred$show_reg)] <- "Studio B Shepard Smith"
med_pred$show_reg[grep("Lou|LOU", med_pred$show_reg)] <- "Lou Dobbs"

shows <- c("Lou Dobbs", "Wolf Blitzer", "Glenn Beck", "Hannity", "Greta Van Susteren", "O'Reilly Factor", "Chris Matthews", "Up W/Chris Hayes")
med_pred <- subset(med_pred, show_reg %in% shows)


# Plot
# Stacked bar plot 
topic_channel <- ddply(med_pred, c("show_reg"), summarise, slant = mean(pred))
topic_channel$show_reg <- factor(topic_channel$show_reg)
topic_channel$show_reg <- factor(topic_channel$show_reg, levels(topic_channel$show_reg)[order(topic_channel$slant)])

#topic_channel[,3] <- zero1(topic_channel[,3], 1, 0) 

# Plot
# Load libs
library(plyr)
library(tidyr)
library(grid)
library(scales)
library(ggplot2)

# Plot
ggplot(topic_channel, aes(x=show_reg, y=slant)) +
scale_y_continuous() +
geom_point() +
coord_flip() +
theme_bw() +
ylab('Slant within Civil Rights') +
xlab('') +
scale_fill_manual(values=c("#aaaaee", '#eeaaaa')) +
theme(legend.position='none',
      panel.border = element_blank(),
      axis.ticks.y=element_blank(),
      panel.grid = element_blank())
ggsave("figs/civil_prefs.pdf", width=6.5)


# Set dir
ifelse(grepl("Gaurav", getwd()), setwd(paste0(basedir, "media")), setwd("/Users/aguess/Dropbox/"))
setwd("issue_ideology")

# Load data
# Get predicted media topic + date + channel info.
cnn_pred     <- read.csv("tabs/econ_pred/cnn_pred_vw.csv")
lacc_pred    <- read.csv("tabs/econ_pred/lacc_pred_vw.csv")
archive_pred <- read.csv("tabs/econ_pred/archive_pred_vw.csv")
cnnfn_pred   <- read.csv("tabs/econ_pred/cnnfn_pred_vw.csv")
msnbc_pred   <- read.csv("tabs/econ_pred/msnbc_pred_vw.csv")
stfox_pred   <- read.csv("tabs/econ_pred/stfox_pred_vw.csv")
fox_pred     <- read.csv("tabs/econ_pred/fox_pred_vw.csv")

# Stack it all
media_pred <-  rbind(cnn_pred, lacc_pred, archive_pred, cnnfn_pred, msnbc_pred, stfox_pred, fox_pred)
write.csv(media_pred, file="tabs/econ_pred/econ_pred.csv", row.names=F)

# Between 2003 and 2012
med_pred <- subset(media_pred, media_pred$year > 2002 & media_pred$year < 2012)

# Split by congress
med_pred$show_reg[grep("WOLF|Situation|SITUA", med_pred$show_reg)] <- "Wolf Blitzer"
med_pred$show_reg[grep("MADD|Maddow", med_pred$show_reg)] <- "Rachel Maddow"
med_pred$show_reg[grep("BEC|Bec", med_pred$show_reg)] <- "Glenn Beck"
med_pred$show_reg[grep("HANN|Hann", med_pred$show_reg)] <- "Hannity"
med_pred$show_reg[grep("Greta|GRETA", med_pred$show_reg)] <- "Greta Van Susteren"
med_pred$show_reg[grep("Keith|KEITH|COUNTDOWN", med_pred$show_reg)] <- "Countdown Keith Olbermann"
med_pred$show_reg[grep("OReilly|OREI", med_pred$show_reg)] <- "O'Reilly Factor"
med_pred$show_reg[grep("COOPER|Coop", med_pred$show_reg)] <- "Anderson Cooper"
med_pred$show_reg[grep("MATTH|Matt|HARD", med_pred$show_reg)] <- "Chris Matthews"
med_pred$show_reg[grep("ED S|Ed S|THEEDSHOW", med_pred$show_reg)] <- "Ed Show"
med_pred$show_reg[grep("Hayes|HAYES", med_pred$show_reg)] <- "Up W/Chris Hayes"
med_pred$show_reg[grep("Shep|SHEP", med_pred$show_reg)] <- "Studio B Shepard Smith"
med_pred$show_reg[grep("Lou|LOU", med_pred$show_reg)] <- "Lou Dobbs"

shows <- c("Lou Dobbs", "Wolf Blitzer", "Glenn Beck", "Hannity", "Greta Van Susteren", "O'Reilly Factor", "Chris Matthews", "Up W/Chris Hayes")
med_pred <- subset(med_pred, show_reg %in% shows)


# Plot
# Stacked bar plot 
topic_channel <- ddply(med_pred, c("show_reg"), summarise, slant = mean(pred))
topic_channel$show_reg <- factor(topic_channel$show_reg)
topic_channel$show_reg <- factor(topic_channel$show_reg, levels(topic_channel$show_reg)[order(topic_channel$slant)])

#topic_channel[,3] <- zero1(topic_channel[,3], 1, 0) 

# Plot
# Load libs
library(plyr)
library(tidyr)
library(grid)
library(scales)
library(ggplot2)

# Plot
ggplot(topic_channel, aes(x=show_reg, y=slant)) +
scale_y_continuous() +
geom_point() +
coord_flip() +
theme_bw() +
ylab('Slant within Economics') +
xlab('') +
scale_fill_manual(values=c("#aaaaee", '#eeaaaa')) +
theme(legend.position='none',
      panel.border = element_blank(),
      axis.ticks.y=element_blank(),
      panel.grid = element_blank())
ggsave("figs/econ_prefs.pdf", width=6.5)

# Twitter ideology
# ~~~~~~~~~~~~~

media_data <- read.csv("data/media_data/media_data_app_table.csv")
media_data <- subset(media_data, !is.na(screenName))
twitter    <- read.csv("data/ideology-final-estimates.csv")
media      <- merge(media_data, twitter, all.x=T, all.y=F, by="screenName")

# Split by congress
media_pred <- read.csv(file="tabs/econ_pred/econ_pred.csv")

# Between 2003 and 2012
med_pred <- subset(media_pred, media_pred$year > 2002 & media_pred$year < 2012)

med_pred$show_reg[grep("WOLF|Situation|SITUA", med_pred$show_reg)] <- "Wolf Blitzer Reports"
med_pred$show_reg[grep("MADD|Maddow", med_pred$show_reg)] <- "Rachel Maddow Show"
med_pred$show_reg[grep("BEC|Bec", med_pred$show_reg)] <- "Glenn Beck"
med_pred$show_reg[grep("HANN|Hann", med_pred$show_reg)] <- "Hannity"
med_pred$show_reg[grep("Greta|GRETA", med_pred$show_reg)] <- "Greta Van Susteren"
med_pred$show_reg[grep("Keith|KEITH|COUNTDOWN", med_pred$show_reg)] <- "Countdown Keith Olbermann"
med_pred$show_reg[grep("OReilly|OREI", med_pred$show_reg)] <- "O'Reilly Factor"
med_pred$show_reg[grep("COOPER|Coop", med_pred$show_reg)] <- "Anderson Cooper"
med_pred$show_reg[grep("MATTH|Matt|HARD", med_pred$show_reg)] <- "Chris Matthews"
med_pred$show_reg[grep("ED S|Ed S|THEEDSHOW", med_pred$show_reg)] <- "Ed Show"
med_pred$show_reg[grep("Hayes|HAYES", med_pred$show_reg)] <- "Up W/Chris Hayes"
med_pred$show_reg[grep("Shep|SHEP", med_pred$show_reg)] <- "Studio B Shepard Smith"
med_pred$show_reg[grep("Lou|LOU", med_pred$show_reg)] <- "Lou Dobbs"

topic_channel <- ddply(med_pred, c("show_reg"), summarise, slant = mean(pred))

media$ideology[match(media$Show, topic_channel$show_reg)]

med <- merge(media, topic_channel, by.x="Show", by.y="show_reg", all.x=T)
cor(med$ideology, med$slant)

