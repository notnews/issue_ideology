"

Plot Confidence Matrix
@input:  
@output: 

@authors: Gaurav Sood and Andy Guess

"

# Set dir
ifelse(grepl("aguess", getwd()), setwd("/Users/aguess/Dropbox/"), setwd(basedir))
setwd("issue_ideology")

# Load libs
library(ggplot2)
library(reshape2)
library(scales)

# Load test data predictions and test data y (above)
cm <- read.csv("tabs/topic_model/test_confusion_matrix_major.csv")[,2:21]
cm <- cm/rowSums(cm)
rownames(cm) <- as.numeric(gsub("X", "", colnames(cm)))

# Forget about 99
cm <- cm[1:19,1:19]

# Get row and colnames
topic     <- read.csv("data/cong_bills/topic_code.csv")
majtopic  <- subset(topic, major_dummy==1)
cm$topic  <- majtopic$topic[match(rownames(cm), majtopic$code)]

# wide to long
out2       <- melt(cm, idvar="topic")
out2$pred  <- majtopic$topic[match(as.numeric(gsub("X", "", as.character(out2$variable))), majtopic$code)]
out2$topic <- factor(out2$topic)
out2$topic <- factor(out2$topic, levels=rev(levels(out2$topic)))

ggplot(out2, aes(topic, pred)) + 
geom_tile(aes(fill = value), colour = "#dddddd") + 
scale_fill_gradient(low = "white", high = "steelblue") + 
theme_minimal() + 
labs(x="",y="")+ 
theme(axis.text.x = element_blank(),
      axis.text.y = element_text(size=8),  
      title = element_text(size=12),
      legend.position  = "none",
      axis.title.x = element_text(size=10),
      axis.title.y = element_text(size=10),
      axis.ticks.y = element_blank(),
	  axis.ticks.x = element_blank(),
      panel.grid.major.y = element_line(colour = "#e3e3e3", linetype = "dotted"),
      panel.grid.minor.x = element_blank(),
	  panel.grid.major.x = element_line(colour = "#f1f1f1", linetype = "solid"),
	  panel.border       = element_blank())  # change text size

ggsave("figs/conf_matrix_topic.pdf")

# Minor Topics

# Load test data predictions and test data y (above)
cm <- read.csv("tabs/topic_model/test_confusion_matrix_topic_1.csv")
#paste0("X", cm[,1])[paste0("X", cm[,1]) %in% names(cm)]
cm <- cm[,paste0("X", cm[,1])[paste0("X", cm[,1]) %in% names(cm)]]
cm <- cm/rowSums(cm)
cm <- data.frame(a = as.factor(rep(1, 90)), cm = diag(as.matrix(cm))) # this is a hack but correct

ggplot(cm, aes(x = a, y =cm)) + 
geom_boxplot() + 
theme_minimal() + 
labs(x=NULL,y="Accuracy")+ 
theme(axis.text.x = element_blank(),
      axis.text.y = element_text(size=8),  
      title = element_text(size=12),
      legend.position  = "none",
      axis.title.x = element_text(size=10),
      axis.title.y = element_text(size=10),
      axis.ticks.y = element_blank(),
      axis.ticks.x = element_blank(),
      panel.grid.major.y = element_line(colour = "#e3e3e3", linetype = "dotted"),
      panel.grid.minor.x = element_blank(),
      panel.grid.major.x = element_line(colour = "#f1f1f1", linetype = "solid"),
      panel.border       = element_blank())
ggsave("figs/conf_matrix_topic_all.pdf")
