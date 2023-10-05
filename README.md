# thesis_CGalisteo

**analysisPhyChem.R:** Analysis of the physico physicochemical parameters of the sample.

**cleaning_seqs.py:** Mostly, filter FASTA file by length. By default, 500 bp. It's available from the servidor. Interactive. 

**countingAAS.py:** Count the number of each amino acids in a FASTA file and calculate the percentage. You might want to use 'cleaning_seqs.py -l 100' first. Interactive

**exclusiveCounting.R:** Count exclusive genes for a genome from a pangenome matrix.

**fromHeroToZero.R:** Transform "OGs_matrix" (from Enveomics' Blast all vs all file) to "0/1 matrix".

**genome2remove.R:** Create a list of genomes with undesired parameters from a checkm file. From that list, genomes could be easily removed from a folder by Linux commands.

**getMyACC.R:** Add Accession Number to an info file for gitana.R.

**KO_database.R:** Download KEGG database and link them (it might take a while).

**KO_merge.R:** Merge all the file from BlastKOALA into one.

**rpkg_linecounter.R:** Filter all blast files in the folder to calculate RPKG.

**rpkg_linecounter_oneFile.R:** Filter blast file to calculate RPKG and generate one result for each file (Use when the blast files are too big for your RAM).
