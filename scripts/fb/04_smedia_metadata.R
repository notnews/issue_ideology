library(foreign)
library(gdata)

ifelse(grepl("Gaurav", getwd()), setwd(paste0(basedir, "media")), setwd("/Users/aguess/Dropbox/"))
setwd("issue_ideology")

load("data/cong_fb_pages.RData")
handles <- read.csv("data/cong_smedia/state_legislator_twitter_handles.csv", stringsAsFactors = FALSE)
cong <- read.csv("data/cong_smedia/congress.csv", stringsAsFactors = FALSE)

head(cong); head(handles)

cs <- read.dta("data/cong_smedia/HANDSL01113C20_BSSE_12.DTA") # Common Space scores
cs <- cs[cs$cong == 113,]
state.codes <- c(41, 81, 61, 42, 71, 62, 01, 11, 43, 44, 82, 63, 21, 22, 31, 32, 51, 45, 02, 52, 03, 23, 33, 46, 34, 64, 35, 65, 04, 12, 66, 13, 47, 36, 24, 53, 72, 14, 05, 48, 37, 54, 49, 67, 06, 40, 73, 56, 25, 68)
state.abbrevs <- c("AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "FL", "GA", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY")
cs$state.abb <- state.abbrevs[match(cs$state, state.codes)]
cs <- cs[, c("cd", "state.abb", "party", "name", "dwnom1")]
cs <- cs[-1,]
head(cs)

cs$name <- gsub(" ", "", trim(cs$name))
cs$namestate <- with(cs, paste(trim(state.abb), ifelse(party == "200", "R", 
                                      ifelse(party == "100", "D", "I")), gsub(".", "", name, fixed = TRUE), sep = "-"))
cong$last_name <- as.vector(unlist(sapply(cong$last_name, function(x) strsplit(x, split = " ")[[1]][1])))
cong$last_name <- ifelse(nchar(cong$last_name) >= 10, strtrim(cong$last_name, 8), cong$last_name)

cong$last_name <- toupper(cong$last_name)
cong$last_name[which(cong$last_name == "KIRKPATR")] <- "KIRKPATRIC"
cong$last_name[which(cong$last_name == "SCHWEIKE")] <- "SCHWEIKERT"
cong$last_name[which(cong$last_name == "MCCLINTO")] <- "MCCLINTOCK"
cong$last_name[which(cong$last_name =="PERLMUTT")] <- "PERLMUTTER"
cong$last_name[which(cong$last_name =="BLUMENTH")] <- "BLUMENTHAL"
#cong$last_name[which(cong$last_name =="NORTON")] <- "" # D.C.
cong$last_name[which(cong$last_name =="WASSERMAN")] <- "WASSERMA"
cong$last_name[which(cong$last_name =="BILIRAKIS")] <- "BILIRAKI"
#cong$last_name[which(cong$last_name =="BORDALLO")] <- "" # ?
cong$last_name[which(cong$last_name =="BARRASSO")] <- "BARASSO"
cong$last_name[which(cong$last_name =="BRIDENST")] <- "BRIDENSTIN"
cong$last_name[which(cong$last_name =="CARTWRIG")] <- "CARTWRIGHT"
#cong$last_name[which(cong$last_name =="CHRISTEN")] <- ""
cong$last_name[which(cong$last_name =="CULBERSON")] <- "CULBERSO"
cong$last_name[which(cong$last_name =="DESJARLA")] <- "DESJARLAIS"
cong$last_name[which(cong$last_name =="FARENTHO")] <- "FARENTHOLD"
cong$last_name[which(cong$last_name =="FITZPATR")] <- "FITZPATRI"
cong$last_name[which(cong$last_name =="FLEISCHM")] <- "FLEISCHMA"
cong$last_name[which(cong$last_name =="GOODLATTE")] <- "GOODLATT"
cong$last_name[which(cong$last_name =="GUTIERREZ")] <- "GUTIERRE"
cong$last_name[which(cong$last_name =="HENSARLI")] <- "HENSARLIN"
cong$last_name[which(cong$last_name =="HERRERA")] <- "HERRERABEU"
cong$last_name[which(cong$last_name =="LUETKEME")] <- "LUETKEMEYER"
cong$last_name[which(cong$last_name =="MCDERMOTT")] <- "MCDERMOT"
cong$last_name[which(cong$last_name =="MCMORRIS")] <- "MCMORRISRO"
cong$last_name[which(cong$last_name =="NEUGEBAU")] <- "NEUGEBAUE"
cong$last_name[which(cong$last_name =="O&#X27;R")] <- "OROURKE"
#cong$last_name[which(cong$last_name =="PIERLUISI")] <- ""
cong$last_name[which(cong$last_name =="RUPPERSB")] <- "RUPPERSBE"
#cong$last_name[which(cong$last_name =="SABLAN")] <- ""
cong$last_name[which(cong$last_name =="SLAUGHTER")] <- "SLAUGHTE"
cong$last_name[which(cong$last_name =="VAN")] <- "VANHOLLE"
cong$last_name[which(cong$last_name =="VELÁZQUEZ")] <- "VELAZQUE"
cong$last_name[which(cong$last_name =="VISCLOSKY")] <- "VISCLOSK"
cong$last_name[which(cong$last_name =="WHITEHOU")] <- "WHITEHOUSE"
cong$last_name[which(cong$last_name =="WHITFIELD")] <- "WHITFIEL"

cong$namestate <- with(cong, paste(state, party, last_name, sep = "-"))

cong.new <- merge(cong, cs, by = "namestate", all.x = TRUE)
# head(cong.new)
# tail(cong.new)
# length(which(is.na(cong.new$dwnom1)))
# cong.new[which(is.na(cong.new$dwnom1)),1]
# toupper("schakowsky") %in% trim(cs$name)
# cs[trim(cs$name) %in% toupper("lujan"),]

cong.new <- cong.new[!seq(1, nrow(cong.new)) %in% which(is.na(cong.new$dwnom1)),]
head(cong.new)
