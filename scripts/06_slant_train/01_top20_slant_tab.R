"

Print out top 20 R/D Slant predictors of each topic

"


# Set dir
ifelse(grepl("aguess", getwd()), setwd("/Users/aguess/Dropbox/"), setwd(basedir))
setwd("issue_ideology")

# Load libs
library(readr)
library(xtable)

# Load in the data
res <- data.frame(term=NULL, party=NULL, topic = NULL)

l_files <- dir("tabs/slant_model/top20/")

j <- 1
for (i in l_files){
	
	temp       <- data.frame(term = paste(read.csv(paste0("tabs/slant_model/top20/", i))$term, collapse=", "))
	temp$party <- gsub(".*top.*_|.csv", "", i)
	temp$topic <- gsub("major_|_top.*$", "", i)
	res        <- rbind(res, temp) 
}

# Add topic labels
pt <- read.csv("data/cong_bills/topic_code.csv")
pt_major <- subset(pt, pt$major_dummy==1)
res$topic_lab <-  pt_major$topic[match(res$topic, pt_major$code)]

# Nuke every alternate topic_label 
res$topic_lab[seq(2,nrow(res), 2)] <- ""

# Seems like party labels flipped
res$party <- ifelse(res$party=="rep", "D", "R")

print(
	  xtable(res[,c("topic_lab", "party", "term")], 
	  	caption="Top 20 Partisan Predictors of Each Major Topic", 
	  	align= c("pl{0.025\\textwidth}",  "p{0.1\\textwidth}", "p{0.025\\textwidth}", "p{0.75\\textwidth}"), label="tab:top20_slant"), 
		include.rownames = FALSE,
		floating=FALSE,
	    include.colnames = TRUE, size="\\tiny", 
	    tabular.environment = "longtable",
	    hline.after=c(-1, seq(0, nrow(res),2)),
	    type = "latex", sanitize.text.function = function(x){x},
	    caption.placement="top",
	    table.placement="!htb",
	    file="tabs/top20_slant.tex")

