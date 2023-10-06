#!/usr/bin/Rscript --vanilla --silent
# -*-coding: utf-8 -*-

# @script: symetric2asymetric
# @autor: Cristina Galisteo
# @Date: April 2021
# @Version: 1.0


### DESCRIPTION
# It is possible that some programs need ANI results input. If running orthoANI with 'list' option, the result is symetric.
# This script transforms the symetric result into a asymetric result (that can be used with mOTUlize, for example).

### LIBRARY
library(optparse) # v1.6.6

### ARGUMENTS
option_list = list(
  make_option(c("-i", "--infile"),   # INPUT FILE
              action="store",
              type="character",
              default = NULL,
              help="OrthoANI result file. It should have 3 columns. First two should show strain names and the last one orthoANI result separated by TAB.
              "),
  make_option(c("-o", "--outfile"),   # OUTPUT FILE
              action="store",
              type="character",
              default = "asymetricOrthoANI.txt",
              help="Output file. It will keep the same structure of the input file but double the length. By default: 'asymetricOrthoANI.txt'.
              ")
)
opt_parser = OptionParser(option_list=option_list, add_help_option=TRUE)
opt = parse_args(opt_parser)

### SCRIPT
orthoANI <- read.csv(file = opt$infile, sep = "\t", header = F)
# Save info for each column in a vector
col1 <- as.character(orthoANI[,1])
col2 <- as.character(orthoANI[,2])
col3 <- as.numeric(orthoANI[,3])
# For each row, save column 1 in vector 2, and column 2 in vector 1. orthoANI value keeps its place. 
for (i in 1:nrow(orthoANI)){
  col1 <- c(col1, as.character(orthoANI[i,2]))
  col2 <- c(col2, as.character(orthoANI[i,1]))
  col3 <- c(col3, as.character(orthoANI[i,3]))
}
# Create a new dataframe and save this new info. It should be double the rows of the original. 
asymetricorthoANI <- data.frame(col1)
asymetricorthoANI <- cbind(asymetricorthoANI, col2)
asymetricorthoANI <- cbind(asymetricorthoANI, col3)

### SAVE and BYE-BYE
write.table(asymetricorthoANI, opt$outfile, sep = "\t", row.names=FALSE, col.names=FALSE, quote = F)
cat(paste("Work done :)","\n"))
