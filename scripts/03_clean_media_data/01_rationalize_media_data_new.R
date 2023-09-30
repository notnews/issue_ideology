# rm(list=ls(all=TRUE))

"

Rationalize Media Data

What the Script Does:
- Ingests all the media data 
- Normalizes all show, channel names
- Spits out datasets with additional normalized show, channel name columns
- Spits out the appendix table describing media content (pooling over all the media data) 
	--- Channel (Outlet), Show, n_transcripts, years/date-range, source_data (It would be LACC, Newsbank etc.)

Suggestions for how to:
1. Out all unique show/channel combinations from all datasets
2. Add normalized cols. of shows and channels
3. Merge the cols back
4. Then write out a function that sequentially goes through the datasets and produces the Appendix Table
5. Output the Appendix table to folder tabs and in the ms., include a pointer to the latex table file in the appendix.

"

# Set dir
ifelse(grepl("Gaurav", getwd()), setwd(paste0(basedir, "media")), setwd("/Users/aguess/Dropbox/"))
setwd("issue_ideology")
setwd("data/media_data/raw")

# Load lib
library(readr)
library(gdata)
library(tools)
library(dplyr)

# Read dat
int_archive <- read_csv("archive-clean.csv", col_types = paste0(rep("c", 49), collapse = ""))
cnn <- read_csv("cnn-cleaned.csv")
msn <- read_csv("msnbc.csv")
lacc <- read_csv("lacc-cleaned.csv")

fox <- read_csv("newsbank-fox-cleaned.csv")
cnnfn <- read_csv("newsbank-cnn-fn-cleaned.csv")
cnni <- read_csv("newsbank-cnn-inter-cleaned.csv")
msnbc <- read_csv("newsbank-msnbc-cleaned.csv")
stf <- read_csv("newsbank-stf-fox-cleaned.csv")

#problems(fox)

### SHOW/CHANNEL COMBOS ###

## 1. Internet Archive

# parse show names
show_int <- as.vector(sapply(int_archive$title, function(x) { trim(strsplit(x, ":")[[1]][1] )}))
show_int[grep("[curator", show_int, fixed = TRUE)] <- as.vector(sapply(int_archive$title[grep("[curator", show_int, fixed = TRUE)], function(x) { trim(strsplit(x, ":")[[1]][3] )}))
show_int <- as.vector(sapply(show_int, function(x) {strsplit(x, " at ")[[1]][1] }))
show_int <- gsub("\n", " ", show_int) # fix &'s
int_archive$show_int <- show_int

names(int_archive)
int_archive[1,]
unique(int_archive$collection)
unique(int_archive$contributor)
unique(show_int)

# channel + show name
#int_archive$showchan <- paste(int_archive$contributor, show_int, sep = " | ")
#unique(int_archive$showchan)
#sort(table(int_archive$showchan))
#names(table(int_archive$showchan))[]
#as.vector(sapply(int_archive$collection, function(x) { trim(strsplit(x, "|", fixed = TRUE)[[1]][1] )}))

ucombs_ia <- select(int_archive, contributor, show_int) %>%
                    arrange(contributor, show_int) %>%
                    distinct(contributor, show_int)

## 2. CNN

names(cnn)
table(cnn$channel.name)

ucombs_cnn <- select(cnn, program.name) %>%
  arrange(program.name) %>%
  distinct(program.name)

## 3. MSN

names(msn)
table(msn$channel.name)

ucombs_msn <- select(msn, program.name) %>%
  arrange(program.name) %>%
  distinct(program.name)

## 4. LACC

names(lacc)
table(lacc$channel.name)




## COMBINE

rbind(ucombs_ia, ucombs_cnn)




## Internet Archive

# Find unique show/channel combos

names(fox)
unique(fox$Show)
unique(fox$Source)
head(int_archive[,!1:49 %in% 41])
unique(int_archive$contributor)
unique(int_archive$title)

# parse show titles:
show_int <- as.vector(sapply(int_archive$title, function(x) { trim(strsplit(x, ":")[[1]][1] )}))

