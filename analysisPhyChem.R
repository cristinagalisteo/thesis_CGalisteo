library(vegan)

f <- read.csv("~/../Desktop/Culturomics vs Metagenomics/Datos_AnalisisQuimicos_TODOS_EngMetTableEditedc.txt",
              header = T, sep = "\t")
head(f)

# Name row with abbreviation (easier to plot later).
f$X # Same order, of course. 
rownames(f) <- c("EC", "pH", "SoilT", "AitT",
                 "Al", "Ca", "P", "K", "Na", "S",
                 "As", "Cd", "Chloride", "Co", "Cu", "Fe", 
                 "Pb", "Mn", "Ni", "Nitrates", "Nitrites", 
                 "Zn", "C", "N", "Sulphate", "Clay", "Sand", "Silt", "Texture")

# Remove discrete rows: 
f <- f[-29,-1]

ft <- t(f)
ft <- as.data.frame(ft)
head(ft)

for (i in 1:ncol(ft)){
  ft[,i] <- as.numeric(as.character(ft[,i]))
}
head(ft) 
  

## CA (Correspondance Analysis)
ord = cca(ft)
ord
plot(ord, scaling=1)
plot(ord, scaling=2)
plot(ord, scaling=3)
ord

# Only metagenomes: 
ordm = cca(ft[-(1:5), ])
ordm
plot(ordm, scaling=1)
plot(ordm, scaling=2)
plot(ordm, scaling=3)
ordm


## PCA

mod = rda(scale(ft))
plot(mod, scaling=1)
plot(mod, scaling=2)
plot(mod, scaling=3)

## Distancias

d = dist(scale(ft)) # Distancias euclideas
plot(hclust(d))

## metaMDS

plot(metaMDS(d), type='t')

heatmap(scale(ft))


## If we do not consider M1_2A y M1_3A, que son de otras zonas. 

ords = cca(ft[-c(4,5), ])
ords
plot(ords, scaling=1)
plot(ords, scaling=2)
plot(ords, scaling=3)



## Metagenomes 

ordss = cca(ft[-c(1:5), ])
ordss
plot(ordss, scaling=1)
plot(ordss, scaling=2)
plot(ordss, scaling=3)




###### CONTAMINATION  
# Metagenomes: 
ftm <- ft[-c(1:5), ]

contamination <- function(v){
  print(max(v))
  print(min(v))
}

contamination(ft$As) # All contaminated
contamination(ft$Cd)
contamination(ft$Cu)
contamination(ft$Pb) # All contaminated
contamination(ft$Zn) # All contaminated

contamination(ftm$As) # All contaminated
contamination(ftm$Cd)
contamination(ftm$Cu)
contamination(ftm$Pb) # All contaminated
contamination(ftm$Zn) # All contaminated
