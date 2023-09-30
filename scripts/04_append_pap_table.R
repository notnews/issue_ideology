"
Policy Agenda Topics Appendix

"

# Set dir
ifelse(grepl("Gaurav", getwd()), setwd(paste0(basedir, "media")), setwd("/Users/aguess/Dropbox/"))
setwd("issue_ideology")

pt <- read.csv("data/cong_bills/topic_code.csv")

pt_major <- subset(pt, pt$major_dummy==1)

pt$major_topic <- substr(pt$code, 1, 2)
pt$major_topic[1:97] <- substr(pt$code[1:97], 1, 1)

# Concatenate text within major_category:
pt_merge          <- aggregate(topic ~ major_topic, paste, collapse=", ",data=pt)
pt_merge$majtopic <- sapply(strsplit(pt_merge$topic, ","), "[", 1)
pt_merge$topic    <- gsub("^.*?, ","", pt_merge$topic)
pt_merge <- pt_merge[order(as.numeric(pt_merge$major_topic)), c(1,3,2)]

library(xtable)

# write file
names(pt_merge) <- c("Topic ID", "Topic Name", "Topic Details")
print(xtable(pt_merge, 
	caption = "Details of Policy Agenda Topics", 
	label = "paptable",
	align= c("p{0.1\\textwidth}", "p{0.1\\textwidth}", "p{0.2\\textwidth}", "p{0.7\\textwidth}")),
	caption.placement = "top",
	size ="scriptsize",
	file = "tabs/PADataAppend.tex", 
	tabular.environment="longtable",
	floating=FALSE,
	include.rownames = FALSE)

# Presentation table
# ~~~~~~~~~~~~~~~~~~~~~~~~

ptpres <- data.frame(col1 = rep(NA,2), col2=rep(NA,2))
ptpres[1,] <- c("Major Topics", paste(pt_major$topic, collapse=", "))
ptpres[2,] <- c("", "")
ptpres[3,] <- c("Macroeconomics", paste0(pt[2:10,2], collapse=", "))

# write file
names(ptpres) <- c("", "")
print(xtable(ptpres, 
	caption = "Details of Policy Agenda Topics", 
	label = "paptable",
	align= c("p{0.1\\textwidth}", "p{0.2\\textwidth}", "p{0.7\\textwidth}")),
	caption.placement = "top",
	size ="scriptsize",
	file = "tabs/PADataPres.tex",
	hline.after = getOption("xtable.hline.after", c(-1,nrow(ptpres))),
	floating=FALSE,
	include.rownames = FALSE)

