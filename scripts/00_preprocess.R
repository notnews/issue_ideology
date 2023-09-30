"

Abstract Pre-Process File

"

# Convert to dtm
library(rJava)
library(RWeka)
library(SnowballC)

" 
Pre-process raw text

Converts to lower case, removes all non-alphanumeric characters, removes numbers, including roman numerals, 
removes any word one letter long, removes stop words, stems/lemmatizes words, removes an additiona list of common words, 
removes one or two letter stemmed words, removes extra white space

"

preprocess <- function(text_column)
{
	# To lower case
		text   <- tolower(text_column) 
	# Remove all non-alphanumeric
		text   <- gsub("[^[:alnum:]]", " ", text) 
	# Remove numbers
		text   <- gsub("\\d", "", text)
	# Remove numbers
		text   <- gsub(paste(c("i", "ii", "iii", "iv", "v", "vi", "vii", "viii", "ix", "x"), collapse = ' | '), "", text)
	# Remove stray letters
		text   <- gsub(paste(letters, collapse = ' | '), "", text)
	# Use tm to get a doc matrix
		corpus <- Corpus(VectorSource(text))
	# remove stopwords
		corpus <- tm_map(corpus, removeWords, stopwords("english"))
	# stem document
		corpus <- tm_map(corpus, stemDocument)
	# take out 1 or 2 letter words and 
	# common leg bill stems
	# always last step: strip extra white space
		common   <- readLines("data/cong_bills/common_words.txt")
		out_text <- lapply(corpus, function(x) {
									# remove 1 or 2 letter stemmed words
									y <- gsub(" *\\b[[:alpha:]]{1,2}\\b *", " ", content(x))
									# remove common words												
									y <- gsub(paste(common, collapse = ' | '), " ", y)
									# Remove extra white space
									gsub("^ +| +$|( ) +", "\\1", y)
								})
		Corpus(VectorSource(out_text))
}

"
Tokenize: bi- and tri-grams
But also: uni- and bi-

"
# Bi-Trigram tokenizer Func.
bitrigramtokeniser <- function(x, n) {
	NGramTokenizer(x, Weka_control(min = 2, max = 3))
}

"
Aim is to have same columns as training data 
You can have a workflow that doesn't require this
"
# Same columns as training data
testmat <- function(train_mat_cols, test_mat){	
  # train_mat_cols <- colnames(train_mat); test_mat <- as.matrix(test_dtm)
  test_mat 	<- test_mat[, colnames(test_mat) %in% train_mat_cols]
  
  miss_names 	<- train_mat_cols[!(train_mat_cols %in% colnames(test_mat))]
  if(length(miss_names)!=0){
    colClasses  <- rep("numeric", length(miss_names))
    df 			<- read.table(text = '', colClasses = colClasses, col.names = miss_names)
    df[1:nrow(test_mat),] <- 0
    test_mat 	<- cbind(test_mat, df)
  }
  as.matrix(test_mat)
}
