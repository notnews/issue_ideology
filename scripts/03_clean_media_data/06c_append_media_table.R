# Read dat
int_archive <- read_csv("archive-clean-reg.csv")
cnn <- read_csv("cnn-cleaned-reg.csv")
msn <- read_csv("msnbc-reg.csv")
lacc <- read_csv("lacc-cleaned-reg.csv")

fox <- read_csv("newsbank-fox-cleaned-reg.csv")
cnnfn <- read_csv("newsbank-cnn-fn-cleaned-reg.csv")
cnni <- read_csv("newsbank-cnn-inter-cleaned-reg.csv")
msnbc <- read_csv("newsbank-msnbc-cleaned-reg.csv")
stf <- read_csv("newsbank-stf-fox-cleaned-reg.csv")

### generate appendix table ###

int_archive$channel_reg[grep("CNN", int_archive$show_title, ignore.case = TRUE)] <- "CNN"
int_archive$channel_reg[grep("FOX", int_archive$show_title, ignore.case = TRUE)] <- "FOXNEWS"
int_archive$channel_reg[grep("MSN", int_archive$show_title, ignore.case = TRUE)] <- "MSNBC"
int_archive$channel_reg[grep("ABC", int_archive$show_title, ignore.case = TRUE)] <- "ABC"
int_archive$channel_reg[grep("CBS", int_archive$show_title, ignore.case = TRUE)] <- "CBS"
#int_archive$channel_reg[grep("NBC", int_archive$show_title, ignore.case = TRUE)] <- "MSNBC"

names(int_archive)
tail(int_archive$channel_reg)

lacc$channel_reg[grep("CNN", lacc$show_title, ignore.case = TRUE)] <- "CNN"
lacc$channel_reg[grep("FOX", lacc$show_title, ignore.case = TRUE)] <- "FOXNEWS"
lacc$channel_reg[grep("MSN", lacc$show_title, ignore.case = TRUE)] <- "MSNBC"
lacc$channel_reg[grep("ABC", lacc$show_title, ignore.case = TRUE)] <- "ABC"
lacc$channel_reg[grep("CBS", lacc$show_title, ignore.case = TRUE)] <- "CBS"
#lacc$channel_reg[grep("NBC", lacc$show_title, ignore.case = TRUE)] <- "NBC"



# --- Channel (Outlet), Show, n_transcripts, years/date-range, source_data (It would be LACC, Newsbank etc.)

library(dplyr)
library(xtable)

#data.files <- c("archive-clean-reg.csv", "cnn-cleaned-reg.csv", "msnbc-reg.csv", "lacc-cleaned-reg.csv", 
#                "newsbank-fox-cleaned-reg.csv", "newsbank-cnn-fn-cleaned-reg.csv", #"newsbank-cnn-inter-cleaned-reg.csv",
#                "newsbank-msnbc-cleaned-reg.csv", "newsbank-stf-fox-cleaned-reg.csv")

#source.names <- c("Internet Archive", "CNN", "MSNBC", "LACC", rep("Newsbank", 4))

data.vars <- c("cnn", "msn", "lacc")
data.vars <- c("cnnfn", "msnbc", "stf", "fox")
#source.names <- paste(rep("Newsbank", 5), 1:5)

setwd("../normalized")
table_out <- NULL

#src <- int_archive

for(v in data.vars) {
  
  src <- get(v)
  #src <- read_csv(v)
  
  tmpdate <- as.Date(src$Date, format = "%A, %B %d, %Y")
  src$day <- format(tmpdate, "%d")
  src$month <- format(tmpdate, "%m")
  src$year <- format(tmpdate, "%Y")
  src$date <- with(src, as.Date(paste(month, day, year, sep = "-"), format = "%m-%d-%Y"))
  #src$date <- with(src, as.Date(paste(month, date, year, sep = "-"), format = "%m-%d-%Y"))
  
  # grab dates by channel-show
  table_tmp <- select(src, show_title, channel_reg, date) %>%
    filter(channel_reg %in% c("CBS", "ABC", "NBC", "CNN", "MSNBC", "FOXNEWS")) %>%
    group_by(show_title, channel_reg, date) %>%
    summarize(num_trans = n()) %>%
    summarize(date_from = format(min(date), "%m/%d/%Y"),
              date_to = format(max(date), "%m/%d/%Y")) #%>%s
    #mutate(data_source = source.names[which(data.files %in% v)])
  
  # grab # transcripts by channel-show
  table_tmp_trans <- select(src, show_title, channel_reg) %>%
    filter(channel_reg %in% c("CBS", "ABC", "NBC", "CNN", "MSNBC", "FOXNEWS")) %>%
    group_by(show_title, channel_reg) %>%
    summarize(num_trans = n())
  
  # combine
  table_tmp$num_trans <- table_tmp_trans$num_trans
  
  table_out <- rbind(table_out, table_tmp)
  #table_out
}

