#!/usr/bin/python3
# -*- coding: utf-8 -*-
"""
Created on 21 November 2021
@author: Cristina Galisteo
Last edited: 02/12/2022
"""

import argparse
from Bio import SeqIO


parser = argparse.ArgumentParser(
    description="Length of the FASTA sequences in a file.")
parser.add_argument(                            # Introduce el fichero fasta
                    '-in', 
                    action="store", 
                    dest="infile", 
                    help="Input file")
parser.add_argument(                           
                    '-s', 
                    action="store_true", 
                    default=False,
                    dest="save", 
                    help="Save the result in a tsv.")
results = parser.parse_args()

seq = []
seq_len =  []
cont = 0
total = 0

if results.save == True:
    archivo = open("countingSEQs.tsv", "w")

for seq_record in SeqIO.parse(results.infile, "fasta"):     # Read
    cont += 1                                               # Count the number sequences (contigs) in the original file. 

    seq.append(seq_record.id)
    seq_len.append(len(seq_record.seq))

    total = total + len(seq_record.seq)

    print("Seq number " + str(cont) + ":\t" + seq_record.id + "\t" + str(len(seq_record.seq)))

    if results.save == True:
        archivo.write(seq_record.id + "\t" + str(len(seq_record.seq)) + "\n")

print("Total size: " + str(total))

if results.save == True:
    archivo.close()