# fix CSPAN:
show_int[grep("[curator", show_int, fixed = TRUE)] <- as.vector(sapply(int_archive$title[grep("[curator", show_int, fixed = TRUE)], function(x) { trim(strsplit(x, ":")[[1]][3] )}))

# collapse news programs "at 5", "at 7", etc.:
show_int <- as.vector(sapply(show_int, function(x) {strsplit(x, " at ")[[1]][1] }))
show_int <- gsub("\n", " ", show_int) # fix &'s
int_archive$show_title <- show_int

# regularize:
# show_int[grep("MATTHEWS", show_int)] <- "CHRIS MATTHEWS"
# show_int[grep("MEET THE PRESS", show_int)] <- "MEET THE PRESS"
# show_int[grep("JOHN KING", show_int)] <- "JOHN KING"
# show_int[grep("ANDERSON COOPER", show_int)] <- "ANDERSON COOPER"
# show_int[grep("SITUATION", show_int)] <- "THE SITUATION ROOM"

int_archive$show_title[grep(toTitleCase(tolower("MATTHEWS")), int_archive$show_title)] <- toTitleCase(tolower("CHRIS MATTHEWS"))
int_archive$show_title[grep(toTitleCase(tolower("MEET THE PRESS")), int_archive$show_title)] <- toTitleCase(tolower("MEET THE PRESS"))
int_archive$show_title[grep(toTitleCase(tolower("JOHN KING")), int_archive$show_title)] <- toTitleCase(tolower("JOHN KING"))
int_archive$show_title[grep(toTitleCase(tolower("ANDERSON COOPER")), int_archive$show_title)] <- toTitleCase(tolower("ANDERSON COOPER"))
int_archive$show_title[grep(toTitleCase(tolower("SITUATION")), int_archive$show_title)] <- toTitleCase(tolower("THE SITUATION ROOM"))

# create new col:
int_archive$show_reg <- toupper(int_archive$show_title)
#int_archive$show_reg <- show_int

# grab unique show titles:
ushow_int <- unique(show_int)
ushow_int <- ushow_int[!is.na(ushow_int)] # NA

# collapse sources:
int_archive$channel_reg <- int_archive$contributor
int_archive$channel_reg[which(int_archive$channel_reg=="FOXNEWSW")] <- "FOXNEWS"
int_archive$channel_reg[which(int_archive$channel_reg=="MSNBCW")] <- "MSNBC"
int_archive$channel_reg[which(int_archive$channel_reg=="CNNW")] <- "CNN"

# cut out local stations: - took out -AG
# int_archive_nolocal <- int_archive[which(int_archive$channel_reg %in% unique(int_archive$channel_reg)[c(3:4, 12:13, 48)]),]
# unique(int_archive_nolocal$show_reg); unique(int_archive_nolocal$channel_reg)
# int_archive[grep("GIBSON", int_archive$show_reg),]$channel_reg # all local stations! (2)
# localvec <- sapply(ushow_int, function(s) length(unique(int_archive[which(int_archive$show_reg == s),]$channel_reg)) > 1)
# names(localvec)[which(localvec)]
# names(localvec)[which(!names(localvec)[which(localvec)] %in% unique(int_archive_nolocal$show_reg))]

unique(int_archive$channel_reg)

length(unique(int_archive$show_reg))
length(unique(gsub(" ", "", gsub("/", "", gsub("-", "", gsub("'", "", int_archive$show_reg))))))

# drop 3:
unique(int_archive$show_reg)[which(duplicated(gsub(" ", "", gsub("/", "", gsub("-", "", gsub("'", "", unique(int_archive$show_reg)))))))]
int_archive$show_reg <- gsub(" ", "", gsub("/", "", gsub("-", "", gsub("'", "", int_archive$show_reg))))
int_archive$show_title <- gsub("The ", "", gsub(" and", " &", gsub("'", "", gsub(",", "", gsub("with ", "", int_archive$show_title, ignore.case = TRUE)))))

int_archive$channel_reg[grep("CNN", int_archive$show_title, ignore.case = TRUE)] <- "CNN"
int_archive$channel_reg[grep("FOX", int_archive$show_title, ignore.case = TRUE)] <- "FOXNEWS"
int_archive$channel_reg[grep("MSN", int_archive$show_title, ignore.case = TRUE)] <- "MSNBC"
int_archive$channel_reg[grep("ABC", int_archive$show_title, ignore.case = TRUE)] <- "ABC"
int_archive$channel_reg[grep("CBS", int_archive$show_title, ignore.case = TRUE)] <- "CBS"

