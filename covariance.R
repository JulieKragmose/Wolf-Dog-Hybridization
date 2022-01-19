## Script to make covarance matrix from genotype estimates
## USAGE: Rscript covariance.R <genoest.txt> <out.csv> 


library(methods)
library(ggplot2)
library(plotly)
library(RcppCNPy)
library(data.table)


#Read input arguments
args <- commandArgs(trailingOnly = TRUE)
genoEst <- args[1]
outFile <- args[2]


# The components we want
comp = "1-2"


# Read data
data <- as.matrix(read.table(genoEst, sep=","))
print("data has been read")

# Transpose matrix and remove first row and first column. Then make numeric
data.t <- t(data)
data.t <- data.t[,-1]
data.t <- data.t[-1,]
data.t.num <- matrix(as.numeric(data.t), ncol = ncol(data.t))
print("data has been transposed")


# Make covariance matrix
C <- cov(data.t.num)
print("covariance matrix made")


#Write covariance matrix to outfile
write.csv(C, outFile, row.names = FALSE)