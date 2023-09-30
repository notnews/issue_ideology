"

Preprocess FB and Media Data

@input: 
	1. Pol Data: cong_fb_pages_metadata, capitolwords_112_clean_dw, 
	2. Media Data: media_data/normalized/*
@WhatItDoes:
@output: 
	1. media_mat
	2. pol_mat

@authors: Gaurav Sood and Andy Guess

"

# Set dir
ifelse(grepl("Gaurav", getwd()), setwd(paste0(basedir, "media")), setwd("/Users/aguess/Dropbox/"))
setwd("issue_ideology")

# Load libs
library(readr) 	# read in big data a bit quicker
library(tm)	   	# pre_process text

# Load train mat
load("data/cong_bills/train_mat.Rdata")

"
Pre-process
"

source("code/00_preprocess.R")

# 0. Manifestos
# ---------------------
library(manifestoR)
load("data/election_programmes.Rdata")
str(election_programmes[[1]])
manifesto <- data.frame(text=paste(election_programmes[[1]]$content$text, collapse=' '), date=election_programmes[[1]]$meta$date, party=election_programmes[[1]]$meta$party)
manifesto[2,] <- data.frame(text=paste(election_programmes[[2]]$content$text, collapse=' '), date=election_programmes[[2]]$meta$date, party=election_programmes[[2]]$meta$party)
manifesto[3,] <- data.frame(text=paste(election_programmes[[3]]$content$text, collapse=' '), date=election_programmes[[3]]$meta$date, party=election_programmes[[3]]$meta$party)
manifesto[4,] <- data.frame(text=paste(election_programmes[[4]]$content$text, collapse=' '), date=election_programmes[[4]]$meta$date, party=election_programmes[[4]]$meta$party)
manifesto[5,] <- data.frame(text=paste(election_programmes[[5]]$content$text, collapse=' '), date=election_programmes[[5]]$meta$date, party=election_programmes[[5]]$meta$party)
manifesto[6,] <- data.frame(text=paste(election_programmes[[6]]$content$text, collapse=' '), date=election_programmes[[6]]$meta$date, party=election_programmes[[6]]$meta$party)
manifesto[7,] <- data.frame(text=paste(election_programmes[[7]]$content$text, collapse=' '), date=election_programmes[[7]]$meta$date, party=election_programmes[[7]]$meta$party)
manifesto[,3] <- ifelse(manifesto[,3]==61320, "Democrat", "Republican")
write.csv(manifesto, file="data/manifesto/manifesto.csv", row.names=F)

# 1. Pre-process FB Data
# -----------------------
load("data/cong_smedia/cong_fb_pages_metadata.Rdata")
fb_dat <- subset(fb.text.joined.merged, select=c("mc.name", "mc.text", "party.x", "dwnom1"))
names(fb_dat) <- c("text", "party", "dwnom1")
write.csv(fb_dat, file="data/cong_smedia/fb_dat_reg.csv", row.names=F)

fb_corpus <- preprocess(enc2native(as.character(fb_dat$text)))
fb_dtm  <- DocumentTermMatrix(fb_corpus,  control=list(tokenize = bitrigramtokeniser, bounds=list(global=c(10, Inf))))

# mat has same cols. as train
fb_mat   <- testmat(colnames(train_mat), as.matrix(fb_dtm))
fb_mat   <- fb_mat/rowSums(fb_mat)
save(fb_mat, file="data/cong_smedia/fb_mat.Rdata")

# 2. Subset/Standardize Cong
# --------------------------

# Subset cong data and standardize col names
cong_subset <- function(cong_in, cong_out) {
	cong            <- read_csv(cong_in)
	cong            <- as.data.frame(cong)
	colnames(cong)  <- make.names(colnames(cong))

	# Select columns you need, and only Republican and Democrat speech
	cong           <- subset(cong, subset=party!=328, select=c("bioguide_id", "speaking", "party", "dwnom1"))
	colnames(cong) <- c("bioguide_id", "text", "party", "dwnom1")
	write_csv(cong, cong_out)
}

cong_subset("data/cong_speech/raw/capitolwords_clean_107_dw.csv", "data/cong_speech/cong_107_reg.csv")
cong_subset("data/cong_speech/raw/capitolwords_clean_108_dw.csv", "data/cong_speech/cong_108_reg.csv")
cong_subset("data/cong_speech/raw/capitolwords_clean_109_dw.csv", "data/cong_speech/cong_109_reg.csv")
cong_subset("data/cong_speech/raw/capitolwords_clean_110_dw.csv", "data/cong_speech/cong_110_reg.csv")
cong_subset("data/cong_speech/raw/capitolwords_clean_111_dw.csv", "data/cong_speech/cong_111_reg.csv")
cong_subset("data/cong_speech/raw/capitolwords_clean_112_dw.csv", "data/cong_speech/cong_112_reg.csv")

# First aggregate text by congressperson
#bymem        <- with(cong, tapply(text, bioguide_id, paste, collapse= ' '))
#bymem        <- data.frame(text=bymem, bioguide_id=rownames(bymem))

#congsmall <- cong[!duplicated(cong$bioguide_id), c("bioguide_id", "dwnom1", "party")]
#cong2     <- merge(bymem, congsmall , by="bioguide_id", all.x=T, all.y=F)
#cong2     <- subset(cong2, select=c("text", "party", "dwnom1"))
#cong2_corpus <- preprocess(cong2$text)
#cong2$text <- sapply(cong2_corpus, content)

# 3. Pre-process Media Data
# ---------------------------

# a. CNN
media_dat  <- read_csv("data/media_data/normalized/cnn-cleaned-reg.csv")
med_corpus <- Corpus(VectorSource(media_dat$text))
med_dtm    <- DocumentTermMatrix(med_corpus,  control=list(tokenize = bitrigramtokeniser, bounds=list(global=c(200, Inf))))
med_mat    <- testmat(colnames(train_mat), as.matrix(med_dtm))
cnn_mat    <- med_mat/rowSums(med_mat)
save(cnn_mat, file="data/media_data/media_mat/cnn_mat.Rdata")

# b. LACC
media_dat  <- read_csv("data/media_data/normalized/lacc-cleaned-reg.csv")
med_corpus <- Corpus(VectorSource(media_dat$text))
med_dtm    <- DocumentTermMatrix(med_corpus,  control=list(tokenize = bitrigramtokeniser, bounds=list(global=c(200, Inf))))
med_mat    <- testmat(colnames(train_mat), as.matrix(med_dtm))
lacc_mat   <- med_mat/rowSums(med_mat)
save(lacc_mat, file="data/media_data/media_mat/lacc_mat.Rdata")

# c. Archive
media_dat  <- read_csv("data/media_data/normalized/archive-clean-reg.csv")
med_corpus <- Corpus(VectorSource(media_dat$text))
med_dtm    <- DocumentTermMatrix(med_corpus,  control=list(tokenize = bitrigramtokeniser, bounds=list(global=c(200, Inf))))
med_mat    <- testmat(colnames(train_mat), as.matrix(med_dtm))
archive_mat<- med_mat/rowSums(med_mat)
save(archive_mat, file="data/media_data/media_mat/achive_mat.Rdata")

# d. CNN-FN
media_dat  <- read_csv("data/media_data/normalized/newsbank-cnn-fn-cleaned-reg.csv")
med_corpus <- Corpus(VectorSource(media_dat$text))
med_dtm    <- DocumentTermMatrix(med_corpus,  control=list(tokenize = bitrigramtokeniser, bounds=list(global=c(200, Inf))))
med_mat    <- testmat(colnames(train_mat), as.matrix(med_dtm))
cnnfn_mat  <- med_mat/rowSums(med_mat)
save(cnnfn_mat, file="data/media_data/media_mat/cnnfn_mat.Rdata")

# e. Newsbank MSNBC
media_dat  <- read_csv("data/media_data/normalized/newsbank-msnbc-cleaned-reg.csv")
med_corpus <- Corpus(VectorSource(media_dat$text))
med_dtm    <- DocumentTermMatrix(med_corpus,  control=list(tokenize = bitrigramtokeniser, bounds=list(global=c(200, Inf))))
med_mat    <- testmat(colnames(train_mat), as.matrix(med_dtm))
msnbc_mat  <- med_mat/rowSums(med_mat)
save(msnbc_mat, file="data/media_data/media_mat/msnbc_mat.Rdata")

# f. Newsbank STF Fox
media_dat  <- read_csv("data/media_data/normalized/newsbank-stf-fox-cleaned-reg.csv")
med_corpus <- Corpus(VectorSource(media_dat$text))
med_dtm    <- DocumentTermMatrix(med_corpus,  control=list(tokenize = bitrigramtokeniser, bounds=list(global=c(200, Inf))))
med_mat    <- testmat(colnames(train_mat), as.matrix(med_dtm))
stfox_mat  <- med_mat/rowSums(med_mat)
save(stfox_mat, file="data/media_data/media_mat/stfox_mat.Rdata")

# g. Newsbank Fox
media_dat  <- read_csv("data/media_data/normalized/newsbank-msnbc-cleaned-reg.csv")
med_corpus <- Corpus(VectorSource(media_dat$text))
med_dtm    <- DocumentTermMatrix(med_corpus,  control=list(tokenize = bitrigramtokeniser, bounds=list(global=c(200, Inf))))
med_mat    <- testmat(colnames(train_mat), as.matrix(med_dtm))
fox_mat    <- med_mat/rowSums(med_mat)
save(fox_mat, file="data/media_data/media_mat/fox_mat.Rdata")