# save
setwd("../normalized")
write_csv(int_archive, "archive-clean-reg.csv")

## Fox News

# check for matches:
names(fox)
unique(fox$Show)
sapply(unique(fox$Show), function(x) { unlist(which(length(grep(x, ushow_int, ignore.case = TRUE)) == 0)) })
grep("SPECIAL REPORT", ushow_int, value = TRUE, ignore.case = TRUE)
unique(int_archive$contributor[grep("Eyewitness News", show_int, ignore.case = TRUE)])

# regularize:
fox$show_reg <- fox$Show
fox$show_reg[which(fox$show_reg == "THE O`REILLY FACTOR")] <- "THE O'REILLY FACTOR"
#fox$show_reg[which(fox$show_reg == "FOX THE CRIER REPORT")]
fox$show_reg[which(fox$show_reg == "FOX YOUR WORLD")] <- "YOUR WORLD WITH NEIL CAVUTO"
#fox$show_reg[which(fox$show_reg == "Eyewitness News 5am")]
#fox$show_reg[which(fox$show_reg == "SCARBOROUGH COUNTRY")]
fox$show_reg[which(fox$show_reg == "FOX THE BIG STORY")] <- "BIG STORY"
#fox$show_reg[which(fox$show_reg == "LIVE EVENT")]
#fox$show_reg[which(fox$show_reg == "THE BELTWAY BOYS")]
fox$show_reg[which(fox$show_reg == "BIG STORY WEEKEND EDITION")] <- "BIG STORY"
fox$show_reg[which(fox$show_reg == "THE BIG STORY WITH JOHN GIBSON")] <- "BIG STORY"
#fox$show_reg[which(fox$show_reg == "FOX SPECIAL REPORT WITH BRIT HUME")]
fox$show_reg[which(fox$show_reg == "FOX ON THE RECORD WITH GRETA VAN SUSTEREN")] <- "GRETA VAN SUSTEREN"
fox$show_reg[which(fox$show_reg == "FOX HANNITY & COLMES")] <- "HANNITY"
fox$show_reg[which(fox$show_reg == "SPECIAL")] <- "BIG STORY"

fox$show_title <- fox$show_reg
fox$show_title <- toTitleCase(tolower(fox$show_title))

#unique(fox$Source)
fox$channel_reg <- fox$Source
fox$channel_reg[grep("FOX News", fox$channel_reg)] <- "FOXNEWS"

# ditch bad entries
fox <- fox[which(fox$show_reg != ""),]
fox <- fox[which(fox$show_reg != "Show"),]
#fox <- fox[which(fox$channel_reg == "FOXNEWS" | fox$channel_reg == "MSNBC"),]
unique(fox$channel_reg)

# save
write_csv(fox, "newsbank-fox-cleaned-reg.csv")

## CNN

names(cnn)
head(cnn[, 1:13])
unique(cnn$program.name)
unique(cnn$channel.name)

# King, Dobbs, Beck, Cooper, Wolf, Zahn, Evans/Novak, CNN/Time, Greta, Brown, CLancy, Gupta, Sambolin, Zakaria, Amanpour

cnn$show_title <- cnn$program.name
cnn$show_reg <- toupper(cnn$program.name)
cnn$show_reg <- gsub("CNN ", "", cnn$show_reg) # ditch redundant naming
cnn$show_reg <- gsub(" CORRECTED COPY", "", cnn$show_reg) # fix title
cnn$show_title <- gsub("CNN ", "", cnn$show_title) # ditch redundant naming
cnn$show_title <- gsub(" CORRECTED COPY", "", cnn$show_title) # fix title
unique(cnn$show_reg)

