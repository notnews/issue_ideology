

setwd(basedir)
setwd("issue_ideology/")

cong107 <- read.csv("congress_107_predict_topic_1_new.csv")
pros    <- sapply(cong107[,3:20], inv.logit)
classes <- names(cong107)[apply(pros, 1, which.max)]

# Normalizing by amount of speech
a <- with(cong107, table(party, classes))
b <- addmargins(a)
c <- b[1,ncol(b)]/b[2,ncol(b)]

d <- a
d[1,] <- d[1,]/c


# Proportion of speech by Democrats
# 100  Democrat
# 200  Republican

prop.table(d,2)
