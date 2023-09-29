#!/domus/h1/galisteo/opt/miniconda3/envs/SqueezeMeta-dev/bin/python3

'''
@ author: Cristina Galisteo
@ Date: July 2022

This script is for renaming headers. 
The name (and order) of the fasta file are on "fasta.txt".
The new names of the new headers are on "my_names.txt". The names are for ALL the fastas, meaning that the first header is for the first header of the first fasta;
and the last name is for the last header of the last fasta. 
New fastas are rename as "<old_name>.new.fasta". 
Old fastas are save in the "fasta" file.  

'''

theFasta = open("fasta.txt")
newnames= open('my_names.txt')

# Read the names of the fasta from the file. For each: 
for l in theFasta:

# Remove the "\n":
	l = l.strip("\n") 
	print(l)

# Open it and create a new fasta file: 
	fasta= open(("fasta/" + l))
	newfasta= open((l + ".new.fasta"), 'w')

# Parse each line of the old fasta: 
	for line in fasta:
	
# If it is a header, read the line of the newheaders file: 
		if line.startswith('>'):
			newname= newnames.readline()
			newname= str(">") + newname  # Add the ">". 
			newfasta.write(newname)

# If it is not a header, it will copy the line (the seq): 
		else:
			newfasta.write(line)

# Close old and new fasta files: 
	fasta.close()
	newfasta.close()


newnames.close()
theFasta.close()
