# thesis_CGalisteo

**analysisPhyChem.R:** Analysis of the physico physicochemical parameters of the samples.

**cleaning_seqs.py:** **INTERACTIVE** Filter *contigs* from fasta file by length or SPAdes kmer.<br> 
&nbsp;&nbsp;&nbsp;&nbsp;By default, filter out sequences shorter than 500 bp. <br>
&nbsp;&nbsp;&nbsp;&nbsp;It's available in the servidor. <br>
&nbsp;&nbsp;&nbsp;&nbsp; Usually executed as follow: <br>
&nbsp;&nbsp;&nbsp;&nbsp;<code>cleaning_seqs.py -in <fasta> -cov 20 -l 500</code>

**countingAAS.py:** **INTERACTIVE** Count number of each amino acids in a fasta file and calculate the percentage. <br>
&nbsp;&nbsp;&nbsp;&nbsp;You might want to use <code>cleaning_seqs.py -l 100</code> first. 

**exclusiveCounting.R:** Count exclusive genes for a genome from a pangenome matrix.

**fromHeroToZero.R:** Transform "OGs_matrix" (from Enveomics' Blast all vs all file) to "0/1 matrix".

**genome2remove.R:** Create a list of genomes with undesired parameters from a checkm file. From that list, genomes could be easily removed from a folder by Linux commands.

**getMyACC.R:** Add Accession Number to an info file for gitana.R.

**KO_database.R:** Download KEGG database and link them (it might take a while).

**KO_merge.R:** Merge all the file from BlastKOALA into one.

**rarefactionCurve.R:** Calculate rarefraction curve from "19.Project.contigtable" table (SqM) and plot it afterwards.

**rpkg_linecounter.R:** Filter all blast files in the folder to calculate RPKG.

**rpkg_linecounter_oneFile.R:** Filter blast file to calculate RPKG and generate one result for each file (Use when the blast files are too big for your RAM).