# collapse hosts
grep("MATTHEWS", unique(cnn$show_reg), value = TRUE)
cnn$show_reg[grep("LARRY KING", cnn$show_reg)] <- "LARRY KING"
cnn$show_reg[grep("JOHN KING", cnn$show_reg)] <- "JOHN KING"
cnn$show_reg[grep("DOBBS", cnn$show_reg)] <- "LOU DOBBS"
cnn$show_reg[grep("360", cnn$show_reg)] <- "ANDERSON COOPER"
cnn$show_reg[grep("WOLF", cnn$show_reg)] <- "WOLF BLITZER"
cnn$show_reg[grep("PAULA ZAHN", cnn$show_reg)] <- "PAULA ZAHN"
cnn$show_reg[grep("NOVAK", cnn$show_reg)] <- "EVANS NOVAK"
cnn$show_reg[grep("TIME", cnn$show_reg)] <- "CNN/TIME"
cnn$show_reg[grep("AARON BROWN", cnn$show_reg)] <- "AARON BROWN"
cnn$show_reg[grep("CAMPBELL BROWN", cnn$show_reg)] <- "CAMPBELL BROWN"
cnn$show_reg[grep("JIM CLANCY", cnn$show_reg)] <- "JIM CLANCY"
cnn$show_reg[grep("SANJAY GUPTA", cnn$show_reg)] <- "SANJAY GUPTA"
cnn$show_reg[grep("EARLY START", cnn$show_reg)] <- "EARLY START"

cnn$show_title[grep(toTitleCase(tolower("LARRY KING")), cnn$show_title)] <- toTitleCase(tolower("LARRY KING"))
cnn$show_title[grep(toTitleCase(tolower("JOHN KING")), cnn$show_title)] <- toTitleCase(tolower("JOHN KING"))
cnn$show_title[grep(toTitleCase(tolower("DOBBS")), cnn$show_title)] <- toTitleCase(tolower("LOU DOBBS"))
cnn$show_title[grep(toTitleCase(tolower("360")), cnn$show_title)] <- toTitleCase(tolower("ANDERSON COOPER"))
cnn$show_title[grep(toTitleCase(tolower("WOLF")), cnn$show_title)] <- toTitleCase(tolower("WOLF BLITZER"))
cnn$show_title[grep(toTitleCase(tolower("PAULA ZAHN")), cnn$show_title)] <- toTitleCase(tolower("PAULA ZAHN"))
cnn$show_title[grep(toTitleCase(tolower("NOVAK")), cnn$show_title)] <- toTitleCase(tolower("EVANS NOVAK"))
cnn$show_title[grep(toTitleCase(tolower("TIME")), cnn$show_title)] <- toTitleCase(tolower("CNN/TIME"))
cnn$show_title[grep(toTitleCase(tolower("AARON BROWN")), cnn$show_title)] <- toTitleCase(tolower("AARON BROWN"))
cnn$show_title[grep(toTitleCase(tolower("CAMPBELL BROWN")), cnn$show_title)] <- toTitleCase(tolower("CAMPBELL BROWN"))
cnn$show_title[grep(toTitleCase(tolower("JIM CLANCY")), cnn$show_title)] <- toTitleCase(tolower("JIM CLANCY"))
cnn$show_title[grep(toTitleCase(tolower("SANJAY GUPTA")), cnn$show_title)] <- toTitleCase(tolower("SANJAY GUPTA"))
cnn$show_title[grep(toTitleCase(tolower("EARLY START")), cnn$show_title)] <- toTitleCase(tolower("EARLY START"))

cnn <- cnn[which(cnn$show_reg != ""),] # drop blank shows
cnn$channel_reg <- "CNN"

# save
write_csv(cnn, "cnn-cleaned-reg.csv")

## LACC

head(lacc[, 1:12])
unique(lacc$channel.name)
#lacc <- lacc[which(lacc$channel.name == "FOX-News" | lacc$channel.name == "MSNBC" | lacc$channel.name == "CNN" | lacc$channel.name == "CNBC" | lacc$channel.name == "Current"),]
lacc$channel_reg <- lacc$channel.name
lacc$channel_reg[which(lacc$channel_reg == "FOX-News")] <- "FOXNEWS"
#lacc$channel.name[which(lacc$channel.name == "CNN-Headline")] <- "CNN"
lacc$channel_reg[which(lacc$channel_reg == "Current")] <- "CURRENT"

unique(lacc$program.name)

