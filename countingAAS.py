#!/home/galisteo/opt/miniconda3/bin/python
# -*- coding: utf-8 -*-

"""
@author: Alicia García-Roldán & Cristina Galisteo 
Created: 26/05/2021
"""

import argparse
from Bio import SeqIO

## ARGUMENTS:
parser = argparse.ArgumentParser(
    description="Calculate the percentage of each amino acid in the INPUT sequence(s). You might want to filter your secuence by length before using this script. If so, cleaning_seq.py script is what you are looking for.") 

parser.add_argument( # Introduce el fichero fasta
                    '-in',
                    action="store",
                    dest="infile",
                    help="Input. Amino acids file (.faa)")
results = parser.parse_args() 


##SCRIPT: 
Conteo = {} # Diccionario 
total_AAS = 0 # Count total aas

for seq_record in SeqIO.parse(results.infile, "fasta"):
    for i in seq_record.seq:
        if i == "X" or i == "*":
            break
        else: 
                if i in Conteo:
                    Conteo[i] += 1 # Cada vez que se repita la letra, debe sumarse
                else: 
                    Conteo[i] = 1 # Si no se repite, no se suma y se queda igual
    if "X" != seq_record.seq:  # Si la secuencia no se ha traducido, no cuenta los caracteres 'X' como AAS. 
        total_AAS = total_AAS + len(seq_record.seq)



# Imprimimos el resultado de contar la frecuencia en un diccionario:
print("\nEl número de veces que aparecen los aminoácidos son:\n", Conteo)
# Calculamos cuál es el aminoácido que más aparece y el que menos aparece:
aa_mas_repetido = max(zip(Conteo.values(), Conteo.keys())) 
aa_menos_repetido = min(zip(Conteo.values(), Conteo.keys()))
# Imprimimos el resultado indicando la manera en la que saldrá para que sea más fácil leerlo:
print("\nEl aminoácido que más se repite es (número de veces, aa):", aa_mas_repetido) 
print("\nEl aminoácido que menos se repite (número de veces, aa):", aa_menos_repetido,"\n")
# Se han añadido saltos de líneas para que la información sea más clara a la hora de leerla.
print("Número total de aminoácidos: ", total_AAS, "\t")




archivo = open("{}.aas.out".format(results.infile), "w")
archivo.write(str(results.infile) + ":" + "\n")
archivo.write("aas" + "\t" + "Total" + "\t" + "Percentage" + "\n")
for key in Conteo: 
    archivo.write(str(key) + "\t" + str(Conteo[key]) +"\t" + str(Conteo[key]*100/total_AAS) + "\n")

archivo.close()
