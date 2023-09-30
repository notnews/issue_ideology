setwd("../normalized")

library(dplyr)

## Internet Archive

int_archive <- read_csv("archive-clean-reg.csv")

length(unique(int_archive$show_reg))
length(unique(gsub(" ", "", gsub("/", "", gsub("-", "", gsub("'", "", int_archive$show_reg))))))

# drop 3:
unique(int_archive$show_reg)[which(duplicated(gsub(" ", "", gsub("/", "", gsub("-", "", gsub("'", "", unique(int_archive$show_reg)))))))]
int_archive$show_reg <- gsub(" ", "", gsub("/", "", gsub("-", "", gsub("'", "", int_archive$show_reg))))
int_archive$show_title <- gsub("The ", "", gsub(" and", " &", gsub("'", "", gsub(",", "", gsub("with ", "", int_archive$show_title, ignore.case = TRUE)))))

## CNN

cnn <- read_csv("cnn-cleaned-reg.csv")

length(unique(cnn$show_reg))
length(unique(gsub(" ", "", gsub("/", "", gsub("-", "", gsub("'", "", cnn$show_reg))))))

# drop 2:
unique(cnn$show_reg)[which(duplicated(gsub(" ", "", gsub("/", "", gsub("-", "", gsub("'", "", unique(cnn$show_reg)))))))]
cnn$show_reg <- gsub(" ", "", gsub("/", "", gsub("-", "", gsub("'", "", cnn$show_reg))))
cnn$show_title <- gsub("The ", "", gsub(" and", " &", gsub("'", "", gsub(",", "", gsub("with ", "", cnn$show_title, ignore.case = TRUE)))))

## MSN

msn <- read_csv("msnbc-reg.csv")

length(unique(msn$show_reg))
length(unique(gsub(" ", "", gsub("/", "", gsub("-", "", gsub("'", "", msn$show_reg))))))

msn$show_title <- gsub("The ", "", gsub(" and", " &", gsub("'", "", gsub(",", "", gsub("with ", "", msn$show_title, ignore.case = TRUE)))))

## LACC

lacc <- read_csv("lacc-cleaned-reg.csv")

length(unique(lacc$show_reg))
length(unique(gsub(" ", "", gsub("/", "", gsub("-", "", gsub("'", "", lacc$show_reg))))))

lacc$show_reg <- gsub(" ", "", gsub("/", "", gsub("-", "", gsub("'", "", lacc$show_reg))))
lacc$show_title <- gsub("The ", "", gsub(" and", " &", gsub("'", "", gsub(",", "", gsub("with ", "", lacc$show_title, ignore.case = TRUE)))))

# drop 1:
unique(lacc$show_reg)[which(duplicated(gsub(" ", "", gsub("/", "", gsub("-", "", gsub("'", "", unique(lacc$show_reg)))))))]
lacc$show_reg <- gsub(" ", "", gsub("/", "", gsub("-", "", gsub("'", "", lacc$show_reg))))

## Newsbank

fox <- read_csv("newsbank-fox-cleaned-reg.csv")
cnnfn <- read_csv("newsbank-cnn-fn-cleaned-reg.csv")
cnni <- read_csv("newsbank-cnn-inter-cleaned-reg.csv")
msnbc <- read_csv("newsbank-msnbc-cleaned-reg.csv")
stf <- read_csv("newsbank-stf-fox-cleaned-reg.csv")

length(unique(fox$show_reg))
length(unique(gsub(" ", "", gsub("/", "", gsub("-", "", gsub("'", "", fox$show_reg))))))

# drop 1:
unique(cnnfn$show_reg)[which(duplicated(gsub(" ", "", gsub("/", "", gsub("-", "", gsub("'", "", unique(cnnfn$show_reg)))))))]
cnnfn$show_reg <- gsub(" ", "", gsub("/", "", gsub("-", "", gsub("'", "", cnnfn$show_reg))))

