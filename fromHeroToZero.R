## @author: Cristina Galisteo
## @date: November 2022
## Transform "OGs_matrix" to "0/1 matrix": 

m <- read.csv("OGs_matrix_faa.txt", sep = "\t")

n <- ncol(m) 
for (num in 1:n){
  ## ...we turn it into character to be able to modify it...
  m[,num] <- as.character(m[,num])
  ## ... and for each row in that col... 
  for (i in 1:length(m[,num])){
    ## ... the value will be replace with 0 if the gene is not present, and with 1 if it is
    if (m[i, num] == "-"){
      m[i, num] <- 0
    }
    else {
      m[i, num] <- 1
    }
  }
  ## We want the new values to be number, not characters 
  m[,num] <- as.numeric(m[,num])
} 

## We may want to subset the matrix (or not) and, consequently, remove the 0 columns for all the remaining strains: 
# m <- m[, c(3,4,18,25,29,33)]
# m <- m[rowSums(m)>0, ]

## If it is for PanGP, we will remove colnames and row names when saving: 
write.table(x = m, "OGs_01Matrix_faa.txt", sep = "\t", # )
          col.names = F, row.names = F)

write.csv(x = m, "OGs_01Matrix_faa.txt", sep = "\t")
