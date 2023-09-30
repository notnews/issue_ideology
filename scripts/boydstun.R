"

Combine Boydstun with codes 

"

setwd(basedir)
setwd("issue_ideology/data/boydstun/")

full_text <- read.csv("full_text_plus_details.csv")
new_codes <- read.csv("Boydstun_NYT_FrontPage_Dataset_1996-2006_0_PAP2014_recoding.csv")

final_dat <- merge(full_text, new_codes, by.x="Article_ID", by.y="id")
names(final_dat)[40:44] <- paste0("pap_codefile_", names(final_dat)[40:44])
names(final_dat) <- tolower(names(final_dat))
names(final_dat) <- gsub("\\.", "_", names(final_dat)) # convert to snake case

write.csv(final_dat, file="nyt_full_text_plus_new_pap_codes.csv")