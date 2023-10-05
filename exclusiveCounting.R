# Author: C. Galisteo
# R version 3.6.2
###
### To count exclusive genes in a cluster of species
###

## Read OGs matrix
my_data <- read.csv(file = "~/../Desktop/PAPER ALIIFODINIBIUS/OGs_matrix_faa.txt", sep = "\t")
# head(my_data)

## Enumerate genes
# my_genes <- paste("gene", 1:nrow(my_data), sep="_") 
# my_data <- cbind(my_data, my_genes)

## Subset the df and keep only the columns  with genes present in the strain under study: 
Ali <- my_data[my_data$Aliifodinibius_1BSP15_2V2 != "-", ]

## Check
# nrow(my_data)
# nrow(my_data[my_data$Aliifodinibius_1BSP15_2V2 != "-", ])

## In case we need to remove some undesired species/strains: 
# colnames(Ali) # Check the position
# Ali <- Ali[, -7] # Remove

### Parse: 
n <- ncol(Ali) - 1 # If we have added the enumeration of genes
# n <- ncol(Ali)     # If we haven't
## For each strain (each col)...
for (num in n){
  ## ...we turn it into character to be able to modify it...
  Ali[,num] <- as.character(Ali[,num])
  ## ... and for each row in that col... 
  for (i in 1:length(Ali[,num])){
    ## ... the value will be replace with 0 if the gene is not present, and with 1 if it is
    if (Ali[i, num] == "-"){
      Ali[i, num] <- 0
    }
    else {
      Ali[i, num] <- 1
    }
  }
  ## We want the new values to be number, not characters 
  Ali[,num] <- as.numeric(Ali[,num])
} 

## Sum of the row will be at least 1 (or strain)
## So, only the rows which Sum value is 1 belong to genes that are present exclusively in the strain under study
length(rowSums(Ali[,-ncol(Ali)]) [rowSums(Ali[,-ncol(Ali)]) == 1]) # If we have added the enumeration of genes
length(rowSums(Ali) [rowSums(Ali) == 1])                           # If we haven't
