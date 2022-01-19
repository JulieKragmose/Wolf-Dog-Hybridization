## Script to plot PCA from the covariance matrix
## USAGE: Rscript PCAentropy.R <covariance.cov> <annotation.filelist> <out.png> 


library(methods)
library(ggplot2)
library(plotly)
library(RcppCNPy)
library(data.table)


#Read input arguments
args <- commandArgs(trailingOnly = TRUE)
covFile <- args[1]
annotFile <- args[2]
outFile <- args[3]


# The components we want
comp = "1-2"


# Read data
#data <- as.matrix(read.table(genoEst, sep=","))
#print("data has been read")

# Transpose matrix and remove first row and first column. Then make numeric
#data.t <- t(data)
#data.t <- data.t[,-1]
#data.t <- data.t[-1,]
#data.t.num <- matrix(as.numeric(data.t), ncol = ncol(data.t))
#print("data has been transposed")


# Make covariance matrix
#C <- cov(data.t.num)
#print("covariance matrix made")


# Read covariance matrix
C <- as.matrix(read.table(covFile, sep = " "))

# Read annotation file
annot <- fread(annotFile, sep=" ", header=T)

# Parse components to analyse
comp <- as.numeric(strsplit(comp, "-", fixed=TRUE)[[1]])

# Eigenvalues
eig <- eigen(C, symm=TRUE)
eig$val <- eig$val/sum(eig$val)
print("eigenvalues have been calculated")



### Plot ###
PC <- as.data.frame(eig$vectors)
colnames(PC) <- gsub("V", "PC", colnames(PC))
PC$Pop <- factor(annot$CLUSTER)
PC$Predicted <- factor(annot$SUSPECTED)
PC$ID <- factor(annot$FID)

title <- paste("PC",comp[1]," (",signif(eig$val[comp[1]], digits=3)*100,"%)"," / PC",comp[2]," (",signif(eig$val[comp[2]], digits=3)*100,"%)",sep="",collapse="")

x_axis = paste("PC",comp[1],sep="")
y_axis = paste("PC",comp[2],sep="")

# The actual plotting
#Colour palette
cbPalette <- c("#D55E00", "#009E73", "#56B4E9")

ggplot() + 
  geom_point(data=PC, aes_string(x=x_axis, y=y_axis, color="Pop", shape="Predicted"), size = 4, alpha = 0.8) + 
  ggtitle(title)+
  scale_color_manual(values=cbPalette) +
  labs(shape = "Suspected hybridization level") +
  theme_classic() +
  theme(legend.position = "none") +
  scale_shape_manual(values=c(7, 15, 1, 2, 17, 16, 18, 3)) +
  guides(color=guide_legend(title="Population")) 
ggsave(gsub('pdf$','png',outFile),device = "png", width = 6, height = 5)



#Plot where you can see the samples
ggplot(data=PC, aes_string(x=x_axis, y=y_axis, color="ID", shape="Predicted", label = "ID")) + 
  geom_point(size = 4, alpha = 0.8) + 
  geom_text(size = 2, nudge_y = 0.03) +
  ggtitle(title)+
  labs(shape = "Suspected hybridization level") +
  theme_classic() +
  scale_shape_manual(values=c(7, 15, 1, 2, 17, 16, 18, 3)) +
  guides(color=guide_legend(title="Population")) 
ggsave("PCA_WG_colourBySample.png",device = "png", width = 8, height = 5)