lacc$show_reg <- lacc$program.name
lacc$show_title <- lacc$program.name
lacc$show_reg <- toupper(lacc$show_reg)


# collapse hosts
grep("PIERS", unique(lacc$program.name), value = TRUE)
lacc$show_reg[grep("LARRY KING", lacc$show_reg)] <- "LARRY KING LIVE"
lacc$show_reg[grep("JOHN KING", lacc$show_reg)] <- "JOHN KING"
lacc$show_reg[grep("COOPER", lacc$show_reg)] <- "ANDERSON COOPER"
lacc$show_reg[grep("CAMPBELL BROWN", lacc$show_reg)] <- "CAMPBELL BROWN"
lacc$show_reg[grep("PIERS", lacc$show_reg)] <- "PIERS MORGAN TONIGHT"

lacc$show_title[grep(toTitleCase(tolower("LARRY KING")), lacc$show_title)] <- toTitleCase(tolower("LARRY KING LIVE"))
lacc$show_title[grep(toTitleCase(tolower("JOHN KING")), lacc$show_title)] <- toTitleCase(tolower("JOHN KING"))
lacc$show_title[grep(toTitleCase(tolower("COOPER")), lacc$show_title)] <- toTitleCase(tolower("ANDERSON COOPER"))
lacc$show_title[grep(toTitleCase(tolower("CAMPBELL BROWN")), lacc$show_title)] <- toTitleCase(tolower("CAMPBELL BROWN"))
lacc$show_title[grep(toTitleCase(tolower("PIERS")), lacc$show_title)] <- toTitleCase(tolower("PIERS MORGAN TONIGHT"))


lacc <- lacc[which(lacc$show_reg != ""),] # drop blank shows
lacc <- lacc[which(lacc$show_reg != "4"),] # drop blank shows

sapply(unique(lacc$show_reg), function(x) { unlist(which(length(grep(x, ushow_int, ignore.case = TRUE)) == 0)) })
grep("PIERS", ushow_int, value = TRUE, ignore.case = TRUE)

# save
write_csv(lacc, "lacc-cleaned-reg.csv")

## MSNBC

names(msn)
head(msn[, 1:14])
unique(msn$program.name)
unique(msn$channel.name)

msn$show_reg <- msn$program.name
msn$show_title <- msn$program.name
msn$show_reg <- toupper(msn$show_reg)

# collapse hosts
grep("HAYES", unique(msn$show_reg), value = TRUE)
msn$show_reg[grep("MADDOW", msn$show_reg)] <- "THE RACHEL MADDOW SHOW"
msn$show_reg[grep("MATTHEWS", msn$show_reg)] <- "CHRIS MATTHEWS"
msn$show_reg[grep("DONNELL", msn$show_reg)] <- "LAWRENCE O'DONNELL"
msn$show_reg[grep("ED SHOW", msn$show_reg)] <- "THE ED SHOW"
msn$show_reg[grep("ANDREA MITCHELL", msn$show_reg)] <- "ANDREA MITCHELL REPORTS"
msn$show_reg[grep("MELISSA HARRIS-PERRY", msn$show_reg)] <- "MELISSA HARRIS-PERRY"
msn$show_reg[grep("POLITICS NATION", msn$show_reg)] <- "POLITICSNATION"

msn$show_title[grep(toTitleCase(tolower("MADDOW")), msn$show_title)] <- toTitleCase(tolower("THE RACHEL MADDOW SHOW"))
msn$show_title[grep(toTitleCase(tolower("MATTHEWS")), msn$show_title)] <- toTitleCase(tolower("CHRIS MATTHEWS"))
msn$show_title[grep(toTitleCase(tolower("DONNELL")), msn$show_title)] <- toTitleCase(tolower("LAWRENCE O'DONNELL"))
msn$show_title[grep(toTitleCase(tolower("ED SHOW")), msn$show_title)] <- toTitleCase(tolower("THE ED SHOW"))
msn$show_title[grep(toTitleCase(tolower("ANDREA MITCHELL")), msn$show_title)] <- toTitleCase(tolower("ANDREA MITCHELL REPORTS"))
msn$show_title[grep(toTitleCase(tolower("MELISSA HARRIS-PERRY")), msn$show_title)] <- toTitleCase(tolower("MELISSA HARRIS-PERRY"))
msn$show_title[grep(toTitleCase(tolower("POLITICS NATION")), msn$show_title)] <- toTitleCase(tolower("POLITICSNATION"))

