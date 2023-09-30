"

Plot Partisanship of Agendas
Plot over time also (for fun)

"

# Set dir
ifelse(grepl("aguess", getwd()), setwd("/Users/aguess/Dropbox/"), setwd(basedir))
setwd("issue_ideology")


# Load data
# Get predicted topic + date 
cong_107_pred  <- read.csv("tabs/pol_pred/congress_107_predict_major_label.csv")
cong_108_pred  <- read.csv("tabs/pol_pred/congress_108_predict_major_label.csv")
cong_109_pred  <- read.csv("tabs/pol_pred/congress_109_predict_major_label.csv")
cong_110_pred  <- read.csv("tabs/pol_pred/congress_110_predict_major_label.csv")
cong_111_pred  <- read.csv("tabs/pol_pred/congress_111_predict_major_label.csv")
cong_112_pred  <- read.csv("tabs/pol_pred/congress_112_predict_major_label.csv")

# Stack it all
pol_pred <-  rbind(cbind(cong_107_pred, cong=107), cbind(cong_108_pred, cong=108), cbind(cong_109_pred, cong=109), 
                cbind(cong_110_pred, cong=110), cbind(cong_111_pred, cong=111), cbind(cong_112_pred, cong=112))
pol_pred <- subset(pol_pred, !is.na(party) & party!='328')

# Plot
# Load libs
library(readr)
library(tidyr)
library(caret)
library(dplyr)

# Read in topic code
pol_topic <- read_csv("data/cong_bills/topic_code.csv")
pol_pred$majt <- pol_topic$topic[match(pol_pred$topic, pol_topic$code)]
pol_pred$obama <- ifelse(pol_pred$cong > 109, "Obama", "Bush")

# Proportion of speech by Democrats in each congress --- to account for differences in ns of the party
pt <- 
pol_pred[, c("party", "cong", "obama")] %>%
group_by(cong) %>% 
mutate(n = mean(party==100), obama=obama)

# Total speech on a topic by a party
pt_p <- 
pol_pred[, c("party", "obama", "majt")] %>%
group_by(obama, party, majt) %>% 
summarise (n = n())

# Normalize
p_b <- sum(pt_p[pt_p$party=="100" & pt_p$obama=="Obama","n"])/sum(pt_p[pt_p$party=="200" & pt_p$obama=="Obama","n"])
p_o <- sum(pt_p[pt_p$party=="100" & pt_p$obama=="Obama","n"])/sum(pt_p[pt_p$party=="200" & pt_p$obama=="Obama","n"])

pt_p$n <- ifelse(pt_p$party=="100" & pt_p$obama=="Obama", pt_p$n/p_o, ifelse(pt_p$party=="100" & pt_p$obama=="Bush", pt_p$n/p_b, pt_p$n))

# Long to wide
pt_pcw <- spread(pt_p, party, n)

# Share of all R/D speech
pt_pcw$dem_share <- pt_pcw$"100"/rowSums(cbind(pt_pcw$"100", pt_pcw$"200"))
pt_pcw$rep_share <- pt_pcw$"200"/rowSums(cbind(pt_pcw$"100", pt_pcw$"200"))

# Wide to long 
pt_l <- gather(pt_pcw, party, value=share, dem_share, rep_share)
pt_l$party <- ifelse(pt_l$party=="rep_share", "R", "D")

# Plot
library(grid)
library(scales)
library(ggplot2)

pt_l <- subset(pt_l, !is.na(pt_l$share) & pt_l$majt!='Other, Miscellaneous, and Human Interest')
pt_l$majt <- factor(pt_l$majt, levels=pt_l$majt[order(pt_l[pt_l$party=="D" & pt_l$obama=="Bush",]$share)])

# Plot
ggplot(pt_l, aes(x=majt, y=share, fill=party)) +
scale_fill_manual(values=c("#aaaaee", '#eeaaaa')) +
geom_bar(stat='identity') +
scale_y_continuous(labels = percent_format(), expand=c(0,0)) + 
geom_hline(yintercept=.5, linetype = 'dashed') +
theme_minimal() +
coord_flip() + 
xlab("") + 
ylab('Share of Issue Related Speech') +
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
      legend.text=element_text(size=8))  + 
facet_wrap(~ obama, ncol=2, drop = TRUE) 
ggsave("figs/major_by_obama.pdf", width=7, height=4)


