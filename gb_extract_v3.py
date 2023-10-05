#!/usr/bin/python3.9
# -*- coding: utf-8 -*-
"""
Created on Thu Feb 18 13:01:43 2021

@author: Cristina Galisteo

Last edited: 19:55 22/03/2021
"""
###
### MODULES
###

import argparse, re
from utils_16SfGB import *
from Bio import SeqIO

###
### ARGUMENTS
###

parser = argparse.ArgumentParser(
    description="Extracción del gen ARNr 16S en formato 'gb'")

parser.add_argument(                            # Introduce el fichero genbank
                    '-in', 
                    action="store", 
                    dest="infile", 
                    help="Input file in genbank format (.gb|.gbf|.gbff)")

parser.add_argument(                            
                    '-prod', 
                    action="store", 
                    dest="prod", 
                    help="Choose product to extract. Eg.: 16SrRNA")

parser.add_argument(                            #
                    '-o', 
                    action="store", 
                    dest="o", 
                    help="Output format")

parser.add_argument(                            # Booleano que se activa a True si se añade 
                    '-prokka', 
                    action="store_true", 
                    default=False,
                    dest="prokka", 
                    help="Create a new readable file from a genbank file from Prokka. \n It'll be save as 'new_<original-name>.gbf'")

parser.add_argument(                            # Booleano que se activa a True si se añade 
                    '-tsv', 
                    action="store_true", 
                    default=False,
                    dest="tsv", 
                    help="Create a .tsv file with N and length of the extracted sequence(s)")

parser.add_argument(                            # Versión 2.0
                    '--version', 
                    action="version", 
                    version="gb_extract 3.0")

results = parser.parse_args()





print("Let's start! We're working with file: '{}' to extract '{}'".format(results.infile,results.prod))


# Creamos una variable con el nombre que tiene el fichero de entrada, sin la extensión. 
# Por tanto, se corta por el punto y nos quedamos con la primera parte ([0])
name_genoma = results.infile.split(".")[0]


###
### FOR PROKKA
###
# Create a new file with an altered LOCUS header. 
# This allow SeqIO module to read it as a genbank normal file. (SeqIO doesn't read header that are too long, as the ones Prokka creates)

if results.prokka == True: 
    
    print("\t It's from Prokka, so let's transform it first...")
    
    original_gbf = open(results.infile)                           # Read Prokka file
    our_gb_file = "new_{}.gbf".format(name_genoma)
    altered_gbf = open(our_gb_file,"w")      # Create a new file to save the readible headers for SeqIO
                                                                  # Keeps the same name that the original file adding "new_"at the beggining. 
    
    
    ## READING INPUT FILE:
    cont = 0
    for line in original_gbf:                              # Looking for the "locus" line
    
    # If it's NOT a locus line, write the line just the same
        if line.find("LOCUS") == -1:                       
               altered_gbf.write(line)
    
    # If it IS a locus line, create a new line for it. 
        else:
            node = re.search("(NODE_.*)(_length_)(.*)(_cov)(.*)( bp.*)", line).group(1)
            long = re.search("(NODE_.*)(_length_)(.*)(_cov)(.*)( bp.*)", line).group(3)
            bp_type = re.search("(NODE_.*)(_length_)(.*)(_cov)(.*)( bp.*)", line).group(6)
            new_line = str("LOCUS       " + str(node) + "             " + str(long) + str(bp_type) + " ")   # New line as we want it
            altered_gbf.write(new_line)
            
            # Count how many lines have been replace. 
            cont += 1
    
    original_gbf.close()
    altered_gbf.close() 
    
    print("\t ...new file '{}' created! {} lines have been replace".format(our_gb_file, cont))


###
### SCRIPT
###

# If we're not working with Prokka, we'll rename the input file as 'our_gb_file'
else:
    our_gb_file = results.infile

# Create a writtable .tsv file if asked
if results.tsv == True:
    archivo = open("name_long_N.tsv", "w") 


# Create a counting variable to allow the extraction of one or more fragment without re-writing them 
conteo = 1

# 16S rRNA is 'rRNA' type, while the rest are 'CDS' type. So the rute is going to be different
if results.prod == "16SrRNA": 
    results.prod = "16S ribosomal RNA"


