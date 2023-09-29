#!/usr/bin/Rscript --vanilla
# -*-coding: utf-8 -*-

# @autor: Cristina Galisteo Gómez
# @Date: March 2023
# @Version: 1.3 # Edited: July 2023 (CG)

library(optparse)

option_list = list(
  make_option(c("-f", "--file"),
              action="store",
              type="character",
              default = NULL,
              help="Result file. If empty, it will work with all the '.results' files in the folder."
              )
)
opt_parser = OptionParser(option_list=option_list, add_help_option=TRUE)
opt = parse_args(opt_parser)

cat(paste0(opt$file, "\n"))

nlines <- c()
# Read the file
f <- read.csv(opt$file, header = F, sep = "\t")
f <- f[f$V3 >= 95 & f$V4 >= 50 & f$V11 <= 1e-5, ]
l <- length(unique(as.character(f$V1)))
data <- paste0(opt$file, "\t", l)
write.table(data, paste0(opt$file, "_RPKG_countig.txt"), sep = "\t",  append = F, quote = F, row.names = F, col.names = F)
