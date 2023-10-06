# thesis_CGalisteo

**analysisPhyChem.R:** Analysis of the physico physicochemical parameters of the samples.

**cleaning_seqs.py:** [INTERACTIVE]() Filter *contigs* from fasta file by length or SPAdes kmer.<br> 
&nbsp;&nbsp;&nbsp;&nbsp;INTERACTIVE <br>
&nbsp;&nbsp;&nbsp;&nbsp;By default, filter out sequences shorter than 500 bp. <br>
&nbsp;&nbsp;&nbsp;&nbsp;It's available in the servidor. <br>
&nbsp;&nbsp;&nbsp;&nbsp; Usually executed as follow: <br>
&nbsp;&nbsp;&nbsp;&nbsp;<code>cleaning_seqs.py -in <file.fasta> -cov 20 -l 500</code>

**countingAAS.py:** **INTERACTIVE** Count number of each amino acids in a fasta file and calculate the percentage. <br>
&nbsp;&nbsp;&nbsp;&nbsp;You might want to use <code>cleaning_seqs.py -in <file.fasta> -l 100</code> first. <br>
&nbsp;&nbsp;&nbsp;&nbsp;<code>countingAAS.py -in <file_m100.fasta> </code>

**countseq.py:** **INTERACTIVE** Size of each of the sequences in a fasta file.  <br>
&nbsp;&nbsp;&nbsp;&nbsp; Results will be printed on screen.  <br>
&nbsp;&nbsp;&nbsp;&nbsp; <code>-s</code> would save the results in "countingSEQs.tsv" file. <br>
&nbsp;&nbsp;&nbsp;&nbsp; <code>countseq.py -f <file.fasta> -s</code>

**exclusiveCounting.R:** Count exclusive genes in a genome from a pangenome matrix.

**fakeARBinfofile.R:** Create a file with info of the strains to use with **gitana.R**.

**fromHeroToZero.R:** Transform "OGs_matrix" (from Enveomics' Blast all vs all file) to "0/1 matrix".

**gb_extract_v3.py:** **INTERACTIVE** Extract gene from genbank (gb|gbf|gbff) format to gb|fasta format.<br>
&nbsp;&nbsp;&nbsp;&nbsp;Information about the length or number of N is saved in a .tsv file.<br>
&nbsp;&nbsp;&nbsp;&nbsp;Compatible with genbank file from Prokka.<br>
&nbsp;&nbsp;&nbsp;&nbsp;<code>gb_extract_v3.py -f <file.fasta> -s</code>

**genome2remove.R:** Create a list of genomes with undesired parameters from a checkm file. From that list, genomes could be easily removed from a folder by Linux commands.

**getMyACC.R:** Add Accession Number to an info file in **gitana.R**.

**ko_database.R:** Download KEGG database and link them (it might take a while).

**ko_merge.R:** Merge all the file from BlastKOALA into one.

**rarefactionCurve.R:** Calculate rarefraction curve from "19.Project.contigtable" table (SQM) and plot it afterwards.

**rpkg_linecounter.R:** Filter all blast files in the folder to calculate RPKG.<br>
<code>rpkg_linecounter_oneFile.R</code>

**rpkg_linecounter_oneFile.R:** Filter blast file to calculate RPKG and generate one result for each file <br>
Use when the blast files are too big for your RAM. <br>
<code>rpkg_linecounter_oneFile.R -f <blast.result></code>

**shannon_diversity.R:** Calculate alfa diversity from "19.Project.contigtable" table (SQM), and plot it too.