# Let's parse
print("Extracting...")


for record in SeqIO.parse(our_gb_file, "genbank"):
    
    # Checking features (looking for 16S rRNA or whatever)
    for f in record.features: 

## For 16S rRNA:        
        # Discharge type != rRNA
        if results.prod == "16S ribosomal RNA":
            if f.type == "rRNA":
                
                if "product" in f.qualifiers:
                    # (Este if no sé si es necesario tenerlo o se podría poner el siguiente directamente)
                    # Los producto son una cadena. Queremos el primero ([0]), y que sea 16S. 
                    if f.qualifiers["product"][0] == results.prod: 
                        
                        # Create RECORD and ANNOTATIONS for new file.gb
                        rna16S = f.extract(record)  ## RECORD (just 16S rRNA)
    
                        if rna16S.id == "<unknown id>": 
                            rna16S.id = record.id
                        if rna16S.name == "<unknown name>": 
                            rna16S.name = record.name
                        if rna16S.description == "<unknown description>": 
                            rna16S.description = record.description   
    
    
                        rna16S.annotations = record.annotations  ## ANNOTATIONS (copy annotations of complete file)

                        rna16S.annotations["molecule_type"] = "DNA" 
    
                        cont_N = my_N(rna16S.seq)   # Recount N 
                        long = len(rna16S.seq)      # Check sequence length
    
                        print("\t" + "'16SrRNA_extract_{}_{}' has {} bp and {} N".format(name_genoma, conteo, long, cont_N))
                        
                        if results.tsv == True: 
                            archivo.write("{}_{}".format(name_genoma, conteo) + "\t" + str(long) + "\t" + str(cont_N) + "\n")
                        print(results.o)
                        # Enumerete to avoid rewriting the brand new files
                        if results.o == "genbank":
                            SeqIO.write(rna16S, "16SrRNA_extract_{}_{}.gb".format(name_genoma, conteo), results.o)  
                        elif results.o == "fasta":
                            SeqIO.write(rna16S, "16SrRNA_extract_{}_{}.fasta".format(name_genoma, conteo), results.o)
                        conteo += 1 

## For other genes:                         
        else: 
            if f.type == "CDS":

                if "product" in f.qualifiers:
                    
#                    if f.qualifiers["product"][0] == "DNA-directed RNA polymerase": 
                    if "gene" in f.qualifiers:
                        if f.qualifiers["gene"][0] == results.prod:
                            gene = f.extract(record)
            
                            if gene.id == "<unknown id>": 
                                gene.id = record.id
                            if gene.name == "<unknown name>": 
                                gene.name = record.name
                            if gene.description == "<unknown description>": 
                                gene.description = record.description   
                            
                            gene.annotations = record.annotations
                            
                            gene.annotations["molecule_type"] = "DNA" 
            
                    
                            cont_N = my_N(gene.seq)   # Recount N 
                            long = len(gene.seq)      # Check sequence length
            
                            print("\t" + "'gene_{}_extract_{}_{}' has {} bp and {} N".format(results.prod, name_genoma, conteo, long, cont_N))
                            
                            if results.tsv == True: 
                                archivo.write("{}_{}".format(name_genoma, conteo) + "\t" + str(long) + "\t" + str(cont_N) + "\n")
                           
                                                        # Enumerete to avoid rewriting the brand new files
                            if results.o == "genbank":
                                SeqIO.write(gene, "gene_{}_extract_{}_{}.gb".format(results.prod, name_genoma, conteo), results.o)  
                            elif results.o == "fasta":
                                SeqIO.write(gene, "gene_{}_extract_{}_{}.fasta".format(results.prod, name_genoma, conteo), results.o)  
                                
                            conteo += 1 
    

                   
if conteo == 1: 
    print("\t" + "No {} found for {} ".format(results.prod, results.infile))
    if results.tsv == True:
        archivo.write(name_genoma + "\t" + str(0) + "\t" + str(0) + "\n")
        archivo.close()
    
if results.tsv == True: 
    archivo.close()
       
print("Yey, we're finished! \n \t {} file(s) created!".format(conteo-1))



