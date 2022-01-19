#Plotting inter-source ancestry against admixture proportions
#NB: Has not been made to take command line arguments!

library(ggplot2)
library(tidyverse)
library(dplyr)
library(plotly)
library(methods)
library(ggrepel)

#Sample names in right order
sample <- c("ChowChow01","GermanShepherd02","MW005","MW006","MW007","MW011","MW099","MW101","MW103","MW1178","MW177","MW264","MW265","MW266","MW267","MW268","MW269","MW305","MW312_R-EXT","MW341","MW519","MW562","MW565","MW567","MW568")
type <- c("Dog", "Dog", "Wolf", "Wolf", "Wolf", "Wolf", "Hybrid","Hybrid","Hybrid","Hybrid","Hybrid","Hybrid","Hybrid","Hybrid","Hybrid","Hybrid","Hybrid","Hybrid","Hybrid","Hybrid","Hybrid","Hybrid","Hybrid","Hybrid","Hybrid")
suspected <- c("Pure dog", "Pure dog", "Pure wolf", "Pure wolf", "Pure wolf", "Pure wolf", "F1","F1","F1","Unknown","Unknown","F1","F1","F2_backcross_with_wolf","F1","F2_backcross_with_dog","F1","Unknown","Unknown","Czechoslovakian_wolfdog","Wolfdog","Unknown","Unknown","Unknown","Unknown")
group <- c("Pure_dog(NA)", "Pure_dog(NA)", "Pure_wolf(Norway)", "Pure_wolf(Norway)", "Pure_wolf(Norway)", "Pure_wolf(Norway)", "F1(Germany)", "F1(Germany)", "F1(Germany)", "Unknown(Ukraine)", "Unknown(Israel)", "F1(Poland)", "F1(Poland)", "F2_BC_w/wolf(Poland)", "F1(Poland)", "F2_BC_w/dog(Poland)", "F1(Poland)", "Unknown(Italy)", "Unknown(Israel)", "Czech_wolfdog(Czech.Rep.)", "Wolfdog(NA)", "F1(Mongolia)", "F1(Mongolia)", "F1(Mongolia)", "F1(Mongolia)")

   
#Read data
#WG------------------------------------------------------------------------------------------------------
q_data <- read.csv("C:/Users/julie/OneDrive/Skrivebord/Hybridization/WG/Entropy/admixEst_WG_K2.txt") %>%
 select(mean) %>%
 slice_head(prop = 0.5) %>%
 cbind(sample) %>%
 rename(q = mean)
 
Q_data <- read.csv("C:/Users/julie/OneDrive/Skrivebord/Hybridization/WG/Entropy/Q12_WG_K2.txt") %>%
 select(mean) %>%
 slice_head(prop=2/3) %>%
 slice_tail(prop=0.5) %>%
 cbind(sample) %>%
 rename(Q = mean)
   
plottitle <- "Whole Genome"
plotpath <- "C:/Users/julie/OneDrive/Skrivebord/Hybridization/WG/Entropy/trianglePlot_WG"

#BC------------------------------------------------------------------------------------------------------
# q_data <- read.csv("C:/Users/julie/OneDrive/Skrivebord/Hybridization/BeadChip/Entropy/admixEst_BC_K2.txt") %>%
#  select(mean) %>%
#  slice_head(prop = 0.5) %>%
#  cbind(sample) %>%
#  rename(q = mean)
#   
# Q_data <- read.csv("C:/Users/julie/OneDrive/Skrivebord/Hybridization/BeadChip/Entropy/Q12_BC_K2.txt") %>%
#  select(mean) %>%
#  slice_head(prop=2/3) %>%
#  slice_tail(prop=0.5) %>%
#  cbind(sample) %>%
#  rename(Q = mean)
#   
# plottitle <- "CanineHD BeadChip SNPs"
# plotpath <- "C:/Users/julie/OneDrive/Skrivebord/Hybridization/BeadChip/Entropy/trianglePlot_BC"
#--------------------------------------------------------------------------------------------------------


#Combine data
data <- inner_join(q_data, Q_data, by = "sample") %>%
  cbind(type) %>%
  cbind(suspected) %>%
  cbind(group)
 


cbPalette <- c("#D55E00", "#009E73", "#56B4E9") 


#Plot
p <- ggplot(data, aes(x = q, y = Q, shape = suspected, label = sample, color = type, text = paste("Sample:",sample))) + 
  geom_point(size = 4, alpha = 0.8) +
  scale_shape_manual(values=c(7, 15, 1, 2, 17, 16, 18, 3)) +
  scale_color_manual(values=cbPalette) +
  theme_classic() +
  xlim(0.0, 1.0) + 
  ylim(0.0, 1.0) + 
  geom_segment(x = 0.0, y = 0.0, xend = 0.5, yend = 1.0, color="black") +
  geom_segment(x = 1.0, y = 0.0, xend = 0.5, yend = 1.0, color="black") +
  geom_vline(xintercept = 0.5, linetype = "dashed") +
  #geom_text(size = 2, nudge_y = 0.03) +
  labs(x = "Admixture proportion q", y = expression("Inter-source ancestry Q"[12]), shape="Suspected hybridization level", color="Population" )
#p
ggsave(paste(plotpath, ".png"), width = 8, height = 5)


# #Extra plot to check the samples by shape
p1 <- ggplot(data, aes(x = q, y = Q, shape = sample, label = sample, color = type, text = paste("Sample:",sample))) + 
 geom_point(size = 3) +
 scale_shape_manual(values=1:nlevels(data$sample)) +
  scale_color_manual(values=cbPalette) +
 theme_classic() +
 xlim(0.0, 1.0) + 
 ylim(0.0, 1.0) + 
 geom_segment(x = 0.0, y = 0.0, xend = 0.5, yend = 1.0, color="black") +
 geom_segment(x = 1.0, y = 0.0, xend = 0.5, yend = 1.0, color="black") +
 geom_text(size = 2, nudge_y = 0.03) +
 geom_vline(xintercept = 0.5, linetype = "dashed") +
labs(title = plottitle, x = "Admixture proportion q", y = expression("Inter-source ancestry Q"[12]))
#p1
ggsave(paste(plotpath,"_shapeBySample.png"), width = 8, height = 5)


# Extra extra plot with labels and coloured by group
cbPalette2 <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7", "#8BC34A", "#551A8B", "#999999", "#6B3E2E")
p2 <- ggplot(data, aes(x = q, y = Q, shape = type, label = sample, color = group, text = paste("Sample:",sample))) + 
  geom_point(size = 4, alpha = 0.8) +
  geom_text_repel() +
  scale_shape_manual(values=c(16, 15, 17)) +
  scale_color_manual(values=cbPalette2) +
  theme_classic() +
  xlim(0.0, 1.0) + 
  ylim(0.0, 1.0) + 
  geom_segment(x = 0.0, y = 0.0, xend = 0.5, yend = 1.0, color="black") +
  geom_segment(x = 1.0, y = 0.0, xend = 0.5, yend = 1.0, color="black") +
  geom_vline(xintercept = 0.5, linetype = "dashed") +
  labs(title = plottitle, x = "Admixture proportion q", y = expression("Inter-source ancestry Q"[12]), color = "Suspected hybridization level", shape = "Population")
p2
ggsave(paste(plotpath,"_colourByGroup.png"), width = 8, height = 5)