table_out <- filter(table_out, num_trans>=100)
table_out <- arrange(table_out, show_title)
table_out$show_title <- toTitleCase(tolower(table_out$show_title))
table_out$show_title <- gsub("Abc", "ABC", table_out$show_title)
table_out$show_title <- gsub("Cbs", "CBS", table_out$show_title)
table_out$show_title <- gsub("Msnbc", "MSNBC", table_out$show_title)
table_out$show_title <- gsub("Nbc", "NBC", table_out$show_title)
table_out$show_title <- gsub("Cnn", "CNN", table_out$show_title)
table_out$show_title <- gsub("your", "Your", table_out$show_title)
table_out$show_title <- gsub("this", "This", table_out$show_title)

names(table_out) <- c("Show", "Network", "From", "To", "num_trans")
table_out <- ungroup(table_out)

table_out <- select(table_out, 1:5) %>%
  group_by(Show) %>%
  summarize(Network = Network, From = From, To = To, total_trans = sum(num_trans))
names(table_out) <- c("Show", "Network", "From", "To", "# of Transcripts")

# remove remaining dupes
table_out$Show[grep("Shepard", table_out$Show)] <- "Shepard Smith"
table_out$Show[grep("Gupta", table_out$Show)] <- "Sanjay Gupta"
table_out$Show[grep("Greta", table_out$Show)] <- "Greta Van Susteren"

#grep("morgan", table_out$Show, value = TRUE, ignore.case = TRUE)

table_out$Show[grep("curve", table_out$Show, ignore.case = TRUE)] <- "Ahead of the Curve"
table_out$Show[grep("americas news h", table_out$Show, ignore.case = TRUE)] <- "Americas News HQ"
table_out$Show[grep("campbell", table_out$Show, ignore.case = TRUE)] <- "Campbell Brown"
table_out$Show[grep("countdown", table_out$Show, ignore.case = TRUE)] <- "Countdown"
table_out$Show[grep("front", table_out$Show, ignore.case = TRUE)] <- "Erin Burnett Out Front"
table_out$Show[grep("hannity", table_out$Show, ignore.case = TRUE)] <- "Hannity"
table_out$Show[grep("hardball", table_out$Show, ignore.case = TRUE)] <- "Hardball"
table_out$Show[grep("velez", table_out$Show, ignore.case = TRUE)] <- "Jane Velez-Mitchell"
table_out$Show[grep("john king", table_out$Show, ignore.case = TRUE)] <- "John King"
table_out$Show[grep("larry king", table_out$Show, ignore.case = TRUE)] <- "Larry King"
table_out$Show[grep("last word", table_out$Show, ignore.case = TRUE)] <- "Last Word"
table_out$Show[grep("dobbs", table_out$Show, ignore.case = TRUE)] <- "Lou Dobbs"
table_out$Show[grep("new day", table_out$Show, ignore.case = TRUE)] <- "New Day"
table_out$Show[grep("morgan", table_out$Show, ignore.case = TRUE)] <- "Piers Morgan"

table_out$Show[grep("World News", table_out$Show, ignore.case = TRUE)] <- "ABC World News Tonight"
table_out$Show[grep("Am Wake Up", table_out$Show, ignore.case = TRUE)] <- "AM Wake Up Call"
table_out$Show[grep("Americas Newsroom", table_out$Show, ignore.case = TRUE)] <- "America's Newsroom"
table_out$Show[grep("CBS evening news", table_out$Show, ignore.case = TRUE)] <- "CBS Evening News"
table_out$Show[grep("gps", table_out$Show, ignore.case = TRUE)] <- "Fareed Zakaria GPS"
table_out$Show[grep("hardball", table_out$Show, ignore.case = TRUE)] <- "Chris Matthews"
table_out$Show[grep("MSNBC News Live", table_out$Show, ignore.case = TRUE)] <- "MSNBC Live"
table_out$Show[grep("Oreilly", table_out$Show, ignore.case = TRUE)] <- "O'Reilly Factor"
table_out$Show[grep("politicsnation", table_out$Show, ignore.case = TRUE)] <- "PoliticsNation"

table_out <- select(table_out, 1:5) %>%
  group_by(Show) %>%
  summarize(Network = Network, From = From, To = To, total_trans = sum(num_trans))
names(table_out) <- c("Show", "Network", "From", "To", "# of Transcripts")

# remove local stragglers
table_out <- table_out[!1:nrow(table_out) %in% grep("[A-Z][A-Z][A-Z][ ]*[0-9]+", table_out$Show),]
table_out <- table_out[!1:nrow(table_out) %in% grep("Fox[ ]*[0-9]+", table_out$Show),]



# write file
setwd("../../../tabs")
print(xtable(table_out, caption = "Summary of the network, date range, and number of transcripts for each show in the text data.", label = "datatable"), 
      file = "MediaDataAppend.tex", include.rownames = FALSE, caption.placement = "top", size = "scriptsize", tabular.environment = "longtable", floating = FALSE)

setwd("../data/media_data/")
write.csv(table_out, "media_data_app_table.csv")




#### stats #####

282-27

data.vars <- c("int_archive", "msn", "cnn", "lacc", "fox", "cnnfn", "msnbc", "stf")

for(i in 1:length(data.vars)) {
  
  src <- get(data.vars[i])
  
  prnt1 <- distinct(select(src, channel_reg)) %>%
    summarise(num_chan = n())
  print(prnt1)
  
  print1 <- distinct(select(src, show_title)) %>%
    summarise(num_show = n())
  print(print1)
  
}




