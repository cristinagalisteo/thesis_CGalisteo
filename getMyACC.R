# Author: C. Galisteo   # Date: June-July 2022
#### Add Accession Numbers into a info file for gitana.R. 

### Read seq id with ACC: 

seqid <- read.table("../Desktop/Culturomics vs Metagenomics/arboles16S/seqids.forR.txt", sep ="\t")
head(seqid)


# read txt file:

fakeARB <- read.table("../Desktop/Culturomics vs Metagenomics/arboles16S/alphaproteobacteria/fakeARB.txt", sep ="\t")
head(fakeARB)
nrow(fakeARB)
# fakeARB <- sapply(fakeARB, as.character)
fakeARB$V2 <- as.character(fakeARB$V2)

#• Let's add to the df for easing the check, but we will remove it after, before saving it: 
strain <- gsub("sp. ", "", fakeARB$V4)
fakeARB <- cbind(fakeARB, strain)
head(fakeARB)

count = 1
for (s in fakeARB$strain){
  print(count)
  count <- count +1
  print(s)
  if (s %in% seqid$V3){
    acc <- as.character(seqid[seqid$V3 == s, ]$V4)
  
    fakeARB[fakeARB$strain == s, ]$V2 <- acc 
  
  }

}

fakeARB

# Works!!! 


########### FUNCTION  



getMyAcc <- function(accfile, filerute){
  fakeARB <- read.table(filerute, sep ="\t")
  fakeARB$V2 <- as.character(fakeARB$V2)
  
  strain <- gsub("sp. ", "", fakeARB$V4)
  fakeARB <- cbind(fakeARB, strain)
  
  for (s in fakeARB$strain){

    if (s %in% seqid$V3){
      acc <- as.character(seqid[seqid$V3 == s, ]$V4)
      fakeARB[fakeARB$strain == s, ]$V2 <- acc
    }
  }
  fakeARB <- fakeARB[, -ncol(fakeARB)]
  
  write.table(fakeARB, file = paste0(filerute, ".edited.txt"), sep="\t", quote=F, row.names = F, col.names = F)
  
  return(print(fakeARB[is.na(fakeARB$V2),]))
}

seqid <- read.table("~/../Desktop/Culturomics vs Metagenomics/arboles16S/seqids.forR.txt", sep ="\t")

myFakesARB <- list(
  alpha="~/../Desktop/Culturomics vs Metagenomics/arboles16S/withType/alphaproteobacteria/alpha_fakeARB.txt",
     AB="~/../Desktop/Culturomics vs Metagenomics/arboles16S/withType/AB/fake_arb_AB.txt"
     # altero_gamma="~/../Desktop/Culturomics vs Metagenomics/arboles16S/alteromonadales_gammaproteobacteria/fakeARB.txt", 
     # bacillota="~/../Desktop/Culturomics vs Metagenomics/arboles16S/Bacillota/fakeARB.txt", 
     # archaea="~/../Desktop/Culturomics vs Metagenomics/arboles16S/Euryarchaeota/fake_arb_Euryarchaeota.txt", 
     # otrosGamma="~/../Desktop/Culturomics vs Metagenomics/arboles16S/otrosgammaproteobacteria/fake_arb_otrosGamma.txt")
)

getMyAcc(seqid, "~/../Desktop/Culturomics vs Metagenomics/arboles16S/alphaproteobacteria/fakeARB.txt")
getMyAcc(seqid, "~/../Desktop/Culturomics vs Metagenomics/arboles16S/withType/alteromonadales/altero_fake_arb.txt")
getMyAcc(seqid, "~/../Desktop/Culturomics vs Metagenomics/arboles16S/withType/gammaproteobacteria/gamma_fake_arb.txt")

for (l in myFakesARB){
  getMyAcc(seqid, l)
}