msn <- msn[which(msn$show_reg != ""),] # drop blank shows
#msn <- msn[which(msn$program.name != "MONDAY"),]
#msn <- msn[which(msn$program.name != "TUESDAY"),]
#msn <- msn[which(msn$program.name != "WEDNESDAY"),]
#msn <- msn[which(msn$program.name != "THURSDAY"),]
#msn <- msn[which(msn$program.name != "FRIDAY"),]
msn$channel_reg <- "MSNBC"

sapply(unique(msn$program.name), function(x) { unlist(which(length(grep(x, ushow_int, ignore.case = TRUE)) == 0)) })
grep("MATTHEWS", ushow_int, value = TRUE, ignore.case = TRUE)

# save
write_csv(msn, "msnbc-reg.csv")


## cnnfn

names(cnnfn)
unique(cnnfn$Show)
unique(cnnfn$Source)
sapply(unique(cnnfn$Show), function(x) { unlist(which(length(grep(x, ushow_int, ignore.case = TRUE)) == 0)) })
grep("SPECIAL REPORT", ushow_int, value = TRUE, ignore.case = TRUE)
unique(int_archive$contributor[grep("Eyewitness News", show_int, ignore.case = TRUE)])

# regularize:
cnnfn$show_reg <- cnnfn$Show
cnnfn$show_reg[which(cnnfn$show_reg == "THE O`REILLY FACTOR")] <- "THE O'REILLY FACTOR"
cnnfn$show_title <- cnnfn$show_reg
cnnfn$show_title <- toTitleCase(tolower(cnnfn$show_title))

#unique(cnnfn$channel_reg)
cnnfn$channel_reg <- cnnfn$Source
cnnfn$channel_reg[grep("FOX News", cnnfn$channel_reg)] <- "FOXNEWS"

# ditch local stations, etc.:
cnnfn <- cnnfn[which(cnnfn$show_reg != ""),]
cnnfn <- cnnfn[which(cnnfn$show_reg != "Show"),]
cnnfn <- cnnfn[grep("CNNfn", cnnfn$channel_reg),]
cnnfn$channel_reg <- "CNN" # is this right?

# save
write_csv(cnnfn, "newsbank-cnn-fn-cleaned-reg.csv")

## cnni

names(cnni)
unique(cnni$Show)
grep("CNN", unique(cnni$Source), ignore.case = TRUE, value = TRUE)
unique(cnni$Source)

#ditch local stations, etc.:
cnni <- cnni[which(cnni$Source == "CNN" | cnni$Source == "MSNBC"),]
cnni$show_reg <- cnni$Show
cnni$show_title <- toTitleCase(tolower(cnni$show_reg))
cnni$channel_reg <- cnni$Source

# save
write_csv(cnni, "newsbank-cnn-inter-cleaned-reg.csv")

## newsbank msnbc

names(msnbc)
unique(msnbc$Show)
msnbc$channel_reg <- "MSNBC"
msnbc$show_reg <- msnbc$Show

grep("KORNACKI", ushow_int, value = TRUE, ignore.case = TRUE)
grep("DONNELL", msn$program.name, value = TRUE, ignore.case = TRUE)

# collapse hosts
grep("KORNACKI", unique(msnbc$Show), value = TRUE, ignore.case = TRUE)
msnbc$show_reg[grep("HAYES", msnbc$show_reg)] <- "UP W/CHRIS HAYES"
msnbc$show_reg[grep("DONNELL", msnbc$show_reg)] <- "LAWRENCE O'DONNELL"
msnbc$show_reg[grep("ED SHOW", msnbc$show_reg)] <- "THE ED SHOW"
msnbc$show_reg[grep("HARRIS-PERRY", msnbc$show_reg)] <- "MELISSA HARRIS-PERRY"
msnbc$show_reg[grep("POLITICS NATION", msnbc$show_reg)] <- "POLITICSNATION"

