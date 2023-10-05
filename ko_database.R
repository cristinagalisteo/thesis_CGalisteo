# Author: C. Galisteo   # Date: June-July 2022
# R version 3.6.2

## GET LIST TABLE 

getKeggTable <- function(db){
  ## db: pathway | brite | module | ko | genome | <org> | vg | vp | ag | compound |
  #  glycan | reaction | rclass | enzyme | network | variant | disease |
  #  drug | dgroup | atc | jtc | ndc | yj | pubmed
  
  link_REST_url <- paste0("http://rest.kegg.jp/list/", db, "/")
  kegg_df<- data.frame()
  
  current_row = 1
  for (line in readLines(link_REST_url)) {
    tmp <- strsplit(line, "\t")[[1]]
    id <- tmp[1]
    id <- strsplit(id, ":")[[1]][2]  
    name<- tmp[2]
    kegg_df[current_row, 1]=id
    kegg_df[current_row, 2]=name
    current_row = current_row + 1
  }
  names(kegg_df) <- c("id","name")
  row.names(kegg_df) <- kegg_df$id
  return(kegg_df)
}



## GET LINK BETWEEN DATABASES

getLinkTable <- function(db1, db2){
  # db1: source database
  # db2: target database
  link_REST_url <- paste0("http://rest.kegg.jp/link/", db2, "/", db1)
  kegg_df<- data.frame()
  
  current_row = 1
  for (line in readLines(link_REST_url)) {
    tmp <- strsplit(line, "\t")[[1]]
    id <- tmp[1]
    id <- strsplit(id, ":")[[1]][2]  
    name<- tmp[2]
    name <- strsplit(name, ":")[[1]][2]  
    kegg_df[current_row, 1]=id
    kegg_df[current_row, 2]=name
    current_row = current_row + 1
  }
  names(kegg_df) <- c(db1,db2)
  return(kegg_df)
}

############## USING FUNCTIONS 

KO_table <- getKeggTable("ko")
module_table <- getKeggTable("module")
brite_table <- getKeggTable("brite")
map_table <- getKeggTable("pathway")

link_KO_module <- getLinkTable("ko", "module")
link_KO_brite <- getLinkTable("ko", "brite")
link_KO_map <- getLinkTable("ko", "pathway")
link_KO_map <- link_KO_map[seq(from= 1, to =nrow(link_KO_map), by = 2), ]
rownames(link_KO_map) <- link_KO_map$ko
