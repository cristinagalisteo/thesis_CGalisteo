# Calculate ALPHA-DIVERSITY from "19.Project.contigtable" table (SQM)
#
# @Date: 12/06/23
# @Author: Cristina Galisteo

# R version 3.6.2
# library(vegan) # v.2.5-7
# library(paletteer) # v.1.4.0


setwd("C:/Users/Cristina Galisteo/Desktop/Uppsala/Metagenomes/contigs_table")

files <- unlist(list.files(pattern = "forR"))

# Get info into a list: 
mylist <- list()
for (newfile in files) {
  # Read table: 
  f <- read.table(newfile, header = T, sep = "\t")
  
  # Extract taxonomic rank: 
  genus_v <- rep(NA, nrow(f)) # Vector where the selected rank will be save. 
  l <- (strsplit(as.character(f$Tax), ";")) 
  lp <- grep ("f_", l)  # Posiciones que tienen anotado para phylum
  t <- unlist(strsplit(as.character(f$Tax), ";"))  # Todo
  tp <- grep ("f_", t) # Posiciones de "todo" que continen "phylo". Corresponderan con los rows de posiciones de "p". 
  genus_v[lp] <- t[tp] # Sustituye NA por la taxo
  f <- cbind(f, genus_v) # Add as a new column
  
  mylist[[newfile]] <- f
  
  # Get the diversity: 
  # mym <- t(table(f$genus_v))  #  Columns are the taxo names ...
  # rownames(mym) <- newfile     # ... and row is the sample. 
  # mylist[[newfile]] <- mym # Save the matrix.
  
}


number_rows <- (lapply(mylist, nrow))
number_rows <- unlist(number_rows)
n_min </-/min(number_rows) ##  1197119

# Floor para que sea entero
# Max será el número que queremos más uno, porque nunca va a ser ese numero
## Ej: floor(runif(3, min=0, max=100))
# Hacemos un random pick para cada set en función de número máximo de líneas que tenga, preo siempre escogiendo 1197119 números
# Ese vector serán las rows con las que nos quedaremos (los contigs) para cada uno de los data sets. 
# newf <- f[randomSet, ]
# Metemos eso en una función para que lo haga en la lista

myFuncion <- function(n_min, df) {
  randomSet <- floor(runif(n_min, min=1, max=nrow(df)+1))
  newdf <- df[randomSet, ]
  return(newdf)
}

myRandomList <- list()
for (d in names(mylist)){
  # print(d)
  myRandomList[[d]] <- myFuncion(n_min, mylist[[d]])
}
# myRandomList <- (lapply(mylist, myFuncion))
number_rows <- (lapply(myRandomList, nrow))

saveRDS(mylist, "mylist.Robject")
saveRDS(myRandomList, "myRandomlist.Robject")


myRandomTaxoList <- list()
for (n in names(myRandomList)) {
  f <- myRandomList[[n]]
  # Extract taxonomic rank: 
  phylum_v <- rep(NA, nrow(f)) # Vector where the selected rank will be save. 
  l <- (strsplit(as.character(f$Tax), ";")) 
  lp <- grep ("p_", l)  # Posiciones que tienen anotado para phylum
  t <- unlist(strsplit(as.character(f$Tax), ";"))  # Todo
  tp <- grep ("p_", t) # Posiciones de "todo" que continen "phylo". Corresponderan con los rows de posiciones de "p". 
  phylum_v[lp] <- t[tp] # Sustituye NA por la taxo
  f <- cbind(f, phylum_v) # Add as a new column
  
  class_v <- rep(NA, nrow(f)) # Vector where the selected rank will be save. 
  l <- (strsplit(as.character(f$Tax), ";")) 
  lp <- grep ("c_", l)  # Posiciones que tienen anotado para phylum
  t <- unlist(strsplit(as.character(f$Tax), ";"))  # Todo
  tp <- grep ("c_", t) # Posiciones de "todo" que continen "phylo". Corresponderan con los rows de posiciones de "p". 
  class_v[lp] <- t[tp] # Sustituye NA por la taxo
  f <- cbind(f, class_v) # Add as a new column
  
  orden_v <- rep(NA, nrow(f)) # Vector where the selected rank will be save. 
  l <- (strsplit(as.character(f$Tax), ";")) 
  lp <- grep ("o_", l)  # Posiciones que tienen anotado para phylum
  t <- unlist(strsplit(as.character(f$Tax), ";"))  # Todo
  tp <- grep ("o_", t) # Posiciones de "todo" que continen "phylo". Corresponderan con los rows de posiciones de "p". 
  orden_v[lp] <- t[tp] # Sustituye NA por la taxo
  f <- cbind(f, orden_v) # Add as a new column
  
  myRandomTaxoList[[n]] <- f
  
  # Get the diversity: 
  # mym <- t(table(f$genus_v))  #  Columns are the taxo names ...
  # rownames(mym) <- newfile     # ... and row is the sample. 
  # mylist[[newfile]] <- mym # Save the matrix.
  
}




