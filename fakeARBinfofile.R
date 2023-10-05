# @autor: Cristina Galisteo Gomez
# @Date: February 2023 

# R version 4.2.2

setwd("C:/Users/Cristina Galisteo/Desktop/Culturomics vs Metagenomics/arboles16S/alteromonadales_gammaproteobacteria/")

library(seqinr)     # V.4.2-16  # Read fasta
library(paletteer)  # V.1.5

##### FASTA

fasta2 <- read.fasta("alphaproteobacteriaPlusOutgroup.fasta") # Fasta file used for the creation of the tree. Same headers, please.  
sumfasta2 <-summary(fasta2)

sumfasta2 <- cbind(rownames(sumfasta2), sumfasta2)
colnames(sumfasta2)[1] <- "Strain"
sumfasta2 <- as.data.frame(sumfasta2)
sumfasta2$Length <- as.numeric(as.character(sumfasta2$Length))  # We could use this Length but we're going to use the one in the table (it's the same)

# The name of the strains look something like this: ">Marinobacter_2APP75-5+27F_1071_P".
# I want to keep the strain to compare them with the table file with all the info. 

fastanames <- sumfasta2$Strain
positionstart <- gregexpr("_", fastanames)

mynames <- c()
for (p in 1:length(fastanames)) {
  if ( (grepl("F27", sn)==T) | (grepl("27F", sn)==T) | (grepl("ArchF", sn)==T) ){
    sn <- substr(fastanames[p], start = positionstart[[p]][1] + 1 , stop = 100)
    if (grepl("F27", sn) == TRUE) {
      sn <- substr(sn, start = 0 , stop = (regexpr("F27",sn)-2))
    }
    if (grepl("27F", sn) == TRUE) {
      sn <- substr(sn, start = 0 , stop = (regexpr("27F",sn)-2))
    }
    if (grepl("Arc", sn) == TRUE) {
      sn <- substr(sn, start = 0 , stop = (regexpr("Arc",sn)-2))
    }
  }
  else {
    sn <- substr(fastanames[p], start = positionstart[[p]][1] + 1 , stop= positionstart[[p]][length(positionstart[[p]])-1] -1)
  }
  mynames <- c(mynames, sn)
} 

# Both vectors should be the same length: 
length(fastanames)
length(mynames)

# Some more changes: 
mynames <- gsub("_", ".", mynames)
mynames <- gsub("sp.", "", mynames)

# Checking everything is okay:
mynames

# Manual changes: 
mynames[2] <- "2ASP75-1"
mynames[9] <- "2ASP75-19"
mynames[38] <- "3ASR75-205"

# Yey! 

#### Sequences file: 
f <- read.csv("~/archivos_forR/secuencias/ParaR_06_04_22_MOD_completeNOM_ordenado.csv", header = T, sep = ";")

# Check that every strain name from the hasta file is in the sequence file: 
# If they're, everything should be TRUE with the exception of the "outgroup" if present. 
table(mynames %in% f$Cepas)

# Check the bad ones: 
mal <- which ((mynames %in% f$Cepas) == F)
mynames[mal]

# Let's do a dataframe with the strains from the analysis (same order than mynames/fastanames):
mf <- f[1,]  # Let's copy the first row and delete it after: 
for (n in mynames) {  
  mf <- rbind(mf, f[f$Cepas == n, ])
}
mf <- mf[-1, ] # Delete it.

# Check if the length/nrow is the same: 
nrow(mf) # 54
length(mynames) # 53
length(fastanames) # 53

# We might have some strains duplicated in the sequences file, that's why: 
d <- which(duplicated(mf$Cepas))
d
mf[d, ]
mf <- mf[-19, ]
mf <- mf[-18, ]

# We must add the outgroup. All their info is going to be "NA" because we don¡t want to represent it: 
outgroup <- c(fastanames[length(fastanames)], rep (NA, ncol(mf)-1))
mf <- rbind(mf, outgroup)
mf <- cbind(fastanames, mf)

# Now we can create a fake file with the same look that the ARB nds file.
# We will use it in "gitana.R": 
fakeARB <- fastanames
fakeARB <- cbind(fakeARB, rep(NA, length(fastanames)))
fakeARB <- cbind(fakeARB, mf$Taxon)
fakeARB <- cbind(fakeARB,paste0("sp. ", mf$Cepas))
fakeARB <- cbind(fakeARB, rep("NT", length(fastanames)))

write.table(fakeARB, "fakeARB.txt", quote = F, sep ="\t", row.names = F, col.names = F)
## The accession numbers had to be added with "getMyACC.R" script.
