#Plot the R statistics

library(ggplot2)
library(tidyverse)


#Initalize empty dataframe
data <- data.frame(param = factor(),
                   effectiveSampleSize = numeric(),
                   potentialScaleReductionFactor = numeric(),
                   p = character(),
                   k = factor())


# Read data for q (admixture estimates)
for(i in 2:8) {
  diagFile <- paste("C:/Users/julie/OneDrive/Skrivebord/Hybridization/BeadChip/Entropy/Rstatistics/qmcmcdiag_BC_q_K", i, ".txt", sep="")
  subdata <- read.csv(file = diagFile) %>%
    mutate(p="q (admixture estimates)", k = as.factor(i))
  
  #Add data for this K to full dataframe
  data <- rbind(data, subdata)
}

# Read data for alpha (???)
for(i in 2:8) {
  diagFile <- paste("C:/Users/julie/OneDrive/Skrivebord/Hybridization/BeadChip/Entropy/Rstatistics/qmcmcdiag_BC_alpha_K", i, ".txt", sep="")
  subdata <- read.csv(file = diagFile) %>%
    mutate(p="alpha (genetic variation in ancestor)", k = as.factor(i))
  
  #Add data for this K to full dataframe
  data <- rbind(data, subdata)
}

# Read data for fst (???)
for(i in 2:8) {
  diagFile <- paste("C:/Users/julie/OneDrive/Skrivebord/Hybridization/BeadChip/Entropy/Rstatistics/qmcmcdiag_BC_fst_K", i, ".txt", sep="")
  subdata <- read.csv(file = diagFile) %>%
    mutate(p="fst (fixation index)", k = as.factor(i))
  
  #Add data for this K to full dataframe
  data <- rbind(data, subdata)
}




# Plot
p1 <- ggplot(data, aes(x = k, y = potentialScaleReductionFactor)) +
  geom_dotplot(binaxis = 'y', stackdir = 'center', dotsize = 1.2, stackratio = 0.1) + 
  geom_hline(yintercept = 1.05, linetype = 'dashed', color = 'red', size = 1) +
  labs(x = "K", y = "R statistic") +
  ylim(0.90, 3.0) +
  facet_wrap(~ p, ncol = 1)
p1
ggsave("C:/Users/julie/OneDrive/Skrivebord/Hybridization/BeadChip/Entropy/Rstatistics_BC.png", width = 8, height = 5)
