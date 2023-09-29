# Author: C. Galisteo   # Date: June-July 2022
# R version 3.6.2

## Read all the files in the working directory "_user_ko.txt" and merge the result into a csv file. 
## If the first line doesn't have a KO number, add manually "fake" and it will be remove later. 

files <- unlist(list.files(pattern = "_user_ko.txt"))

f <- read.csv(files[1], header = F, sep = "\t")
funID <- f$V2
funID <- as.character(funID[funID != ""])
genoma <- substr(files[1], start = 0, stop = regexpr("_user_ko.txt", files[1])-1)
m <- as.matrix(table(funID))
colnames(m) <- c(genoma)

for (file in files[-1]){
  # Read the file
  f <- read.csv(file, header = F, sep = "\t")
  
  # Extract de ID
  funID <- f$V2
  if (funID[1] == "fake"){
    funID[1] <- ""
  }
  #funID <- substr(funID, start = (regexpr("K", funID)), stop = 100)
  funID <- as.character(funID[funID != ""])
  genoma <- substr(file, start = 0, stop = regexpr("_user_ko.txt", file)-1)
  
  #write.csv(as.factor(funID), paste0("funID_", genoma, ".txt"), sep="\t", row.names = F, col.names = F, )
  ## Count how many of each fun ID: 
  # Check how many different and save it as a matrix: 
  m2 <- as.matrix(table(funID))
  
  colnames(m2) <- c(genoma)
  
  m <- merge(m, m2, by = "row.names", all = TRUE)
  row.names(m) <- m[,1]
  m <- m[,-1]
  
}
m[is.na(m)] = 0


write.table(m, "KO_merged.tsv", row.names = T, sep = "\t")
