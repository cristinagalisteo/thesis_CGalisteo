# Author: C. Galisteo   # Date: 2022
# R version 3.6.2

## Create a list of genomes with undesired parameters from a checkm file. From that list, genomes could be easily removed from a folder by Linux commands.
# Remember to remove the header from the checkm file first.

t <-read.csv("~/../Desktop/checkm_result_all221109.txt", header = F, sep = "\t")
dim(t)

head(t)
min(t$V13) # 72.41 %
max(t$V14) # 43.10 % 

table(t$V13)
table(t$V14)

nrow(t) # 514

nrow(t[t$V13 >= 90, ]) # 506
t_90 <- t[t$V13 >= 90, ]

nrow(t_90[t_90$V14 <= 2, ]) # 506
t_90_2 <- t_90[t_90$V14 <= 2, ]

table(t_90_2$V13)
table(t_90_2$V14)

t_90_2_0 <- t_90_2[t_90_2$V15 == 0, ]
nrow(t_90_2_0) # 382

max(t_90_2_0$V1)
t_90_2_0_0marker <- t_90_2_0[t_90_2_0$V10 == 0, ]
nrow(t_90_2_0_0marker) # 368
table(t_90_2_0_0marker$V9)

t_90_2_0_03marker <- t_90_2_0_0marker[t_90_2_0_0marker$V9 <= 3, ]
nrow(t_90_2_0_03marker) # 280 

rmgenome <- t[t$V13 < 90, ]
nrow(rmgenome) # 8
rmgenome2 <- t[t$V14 > 2, ]
nrow(rmgenome2) # 106
rmgenome3 <- t[t$V15 != 0, ]
nrow(rmgenome3) # 50
rmgenome4 <- t[t$V10 != 0, ]
nrow(rmgenome4) # 59
rmgenome5 <- t[t$V9 >3, ]
nrow(rmgenome5) # 210

rmgenomeAll <- rbind(rmgenome, rmgenome2, rmgenome3, rmgenome4, rmgenome5)
length(unique(rmgenomeAll$V1)) # 234

234 + 280 # 514 hehehe :)

write.table(paste0(unique(rmgenomeAll$V1), ".fsa"), "genome2remove.txt", quote = F, row.names = F, col.names = F)
