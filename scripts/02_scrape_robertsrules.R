library(rvest)

setwd("~/Dropbox/issue_ideology/data/roberts_rules")

toc <- "http://www.rulesonline.com/rror--00.htm"

r <- html_session(toc)
chapts <- r %>% html_nodes("a") %>% html_attr("href") # grab links from TOC
chapts <- chapts[5:21]
chapts <- paste0("http://www.rulesonline.com/", chapts) # pages we want to scrape

for(c in chapts) {
  
  r <- html_session(c)
  rr_text <- html_nodes(r, "p") %>% html_text(trim = TRUE)
  #rr_text <- html_nodes(r, "td") %>% html_text(trim = TRUE)
  rr_text <- gsub("\r\n", " ", rr_text)
  
  write(rr_text, paste0(gsub("http://www.rulesonline.com/", "", gsub(".htm", "", c)), ".txt"))
  
}

