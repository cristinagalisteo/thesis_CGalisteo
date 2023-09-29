# thesis_CGalisteo

**cleaning_seqs.py:** Mostly, filter FASTA file by length. By default, 500 bp. It's available from the servidor. Interactive. 

**countingAAS.py:** Count the number of each amino acids in a FASTA file and calculate the percentage. You might want to use 'cleaning_seqs.py -l 100' first. Interactive

**rpkg_linecounter.R:** Filter all blast files in the folder to calculate RPKG

**rpkg_linecounter_oneFile:** Filter blast file to calculate RPKG and generate one result for each file (Use when the blast files are too big for your RAM)