msnbc$show_title <- gsub("The ", "", gsub(" and", " &", gsub("'", "", gsub(",", "", gsub("with ", "", msnbc$show_title, ignore.case = TRUE)))))
fox$show_title <- gsub("The ", "", gsub(" and", " &", gsub("'", "", gsub(",", "", gsub("with ", "", fox$show_title, ignore.case = TRUE)))))
cnnfn$show_title <- gsub("The ", "", gsub(" and", " &", gsub("'", "", gsub(",", "", gsub("with ", "", cnnfn$show_title, ignore.case = TRUE)))))
stf$show_title <- gsub("The ", "", gsub(" and", " &", gsub("'", "", gsub(",", "", gsub("with ", "", stf$show_title, ignore.case = TRUE)))))


## drop shows with <100 transcripts

length(unique(int_archive$show_reg)) # 157
keep_shows <- select(int_archive, show_reg) %>%
  group_by(show_reg) %>%
  summarize(num_trans = n()) %>%
  filter(num_trans >= 100) # now 88!

int_archive <- int_archive[which(int_archive$show_reg %in% keep_shows$show_reg),]

dropShows <- function(s) {
  
  keep_s <- select(s, show_reg) %>%
    group_by(show_reg) %>%
    summarize(num_trans = n()) %>%
    filter(num_trans >= 100)
  
  return(s[which(s$show_reg %in% keep_s$show_reg),])
}

cnn <- dropShows(cnn)
msn <- dropShows(msn)
lacc <- dropShows(lacc)

fox <- dropShows(fox)
cnnfn <- dropShows(cnnfn)
cnni <- dropShows(cnni)
msnbc <- dropShows(msnbc)
stf <- dropShows(stf)

## reduce to 5 cols each
  
names(cnn)[8] <- "day"
names(msn)[8] <- "day"
names(lacc)[7] <- "day"
names(lacc)[13] <- "text"

cnn <- cnn[, c("show_reg", "channel_reg", "year", "month", "day", "text")]
msn <- msn[, c("show_reg", "channel_reg", "year", "month", "day", "text")]
lacc <- lacc[, c("show_reg", "channel_reg", "year", "month", "day", "text")]

data.vars <- c("fox", "cnnfn", "msnbc", "stf")
file.names <- c("newsbank-fox-cleaned-reg.csv", "newsbank-cnn-fn-cleaned-reg.csv", 
                "newsbank-msnbc-cleaned-reg.csv", "newsbank-stf-fox-cleaned-reg.csv")
  
for(v in data.vars) {
  
  src <- get(v)
  
  tmpdate <- as.Date(src$Date, format = "%A, %B %d, %Y")
  src$day <- format(tmpdate, "%d")
  src$month <- format(tmpdate, "%m")
  src$year <- format(tmpdate, "%Y")
  names(src)[which(names(src) == "Content")] <- "text"
  
  src <- src[, c("show_reg", "channel_reg", "year", "month", "day", "text")]
  
  write_csv(src, file.names[which(data.vars %in% v)])
  
}

tmpdate <- as.Date(int_archive$date)
int_archive$day <- format(tmpdate, "%d")
int_archive$month <- format(tmpdate, "%m")
int_archive$year <- format(tmpdate, "%Y")

int_archive <- int_archive[, c("show_title", "channel_reg", "year", "month", "day", "text")]

## write files

write_csv(int_archive, "archive-clean-reg.csv")
write_csv(cnn, "cnn-cleaned-reg.csv")
write_csv(msn, "msnbc-reg.csv")
write_csv(lacc, "lacc-cleaned-reg.csv")

write_csv(fox, "newsbank-fox-cleaned-reg.csv")
write_csv(cnnfn, "newsbank-cnn-fn-cleaned-reg.csv")
#write_csv(cnni, "newsbank-cnn-inter-cleaned-reg.csv") # 0 rows -- don't include
write_csv(msnbc, "newsbank-msnbc-cleaned-reg.csv")
write_csv(stf, "newsbank-stf-fox-cleaned-reg.csv")
