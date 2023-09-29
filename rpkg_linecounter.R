#!/usr/bin/Rscript --vanilla --silent
# -*-coding: utf-8 -*-

# @autor: Cristina Galisteo Gómez
# @Date: March 2023
# @Version: 1.0


files <- unlist(list.files(pattern = "results"))

nlines <- c()
for (file in files){
  # Read the file
  f <- read.csv(file, header = F, sep = "\t") 
  
  # In this case, we only save identity values over 95 %,
  # length over 50 bp, 
  # and evalue <= 1e-5.
  f <- f[f$V3 >= 95 & f$V4 >= 50 & f$V11 <= 1e-5, ]
  # And make sure we only have a hit by read:
  l <- length(unique(f$V1))

  nlines <- c(nlines, l)
  
}

df <- cbind(files, nlines)

write.table(df, "RPKG_countig.txt", append = F, quote = F, row.names = F, col.names = F)
