"

FB + Media Predict
And merge it back

@authors: Gaurav Sood and Andy Guess



"

# Set dir
ifelse(grepl("Gaurav", getwd()), setwd(paste0(basedir, "media")), setwd("/Users/aguess/Dropbox/"))
setwd("issue_ideology")

# Load libs
library(readr) 	# read in big data a bit quicker
library(e1071)

# Load model
load("tabs/fit_svm_notune")

# Media data
# ~~~~~~~~~~~~~~~~~~~~~
# a. CNN
load("data/media_data/media_mat/cnn_mat.Rdata")
pred    <- predict(fit_svm_notune, cnn_mat, type = "class")
save(pred, file="tabs/media_pred/cnn_pred")

# b. LACC 
load("data/media_data/media_mat/lacc_mat.Rdata")
lacc_pred    <- predict(fit_svm_notune, lacc_mat, type = "class")
save(lacc_pred, file="tabs/media_pred/lacc_pred")

# c. Archive
load("data/media_data/media_mat/achive_mat.Rdata")
archive_pred    <- predict(fit_svm_notune, archive_mat, type = "class")
save(archive_pred, file="tabs/media_pred/archive_pred")

# d. CNN-FN
load("data/media_data/media_mat/cnnfn_mat.Rdata")
cnnfn_pred    <- predict(fit_svm_notune, cnnfn_mat, type = "class")
save(cnnfn_pred, file="tabs/media_pred/cnnfn_pred")

# e. Newsbank MSNBC
load("data/media_data/media_mat/msnbc_mat.Rdata")
msnbc_pred    <- predict(fit_svm_notune, msnbc_mat, type = "class")
save(msnbc_pred, file="tabs/media_pred/msnbc_pred")

# f. Newsbank STF Fox
load("data/media_data/media_mat/stfox_mat.Rdata")
stfox_pred    <- predict(fit_svm_notune, stfox_mat, type = "class")
save(stfox_pred, file="tabs/media_pred/stfox_pred")

# g. Newsbank Fox
load("data/media_data/media_mat/fox_mat.Rdata")
fox_pred    <- predict(fit_svm_notune, fox_mat, type = "class")
save(fox_pred, file="tabs/media_pred/fox_pred")

# Cong Predict
# ~~~~~~~~~~~~~~~~~~~~~~~

# Cong 111
load("data/cong_speech/cong_111_mat.Rdata")
cong_111_pred    <- predict(fit_svm_notune, cong_111, type = "class")
save(fox_pred, file="tabs/pol_pred/cong_112_pred.csv")

# Cong 112
load("data/cong_speech/cong_112_mat.Rdata")
cong_112_pred    <- predict(fit_svm_notune, cong_112, type = "class")
save(fox_pred, file="tabs/pol_pred/cong_112_pred.csv")
