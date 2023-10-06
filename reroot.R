#!/usr/bin/Rscript --vanilla --silent
# -*-coding: utf-8 -*-

# @autor: Cristina Galisteo Gómez
# @Date: Feb 2023
# @Version: 1.0

library(ggtree)
# Package for visualization and annotation of phylogenetic trees, based on 'ggplot2' library.

library(phytools)
# Reroot.

library(optparse)
# Package for command line.

option_list = list(
### External files read:
  ## Trees:
  make_option(c("-t", "--tree"),
              action="store",
              type="character",
              default = NULL,
              help="Original tree."
              ),
  make_option(c("-o", "--out_tree"),
              action="store",
              type="character",
              default = "rerooted.tree",
              help="Re-rooted tree. \n\t\tBy default, 'rerooted.tree'."
              ),

  make_option(c("-c", "--print"),
              action="store_true",
              default = FALSE,
              help="Print original tree with node numeration. \n\t\tBy default, FALSE."
              ),
  make_option(c("-n", "--node"),
              action="store",
              type="character",
              default = "NULL",
              help="Node number."
              ),
  make_option(c("-p", "--position"),
              action="store",
              type="character",
              default = "NULL",
              help="Position. See more in the 'help' of the 'reroot' function from 'phytools' package."
              ),

  make_option(c("-W", "--output_width"),
              action="store",
              type="double",
              default = 30,
              help="Output file width (cm). By default, A4 width (30 cm).\n\t\tBigger trees need bigger sheet size."
              ),
  make_option(c("-H", "--output_height"),
              action="store",
              type="double",
              default = 21,
              help="Output file height (cm). By default, A4 height (21 cm).\n\t\tBigger trees need bigger sheet size."
              ),
  make_option(c("-s", "--tree_size"),
              action="store",
              type="double",
              default = 0.22,
              help="Tree size. Lower values expand the tree along the X axis. By default, 0.22. \n\t\tIt's recommended to use bigger sizes for circular layouts."
              )
)

opt_parser = OptionParser(option_list=option_list, add_help_option=TRUE)
opt = parse_args(opt_parser)


### Read tree and print: 
t <- read.tree(opt$tree)

if (opt$print){
    tplot <- ggtree(t) + geom_tiplab() + geom_text(aes(label=node)) + xlim (0, as.numeric(opt$tree_size))
    ggsave("OriginalTree.jpg", tplot, width = opt$output_width, height = opt$output_height, units = "cm", limitsize = FALSE)
    quit()
}

t <- reroot(t, as.numeric(opt$node), position = as.numeric(opt$position))

write.tree(phy = t, file = opt$out_tree)

tplot <- ggtree(t) + geom_tiplab() + geom_text(aes(label=node)) + xlim (0, as.numeric(opt$tree_size))
ggsave("rerootTree.jpg", tplot, width = opt$output_width, height = opt$output_height, units = "cm", limitsize = FALSE)
