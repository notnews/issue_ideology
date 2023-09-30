library(dplyr)

# Set dir
ifelse(grepl("Gaurav", getwd()), setwd(paste0(basedir, "media")), setwd("/Users/aguess/Dropbox/"))
setwd("issue_ideology")
setwd("data")

twideo <- read.csv("ideology-final-estimates.csv", stringsAsFactors = FALSE)
head(twideo)
names(twideo)

twideo <- filter(twideo, followersCount.y > 10000) # want orgs, not people
twideo$media.organization[twideo$media.organization %in% c("CBS News", "ABC News", "ABC", "NBC", "CNBC", "CNN", "MSNBC", "PBS", "NBC News", "Fox News", "NPR")]
twideo <- filter(twideo, media.organization %in% c("CBS News", "ABC News", "ABC", "NBC", "CNBC", "CNN", "MSNBC", "PBS", "NBC News", "Fox News", "NPR"))

twideo$showname <- toupper(with(twideo, gsub("w/", "", gsub("'", "", journalist.name))))

# read in app table
setwd("../data/media_data/")
table_out <- read.csv("media_data_app_table.csv")

twideo_handles <- select(twideo, showname, screenName)
table_merge <- table_out
table_merge$showcaps <- toupper(table_merge$Show)
table_merge <- merge(table_merge, twideo_handles, by.x = "showcaps", by.y = "showname", all.x = TRUE)
table_merge <- select(table_merge, -showcaps)

table_merge <- filter(table_merge, screenName != "TheRevAl" | is.na(screenName)) # wrong handle
table_merge$screenName[which(table_merge$screenName == "andersoncooper")] <- "AC360" # show not person
table_merge$screenName[which(table_merge$screenName == "BreakingNews")] <- "cnnbrk" # NBC not CNN
table_merge$screenName[which(table_merge$Show == "CBS Evening News")] <- "CBSEveningNews"
table_merge$screenName[which(table_merge$Show == "Hannity")] <- "hannityshow"
table_merge$screenName[which(table_merge$Show == "Rachel Maddow Show")] <- "maddow"

length(which(!is.na(table_merge$screenName))) # 23

# next set
table_merge$screenName[which(table_merge$Show == "Oreilly Factor")] <- "Bill_O_Reilly"
table_merge$screenName[which(table_merge$Show == "Scarborough Country")] <- "JoeNBC"
table_merge$screenName[which(table_merge$Show == "Your World Neil Cavuto")] <- "TeamCavuto"
table_merge$screenName[which(table_merge$Show == "Last Word")] <- "TheLastWord"
table_merge$screenName[grep("Blitzer Reports", table_merge$Show, ignore.case = TRUE)] <- "wolfblitzer"
table_merge$screenName[grep("Tapper", table_merge$Show, ignore.case = TRUE)] <- "TheLeadCNN"
table_merge$screenName[grep("andrea mitchell", table_merge$Show, ignore.case = TRUE)] <- "mitchellreports"
table_merge$screenName[grep("good morning", table_merge$Show, ignore.case = TRUE)] <- "GMA"
table_merge$screenName[grep("fox news live", table_merge$Show, ignore.case = TRUE)] <- "FoxNews"
table_merge$screenName[grep("gupta", table_merge$Show, ignore.case = TRUE)] <- "drsanjaygupta"
table_merge$screenName[grep("crowley", table_merge$Show, ignore.case = TRUE)] <- "crowleyCNN"
table_merge$screenName[grep("amanpour", table_merge$Show, ignore.case = TRUE)] <- "camanpour"
table_merge$screenName[which(table_merge$Show == "Special Report Brit Hume")] <- "brithume"
table_merge$screenName[grep("geraldo", table_merge$Show, ignore.case = TRUE)] <- "GeraldoRivera"
table_merge$screenName[grep("red eye", table_merge$Show, ignore.case = TRUE)] <- "greggutfeld"


table_merge[grep("red eye", table_merge$Show, ignore.case = TRUE),] 

# dupes: HUME, STATE OF UNION

# write file
#setwd("../data/media_data/")
write.csv(table_merge, "media_data_app_table.csv")
