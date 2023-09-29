#!/usr/local/bin/python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jan 13 21:05:33 2021

@author: Cristina Galisteo 

Last edited: 22/03/2021
"""

import argparse
from Bio import SeqIO


## FUNCIONES
def my_error(parser, mensaje):
    '''
    Imprime "Error" acompaÃ±ado del texto que espeficique el tipo de error.
    AdemÃ¡s, imprime la ayuda del los argumentos
    Y cierra el programa
    '''
    print("\n" + "ERROR | " + mensaje + "\n")
    parser.print_help()
    quit()




## ARGUMENTOS

parser = argparse.ArgumentParser(
    description="Clean FASTA sequences according with the lenght of the sequences and their k-mer coverage (optional).")
parser.add_argument(                            # Introduce el fichero fasta
                    '-in', 
                    action="store", 
                    dest="infile", 
                    help="Input file")
parser.add_argument(
                    '-l', 
                    action="store", 
                    dest="long", 
                    help="Min length. By default: 500")
parser.add_argument(                           
                    '-cov', 
                    action="store", 
                    dest="cov", 
                    help="If input file is the result of SPAdes assambler, cleaning by k-mer coverage can be done")
parser.add_argument(                           
                    '-d', 
                    action="store_true", 
                    default=False,
                    dest="d", 
                    help="Create a new fasta file with the deleted sequences")
parser.add_argument(                            # Version 1.2
                    '--version', 
                    action="version", 
                    version="Cleaner 1.2")


results = parser.parse_args()


## COMPROBACIÃ“N DE LOS ARGUMENTOS
  
    # Comprueba que se ha introducido un archivo .fasta | .fna | .faa
if results.infile == None: 
    my_error(parser, "Input file missing")  



# Si no se introduce nada, se considera que el valor es 500.  
if results.long == None: 
    results.long = "500" 
elif float(results.long) < 0: 
    my_error(parser, "Value must be positive")




print("Let's go!" 
      + "\n"
      + "We're working with: " + str(results.infile))


## LECTURA DEL ARCHIVO FASTA

seq_len =  []    # List for deleted sequences because of length
seq_cov =  []    # List for deleted sequences because of coverage 
my_records = []  # List for saved sequences
if results.d == True: 
    my_dirty_records = [] # List for deleted sequences

cont = 0         # For counting total number of analized sequences

archivo = open("deleted.tsv", "w") 


for seq_record in SeqIO.parse(results.infile, "fasta"):     # Read
    cont += 1                                               # Count the number sequences (contigs) in the original file. 
    
    if len(seq_record.seq) < float(results.long):           # Check the length
        seq_len.append(seq_record.id)                       # Save IDs from removed sequences     
        archivo.write(seq_record.id + "\t" + "SHORT" +"\t" + str(len(seq_record.seq)) + "\n")                 
        if results.d == True:                               # Save record for new dirty_file
            my_dirty_records.append(seq_record)

    else:
        if results.cov != None: 
            if float(seq_record.id.split("cov_")[1]) < float(results.cov):      # Check the coverage 
                seq_cov.append(seq_record.id)                                   # Save IDs from removed sequences
                archivo.write(seq_record.id + "\t" + "LOW_COV" +"\t" + str(seq_record.id.split("cov_")[1]) + "\n")
                if results.d == True:                                       # Save record for new dirty_file
                    my_dirty_records.append(seq_record)
            else:                                                               # Save record for new clean_flire
                my_records.append(seq_record)
        else:                                                                   # Save record for new clean_flire
            my_records.append(seq_record)

archivo.close()

SeqIO.write(my_records, "clean.fasta", "fasta")             # Creat new clean fasta file. 
if results.d == True:
    SeqIO.write(my_dirty_records, "dirty.fasta", "fasta")   # Creat new dirty fasta file. 
       

print("Done!"
      + "\n"
      + "{} sequences have been analized.".format(cont)
      + "\n"
      + "{} sequences have been deleted:".format(len(seq_len) + len(seq_cov))
      + "\n"   
      + "\t"
      + "{} shorter than {} bp".format(len(seq_len),results.long))
if results.cov != None:
    print("\t"
      + "{} lower than {}x coverage".format(len(seq_cov),results.cov))
print("{} final sequences".format(cont-len(seq_len)-len(seq_cov)))
