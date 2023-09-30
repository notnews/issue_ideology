
mc.text <- tapply(df_fb_pages_wide$text, df_fb_pages_wide$mc_name, function(x) paste(x, collapse = " "))

fb.text.joined <- as.data.frame(cbind(unique(df_fb_pages_wide$mc_name), mc.text))
names(fb.text.joined)[1] <- "mc.name"
fb.text.joined[,1] <- names(fb.text.joined[,1])
names(fb.text.joined[,1]) <- NULL

# fix FB names
look <- which(cong.new$facebook_account == as.numeric(cong.new$facebook_account))
cong.new[look,]$facebook_account[1] <- "CongressmanBradSherman"
cong.new[look,]$facebook_account[2] <- "CalvertforCongress"
cong.new[look,]$facebook_account[3] <- "jointom"
cong.new[look,]$facebook_account[4] <- "Congressman-Alcee-L-Hastings"
cong.new[look,]$facebook_account[5] <- "Congressman-Lynn-Westmoreland"
cong.new[look,]$facebook_account[6] <- "Mike-Simpson-96007744606"
cong.new[look,]$facebook_account[7] <- "Congressman-Bennie-G-Thompson-7259193379"
cong.new[look,]$facebook_account[8] <- "Walter-Jones"
cong.new[look,]$facebook_account[9] <- "RepAlbioSires"
cong.new[look,]$facebook_account[10] <- "Nydia-Velazquez"
cong.new[look,]$facebook_account[11] <- "RepFrankLucas"
cong.new[look,]$facebook_account[12] <- "CongressmanJoePitts"
cong.new[look,]$facebook_account[13] <- "Louie-Gohmert"
cong.new[look,]$facebook_account[14] <- "PeteOlsonTX"
cong.new[look,]$facebook_account[15] <- "senshelley"

head(cong.new[, c("facebook_account", "party.x", "dwnom1", "state", "chamber")])
fb.text.joined.merged <- merge(fb.text.joined, cong.new[, c("facebook_account", "party.x", "dwnom1", "state", "chamber", "namestate")], by.x = "mc.name", by.y = "facebook_account", all.x = TRUE)
names(fb.text.joined.merged)
head(fb.text.joined.merged[, c(1, 3:7)], n = 40)

which(cong.new$facebook_account == "106631626049851")

fb.text.joined.merged <- fb.text.joined.merged[which(!is.na(fb.text.joined.merged$party.x)),]
save(fb.text.joined.merged, file = "data/cong_smedia/cong_fb_pages_metadata.Rdata")
