#!/usr/bin/env python3
import sys, os


# Usage: python3 bim2vcf.py <plink.bim> <vcf file> <outfile>
# Remember the vcf file should be unzipped


#Read input
bimFilename = sys.argv[1]
vcfFilename = sys.argv[2]
outFilename = sys.argv[3]

# Read in the IDs of the variants we want to keep and save in set
bimFile = open(bimFilename, 'r')
bimSet = set()
for line in bimFile:
	linesplit = line.split('\t')
	ID = linesplit[1]
	bimSet.add(ID)
bimFile.close()
print(str(len(bimSet)) + ' variants to be included in new VCF')


#Read vcf and write the variants we want to keep to outfile
vcfFile = open(vcfFilename, 'r')
outFile = open(outFilename, 'w')

for line in vcfFile:
	# Header lines
	if line.startswith('#'):
		outFile.write(line)
	
	# Variant lines
	else:
		linesplit = line.split('\t')
		chrom = linesplit[0]
		pos = linesplit[1]
		ID = chrom+':'+pos+'[b37]'
		
		#Check if it's a variant we want to keep
		if ID in bimSet:
			outFile.write(line)

vcfFile.close()
outFile.close()