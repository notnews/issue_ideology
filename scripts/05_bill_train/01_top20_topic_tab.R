"

Print out top 20 predictors of each topic

"


# Set dir
ifelse(grepl("aguess", getwd()), setwd("/Users/aguess/Dropbox/"), setwd(basedir))
setwd("issue_ideology")

# Load libs
library(readr)
library(xtable)

top20_major <- read_csv("tabs/pol_pred/top20/major_bills_top20_new.csv")
top20_key   <- do.call(paste, c(as.data.frame(t(top20_major)), sep=", "))
top20       <- data.frame(topic = names(top20_major), predictors=top20_key)

print(
	  xtable(top20, 
	  	caption="Top 20 Predictors of Each Major Topic", 
	  	align= c("pl{0.05\\textwidth}",  "p{0.15\\textwidth}", "p{0.8\\textwidth}"), label="tab:top20_major"), 
		include.rownames = FALSE,
		floating=FALSE,
	    include.colnames = TRUE, size="\\tiny", 
	    tabular.environment = "longtable",
	    hline.after=-1:nrow(top20),
	    type = "latex", sanitize.text.function = function(x){x},
	    caption.placement="top",
	    table.placement="!htb",
	    file="tabs/top20_major_topic.tex")

# Minor topic_1
top20_major <- read.csv("tabs/pol_pred/top20/topic_1_bills_top20_new.csv", header=F)
top20_key   <- do.call(paste, c(as.data.frame(t(top20_major[2:21,])), sep=", "))
top20       <- data.frame(topic = unlist(top20_major[1,]), predictors=top20_key)

print(
	  xtable(top20, 
	  	caption="Top 20 Predictors of Each Minor Topic", 
	  	align= c("pl{0.05\\textwidth}",  "p{0.15\\textwidth}", "p{0.8\\textwidth}"), label="tab:top20_minor"), 
		include.rownames = FALSE,
		floating=FALSE,
	    include.colnames = TRUE, size="\\tiny", 
	    tabular.environment = "longtable",
	    hline.after=-1:nrow(top20),
	    type = "latex", 
	    sanitize.text.function=function(x) sanitize(x, type = "latex"),
	    caption.placement="top",
	    table.placement="!htb",
	    file="tabs/top20_minor_topic.tex")