msnbc$show_title <- toTitleCase(tolower(msnbc$show_reg))

# save
write_csv(msnbc, "newsbank-msnbc-cleaned-reg.csv")

## newsbank stf fox

names(stf)
unique(stf$Show)
unique(stf$Source)

stf <- stf[which(stf$Source == "FOX News Channel"),]
stf$channel_reg <- "FOXNEWS"

stf$show_reg <- gsub("FOX ", "", stf$Show)

# regularize:
grep("SPECIAL", unique(stf$Show), ignore.case = TRUE, value = TRUE)
grep("CARLSON", ushow_int, ignore.case = TRUE, value = TRUE)
stf$show_reg[grep("BIG STORY", stf$show_reg)] <- "BIG STORY"
stf$show_reg[grep("HUME", stf$show_reg)] <- "FOX SPECIAL REPORT WITH BRIT HUME"
stf$show_reg[grep("ON THE RECORD WITH GRETA VAN SUSTEREN", stf$show_reg)] <- "GRETA VAN SUSTEREN"
stf$show_reg[grep("HANNITY", stf$show_reg)] <- "HANNITY"
stf$show_reg[grep("SPECIAL", stf$show_reg)] <- "SPECIAL REPORT WITH BRIT HUME"

stf$show_title <- toTitleCase(tolower(stf$show_reg))

# save
write_csv(stf, "newsbank-stf-fox-cleaned-reg.csv")

### generate appendix table ###

# --- Channel (Outlet), Show, n_transcripts, years/date-range, source_data (It would be LACC, Newsbank etc.)

library(dplyr)
library(xtable)

data.files <- c("archive-clean-reg.csv", "cnn-cleaned-reg.csv", "msnbc-reg.csv", "lacc-cleaned-reg.csv", 
                "newsbank-fox-cleaned-reg.csv", "newsbank-cnn-fn-cleaned-reg.csv", #"newsbank-cnn-inter-cleaned-reg.csv",
                "newsbank-msnbc-cleaned-reg.csv", "newsbank-stf-fox-cleaned-reg.csv")

source.names <- c("Internet Archive", "CNN", "MSNBC", "LACC", rep("Newsbank", 4))


#data.vars <- c("cnnfn", "cnni", "msnbc", "stf", "fox")
#source.names <- paste(rep("Newsbank", 5), 1:5)

setwd("../normalized")

table_out <- NULL
for(v in data.files) {
  
  #src <- get(v)
  src <- read_csv(v)
  
  # date var or Date var?
  if(v == "cnn-cleaned-reg.csv" | v == "msnbc-reg.csv" | v == "lacc-cleaned-reg.csv") {
    src$Date <- format(with(src, as.Date(paste(month, date, year, sep = "-"), format = "%m-%d-%Y")),
                       "%A, %B %d, %Y")
  }
  else {
    if("date" %in% names(src)) {
      src$Date <- format(src$date, "%A, %B %d, %Y")
    }
  }
  
  # grab dates by channel-show
  table_tmp <- select(src, show_reg, channel_reg, Date) %>%
    group_by(show_reg, channel_reg, Date) %>%
    summarize(num_trans = n()) %>%
    summarize(date_from = format(min(as.Date(Date, format = "%A, %B %d, %Y")), "%m/%d/%Y"),
              date_to = format(max(as.Date(Date, format = "%A, %B %d, %Y")), "%m/%d/%Y")) %>%
    mutate(data_source = source.names[which(data.files %in% v)])
  
  # grab # transcripts by channel-show
  table_tmp_trans <- select(src, show_reg, channel_reg) %>%
    group_by(show_reg, channel_reg) %>%
    summarize(num_trans = n())
  
  # combine
  table_tmp$num_trans <- table_tmp_trans$num_trans
  
  table_out <- rbind(table_out, table_tmp)
  
}

# write file
setwd("../../../tabs")
names(table_out) <- c("Show", "Channel", "From", "To", "Source", "Number of Transcripts")
print(xtable(table_out, caption = "Summary of the source, date range, and number of transcripts for each show in the text data.", label = "datatable"), file = "MediaDataAppend.tex", include.rownames = FALSE)