for (n in names(myRandomTaxoList)) {
  write.table(file = paste0(n, ".edited.txt"), x = myRandomTaxoList[[n]], sep="\t", quote=F, row.names = F, col.names =T)
}


setwd("C:/Users/Cristina Galisteo/Desktop/Uppsala/Metagenomes/contigs_table")
files <- unlist(list.files(pattern = ".edited.txt"))
myRandomTaxoList <- list()
for (f in files){
  myRandomTaxoList[[f]] <- read.table(f, header=T, sep = "\t", quote = "")
}


for (f in names(myRandomTaxoList)){
### Check NA in all the taxonomic ranks: 
  family_NA <- which(is.na(myRandomTaxoList[[f]]$genus_v))
  phylum_NA <- which(is.na(myRandomTaxoList[[f]]$phylum_v))
  class_NA <- which(is.na(myRandomTaxoList[[f]]$class_v))
  orden_NA <- which(is.na(myRandomTaxoList[[f]]$orden_v))
  
  ## In order to edit the family vector, let's transform it into character: 
  myRandomTaxoList[[f]]$genus_v <- as.character(myRandomTaxoList[[f]]$genus_v)
  
  ## If there is no family either phylum annotation, then it is "Unclassified": 
  myRandomTaxoList[[f]][intersect(family_NA,phylum_NA),]$genus_v <- "Unclassified"
  
  ## Recalculate the NA in the family vector, as we have already detected the Unclassifies: 
  family_NA <- which(is.na(myRandomTaxoList[[f]]$genus_v))
  # In this case, if the class is unknown  but the phylum known, we want to indicate which phylum was it identified in. This info is the "phylum_v"
  myRandomTaxoList[[f]][intersect(family_NA,class_NA),]$genus_v <- paste0(as.character(myRandomTaxoList[[f]][intersect(family_NA,class_NA),]$phylum_v),"_Unclassified")
  
  ## Great! Let's repeate with orden: 
  # Recalculate:
  family_NA <- which(is.na(myRandomTaxoList[[f]]$genus_v))
  # Edit: 
  myRandomTaxoList[[f]][intersect(family_NA,orden_NA),]$genus_v <- paste0(as.character(myRandomTaxoList[[f]][intersect(family_NA,orden_NA),]$class_v),"_Unclassified")
  
  ## Now, only the unclassfied family with order annotation are left: 
  family_NA <- which(is.na(myRandomTaxoList[[f]]$genus_v))
  
  myRandomTaxoList[[f]][family_NA,]$genus_v <- paste0(as.character(myRandomTaxoList[[f]][family_NA,]$orden_v),"_Unclassified")
}


for (n in names(myRandomTaxoList)) {
  write.table(file = paste0(n, ".edited_UnclassifiedFam.txt"), x = myRandomTaxoList[[n]], sep="\t", quote=F, row.names = F, col.names =T)
}


myDiversityList <- list()
for (n in names(myRandomTaxoList)){
  # Get the diversity:
  mym <- t(table(myRandomTaxoList[[n]]$genus_v))  #  Columns are the taxo names ...
  rownames(mym) <- n     # ... and row is the sample.
  myDiversityList[[n]] <- mym # Save the matrix.

}

## We've calculated the diversity for each of the samples. Now we need them all in the same df.
## That means mergining: 

for (i in 1:length(myDiversityList)){
  myDiversityList[[i]] <- as.data.frame(t(myDiversityList[[i]]))
  rownames(myDiversityList[[i]]) <- myDiversityList[[i]][,1]
  colnames(myDiversityList[[i]]) <- c("tax", "del", names(myDiversityList)[i])
}

head(myDiversityList)
mymerged <- merge(myDiversityList[[1]], myDiversityList[[2]], by=0, all=T)
rownames(mymerged) <- mymerged$Row.names
head(mymerged)
mymerged <- mymerged[, -c(1,2,3,5,6)]

for (i in 3:length(myDiversityList)){
  mymerged <- merge(mymerged, myDiversityList[[i]], by=0, all=T)
  rownames(mymerged) <- mymerged$Row.names
  mymerged <- mymerged[, -c(1, (i+1), (i+2))]
}

mymerged[is.na(mymerged)] <- 0
head(mymerged)

# Finally we have matrix with the diversity of each sample. 
# Samples should be in the rows. 
mymergedt <- as.data.frame(t(mymerged))
head(mymergedt)
dim(mymergedt)
rownames(mymergedt) <- c("M3_1A", "M2_1A", "M3_1B", "M2_1B", "M3_1C", "M2_1C", 
                         "M3_2A", "M2_2A", "M3_2B", "M2_2B", "M3_2C", "M2_2C",
                         "M3_3A", "M2_3A", "M3_3B", "M2_3B", "M3_3C", "M2_3C")

