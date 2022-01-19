#!/usr/bin/env python3
import sys, os


# Usage: python3 plink2vcf.py <plink.prune.in> <vcf file> <outfile>
# Remember the vcf file should be unzipped


#Read input
pruneFilename = sys.argv[1]
vcfFilename = sys.argv[2]
outFilename = sys.argv[3]


# Read in the IDs of the variants we want to keep and save in set
pruneFile = open(pruneFilename, 'r')
pruneSet = set()
for line in pruneFile:
	ID = line[:-1]
	pruneSet.add(ID)
pruneFile.close()
print(str(len(pruneSet)) + ' variants to be included in new VCF')


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
		if ID in pruneSet:
			outFile.write(line)

vcfFile.close()
outFile.close()