library(vegan)

shanon <- diversity(mymergedt)
shanon <- as.data.frame(shanon)
head(shanon)

year <- rep(c("M3", "M2"), 9)
sampling <- c(rep("1A",2), 
              rep("1B", 2), 
              rep("1C", 2), 
              rep("2A", 2), 
              rep("2B", 2), 
              rep("2C", 2), 
              rep("3A", 2), 
              rep("3B", 2), 
              rep("3C",2)
)
area <- c(rep("1", 6), rep("2", 6), rep("3", 6))

shanon <- cbind(shanon, year, sampling, area)

shanon$year <- rep(c(3, 2), 9)
head(shanon)
write.table(shanon, "shanon_family_rarefracted_ready2plot.txt", sep ="\t", quote=F,  row.names = F)

ggplot(shanon, aes(x = year, y = shanon, color = sampling)) + 
  geom_point() + 
  geom_line(size = 2) + 
  ylab("Shannon diversity") + 
  xlab("Year") + 
  labs(color = "Sampling Area") + 
  theme(legend.position = c(0.2, 0.15),
        legend.key = element_rect(fill = alpha("white", 0.0)),  
        legend.title = element_text(size = 14, face ="bold"),
        legend.title.align=0.5, 
        legend.text = element_text(size = 11),
        axis.title.y = element_text(margin = margin(r = 15), face="bold", size = 12), # Set some margin from the coord
        axis.title.x = element_text(margin = margin(t = 15), face="bold", size = 12), 
        axis.text = element_text(size = 11),
        panel.background = element_blank(), # White background
        axis.line = element_line(), # Draw axis lines
        plot.margin = margin(t = 50,  # Top margin
                             r = 20,  # Right margin
                             b = 20,  # Bottom margin
                             l = 20) # Left margin
  ) +  
  scale_x_continuous(limits = c(2, 3), 
                     breaks = c(2, 3), 
                     labels = c("M2\n(2020)", "M3\n(2021)")) + 
  scale_y_continuous(limits = c(1.8, 3.6),
                     breaks = c(2, 2.25, 2.5, 2.75, 3, 3.25, 3.5)) +
  scale_color_manual(values = 
                       # paletteer_d("ggthemes::manyeys")[c(1:3, 5:7, 13:15)] 
                       # paletteer_d("ggthemes::Traffic")[c(1,4,7,2,5,8,3,6,9)]
                       c("#B71C1C", "#E53935", "#E57373", 
                         "#01579B", "#039BE5", "#29B6F6", 
                         "#33691E", "#7CB342", "#AED581")
  ) + 
  guides(color=guide_legend(ncol=3))

ggsave("shanon_diversity_FAMILY_rarefracted.jpg", dpi = 300, units= "cm", height = 17, width = 17)


## SPANISH VERSION: 

ggplot(shanon, aes(x = year, y = shanon, color = sampling)) + 
  geom_point() + 
  geom_line(size = 2) + 
  ylab("Diversidad Shannon") + 
  xlab("Muestreo") + 
  labs(color = "Área muestreada") + 
  theme(legend.position = c(0.2, 0.15),
        legend.key = element_rect(fill = alpha("white", 0.0)),  
        legend.title = element_text(size = 14, face ="bold"),
        legend.title.align=0.5, 
        legend.text = element_text(size = 11),
        axis.title.y = element_text(margin = margin(r = 15), face="bold", size = 12), # Set some margin from the coord
        axis.title.x = element_text(margin = margin(t = 15), face="bold", size = 12), 
        axis.text = element_text(size = 11),
        panel.background = element_blank(), # White background
        axis.line = element_line(), # Draw axis lines
        plot.margin = margin(t = 50,  # Top margin
                             r = 20,  # Right margin
                             b = 20,  # Bottom margin
                             l = 20) # Left margin
  ) +  
  scale_x_continuous(limits = c(2, 3), 
                     breaks = c(2, 3), 
                     labels = c("M2\n(2020)", "M3\n(2021)")) + 
  scale_y_continuous(limits = c(1.8, 3.6),
                     breaks = c(2, 2.25, 2.5, 2.75, 3, 3.25, 3.5),
                     labels = c("2,00", "2,25", "2,50", "2,75", "3,00", "3,25", "3,50")) +
  scale_color_manual(values = 
                       # paletteer_d("ggthemes::manyeys")[c(1:3, 5:7, 13:15)] 
                       # paletteer_d("ggthemes::Traffic")[c(1,4,7,2,5,8,3,6,9)]
                       c("#B71C1C", "#E53935", "#E57373", 
                         "#01579B", "#039BE5", "#29B6F6", 
                         "#33691E", "#7CB342", "#AED581")
  ) + 
  guides(color=guide_legend(ncol=3))

ggsave("shanon_diversity_FAMILY_rarefracted_SPA.jpg", dpi = 300, units= "cm", height = 17, width = 17)
